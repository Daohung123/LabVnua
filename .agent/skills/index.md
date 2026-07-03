# Skill Index

## Counters
| TYPE | Completed Since Review | Last Review | Next Review |
|---|---:|---|---|
| CODING | 2 | - | 10 completed worklogs |
| TEST | 0 | - | 10 completed worklogs |
| BUG | 0 | - | 10 completed worklogs |
| CREATE_DD | 2 | - | 10 completed worklogs |

## Skills
| ID | TYPE | Pattern | Trigger | File | Evidence |
|---|---|---|---|---|---|

## Counter Rule
- Increment a counter only after a completed worklog of that same `TYPE`.
- Do not increment a counter because an agent read a workflow, skill, or worklog.
- When a type reaches 10 completed worklogs since its last review, read the ten most recent completed worklogs of that type, group them by `PATTERN` and `TAGS`, create skills only for stable repeated patterns, update this index with evidence, then reset only that type's counter to `0`.

## Skill File Format
Store skills at `.agent/skills/<TYPE>/SKILL-<TYPE>-<short-name>.md`.

```md
# SKILL-<TYPE>-<short-name>

- `TYPE:` <task type>
- `PATTERN:` <reusable pattern>
- `TRIGGER:` <when to use it>
- `EVIDENCE:` <3+ source worklogs>

## INPUTS
- <required context>

## STEPS
1. <repeatable step>
2. <repeatable step>

## CHECK
- <verification>

## PITFALLS
- <common mistake>
```

Do not create a skill for a one-off requirement, unstable behavior, or unverified assumption.
