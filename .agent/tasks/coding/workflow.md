# Coding Workflow

1. Identify `SCOPE`, acceptance criteria, and affected layer: UI, controller, service, API, database, notification, chat, AI, or platform.
2. Load targeted context using `AGENTS.md` and `.agent/project-map.md`.
3. Read up to three relevant worklogs from `.agent/worklogs/CODING/`.
4. Read `.agent/skills/index.md`, then only matching coding skills.
5. Create or update one coding checklist under `docs/checklists/coding/`.
6. Plan the smallest safe implementation using existing feature-first Flutter conventions.
7. Implement only scoped changes; do not mix cleanup with behavior unless required.
8. Run relevant checks, usually `flutter test` and `flutter analyze`.
9. Update implementation/test result, then checklist, then worklog, then skill index.
