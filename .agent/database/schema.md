# Database Schema

## SQLite Database
- File name: `auth.db`
- Version: `3`
- Schema source: `lib/config/config_DB.dart`

## Tables
| Table | Purpose | Key fields | Evidence |
|---|---|---|---|
| `session` | Stores current login/session data. | `id`, `user`, `pass`, `cookie`, `token`, `active` | `lib/config/config_DB.dart` |
| `notifications` | Stores portal notification data. | `id`, `tieu_de`, `noi_dung`, `ngay_gui`, `is_da_doc` | `lib/config/config_DB.dart` |
| `student_data` | Stores detailed student profile data. | `ma_sv`, `ten_day_du`, `email`, `lop`, `nganh`, `khoa`, many portal fields | `lib/config/config_DB.dart` |
| `notification_history` | Stores detected data changes and notification state. | `id`, `change_id`, `data_type`, `change_type`, `entity_id`, `old_hash`, `new_hash`, `is_read`, `created_at`, `notified_at` | `lib/config/config_DB.dart` |
| `chat_notifications` | Stores local chat notification records. | `id`, `conversation_id`, `sender_student_id`, `sender_name`, `message`, `created_at`, `is_read` | `lib/config/config_DB.dart` |
| `cached_scores` | Cached watched score data. | `id`, `data_type`, `entity_id`, `payload`, `payload_hash`, `cached_at` | `lib/config/config_DB.dart` |
| `cached_schedule` | Cached watched schedule data. | same cache shape | `lib/config/config_DB.dart` |
| `cached_exam_schedule` | Cached watched exam schedule data. | same cache shape | `lib/config/config_DB.dart` |
| `cached_tuition` | Cached watched tuition data. | same cache shape | `lib/config/config_DB.dart` |
| `cached_course_register` | Cached watched course registration data. | same cache shape | `lib/config/config_DB.dart` |
| `cached_training_notifications` | Cached watched training notifications. | same cache shape | `lib/config/config_DB.dart` |
| `thoi_khoa_bieu` | Local schedule table. | `id`, `thu_kieu_so`, `tiet_bat_dau`, `so_tiet`, `ten_mon`, `ten_giang_vien`, `ma_phong`, `ngay_hoc` | `lib/config/config_DB.dart` |

## Indexes and Constraints
| Object | Purpose | Evidence |
|---|---|---|
| `notification_history.change_id UNIQUE` | Avoid duplicate change records. | `lib/config/config_DB.dart` |
| `idx_notification_history_data_type` | Query changes by type and time. | `lib/config/config_DB.dart` |
| `idx_notification_history_unread` | Query unread changes. | `lib/config/config_DB.dart` |
| `idx_chat_notifications_unread` | Query unread chat notifications. | `lib/config/config_DB.dart` |
| `idx_chat_notifications_sender` | Query chat notifications by sender. | `lib/config/config_DB.dart` |
| `UNIQUE(data_type, entity_id)` on cached tables | One cache record per watched entity. | `lib/config/config_DB.dart` |
| `idx_<cache_table>_hash` | Query cached payload hashes. | `lib/config/config_DB.dart` |
| `idx_thoi_khoa_bieu_ngay_hoc` | Query schedule by date and start period. | `lib/config/config_DB.dart` |

## Relationships
- Local SQLite relationships are not declared as foreign keys in the schema source.
- Cache tables relate to `WatchedDataType` values in `lib/features/notification/models/data_change_models.dart`.
- `notification_history.change_id` is used by `DataChangeSqliteService` for idempotent insert behavior.

Evidence: `lib/config/config_DB.dart`, `lib/features/notification/models/data_change_models.dart`, `lib/core/services_root/sqlite/notification/data_change_sqlite.dart`

## OPEN_QUESTION
- `OPEN_QUESTION-DB-03:` No entity relationship diagram or formal local database ownership document exists.
