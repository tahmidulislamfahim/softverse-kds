# Softverse KDS

A Flutter-based **Kitchen Display System (KDS)** app for Softverse. It shows
incoming orders in real time, lets a device pair itself as a KDS terminal,
supports recalling completed/past orders, and provides app settings —
built with **GetX** for state management/routing and **flutter_screenutil**
for responsive, device-independent sizing.

## Features

- **Splash** — app bootstrap and initial routing.
- **Pair** — pair a device as a KDS terminal (device name / IP address).
- **Home** — live order queue with swipeable order cards showing customer,
  table, items, and status.
- **Recall** — browse and recall previously completed orders.
- **Settings** — app-level preferences, including light/dark theme.

## Tech stack

| Concern              | Package                |
|-----------------------|------------------------|
| State management/routing | [get](https://pub.dev/packages/get) |
| Responsive sizing      | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) |
| Networking             | [http](https://pub.dev/packages/http) |
| Local persistence       | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Environment config      | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |
| Icons                  | [iconsax_flutter](https://pub.dev/packages/iconsax_flutter), cupertino_icons |
| Fonts                  | [google_fonts](https://pub.dev/packages/google_fonts) |
| Loading states          | [skeletonizer](https://pub.dev/packages/skeletonizer) |
| Snackbars/toasts        | [awesome_snackbar_content](https://pub.dev/packages/awesome_snackbar_content) |
| Dates                  | [intl](https://pub.dev/packages/intl) |
| External links          | [url_launcher](https://pub.dev/packages/url_launcher) |

## Project structure

```
lib/
  core/
    bindings/        # GetX controller bindings (dependency injection)
    common/
      styles/        # shared text style helpers
      widgets/        # reusable, cross-feature widgets
    controller/       # app-wide controllers (e.g. ThemeController)
    models/           # shared models
    services/         # network caller, local storage service
    utils/
      constants/      # API constants, AppColors
      helpers/        # misc app helpers
      theme/          # light/dark theme, theme extensions
  features/
    <feature_name>/
      controller/     # GetxController for the feature
      views/screens/  # routed screens
      widgets/         # feature-specific widgets
      models/          # feature-specific models
  routes/             # named routes (AppRoute)
  app.dart            # GetMaterialApp setup
  main.dart           # entry point
```

Each feature (`splash`, `pair`, `home`, `recall`, `settings`) is self-contained
under `lib/features/<feature_name>/`. See
[`.claude/CLAUDE.md`](.claude/CLAUDE.md) for the full conventions used when
adding new features/screens.

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.11.1`)
- An editor with Flutter/Dart support (VS Code, Android Studio, etc.)

### Setup

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Create a `.env` file in the project root with the API base URL:

   ```env
   BASE_URL=https://your-api-base-url.com
   ```

3. Run the app:

   ```bash
   flutter run
   ```

### Useful commands

```bash
flutter analyze     # static analysis / lint
flutter test        # run tests
flutter pub get      # fetch dependencies (after pubspec/asset changes)
```

## Platforms

Configured for **Android** and **iOS** (see `android/` and `ios/`).

## Contributing

Follow the conventions documented in [`.claude/CLAUDE.md`](.claude/CLAUDE.md)
for feature structure, widgets, controllers, routing, and theming before
opening a PR.
