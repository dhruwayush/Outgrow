# Outgrow

A gentle habit-exit tracker built with Flutter. Pick a habit you want to leave
behind, check in each day you avoid it, and log slips honestly when they happen.

## Features

- **Daily check-ins** – one log per day: "I avoided it" or "I slipped".
- **Streaks** – calculated from your logged days, so a missed day ends the
  current streak. Your best streak is kept.
- **Slip journaling** – record what triggered a slip, plus an optional note.
- **Urge tools** – a guided breathing exercise for riding out cravings.
- **Insights and badges** – trigger patterns, monthly progress and milestones.
- **Daily reminder** notification and light/dark themes.

All data stays on the device (Hive).

## Development

```sh
flutter pub get
flutter run
flutter test       # streak logic and habit provider tests
flutter analyze
```

Regenerate the Hive adapters after changing a model:

```sh
dart run build_runner build --delete-conflicting-outputs
```

### Release build

```sh
flutter build apk --release
```

Release signing reads `keyAlias`, `keyPassword`, `storeFile` and
`storePassword` from `android/local.properties`.
