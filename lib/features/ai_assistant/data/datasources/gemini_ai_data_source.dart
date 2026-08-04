import 'dart:async';
import 'dart:convert';

import 'package:aqedu/core/logging/app_log.dart';
import 'package:http/http.dart' as http;

enum AiGatewayFailureKind {
  configuration,
  timeout,
  invalidApiKey,
  unsupportedLocation,
  modelUnavailable,
  quotaExceeded,
  service,
}

class AiGatewayException implements Exception {
  const AiGatewayException(this.kind, {this.sourceType, this.statusCode});

  final AiGatewayFailureKind kind;
  final String? sourceType;
  final int? statusCode;

  String get userMessage => switch (kind) {
    AiGatewayFailureKind.configuration =>
      'Bản chạy hiện tại chưa nhận GEMINI_API_KEY hoặc GEMINI_MODEL. Hãy kiểm tra file .env ở thư mục gốc dự án rồi chạy lại ứng dụng.',
    AiGatewayFailureKind.timeout =>
      'Trợ lý AI phản hồi quá lâu. Vui lòng thử lại.',
    AiGatewayFailureKind.invalidApiKey =>
      'Gemini từ chối API key. Vui lòng kiểm tra key và giới hạn ứng dụng trong Google AI Studio.',
    AiGatewayFailureKind.unsupportedLocation =>
      'Gemini API chưa hỗ trợ khu vực mạng hiện tại. Vui lòng kiểm tra khu vực và kết nối mạng.',
    AiGatewayFailureKind.modelUnavailable =>
      'Model Gemini đang cấu hình không khả dụng. Vui lòng kiểm tra GEMINI_MODEL.',
    AiGatewayFailureKind.quotaExceeded =>
      'Gemini đang hết hạn mức hoặc tạm quá tải. Vui lòng thử lại sau.',
    AiGatewayFailureKind.service =>
      'Không thể kết nối tới trợ lý AI. Vui lòng thử lại sau.',
  };

  @override
  String toString() {
    final details = <String>[
      kind.name,
      if (statusCode != null) 'status: $statusCode',
      if (sourceType != null) 'source: $sourceType',
    ];
    return 'AiGatewayException(${details.join(', ')})';
  }
}

abstract class AiTextGateway {
  bool get isConfigured;
  String get modelName;

  Future<String?> generateText(String prompt);
}

/// Minimal Gemini Generate Content REST gateway.
///
/// The previous Dart SDK is a legacy client and cannot access current Gemini
/// models reliably. This implementation follows the documented v1beta REST
/// request shape while keeping the API key out of logs and response errors.
class GeminiAiDataSource implements AiTextGateway {
  GeminiAiDataSource({
    required String apiKey,
    String modelName = 'gemini-3.5-flash',
    String? fallbackModelName = 'gemini-2.5-flash',
    Duration requestTimeout = const Duration(seconds: 20),
    http.Client? httpClient,
  }) : _apiKey = apiKey.trim(),
       _modelName = modelName.trim(),
       _fallbackModelName = fallbackModelName?.trim(),
       _requestTimeout = requestTimeout,
       _httpClient = httpClient;

  final String _apiKey;
  final String _modelName;
  final String? _fallbackModelName;
  final Duration _requestTimeout;
  final http.Client? _httpClient;

  @override
  bool get isConfigured => _apiKey.isNotEmpty && _modelName.isNotEmpty;

  @override
  String get modelName => _modelName;

  @override
  Future<String?> generateText(String prompt) async {
    if (!isConfigured) {
      throw const AiGatewayException(AiGatewayFailureKind.configuration);
    }
    try {
      return await _generateTextForModel(_modelName, prompt);
    } on AiGatewayException catch (error) {
      final fallbackModel = _fallbackModelName;
      if (fallbackModel == null ||
          fallbackModel.isEmpty ||
          fallbackModel == _modelName ||
          error.statusCode != 503) {
        rethrow;
      }
      AppLog.api(
        'Gemini primary model tạm thời không khả dụng; dùng model dự phòng',
        khuVuc: 'Trợ lý AI',
        duLieu: {
          'primary_model': _modelName,
          'fallback_model': fallbackModel,
          'status': error.statusCode,
        },
      );
      return _generateTextForModel(fallbackModel, prompt);
    }
  }

  Future<String?> _generateTextForModel(String modelName, String prompt) async {
    try {
      final response = await (_httpClient?.post ?? http.post)(
        _endpointFor(modelName),
        headers: {
          'x-goog-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      ).timeout(_requestTimeout);
      if (response.statusCode != 200) {
        throw AiGatewayException(
          _classifyHttpFailure(response.statusCode, response.body),
          statusCode: response.statusCode,
        );
      }
      return _extractText(response.body);
    } on TimeoutException {
      throw const AiGatewayException(AiGatewayFailureKind.timeout);
    } on AiGatewayException {
      rethrow;
    } catch (error) {
      throw AiGatewayException(
        AiGatewayFailureKind.service,
        sourceType: _safeErrorType(error),
      );
    }
  }

  String _safeErrorType(Object error) {
    if (error is ArgumentError && error.name != null) {
      return '${error.runtimeType}:${error.name}';
    }
    return error.runtimeType.toString();
  }

  Uri _endpointFor(String modelName) => Uri.parse(
    'https://generativelanguage.googleapis.com/'
    'v1beta/models/${Uri.encodeComponent(modelName)}:generateContent',
  );

  AiGatewayFailureKind _classifyHttpFailure(int statusCode, String body) {
    if (statusCode == 401 || statusCode == 403) {
      return AiGatewayFailureKind.invalidApiKey;
    }
    if (statusCode == 404) return AiGatewayFailureKind.modelUnavailable;
    if (statusCode == 429) return AiGatewayFailureKind.quotaExceeded;

    final description = _errorDescription(body);
    if (description.contains('api key') &&
        (description.contains('invalid') ||
            description.contains('not valid') ||
            description.contains('not found'))) {
      return AiGatewayFailureKind.invalidApiKey;
    }
    if (description.contains('location') && description.contains('support')) {
      return AiGatewayFailureKind.unsupportedLocation;
    }
    if (description.contains('model') &&
        (description.contains('not found') ||
            description.contains('not supported') ||
            description.contains('unavailable'))) {
      return AiGatewayFailureKind.modelUnavailable;
    }
    if (description.contains('quota') || description.contains('rate limit')) {
      return AiGatewayFailureKind.quotaExceeded;
    }
    return AiGatewayFailureKind.service;
  }

  String _errorDescription(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final error = decoded['error'];
        if (error is Map && error['message'] is String) {
          return (error['message'] as String).toLowerCase();
        }
      }
    } catch (_) {
      // The response is never logged or shown to the user.
    }
    return '';
  }

  String? _extractText(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map) return null;
    final candidates = decoded['candidates'];
    if (candidates is! List) return null;

    final parts = <String>[];
    for (final candidate in candidates) {
      if (candidate is! Map) continue;
      final content = candidate['content'];
      if (content is! Map || content['parts'] is! List) continue;
      for (final part in content['parts'] as List) {
        if (part is Map && part['text'] is String) {
          final text = (part['text'] as String).trim();
          if (text.isNotEmpty) parts.add(text);
        }
      }
    }
    if (parts.isEmpty) return null;
    return parts.join('\n');
  }
}
