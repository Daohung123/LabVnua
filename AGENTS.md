# Project Agent Guide

## Purpose
This guide is the required entrypoint for future AI coding agents working in this repository. It explains how to classify work, load only relevant context, and preserve handoff state without reading the entire repository.

## Start Here
1. Read `AGENTS.md` first in every session.
2. Classify the task as `CODING`, `TEST`, `BUG`, or `CREATE_DD`.
3. Identify `SCOPE` and `PATTERN`.
4. Read up to three relevant worklogs from `.agent/worklogs/<TYPE>/`.
5. Read `.agent/skills/index.md`, then only matching skill files.
6. Read the matching workflow and rules under `.agent/tasks/`.
7. Load only the architecture, database, API, DD, checklist, and code files needed for the task.

## Project Map
- Repository map: `.agent/project-map.md`
- Architecture overview: `.agent/architecture/overview.md`
- Flutter app architecture: `.agent/architecture/flutter-app.md`
- Architecture audit: `.agent/architecture/audit.md`
- Database notes: `.agent/database/overview.md`, `.agent/database/schema.md`, `.agent/database/migrations.md`
- API notes: `.agent/api/index.md`, `.agent/api/internal.md`, `.agent/api/external.md`
- DD instructions: `.agent/dd/api-dd-instruction.md`, `.agent/dd/module-dd-instruction.md`

## Task Classification
Use exactly one task type:

| TYPE | Use when |
|---|---|
| `CODING` | Implementing or refactoring application behavior, UI, services, models, configuration handling, or docs tied to implementation. |
| `TEST` | Creating, running, expanding, or documenting verification without starting from a confirmed bug fix. |
| `BUG` | Investigating a symptom, reproducing wrong behavior, fixing a confirmed defect, or verifying a fix. |
| `CREATE_DD` | Creating or updating Detail Design documentation from BD/BRD, issues, templates, or verified source evidence. |

If the task mixes types, choose the type that controls the main deliverable and record secondary work in the checklist.

## Context Loading Rules
- Do targeted context loading. Do not read the whole repository by default.
- Load at most three worklogs, prioritized by same `SCOPE` and `PATTERN`, then same `SCOPE` and `TYPE`, then same `TYPE` and similar `TAGS`.
- For local UI-only tasks, do not load database or API docs unless the change crosses those boundaries.
- Unknown requirements, missing source truth, and unresolved conflicts must be recorded as `OPEN_QUESTION`.
- Ask the user only when the missing answer blocks a correct decision about business behavior, authorization, destructive actions, schema/public API contract, or expected test result.
- Continue safe, non-ambiguous work while recording non-blocking questions.

## Universal Rules
- Preserve existing user changes. Do not revert unrelated files.
- Do not modify app source, runtime configuration, migrations, dependencies, or product behavior during documentation bootstrap work.
- For implementation tasks, make the smallest scoped change that satisfies the accepted requirement.
- Prefer existing feature-first Flutter patterns under `lib/features/` and shared utilities under `lib/core/`.
- Never write credentials, API keys, tokens, passwords, connection strings, production PII, or secret values into agent context, checklists, worklogs, or DDs.

## Task Workflows
- `CODING`: `.agent/tasks/coding/workflow.md`, `.agent/tasks/coding/rules.md`, `.agent/tasks/coding/design.md`
- `TEST`: `.agent/tasks/test/workflow.md`, `.agent/tasks/test/rules.md`
- `BUG`: `.agent/tasks/bug/workflow.md`, `.agent/tasks/bug/rules.md`
- `CREATE_DD`: `.agent/tasks/create-dd/workflow.md`, `.agent/tasks/create-dd/rules.md`

## Documentation and Handoff
- Create or update one checklist for all material work under `docs/checklists/<task-type>/`.
- Create or update one compact worklog at the end of each meaningful session under `.agent/worklogs/<TYPE>/`.
- Update order is: implementation/test result -> checklist -> worklog -> skill index.
- Checklist templates live in `.agent/templates/`.
- Worklogs must not paste source code, terminal logs, BD/DD text, secrets, or private data.

## Skill Lifecycle
- Skill index: `.agent/skills/index.md`
- Skill files live under `.agent/skills/<TYPE>/`.
- Increment skill counters only after a completed worklog of that same `TYPE`.
- Review a type after 10 completed worklogs since the last review.
- Create a skill only when a repeated pattern appears at least three times and has stable inputs, outputs, steps, checks, and pitfalls.

## Safety and Secrets
- Configuration key names may be documented; secret values must not be copied.
- Current known configuration key names are documented in `.agent/project-map.md`.
- If a source file contains or appears to contain sensitive values, record the key name or mechanism only and point to the source path without copying the value.
- For destructive commands, schema/public contract changes, authorization behavior, or unclear business rules, stop and ask the user before proceeding.
