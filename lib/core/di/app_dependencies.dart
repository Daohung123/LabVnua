import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/core/config/app_environment.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/ai_context_local_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/flutter_tts_gateway.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/speech_to_text_gateway.dart';
import 'package:aqedu/features/ai_assistant/data/repositories/gemini_ai_assistant_repository.dart';
import 'package:aqedu/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_input.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_output.dart';
import 'package:aqedu/features/ai_assistant/domain/usecases/ask_ai_assistant.dart';
import 'package:aqedu/features/ai_assistant/presentation/controllers/ai_controller.dart';
import 'package:aqedu/features/class_session/data/datasources/class_session_note_local_data_source.dart';
import 'package:aqedu/features/class_session/data/repositories/class_session_note_repository_impl.dart';
import 'package:aqedu/features/class_session/domain/repositories/class_session_note_repository.dart';
import 'package:aqedu/features/class_session/domain/usecases/manage_class_session_notes.dart';
import 'package:aqedu/features/class_session/presentation/controllers/class_session_note_controller.dart';
import 'package:aqedu/features/platform/data/datasources/local_analytics_data_source.dart';
import 'package:aqedu/features/platform/data/repositories/local_analytics_repository.dart';
import 'package:aqedu/features/platform/domain/repositories/analytics_repository.dart';
import 'package:aqedu/features/platform/domain/usecases/record_analytics_event.dart';
import 'package:aqedu/features/task/data/datasources/local_task_local_data_source.dart';
import 'package:aqedu/features/task/data/repositories/local_task_repository_impl.dart';
import 'package:aqedu/features/task/domain/repositories/local_task_repository.dart';
import 'package:aqedu/features/task/domain/usecases/manage_local_tasks.dart';
import 'package:aqedu/features/task/presentation/controllers/local_task_controller.dart';

class AppDependencies {
  AppDependencies._();

  static final AppDependencies instance = AppDependencies._();

  final AppEnvironment environment = const AppEnvironment();

  final AppDatabase database = AppDatabase();

  late final SpeechInput speechInput = SpeechToTextGateway();

  late final SpeechOutput speechOutput = FlutterTtsGateway();

  late final AnalyticsRepository analyticsRepository = LocalAnalyticsRepository(
    localDataSource: LocalAnalyticsDataSource(database: database),
  );

  late final RecordAnalyticsEvent recordAnalyticsEvent = RecordAnalyticsEvent(
    analyticsRepository,
  );

  late final LocalTaskRepository localTaskRepository = LocalTaskRepositoryImpl(
    localDataSource: LocalTaskLocalDataSource(database: database),
  );

  late final ManageLocalTasks manageLocalTasks = ManageLocalTasks(
    localTaskRepository,
  );

  LocalTaskController localTaskController() {
    return LocalTaskController(manageLocalTasks: manageLocalTasks);
  }

  late final ClassSessionNoteRepository classSessionNoteRepository =
      ClassSessionNoteRepositoryImpl(
        localDataSource: ClassSessionNoteLocalDataSource(database: database),
      );

  late final ManageClassSessionNotes manageClassSessionNotes =
      ManageClassSessionNotes(classSessionNoteRepository);

  ClassSessionNoteController classSessionNoteController() {
    return ClassSessionNoteController(
      manageClassSessionNotes: manageClassSessionNotes,
    );
  }

  late final AiAssistantRepository aiAssistantRepository =
      GeminiAiAssistantRepository(
        geminiDataSource: GeminiAiDataSource(
          apiKey: environment.geminiApiKey,
          modelName: environment.geminiModel,
          fallbackModelName: environment.geminiFallbackModel,
        ),
        contextDataSource: AiContextLocalDataSource(),
      );

  late final AskAiAssistant askAiAssistant = AskAiAssistant(
    aiAssistantRepository,
  );

  AiController aiController() {
    return AiController(askAiAssistant: askAiAssistant);
  }
}
