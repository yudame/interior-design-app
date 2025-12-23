# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Interior Design** - AI-powered interior design visualization app. Users upload room photos, select from 12 design styles, and Gemini AI generates professionally redesigned versions.

## Commands

```bash
# Install dependencies
flutter pub get

# Code generation (required after modifying freezed models)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs  # continuous mode

# Run app
flutter run -d ios
flutter run -d android

# Run tests
flutter test
flutter test test/path/to_test.dart           # single file
flutter test --name "test description"        # by name

# Format and lint
dart format .
dart analyze
```

## Architecture

Two-layer architecture (Presentation + Data, no domain layer):

```
lib/
├── core/           # Cross-cutting: theme, routes, DI, connectivity, Result type
├── features/       # Feature modules with data/ and presentation/ subdirs
└── shared/         # Reusable widgets (NeonButton, GlassCard, etc.)
```

Each feature module:
- `data/models/` - Freezed models with JSON serialization
- `data/repositories/` - Abstract interfaces + implementations
- `data/datasources/` - Remote (Firebase) and local (Hive) sources
- `presentation/bloc/` - BLoC with Freezed events/states
- `presentation/pages/` - Screen widgets
- `presentation/widgets/` - Feature-specific components

## Key Patterns

### Result Type
All repository operations return `Result<T>` (success/failure/loading sealed union) instead of throwing exceptions. Defined in `lib/core/utils/result.dart`.

### Connectivity-Aware Repositories
Handle three states: online (full API), poor (5s timeout + cache fallback), offline (cache only + queue for sync).

### Freezed Models
All models, BLoC events, and states use Freezed. After changes, run `dart run build_runner build --delete-conflicting-outputs`.

### Dependency Injection
Uses get_it + injectable. Register services in classes with `@injectable` or `@singleton`. Configuration generates to `lib/core/di/injection.config.dart`.

## Design System

Professional dark theme:
- Colors: `lib/core/theme/app_colors.dart` (cyan accent `#38bdf8`, dark slate backgrounds)
- Typography: `lib/core/theme/app_typography.dart`
- Fonts: JetBrains Mono (headings/labels) + Inter (body text)

## Firebase Setup (Future)

Bundle ID: `me.yuda.interior-design-app`

1. Create Firebase project
2. Add iOS app, download `GoogleService-Info.plist` to `ios/Runner/`
3. Enable: Email/Password Auth, Apple Sign-In, Firestore, Storage

## Key Implementation Files

### Services
- `lib/core/services/api_key_service.dart` - Stores Google AI API key using SharedPreferences
- `lib/core/services/gemini_service.dart` - Calls Gemini API for image generation (gemini-2.0-flash-exp-image-generation model)
- `lib/core/services/project_history_service.dart` - Local project history storage using SharedPreferences

### Design Studio
- `lib/features/design_studio/presentation/pages/design_studio_page.dart` - Main design page with image picker, style selection, before/after toggle, and render button
- `lib/features/design_studio/presentation/widgets/processing_overlay.dart` - Processing overlay with progress indicator
- `lib/features/design_studio/data/models/style_preset.dart` - 12 design style presets

### Gallery (Home)
- `lib/features/gallery/presentation/pages/gallery_page.dart` - Home screen with project history list, tap to resume project in studio

### Settings
- `lib/features/settings/presentation/pages/settings_page.dart` - API key configuration UI

## Notes

- hive_generator removed due to analyzer conflict with freezed; use manual TypeAdapters for Hive
- GeminiService uses Google AI REST API directly via Dio (not firebase_vertexai)
- API key stored with SharedPreferences (switched from FlutterSecureStorage for simulator compatibility)
- 12 style presets defined in `StylePresets.all`
- Implementation status tracked in `TODO.md`
- App icon: Add 1024x1024 PNG to `assets/icon/app_icon.png`, then run `dart run flutter_launcher_icons`
