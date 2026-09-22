# Coding Standards

This file is the checklist a change should pass before it's "done". 
See also `docs/comment-style.md` (how to comment) and
`docs/decisions.md` (why architectural choices were made).

---

## Before every commit

```bash
dart format .
flutter analyze
flutter test
```

- `dart format .` - auto formats to the standard Dart style. No debate
  about spacing/line breaks; the tool decides.
- `flutter analyze` - must return **zero warnings, zero errors**. Per the
  project's Definition of DONE, warnings don't get committed "to fix
  later" - they get fixed now while the context for why the code looks
  that way is still in your head.
- `flutter test` - relevant unit/widget tests pass. See "Testing" below
  for what "relevant" means per feature.

Turn on format-on-save and analyze-on-save in editor (VS Code's Dart
extension does both by default) so these show up as you type rather than
as a surprise at commit time.

---

## What `flutter analyze` enforces here, and why

`analysis_options.yaml` at the project root controls this. Base config:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - public_member_api_docs # every public class/method needs a `///` comment
    - prefer_const_constructors
    - always_declare_return_types
    - avoid_print # use the logger, not print()
    - require_trailing_commas
```

- **`flutter_lints`** - the official baseline (unused imports, missing
  `const`, common correctness issues). This is what `flutter create`
  wires up by default.
- **`public_member_api_docs`** - off by default, turned on here
  deliberately. It makes the dartdoc requirement in `comment-style.md`
  self-enforcing: `flutter analyze` fails the build if a public class or
  method has no `///` comment, rather than relying on remembering to add
  one.
- **`avoid_print`** - use the structured logger (see "Logging" below)
  instead of `print()`, so output can be filtered/tagged and works in
  release builds.

If a rule genuinely doesn't fit a specific line, suppress it narrowly and
say why:
```dart
// ignore: avoid_print
print('debug: one-off dev check, remove before commit');
```
Never disable a rule project wide to silence one inconvenient case.

---

## Project structure

Feature first, not layer first - everything for one screen/feature lives
together so opening one folder shows the whole feature rather than
scattering it across `screens/`, `widgets/`, `providers/`:

```
lib/
  core/
    theme/          # colours, typography, spacing constants
    widgets/        # shared reusable widgets (buttons, cards)
    utils/
  data/
    models/         # Exercise, Routine, Session, UserProfile
    repositories/   # abstract interfaces + fake + Firebase implementations
  features/
    welcome/
    auth/            # login, create_account
    home/
    explore/
    session_player/
    progress/
    profile/
  main.dart
```

- One widget class per file; filename matches the class in `snake_case`
  (`LoginScreen` -> `login_screen.dart`).
- Screens depend on repository **interfaces**, never directly on
  `FirebaseAuth`/`FirebaseFirestore` calls - this is what lets a screen be
  built and tested against a fake implementation before the real backend
  is wired in.

---

## Naming conventions

- Classes/enums/typedefs: `UpperCamelCase`
- Variables/functions/parameters: `lowerCamelCase`
- Files/folders: `snake_case`
- Constants: `lowerCamelCase` (Dart convention not `SCREAMING_CASE`)
- Booleans read as a question: `isLoading`, `hasError`, not `loading`, `error`

---

## Documentation & decisions

- **How to comment** -> `comment-style.md`
- **Architectural decisions** (state management, database
  choice, auth strategy) -> `decisions.md`, one entry per decision, ADR-lite
  format
- **Screen specific reasoning** -> a `SCREEN NOTES` header at the top of
  the screen file itself (see `comment-style.md` §3)

---

## Testing

Per the planning doc's testing strategy - write the test type that matches
what changed, not everything for every change:

| Change type | Minimum test |
|---|---|
| New screen/widget | Widget test - renders, handles loading/empty/error states |
| New business logic (validation, recommendation rules, timer logic) | Unit test |
| New repository | Unit test against the interface, using the fake implementation |
| Critical user journey (sign-in -> home, explore -> session -> completion) | Integration test before milestone/release |

A feature isn't "done" until its loading, empty and failure states are
handled and covered.

---

## Definition of DONE (per feature)

- [ ] Loading, empty, and failure states handled
- [ ] Unit/widget tests over important logic and/or UI behaviour
- [ ] `flutter analyze` - zero warnings
- [ ] `dart format .` applied
- [ ] Accessibility checked (text scaling, contrast, touch target size =
      see planning doc; several MobiFlex users manage mobility limitations,
      so this isn't optional polish)
- [ ] Documentation/decision notes added or updated
      (`comment-style.md` conventions followed, `decisions.md`)
