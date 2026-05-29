# Initial Project Setup Plan

> **Project:** `initial_project` · **SDK:** Flutter ≥ 3.12.0 · **Dart:** ≥ 3.12.0

A step-by-step bootstrapping checklist for the Flutter starter template.
Items marked ✅ are complete; ⬜ are pending.

---

## Phase 1 — Build Infrastructure

| #  | Task                         | Status | Notes                                                                                          |
|----|------------------------------|--------|------------------------------------------------------------------------------------------------|
| 1  | Makefile                     | ✅     | Modular system with 7 includes (`general`, `deps`, `build`, `codegen`, `vectors`, `maintenance`, `git`) |
| 2  | LocalSource package          | ✅     | Workspace package at `packages/local_source` — encrypted prefs via `SharedPreferences` + `encrypt` |
| 3  | `android-settings.sh`        | ✅     | Auto-generates `key.properties` and release keystore (`keytool`) when missing                  |

---

## Phase 2 — Dependencies & Architecture

| #  | Task                         | Status | Notes                                                                                            |
|----|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| 4  | Necessary packages           | ⬜     | Add core deps: `dio`, `get_it`, `go_router`, `flutter_bloc`, `intl`, `flutter_gen`, etc.         |
| 5  | Folder structure              | ⬜     | Establish feature-first layout under `lib/src/` (see [proposed tree](#proposed-folder-structure)) |
| 6  | Extensions                   | ⬜     | Context extensions (`BuildContext` → theme, media query), `String`, `DateTime`, etc.             |
| 7  | Mixins                       | ⬜     | Common mixins — form validation, logging, after-layout callback                                  |
| 8  | Base widgets                 | ⬜     | Reusable primitives: `BaseScaffold`, `BaseButton`, `BaseTextField`, shimmer loader, etc.         |

---

## Phase 3 — App Core

| #  | Task                         | Status | Notes                                                                                            |
|----|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| 9  | `main.dart`                  | ⬜     | Replace default counter app — wire up DI, router, bloc observers, environment config             |
| 10 | Dependency Injection         | ⬜     | `get_it` + `injectable` — register repos, data sources, blocs in a central `injection.dart`      |
| 11 | Routing                      | ⬜     | `go_router` — typed routes, shell routes for bottom nav, redirect guards for auth                |
| 12 | State Management             | ⬜     | `flutter_bloc` / `cubit` — base cubit, bloc observer, per-feature blocs                         |

---

## Phase 4 — Localization & Networking

| #  | Task                         | Status | Notes                                                                                            |
|----|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| 13 | Localization                 | ⬜     | `intl` + Flutter l10n — ARB files in `lib/src/common/localization/`, template: `intl_ru.arb`     |
| 14 | API Client                   | ⬜     | `dio` with interceptors — auth token, logging (`thunder`), retry, error mapping                  |

---

## Phase 5 — Assets & Branding

| #  | Task                         | Status | Notes                                                                                            |
|----|------------------------------|--------|--------------------------------------------------------------------------------------------------|
| 15 | `flutter_gen` asset codegen  | ⬜     | Type-safe asset references — images, fonts, colors from `pubspec.yaml`                           |
| 16 | Assets, icons & logo         | ⬜     | App icon + adaptive icon (Android 12+), logo assets for splash & in-app use                      |
| 17 | Splash & icon generation     | ⬜     | `flutter_native_splash` + `flutter_launcher_icons` — YAML configs already present at project root |

---

## Proposed Folder Structure

```
lib/
├── main.dart                         # Entry point — env bootstrap, DI init, runApp
└── src/
    ├── common/
    │   ├── extensions/               # Context, String, DateTime extensions
    │   ├── mixins/                   # Form validation, logging, etc.
    │   ├── localization/             # ARB files + generated l10n
    │   ├── theme/                    # AppTheme, colors, typography
    │   ├── widgets/                  # Base / shared widgets
    │   └── utils/                    # Helpers, constants, formatters
    ├── core/
    │   ├── di/                       # get_it injection container
    │   ├── network/                  # Dio client, interceptors, API exceptions
    │   └── router/                   # GoRouter config, route names, guards
    └── features/
        ├── auth/                     # login, register, forgot-password
        │   ├── data/
        │   ├── domain/
        │   └── presentation/
        └── home/
            ├── data/
            ├── domain/
            └── presentation/
```

---

## Quick Reference — Make Targets

```bash
make help              # List all targets
make get               # flutter pub get
make apk               # Release APK  (dev config)
make aab               # Release AAB  (prod config)
make ipa               # Release IPA  (prod config)
make icons             # Regenerate launcher icons
make splash            # Regenerate native splash
make l10n              # Regenerate localization
make fluttergen        # Regenerate flutter_gen assets
make format            # dart format (line length 120)
make analyze           # flutter analyze
```
