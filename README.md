# Interior Design

AI-powered interior design visualization app. Upload a room photo, select a style, and let Gemini AI redesign your space.

## Features

- **AI Room Redesign**: Uses Gemini 2.0 Flash to transform room photos into professionally styled interiors
- **12 Design Styles**: Modern Minimalist, Scandinavian, Industrial, Mid-Century Modern, and more
- **Project History**: Save and resume previous designs from the home screen
- **Before/After Toggle**: Compare original and generated images
- **Dark Theme UI**: Clean, professional interface

## Setup

### Prerequisites

- Flutter SDK 3.5+
- Google AI API key (get one at [Google AI Studio](https://aistudio.google.com/apikey))

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

5. Configure your API key in Settings

## Architecture

```
lib/
├── core/
│   ├── theme/              # Dark theme system
│   ├── routes/             # go_router setup
│   ├── services/           # API key, Gemini, project history
│   ├── connectivity/       # Network status handling
│   └── di/                 # get_it dependency injection
├── features/
│   ├── auth/               # Authentication (placeholder)
│   ├── design_studio/      # Main design creation
│   ├── gallery/            # Home screen with project list
│   └── settings/           # API key configuration
└── shared/
    └── widgets/            # Reusable UI components
```

## Tech Stack

- **State Management**: flutter_bloc
- **Code Generation**: freezed, json_serializable
- **Navigation**: go_router
- **DI**: get_it, injectable
- **HTTP**: dio
- **Local Storage**: shared_preferences
