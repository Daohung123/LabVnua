# CREATE_DD Rules

## Verified Rules
| Rule | Source |
|---|---|
| Existing repo-owned DD templates are Excel files under `docs/base/`. | `docs/base/DD_Create_Template.xlsx`, `docs/base/DD_Module_Template.xlsx`, `docs/base/DD_Update_Template.xlsx` |
| Existing DD guidance in this repo is under `docs/base/` and is Vietnamese. | `docs/base/Huong_Dan_Nhap_Lieu_DD_Module_Update_Create.md`, `docs/base/Huong_dan_nhap_lieu_DD_Create_Template.md`, `docs/base/Huong_dan_nhap_lieu_DD_Update_Template.md` |
| Existing auth DD artifacts are Excel files under `docs/auth/`. | `docs/auth/*` |
| The agent bootstrap requires new agent documents in English. | `AGENTS.md` |

## Recommendations
- For LabVnua DD work, prefer repo-owned templates and source evidence over outside-repo templates.
- If a task requests a Markdown API DD package, first confirm an approved repo-owned template path or record `OPEN_QUESTION`.
- Do not modify app source during DD creation unless a separate implementation task explicitly requests it.
- Keep DD claims traceable to BD/BRD, existing DD, source paths, or checklist/issue evidence.

## OPEN_QUESTION
- `OPEN_QUESTION-DD-01:` No repo-owned Markdown API DD package template exists with the requested `Study2Work_API_DD_Template` structure.
- `OPEN_QUESTION-DD-02:` No repo-owned Markdown module DD folder template exists with `Overall.md`, `List_Features.md`, `Function_List.md`, `Views.md`, and `Import_File.md`.

## Resolved Notes
- `RESOLVED-DD-03:` `docs/base/BasicDesign_LearningApp.docx` was extracted into `docs/BD/BasicDesign_LearningApp.md` on 2026-07-02.
