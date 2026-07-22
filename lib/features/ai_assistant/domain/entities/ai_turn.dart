enum AiTaskKind { noSqlite, sqlite, navigate }

enum AiNavigationTarget {
  home,
  study,
  settings,
  schedule,
  scores,
  tuition,
  notifications,
  tasks,
  courseRegistration,
  programTraining,
  prerequisites,
  qrScanner,
}

class AiNavigationAction {
  const AiNavigationAction({required this.target});

  final AiNavigationTarget target;
}

class AiIntent {
  const AiIntent({
    required this.taskKind,
    this.contextKeys = const [],
    this.navigationAction,
  });

  final AiTaskKind taskKind;
  final List<String> contextKeys;
  final AiNavigationAction? navigationAction;
}

class AiContextRequest {
  const AiContextRequest({required this.intent, required this.prompt});

  final AiIntent intent;
  final String prompt;
}

class AiTurnResult {
  const AiTurnResult({
    required this.intent,
    required this.answerText,
    required this.spokenText,
    this.action,
  });

  final AiIntent intent;
  final String answerText;
  final String spokenText;
  final AiNavigationAction? action;
}
