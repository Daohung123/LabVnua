# Coding Rules

## Verified Rules
| Rule | Source |
|---|---|
| Use Flutter/Dart package conventions for app code. | `pubspec.yaml`, `lib/main.dart` |
| Shared theme tokens and components live under `lib/core/theme/`; new UI should prefer `app_components.dart` where feasible. | `lib/core/theme/README.md` |
| Legacy widgets under `lib/core/widgets/` are kept for compatibility and are deprecated for new code. | `lib/core/widgets/README.md` |
| Runtime config keys are supplied through `--dart-define` and `String.fromEnvironment`. | `.env.example`, `README.md`, `lib/core/constants/api/*.dart` |
| Local SQLite schema currently lives in `lib/config/config_DB.dart`. | `lib/config/config_DB.dart` |
| Chat service table names and realtime behavior are implemented in `lib/features/chat/services/chat_service.dart`. | `lib/features/chat/services/chat_service.dart` |
| Flutter lints are enabled through `analysis_options.yaml`. | `analysis_options.yaml` |

## Recommendations
- Keep new feature code inside the relevant `lib/features/<feature>/` folder unless it is genuinely shared.
- Add focused tests for pure helpers, model mapping, controller logic, or service behavior when the change has testable logic.
- Avoid adding new global singletons unless the existing subsystem already uses that pattern.
- For sensitive data paths, avoid adding `print` or `debugPrint`; use safe debug-only logging if needed.

## OPEN_QUESTION
- `OPEN_QUESTION-CODING-01:` No formal naming convention for Dart files/classes beyond existing mixed naming is documented.
- `OPEN_QUESTION-CODING-02:` No approved production logging policy is documented.
