# Coding Standards

> **Purpose:** Keep the MobiFlex codebase consistent, testable, readable, and safe to change.

Use this file as the final checklist before a change is committed or merged.

---

## 1. Before every commit

Run these checks before committing:

```bash
dart format .
flutter analyze
flutter test
```
| Check | What it does | Pass condition |
|---|---|---|
| `dart format .`   | Applies the standard Dart formatting rules.  | Formatting completes successfully. |
| `flutter analyze` | Finds lint, type, and code-quality problems. | **Zero warnings and zero errors.** |
| `flutter test`    | Runs the relevant unit and widget tests.     | All relevant tests pass. |

### Editor setup

Enable **format on save** and **analysis on save** in your editor where possible. This catches issues while you work instead of immediately before a commit.

---

## 2. Static Analysis and Linting

`analysis_options.yaml` controls the project's lint rules.

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - public_member_api_docs
    - prefer_const_constructors
    - always_declare_return_types
    - avoid_print
    - require_trailing_commas
```

### Why these rules are used

| Rule | Purpose |
|---|---|
| `flutter_lints`               | Provides Flutter's standard baseline for common code quality and correctness issues. |
| `public_member_api_docs`      | Requires public classes and methods to have `///` documentation. |
| `prefer_const_constructors`   | Encourages widgets and objects that can be created as `const`. |
| `always_declare_return_types` | Makes function behaviour easier to understand from the declaration. |
| `avoid_print`                 | Keeps debugging output out of production code; use the project logger instead. |
| `require_trailing_commas`     | Keeps multi-line Dart code easier to format and review. |

### Suppressing a lint

Only suppress a lint when there is a genuine reason and keep the suppression as narrow as possible.

```dart
// ignore: avoid_print
print('debug: temporary local check');
```

Do not disable a project-wide rule just to silence one inconvenient line. Temporary debugging code should be removed before the final commit.

---

## 3. Project Structure

The project is **feature-focused** with shared code kept in `core/` and shared data abstractions kept in `data/`.

```text
lib/
  core/
    theme/          # Colours, typography, spacing
    widgets/        # Shared reusable widgets
    utils/          # Shared utilities

  data/
    models/         # Shared models such as Exercise, Routine and UserProfile
    repositories/   # Repository interfaces and implementations

  features/
    welcome/
    auth/
    home/
    explore/
    session_player/
    progress/
    profile/

  main.dart
```

### Structure rules

- Keep feature-specific UI and logic close to the feature that uses it.
- Use **one main widget class per file**.
- Match the filename to the class using `snake_case`.
  - `LoginScreen` -> `login_screen.dart`
- Screens should depend on repository **interfaces**, not direct Firebase calls.
- Firebase specific code belongs in the repository implementation, not in the screen.

This keeps UI code easier to test and allows Firebase implementations to be replaced by fakes during testing.

---

## 4. Naming Conventions

| Code element | Convention | Example |
|---|---|---|
| Classes, enums, typedefs         | `UpperCamelCase` | `LoginScreen` |
| Variables, functions, parameters | `lowerCamelCase` | `isSignedIn` |
| Files and folders                | `snake_case` | `login_screen.dart` |
| Constants                        | `lowerCamelCase` | `defaultSessionLength` |
| Booleans                         | Read like a question | `isLoading`, `hasError`, `canContinue` |

Use names that explain intent. Avoid vague names such as `data`, `thing`, `temp` or `value` when a clearer domain name is available.

---

## 5. Comments and Documentation

Use the right place for each type of documentation.

| Information | Where it belongs |
|---|---|
| Public class or method documentation | `///` dartdoc comment |
| Non-obvious implementation reason    | Short inline comment |
| Screen specific reasoning            | `SCREEN NOTES` at the top of the screen file |
| Large feature specific reasoning     | Feature `README.md` |
| Architecture or technology decision  | `docs/decisions.md` |
| Comment rules and examples           | `docs/comment-style.md` |

Comments should explain **why** something exists, not simply repeat what the code already says.

---

## 6. Logging

Use structured logging for runtime behaviour that may need to be diagnosed later.

```dart
_log.info('Auth: sign-in started');
```

### Logging rules

- Do not use `print()` in committed application code.
- Log useful events, failures and state transitions.
- Do not log passwords, authentication tokens or private user data.
- Comments explain **why the code is written a certain way**.
- Logs explain **what happened while the app was running**.

See `docs/comment-style.md` for the difference between comments and logs.

---

## 7. Testing

Test the part of the application that changed. Not every feature needs every type of test.

| Change | Minimum expected test |
|---|---|
| New screen or widget                     | Widget test for important rendering and behaviour |
| Validation or business logic             | Unit test |
| Recommendation or timer logic            | Unit test |
| New repository                           | Unit test using a fake implementation |
| Loading, empty or error state            | Widget test where practical |
| Critical journey such as sign-in -> home | Integration test before the relevant milestone or release |

### Test the important states

Where relevant, a feature should handle:

- loading;
- successful data;
- empty data;
- validation failure;
- backend/network failure.

A feature is not complete if only the happy path works.

---

## 8. Definition of Done

Before marking a feature as complete:

- [ ] Acceptance criteria are met.
- [ ] Loading, empty, validation and failure states are handled where relevant.
- [ ] Important business logic has unit tests.
- [ ] Important UI behaviour has widget tests.
- [ ] Relevant integration tests pass for critical journeys.
- [ ] `dart format .` has been run.
- [ ] `flutter analyze` returns zero warnings and zero errors.
- [ ] `flutter test` passes.
- [ ] Accessibility has been checked, including text scaling, contrast and touch target size.
- [ ] No temporary `print()` calls, debug code or commented out code remain.
- [ ] Documentation and decision notes are updated when the change introduces a new rule or architectural decision.
- [ ] The change is ready to be reviewed and merged without knowingly leaving avoidable cleanup work behind.
