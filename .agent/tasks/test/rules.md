# Test Rules

## Verified Rules
| Rule | Source |
|---|---|
| Use `flutter test` for automated Flutter tests. | `README.md`, `test/chat_service_test.dart` |
| Use `flutter analyze` for analyzer/lint checks. | `analysis_options.yaml` |
| Existing automated coverage is minimal. | `README.md` |
| Current test evidence covers `generateConversationId`. | `test/chat_service_test.dart` |

## Recommendations
- Prefer focused tests around pure Dart helpers, model parsing, and controller/service logic.
- For API-dependent code, isolate parsing and request-shape logic where possible; avoid requiring real credentials for unit tests.
- Record manual test roles and data in the checklist without storing real credentials, tokens, or private student data.
- If a failure is confirmed and needs code change, create or update a `BUG` checklist.

## OPEN_QUESTION
- `OPEN_QUESTION-TEST-01:` No CI configuration or required pre-merge test gate was found.
- `OPEN_QUESTION-TEST-02:` No approved test data policy exists for VNUA account-based flows.
