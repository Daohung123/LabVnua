import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clean Architecture boundaries', () {
    test('domain layer does not depend on Flutter or infrastructure', () {
      final violations = _scanLayer(
        layer: 'domain',
        forbiddenImportFragments: const [
          'package:flutter/',
          'package:sqflite/',
          'package:http/',
          'package:supabase_flutter/',
          'package:google_generative_ai/',
          'package:workmanager/',
          'package:flutter_local_notifications/',
          '/data/',
          '/presentation/',
          'core/services_root/',
          'config/config_db.dart',
        ],
      );

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('data layer does not depend on presentation', () {
      final violations = _scanLayer(
        layer: 'data',
        forbiddenImportFragments: const ['/presentation/'],
      );

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test(
      'presentation layer does not import data or direct infrastructure',
      () {
        final violations = _scanLayer(
          layer: 'presentation',
          forbiddenImportFragments: const [
            '/data/',
            'package:sqflite/',
            'package:http/',
            'package:supabase_flutter/',
            'package:google_generative_ai/',
            'package:workmanager/',
            'package:flutter_local_notifications/',
            'core/services_root/',
            'config/config_db.dart',
          ],
        );

        expect(violations, isEmpty, reason: violations.join('\n'));
      },
    );
  });
}

List<String> _scanLayer({
  required String layer,
  required List<String> forbiddenImportFragments,
}) {
  final root = Directory('lib/features');
  if (!root.existsSync()) return const [];

  final violations = <String>[];
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => _pathSegments(file.path).contains(layer));

  for (final file in files) {
    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();
      if (!line.startsWith('import ')) continue;
      for (final forbidden in forbiddenImportFragments) {
        if (line.contains(forbidden)) {
          violations.add('${file.path}:${index + 1}: $line');
        }
      }
    }
  }

  return violations;
}

List<String> _pathSegments(String path) {
  return path.split(RegExp(r'[\\/]'));
}
