# Agent Context Folder Map

| Path | Purpose | When to read |
|---|---|---|
| `.agent/project-map.md` | Repository manifest, commands, modules, docs, tests, config keys, and constraints. | Start of any task after `AGENTS.md`. |
| `.agent/architecture/overview.md` | High-level architecture and dependency direction. | Any task touching app structure, navigation, shared services, or cross-feature behavior. |
| `.agent/architecture/flutter-app.md` | Flutter component details: folders, entrypoints, runtime flow, tests, and constraints. | Flutter UI/service/model work. |
| `.agent/architecture/audit.md` | Evidence-backed architecture risks and recommendations. | Before security, reliability, cleanup, or refactor work. |
| `.agent/database/` | SQLite schema, migration notes, and external schema gaps. | Tasks touching sessions, cached data, notifications, chat notifications, or local persistence. |
| `.agent/api/` | Internal service boundaries and external integration notes. | Tasks touching VNUA API, Supabase, Gemini, notifications, or background sync. |
| `.agent/tasks/<type>/` | Workflow, rules, and design guidance for each task type. | After classifying the task type. |
| `.agent/worklogs/<TYPE>/` | Compact session handoff notes grouped by task type. | Read up to three relevant logs before material work; update at session end. |
| `.agent/skills/` | Reusable patterns promoted from repeated completed worklogs. | Read `index.md`, then matching skills only. |
| `.agent/templates/` | Worklog and task checklist templates. | When creating a new worklog or checklist. |
| `.agent/dd/` | API and module DD creation instructions. | `CREATE_DD` tasks only. |
