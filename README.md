# LabVnua

> A Flutter student academic companion for Vietnam National University of Agriculture, branded in-app as EduAI.

## Overview

LabVnua is a Flutter mobile application that helps VNUA students access academic information from one place. The app includes a student login flow, a dashboard, academic service screens, local notifications, realtime chat, QR scanning, and an AI assistant integration.

The repository is suitable as a portfolio project because it shows mobile UI work, API integration, local storage, background synchronization, realtime backend usage, and client-side configuration handling.

## Key Features

- Student authentication against the VNUA training portal API, with local session persistence.
- Student home dashboard with quick access to schedule, grades, tuition, and chat.
- Academic modules for schedule, score lookup, score analysis, tuition, course registration, training program, prerequisite subjects, notifications, and student profile data.
- Local SQLite storage for sessions and cached student/notification data.
- Background data synchronization and local notifications for academic data changes.
- Realtime chat using Supabase tables and realtime subscriptions for users, conversations, and messages.
- AI assistant using the Google Generative AI SDK, with optional notification context from local SQLite data.
- QR code scanner built with `mobile_scanner`.
- Connectivity-aware startup with a dedicated no-network screen.

## Tech Stack

- Flutter / Dart
- Flutter built-in state management with `StatefulWidget`, `StatelessWidget`, controllers, and services
- `http` for VNUA training portal API calls
- `sqflite` for local persistence
- `supabase_flutter` for realtime chat data
- `google_generative_ai` for the AI assistant
- `flutter_local_notifications` and `workmanager` for notifications and background sync
- `mobile_scanner` for QR scanning
- `connectivity_plus` for network checks

## Architecture

The codebase follows a feature-first Flutter structure. Shared UI, theme, constants, API wrappers, SQLite services, notification utilities, and Supabase setup live under `lib/core/`, while user-facing modules live under `lib/features/`. Feature folders generally contain `screens`, `controllers`, `services`, and `models`.

The app does not currently use a dedicated external state-management framework. Most state is handled through Flutter widgets, controller classes, service classes, and local database/API layers.

## Project Structure

```text
lib/
  app.dart
  main.dart
  config/
  core/
    constants/
    models/
    screens/
    services_root/
    theme/
    widgets/
  features/
    ai_assistant/
    auth/
    chat/
    course_register/
    home/
    infor/
    notification/
    prerequisite_subjects/
    program_training/
    qr_code/
    schedure/
    score_data/
    tuition/
assets/
docs/
test/
android/
ios/
web/
```

## Getting Started

### Prerequisites

- Flutter SDK with Dart `^3.9.2`
- Android Studio or Xcode for mobile builds
- A valid VNUA training portal account for authenticated student flows
- Supabase and Gemini configuration values for chat and AI features

### Installation

```bash
flutter pub get
```

### Run the Application

```bash
flutter run \
  --dart-define=GEMINI_API_KEY=... \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

On Windows PowerShell, use one line:

```powershell
flutter run --dart-define=GEMINI_API_KEY=... --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

### Run Tests

```bash
flutter test
```

## Configuration

Runtime client configuration is provided with Dart compile-time defines:

| Key | Purpose |
| --- | --- |
| `GEMINI_API_KEY` | Enables the AI assistant integration. |
| `SUPABASE_URL` | Supabase project URL for realtime chat. |
| `SUPABASE_ANON_KEY` | Supabase anonymous client key for realtime chat. |

Do not commit real keys to the repository. Use `.env.example` only as a blank reference for local setup. Existing keys that were previously committed should be rotated and reviewed in Git history before making the repository public.

## Current Status

- MVP in active development.
- Core student flows are implemented in source code.
- Chat, notifications, QR scanning, and AI assistant integrations are present.
- Some menu entries are visible UI placeholders and should not be treated as completed features.
- Automated test coverage is minimal.

## Roadmap

- Complete or hide placeholder menu entries that currently have empty handlers.
- Replace print-based debug logging and TODO logging comments with structured logging.
- Add focused tests for service parsing, controllers, and pure business helpers.
- Add real application screenshots after verified screenshots are available in the repository.

## Author

Dao Van Hung - Full-stack Developer

GitHub: https://github.com/daovanhung-dev

LinkedIn: https://www.linkedin.com/in/daovanhung11092005

## License

No license file is currently provided in this repository.
