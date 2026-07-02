Tạo context Agent để AI agent làm việc: 0. Yêu cầu tài liệu AGENT phải là tiếng ânh, trước khi tạo agent context thì bạn hãy đọc toàn bộ dự án và tìm những lỗi về kiến trúc dự án và fix lại

1.  Đọc toàn bộ dự án để lấy context dự án để tạo agent context cho AI agent coding, yêu cầu tạo mọi dữ liệu dưới đây bằng context được lấy từ dự án hiện tại hoặc theo các file yêu cầu được gửi vào nếu có

2.  Yêu cầu tạo file AGENTS.md
    - Mục đích: Trước mỗi phiên làm việc AI agent sẽ phải đọc file này đầu tiên
    - AGENTS.md sẽ giúp AI agent phân loại task(coding, test, bug, bug, DD), mỗi một loại task thì sẽ có skill, workflow riêng. Từ đó mà giúp AI agent có thể làm việc hiệu quả, đúng luồng và tiết kiệm token
    - Giúp AI agent có la bàn để tìm các skill, context, workflow trước khi làm việc
    - Phổ biến các rule chung, style làm việc của dự án.

3.  Tạo folder .agent bao gồm các folder:
    - "worklog":
      - Mỗi khi làm việc thì phải đọc lại 3 worklog theo loại task gần nhất để lấy context làm việc
      - Form như sau:
        [ # WL-YYYYMMDD-XX — <task>

              * `STATUS:` DONE | DOING | BLOCKED
              * `TYPE:` CODING | TEST | BUG | CREATE_DD
              * `SCOPE:` <module/feature>
              * `PATTERN:` <reusable task pattern>
              * `TAGS:` <3-5 keywords>

              ## CURRENT

              * <current task / goal>

              ## CHANGED

              * `<file/module>` — <change>
              * `<file/module>` — <change>

              ## NOTE

              * <rule / risk / pitfall / contract to keep>

              ## TASK SPLIT

              * `[x]` <done>
              * `[~]` <doing>
              * `[ ]` <remaining>

              ## NEXT

              1. <first next action>
              2. <next action>


             ]

    - "architechture":
      - Gồm các file mô tả chi tiết kiến trúc của dự án.
      - Mô tả cấu trúc thư mục của từng phần của dự án, dự án nếu được chia thành Be và Fe thì mô tả cả 2, mỗi phần 1 file. Mô tả rõ kiến trúc folder, các file, công nghệ, luồng hoạt động.
    - "database":
      - Nơi mô tả các cấu trúc dữ liệu của database của dự án.
      - Nơi chứa các thông tin quan trọng của database như: host, port, name database, user name, vvv
    - "api":
      - Đây là nơi mô tả api của dự án nếu là web, nếu là di động thì là nơi mô tả các api được lấy từ bên ngoài.
      - Mô tả chi tiết endpoint, response, request, cách dùng.
    - "coding":
      - Đây là nơi chứa luồng, rule coding, style coding, workflow khi coding.
      - workflow.md:
        1.  Trước khi coding, bạn phải xác định module cần coding, tránh đọc lan man, tốn token, đọc qua BD, đọc skill để nạp các skills cần thiết, đọc architechture để lấy kiến trúc, công nghệ dự án, đọc database để hiểu cơ sở dữ liệu dự án, đọc api để hiểu api của dự án, docs/checklists/checklist_coding_task.md(Nơi mô tả tình trạng các task của dự án), DD, các file tài liệu liên quan
        2.  Sau khi đọc nếu task có các câu hỏi mở thì phải hiển thị và hỏi người dùng ngay lập tức
        3.  Sau đó lập kế hoạch coding và tiến hành coding
        4.  Sau khi coding thì phải cập nhật lại tiến độ trong docs/checklists/checklist_coding_task.md có form như sau:
            [ # CODING-<MODULE>-<ID> — <task>

                * `STATUS:` TODO | DOING | BLOCKED | DONE
                * `SCOPE:` <module/feature>
                * `REF:` <BD/DD/issue>
                * `PATTERN:` <repeatable coding pattern>
                * `TAGS:` <3-5 keywords>

                ## GOAL

                * [ ] <expected result / acceptance criteria>

                ## CONTEXT

                * <current behavior or issue>
                * <must-keep rule / API / DB / UI contract>

                ## PLAN

                * [ ] Read `<required DD/code>`
                * [ ] Implement `<main change>`
                * [ ] Update `<related layer/file>`
                * [ ] Handle `<edge case/permission/validation>`
                * [ ] Update docs/checklist if needed

                ## FILES

                * [ ] `<path>` — <purpose/change>
                * [ ] `<path>` — <purpose/change>

                ## CHECK

                * [ ] Build/lint
                * [ ] Unit/API test: `<command or flow>`
                * [ ] Manual flow: `<steps>`
                * [ ] Regression: `<related feature>`

                ## RESULT

                * `DONE:` <short completed summary>
                * `BLOCKED:` <reason or ->
                * `RISK:` <risk/pitfall or ->

                ## HANDOFF

                * `NEXT:` <first action for next session>
                * `READ:` <file to read first>
                * `SKILL:` YES | NO — <reusable lesson/pattern>

        ]

      - rule.md: Nơi mô tả các rule của dự án(Bạn hãy dựa vào các dữ liệu mà bạn đọc từ dự án để tạo ra 1 rule riêng cho dự án).
      - design.md: Nơi mô tả luật thiết kế UI, UX cho dự án(Bạn hãy dựa vào các dữ liệu mà bạn đọc từ dự án để tạo ra 1 design riêng cho dự án).
      - folder "skills": Là nơi chứa các skills chuyên được dùng trong quá trình coding chứa các file:
        ++ readme.md: Đây là nơi khai báo tất cả các skills và chức năng của nó, đây là file phải được đọc đầu tiên khi muốn nạp skills. File này có một bộ đếm worklog, mỗi lần đọc file này thì bộ đếm tăng thêm 1(chỉ tăng khi được đọc, tức là chỉ khi làm những loại task liên quan thì mới được tăng), mỗi khi đủ 10 phiên làm việc thì yêu cầu ai agent đọc lại 10 worklog cùng loại task gần nhất và tạo skills cho những việc nào lặp đi lặp lại(Nếu có) => Agent sẽ càng ngày càng hiểu dự án và làm việc hiệu quả hơn.
      * "test":
      - Đây là nơi chứa luồng, rule test, workflow khi testing.
      - workflow.md:
        1.  Trước khi testing, bạn phải xác định module cần test, tránh đọc lan man, tốn token, đọc qua BD, đọc skill để nạp các skills cần thiết, đọc architechture để lấy kiến trúc, công nghệ dự án, đọc database để hiểu cơ sở dữ liệu dự án, đọc api để hiểu api của dự án, docs/checklists/checklist_test_task.md(Nơi mô tả tình trạng các task của dự án), DD, các file tài liệu liên quan
        2.  Sau khi đọc nếu task có các câu hỏi mở thì phải hiển thị và hỏi người dùng ngay lập tức
        3.  Sau đó lập kế hoạch test và tiến hành test
        4.  Sau khi test thì phải cập nhật lại tiến độ trong docs/checklists/checklist_test_task.md có form như sau:
            [ # TEST-<MODULE>-<ID> — <task>

                * `STATUS:` TODO | DOING | BLOCKED | DONE
                * `SCOPE:` <module/feature>
                * `REF:` <BD/DD/issue/checklist>
                * `PATTERN:` <repeatable test pattern>
                * `TAGS:` <3-5 keywords>

                ## TARGET

                * [ ] <acceptance criteria / expected behavior>

                ## CONTEXT

                * <feature, bug, or flow under test>
                * <must-keep rule / permission / API contract>

                ## CASES

                * [ ] `<case>` → `<expected result>`
                * [ ] `<case>` → `<expected result>`
                * [ ] `<negative/edge case>` → `<expected result>`

                ## DATA

                * `ROLE:` <test role or ->
                * `INPUT:` <important test data or ->
                * `ENV:` LOCAL | DEV | STAGING

                ## RESULT

                * `PASS:` <case IDs or ->
                * `FAIL:` <case ID + short symptom or ->
                * `SKIP:` <case ID + reason or ->

                ## ISSUE

                * [ ] `<issue ID or short bug>`
                * `RISK:` <regression / unclear rule / ->

                ## HANDOFF

                * `NEXT:` <first next action>
                * `READ:` <file/DD/test case to read first>
                * `SKILL:` YES | NO — <reusable testing lesson>

        ]

      - rule.md: Nơi mô tả các rule test của dự án(Bạn hãy dựa vào các dữ liệu mà bạn đọc từ dự án để tạo ra 1 rule riêng cho dự án).
      - folder "skills": Là nơi chứa các skills chuyên được dùng trong quá trình test chứa các file:
        ++ readme.md: Đây là nơi khai báo tất cả các skills và chức năng của nó, đây là file phải được đọc đầu tiên khi muốn nạp skills. File này có một bộ đếm worklog, mỗi lần đọc file này thì bộ đếm tăng thêm 1(chỉ tăng khi được đọc, tức là chỉ khi làm những loại task liên quan thì mới được tăng), mỗi khi đủ 10 phiên làm việc thì yêu cầu ai agent đọc lại 10 worklog cùng loại task gần nhất và tạo skills cho những việc nào lặp đi lặp lại(Nếu có) => Agent sẽ càng ngày càng hiểu dự án và làm việc hiệu quả hơn.
      * "bug":
      - Đây là nơi chứa luồng, rule test, workflow khi tìm bug và fixbug
      - workflow.md:
        1.  Trước khi làm task này, bạn phải xác định module cần test, tránh đọc lan man, tốn token, đọc qua BD, đọc skill để nạp các skills cần thiết, đọc architechture để lấy kiến trúc, công nghệ dự án, đọc database để hiểu cơ sở dữ liệu dự án, đọc api để hiểu api của dự án, docs/checklists/checklist_bug_task.md(Nơi mô tả tình trạng các task của dự án), DD, các file tài liệu liên quan
        2.  Sau khi đọc nếu task có các câu hỏi mở thì phải hiển thị và hỏi người dùng ngay lập tức
        3.  Sau đó lập kế hoạch test và tiến hành task
        4.  Sau khi test thì phải cập nhật lại tiến độ trong docs/checklists/checklist_bug_task.md có form như sau:
            [ # BUG-<MODULE>-<ID> — <short title>

                * `STATUS:` TODO | DOING | BLOCKED | FIXED | VERIFIED
                * `SCOPE:` <module/feature>
                * `REF:` <issue/DD/worklog>
                * `PATTERN:` <repeatable bug type>
                * `TAGS:` <3-5 keywords>

                ## BUG

                * `SYMPTOM:` <actual wrong behavior>
                * `EXPECTED:` <correct behavior>
                * `REPRO:` <short steps or condition>

                ## CONTEXT

                * <affected flow / role / API / screen>
                * <must-keep rule or contract>

                ## FINDING

                * `CAUSE:` <root cause or TBD>
                * `AFFECT:` <files/features impacted>

                ## FIX

                * [ ] `<file>` — <planned/applied fix>
                * [ ] `<file>` — <related update>
                * [ ] Add/update regression test

                ## CHECK

                * [ ] Reproduce before fix
                * [ ] Verify fixed flow
                * [ ] Verify negative/edge case
                * [ ] Regression: <related flow>

                ## RESULT

                * `FIXED:` <summary or ->
                * `BLOCKED:` <reason or ->
                * `RISK:` <remaining risk or ->

                ## HANDOFF

                * `NEXT:` <first next action>
                * `READ:` <required file>
                * `SKILL:` YES | NO — <reusable debug lesson>

        ]

      - rule.md: Nơi mô tả các rule findbug/fixbug của dự án(Bạn hãy dựa vào các dữ liệu mà bạn đọc từ dự án để tạo ra 1 rule riêng cho dự án).
      - folder "skills": Là nơi chứa các skills chuyên được dùng trong quá trình test chứa các file:
        ++ readme.md: Đây là nơi khai báo tất cả các skills và chức năng của nó, đây là file phải được đọc đầu tiên khi muốn nạp skills. File này có một bộ đếm worklog, mỗi lần đọc file này thì bộ đếm tăng thêm 1(chỉ tăng khi được đọc, tức là chỉ khi làm những loại task liên quan thì mới được tăng), mỗi khi đủ 10 phiên làm việc thì yêu cầu ai agent đọc lại 10 worklog cùng loại task gần nhất và tạo skills cho những việc nào lặp đi lặp lại(Nếu có) => Agent sẽ càng ngày càng hiểu dự án và làm việc hiệu quả hơn.

      -"DD":
      - Đây là nơi hướng dẫn các tạo Detail Design dựa vào BD(Basic Design):
      - workflow.md: 0. Trước khi làm task này, bạn phải xác định module cần test, tránh đọc lan man, tốn token, đọc qua BD, đọc skill để nạp các skills cần thiết, đọc architechture để lấy kiến trúc, công nghệ dự án, đọc database để hiểu cơ sở dữ liệu dự án, đọc api để hiểu api của dự án => Mục đích lấy ngữ cảnh hiện tại của dự án để tạo tài liệu DD
        1.  Xác định module, phạm vi cần tạo tài liệu, file BD
        2.  Đọc thật kỹ các tài liệu liên quan
        3.  Bước này tôi chia thành 2 trường hợp:
            - Web:
              1.  API: Đọc prompt dưới đây và làm theo:
                  [ # Create API DD Package From Template

                      Create a complete API Detail Design package for **one API operation only**.

                      ## Input

                      * `API_CODE`: `<e.g. LEARN-PROGRESS-001>`
                      * `MODULE_CODE`: `<e.g. LEARN>`
                      * `API_NAME`: `<short API name>`
                      * `TARGET_DIR`: `docs/api-dd/<module-code-lowercase>/<api-code-lowercase>/`
                      * `TEMPLATE_DIR`: `<path-to>/Study2Work_API_DD_Template`
                      * Business source: `<BD path / section>`
                      * Related sources: `<DD, API checklist, issue, diagram, ADR, existing code paths>`

                      ## Task

                      1. Read only the relevant BD/DD/checklist/diagram/code files for this API.
                      2. Copy `TEMPLATE_DIR` into `TARGET_DIR`.
                      3. Fill the copied template with the API-specific detail design.
                      4. Keep the output structure **exactly identical** to the template.

                      ## Mandatory Rules

                      * One package = one API operation.
                      * Do not rename, remove, merge, reorder, or add files, headings, table columns, template rows, or sections.
                      * Preserve these exact paths:

                      ```text
                      <TARGET_DIR>/
                      ├── README.md
                      ├── HUONG_DAN_NHAP_LIEU_DD.md
                      ├── API_DD_CHECKLIST.md
                      ├── 01_Overview/Overview.md
                      ├── 02_History/History.md
                      ├── 03_Request/Request.md
                      ├── 04_Response/Response.md
                      ├── 05_DataMapping/DataMapping.md
                      └── 06_Error/Error.md
                      ```

                      * Replace every applicable `{{PLACEHOLDER}}` with a concrete value.
                      * For an inapplicable item, use `N/A`.
                      * For unclear or unsupported business rules, use `OPEN_QUESTION`; do not invent behavior.
                      * Keep `README.md` and `HUONG_DAN_NHAP_LIEU_DD.md` unchanged unless the project standard itself changed.
                      * Use English for all DD content.
                      * Use `camelCase` for JSON fields, `snake_case` for database fields, UUID for IDs, and ISO-8601 UTC for timestamps.
                      * Use the standard response envelope: `businessCode`, `message`, `timestamp`, `traceId`, plus `data` or `errors`.
                      * Request/response examples must be valid JSON.
                      * Explicitly define authentication, permission, ownership/scope, validation, transaction boundary, table access, audit/event behavior, and error handling where applicable.
                      * Do not include secrets, passwords, tokens, OTPs, hidden tests, raw private PII, or raw source code containing secrets.
                      * Do not add employer, recruitment, job, CV, interview, matching, shortlist, offer, or hiring behavior unless explicitly approved in the BD.

                      ## Required Content Per File

                      ### `01_Overview/Overview.md`

                      Fill API identity, business goal, scope, source trace, preconditions, postconditions, authorization/scope, data ownership, async work, and open questions.

                      ### `02_History/History.md`

                      Keep the existing history structure. Create the initial `v0.1` row and append future changes only.

                      ### `03_Request/Request.md`

                      Define all relevant headers, path parameters, query parameters, body fields, validation order, and valid JSON request example.

                      ### `04_Response/Response.md`

                      Define response matrix, success envelope, error envelope, response data fields, pagination, and async response behavior if applicable.

                      ### `05_DataMapping/DataMapping.md`

                      Define runtime flow, table read/write mapping, repository methods, transaction/idempotency/concurrency decisions, audit/event/job behavior, and derived tests.

                      ### `06_Error/Error.md`

                      Define stable error catalog entries, HTTP status, business code, safe client message, retry policy, log level, and linked test IDs.

                      ### `API_DD_CHECKLIST.md`

                      Update every checklist item based on the completed DD. Leave unchecked items only when they are genuinely incomplete or blocked.

                      ## Quality Gate

                      Before finishing, verify:

                      * No unresolved template placeholder remains.
                      * API method, endpoint, actor, auth, permission, and scope are consistent across all files.
                      * Request fields match validation and error catalog entries.
                      * Response examples match the response field table.
                      * Data mapping lists all known reads/writes and transaction boundaries.
                      * Every error has a safe message and test reference.
                      * Unknown requirements are recorded as `OPEN_QUESTION`.
                      * The output folder structure and Markdown section/table structure are identical to `Study2Work_API_DD_Template`.

                      ## Final Response Format

                      Return only:

                      ```text
                      STATUS: DONE | BLOCKED
                      TARGET: <TARGET_DIR>
                      FILES: <created/updated files>
                      OPEN_QUESTIONS: <count and IDs, or ->
                      ```

                  ]

              2.  Screen: Tạm thời chưa cập nhật

            - Ứng dụng di động:
              Đọc prompt dưới đây đẻ thiết kế DD:
              [ # Create Module DD From Template

                    Create a complete Design Description package for **one software module**.

                    ## Input

                    * `MODULE_CODE`: `<e.g. LEARN, AUTH, PROFILE>`
                    * `MODULE_NAME`: `<business module name>`
                    * `TECHNICAL_NAME`: `<snake_case module name>`
                    * `TARGET_DIR`: `docs/DD/DD_<MODULE_CODE>/`
                    * `TEMPLATE_DIR`: `<path>/DD_Module_Template`
                    * `SOURCE_BD`: `<BD/BRD path and section>`
                    * `RELATED_SOURCES`: `<related DD, checklist, issue, ADR, diagram, existing code path>`
                    * `RELEASE_SCOPE`: `<MVP / V1 / V2 / Sprint>`

                    ## Task

                    1. Read only the relevant BD, related DD, checklist, issue, diagram, and code needed for this module.
                    2. Copy the entire `TEMPLATE_DIR` into `TARGET_DIR`.
                    3. Fill the copied template with the complete module DD.
                    4. Keep the generated folder structure, headings, tables, anchors, checklist items, Mermaid blocks, and section order **exactly identical** to the template.

                    ## Required Output Structure

                    ```text
                    DD_<MODULE_CODE>/
                    ├── README.md
                    ├── Overall.md
                    ├── List_Features.md
                    ├── Function_List.md
                    ├── Views.md
                    ├── Import_File.md
                    ├── diagrams/
                    │   └── README.md
                    ├── assets/
                    │   └── README.md
                    └── history/
                        └── README.md
                    ```

                    ## Mandatory Rules

                    * One folder represents one module only.
                    * Do not rename, delete, merge, reorder, or add top-level DD files.
                    * Do not remove template headings, table columns, Mermaid sections, checklist sections, anchors, or note blocks.
                    * Replace applicable `{{...}}` and `[MODULE_CODE]` placeholders with concrete content.
                    * For unavailable information, write `N/A`.
                    * For unclear business requirements, write `OPEN_QUESTION`; do not invent rules or behavior.
                    * Do not modify application source code. This task creates or updates DD only.
                    * Keep the template’s existing language, headings, and Markdown format unchanged. Fill content using the language of the BD/source documents.
                    * Do not duplicate business rules: define each rule fully only in `Overall.md`; other files must reference its ID.
                    * Do not add out-of-scope business behavior not stated in the source documents.
                    * Do not include secrets, tokens, passwords, private keys, production PII, or raw credentials.

                    ## Traceability Convention

                    Use these IDs consistently across all files:

                    ```text
                    [MODULE_CODE]             e.g. LEARN
                    [MODULE]-Fxx              Feature
                    [MODULE]-FNxx             Function / use case
                    [MODULE]-Vxx              View
                    [MODULE]-BRxx             Business rule
                    [MODULE]-APIxx            API / event integration
                    [MODULE]-E-<name>         Entity / table
                    [MODULE]-ADRxx            Design decision
                    [MODULE]-RISKxx           Risk / assumption / open question
                    ```

                    Every referenced ID must exist. Do not create dangling links.

                    ## Required Content by File

                    ### `README.md`

                    Keep the template guidance and structure. Replace module-specific placeholders only where needed.

                    ### `Overall.md`

                    Complete every existing section:

                    1. Document metadata.
                    2. Business problem, value, goals, and non-goals.
                    3. Module boundary, ownership, context diagram, inputs, outputs, and side effects.
                    4. Actors, roles, permissions, and feature permission matrix.
                    5. Feature index linked to `List_Features.md`.
                    6. End-to-end happy path, alternate path, and error path.
                    7. State machine and valid state transitions when applicable.
                    8. Business rules as the single source of truth.
                    9. Data ownership, entities, retention, idempotency, transactions, and consistency.
                    10. APIs, events, external integrations, and owners.
                    11. Measurable NFR, security, reliability, observability, availability, and accessibility.
                    12. Risks, assumptions, open questions, and design decisions.
                    13. Full BD → rule → feature → function → view → API/entity → test traceability matrix.
                    14. Approval checklist.

                    ### `List_Features.md`

                    * Fill feature inventory and dependency map.
                    * Create one complete `[MODULE]-Fxx` block for every feature.
                    * Each feature must include sections `A` through `I` exactly as in the template.
                    * Link every feature to source requirements, business rules, functions, views, entities, APIs, events, risks, and acceptance criteria.
                    * Include happy path, alternate flow, error flow, idempotency, and required tests.

                    ### `Function_List.md`

                    * Keep the template layer direction:

                    ```text
                    Presentation
                    → Controller / Provider / API handler
                    → Use case / Service
                    → Repository
                    → Datasource / DAO / API client
                    → Database / External service
                    ```

                    * Create one complete `[MODULE]-FNxx` block for every implementation function/use case.
                    * Each function must have one clear responsibility.
                    * Include input/output contract, permissions, validations, business rules, transaction boundary, side effects, retry/fallback, security controls, code/import mapping, and test checklist.
                    * Do not allow UI to access DAO, ORM, database, or API client directly.

                    ### `Views.md`

                    * Fill view inventory and navigation map.
                    * Create one full `[MODULE]-Vxx` block for every page, modal, drawer, widget, or entry view.
                    * Each view must define layout components, data source, validation, interaction-to-function mapping, cache/fetch rules, copywriting, UX, accessibility, and permission behavior.
                    * Every relevant view must define: `Initial`, `Loading`, `Success`, `Empty`, `Validation error`, `Business error`, `System error`, `Unauthorized`, `Forbidden`, and `Offline` states.
                    * Do not expose stack traces, database details, or sensitive system messages in UI copy.

                    ### `Import_File.md`

                    * Keep dependency direction and layer restrictions from the template.
                    * Define package/external dependency registry only for dependencies actually needed.
                    * Map every significant created or modified file to its layer, responsibility, allowed imports, forbidden imports, exports, and linked feature/function/view.
                    * Define integration contracts, config key names only, feature flags, exports, timeout, retry, fallback, and test mapping.
                    * Never put actual secret values, API keys, connection strings, or tokens into this document.

                    ### `diagrams/README.md`, `assets/README.md`, `history/README.md`

                    Keep these files and their structure.

                    * Put Mermaid, ERD, sequence, state, or context diagrams in `diagrams/` only when they improve understanding.
                    * Put mockups, wireframes, prototype screenshots, or test-safe visual references in `assets/`.
                    * Put only deprecated DD versions in `history/`; never edit historical files.

                    ## Quality Gate

                    Before finishing, verify:

                    * No applicable `{{...}}` placeholder remains.
                    * No feature, function, view, rule, API, entity, ADR, or risk ID is duplicated or missing.
                    * Every feature links to at least one function; every user-facing feature links to at least one view.
                    * Every function has input/output, authorization, error handling, side effect, and test coverage.
                    * Every view has required UI states and interaction mapping.
                    * Business rules are defined once in `Overall.md` and referenced elsewhere.
                    * API, entity, state, role, and permission descriptions are consistent across all files.
                    * `Import_File.md` follows the project architecture and has no reverse-layer imports.
                    * Unknown requirements are recorded as `OPEN_QUESTION`.
                    * The final folder structure and Markdown structure remain identical to `DD_Module_Template`.

                    ## Final Response Format

                    Return only:

                    ```text
                    STATUS: DONE | BLOCKED
                    TARGET: <TARGET_DIR>
                    FILES: <created/updated files>
                    OPEN_QUESTIONS: <count and IDs, or ->
                    ```

              ]
