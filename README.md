# Flavr — AI-Powered Food Suggestions

Flavr is a Flutter mobile app that acts as your personal AI nutritionist and culinary companion. It learns your dietary profile through a guided onboarding flow and uses Google Gemini AI to generate personalized meal recommendations tailored to your preferences, health goals, and allergies.

---

## Features

### Onboarding Wizard (6 steps)
A guided setup flow that builds your dietary profile:
1. **Dietary Style** — Omnivore, vegetarian, vegan, pescatarian, keto, and more
2. **Allergies** — Gluten, dairy, nuts, shellfish, eggs, soy, and more
3. **Favorite Cuisines** — Pick up to 5 (Italian, Indian, Japanese, Mexican, etc.)
4. **Health Goal** — Balanced diet, weight loss, muscle gain, heart health, energy boost, gut health, or diabetic-friendly
5. **Spice Tolerance** — None, mild, medium, hot, or extra hot
6. **Review & Confirm** — Summary of your full profile before saving

### Discover Screen
- Displays 5 AI-generated meal suggestions tailored to your profile
- Pull-to-refresh to get a new batch
- **Load More** to append 5 additional suggestions
- **Surprise Me** FAB for a full regeneration

### Suggestion Detail
Each suggestion includes:
- Dish name, description, and cuisine type
- Full macro breakdown (calories, protein, carbs, fat)
- Ingredients list
- Prep time and spice level
- Dietary tags
- Personalized "Why it fits you" bullets explaining how the dish matches your goals

### Profile Screen
- View your full saved preference profile
- Edit any individual section directly from the profile (re-opens the relevant onboarding step)

### AI Integration
- Powered by **Google Gemini 1.5 Flash**
- A structured system prompt instructs the AI to respond with a strict JSON array
- Automatic retry logic: if the first response cannot be parsed, a stricter re-prompt is sent
- No backend server — the app communicates directly with the Gemini API

### Offline Persistence
- User preferences are stored locally using **Hive** (a fast, lightweight NoSQL store)
- Your profile survives app restarts with no account or internet required after onboarding

### Theming
- Warm food-themed palette (primary orange `#E8633A`, secondary green `#2D6A4F`)
- Full light and dark mode support, follows the system setting
- Nunito typeface throughout

---

## Architecture

Flavr follows **Clean Architecture** with three clear layers:

```
lib/
├── core/             # Constants, theme, shared widgets, error types, utilities
├── domain/           # Models (Hive-backed), enums, repository interfaces
├── data/             # Hive local source, Gemini remote source, repository implementations
└── features/         # Onboarding, Home, Suggestions, Profile — each with providers + screens
```

**State management:** Riverpod (`flutter_riverpod` + `riverpod_annotation`)  
**Routing:** `go_router` with named route constants  
**Dependency injection:** wired in `lib/providers.dart`

---

## Requirements

| Requirement | Version |
|---|---|
| Flutter | 3.x (stable channel recommended) |
| Dart SDK | >=3.4.0 <4.0.0 |
| Android SDK | API 21+ (Android 5.0+) |
| Xcode | 15+ (for iOS builds) |
| Google Gemini API key | Required — see setup below |

---

## Getting a Gemini API Key

1. Go to [Google AI Studio](https://aistudio.google.com)
2. Sign in with your Google account
3. Click **Get API key** → **Create API key**
4. Copy the generated key

---

## Setup & Running

### 1. Clone the repository

```bash
git clone https://github.com/your-username/flavr.git
cd flavr
```

### 2. Create your `.env` file

Create a `.env` file in the project root:

```bash
GEMINI_API_KEY=your_gemini_api_key_here
```

> The `.env` file is bundled as a Flutter asset and loaded at startup. It is excluded from git via `.gitignore` — never commit your API key.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run code generation

Hive type adapters and Riverpod providers are generated — run this once after cloning (and again after modifying any annotated models or providers):

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
# On a connected device or emulator
flutter run

# List available devices
flutter devices
```

### 6. Build a release APK (Android)

```bash
flutter build apk --release
```

### 7. Build for iOS

```bash
flutter build ipa
```

---

## Project Structure

```
d:\MT\
├── .env                          # API key (not committed)
├── pubspec.yaml                  # Project manifest & dependencies
├── analysis_options.yaml         # Lint configuration
└── lib\
    ├── main.dart                 # Entry point
    ├── app.dart                  # Root MaterialApp.router widget
    ├── providers.dart            # Global Riverpod DI wiring
    ├── router\                   # GoRouter config + route name constants
    ├── core\
    │   ├── constants\            # App-wide constants and Gemini config
    │   ├── errors\               # AppException types (API quota, network, parse)
    │   ├── theme\                # Colors, spacing, typography, MaterialTheme
    │   ├── utils\                # PromptBuilder (constructs Gemini prompts)
    │   └── widgets\              # Shared reusable widgets
    ├── domain\
    │   ├── models\               # UserPreferences, FoodSuggestion, enums (Hive-backed)
    │   └── repositories\         # Repository interfaces
    ├── data\
    │   ├── local\                # Hive service + preferences local source
    │   ├── remote\               # Gemini client + food remote source (with retry)
    │   └── repositories\         # Repository implementations
    └── features\
        ├── home\                 # Home/dashboard screen
        ├── onboarding\           # 6-step wizard (providers + screens + widgets)
        ├── suggestions\          # Suggestions list + detail (providers + screens)
        └── profile\              # Profile display screen
```

---

## Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `riverpod_annotation` | Code generation for Riverpod providers |
| `go_router` | Declarative navigation |
| `hive_flutter` | Local NoSQL persistence |
| `google_generative_ai` | Google Gemini AI SDK |
| `flutter_dotenv` | `.env` file loading |
| `uuid` | Unique IDs for suggestion objects |
| `equatable` | Value equality for domain models |
| `intl` | Internationalization utilities |

---

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `GEMINI_API_KEY` | Yes | Your Google Gemini API key from AI Studio |

---

## Troubleshooting

**`GEMINI_API_KEY not found` error**  
Make sure `.env` exists in the project root and contains `GEMINI_API_KEY=...`.

**Code generation errors**  
Run `dart run build_runner build --delete-conflicting-outputs` to regenerate Hive adapters and Riverpod providers after any model changes.

**`MissingPluginException` on Android**  
Run `flutter clean && flutter pub get && flutter run` to clear the build cache.

**Gemini returns empty or malformed results**  
The app has built-in retry logic. If suggestions consistently fail, check that your API key is valid and has not exceeded its quota.
