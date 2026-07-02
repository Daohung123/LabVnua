# CREATE_DD Workflow

1. Identify scope, module/API, platform, BD/BRD source, and approved template.
2. Load only relevant requirement, architecture, API, database, existing DD, and code evidence.
3. Read up to three relevant worklogs from `.agent/worklogs/CREATE_DD/`.
4. Read `.agent/skills/index.md`, then only matching DD skills.
5. Create or update one CREATE_DD checklist under `docs/checklists/create-dd/`.
6. Choose the correct DD instruction:
   - API operation -> `.agent/dd/api-dd-instruction.md`
   - Mobile module or approved module-level design -> `.agent/dd/module-dd-instruction.md`
   - Web screen DD without an approved screen template -> record `OPEN_QUESTION`; do not invent a format.
7. Fill the approved template exactly.
8. Run the DD quality gate.
9. Update checklist, then worklog, then skill index.
