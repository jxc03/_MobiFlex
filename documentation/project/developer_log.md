# Developer/Development Log

Record of what I did, **why** and what I learned.

**How to use it:** add today's entry **at the top** using the template. Keep it short: a line per point is fine.

---

## Template (copy this for each new day)

```markdown
## DD-MM-YYYY

**What was done:** <one sentence - what "done" looks like by end of day>

### Done
- <what I did> - **why:** <reason / what problem it solves>

### Evidence
- <commit hash, PR, test output, screenshot, flutter analyze result>

### Learned
- <new concept, in my own words> - ref: <link>

### Problems
- <issue> -> <what I tried / next step>
- When fixed, don't delete it: mark it **Resolved (DD-MM-YYYY)** with how it was fixed.

### Next
- <first thing tomorrow>
```

> **Why these headings?** *Done / Next / Problems* are the 3 questions used in Scrum teams. *Evidence* makes each claim checkable. *Learned* is what is for interview answers and report.

---

## 21-09-2026

**What was done:** set up static analysis so problems are caught before the code runs.

### Done
- Added the Dart lints package as a dev dependency: `dart pub add --dev lints`.
- In `analysis_options.yaml`, set `include: package:lints/recommended.yaml`.
  **Why:** it's Dart's recommended rule set. It flags code likely to cause problems and enforces one consistent style. It's a superset of the core rules.
- Turned on the analyzer's strict type checks:
  ```yaml
  analyzer:
    language:
      strict-casts: true
      strict-inference: true
      strict-raw-types: true
  ```
  **Why:** all three stop `dynamic` from sneaking in silently. `dynamic` switches off type checking so errors that could be caught now would only show up at runtime.

  | Setting | What it prevents | Example it catches |
  |---|---|---|
  | `strict-casts` | Implicit casts from `dynamic` to a specific type which can crash at runtime | `List<String> names = jsonDecode(body);` needs an explicit cast because the JSON might not be a list of strings |
  | `strict-inference` | Dart falling back to `dynamic` when it can't work out a type | `final map = {};`, write `<String, int>{}` instead |
  | `strict-raw-types` | Generic types used without their type argument | `List items = [];`, write `List<Exercise> items = [];` instead |

### Evidence
- `flutter analyze` -> *<paste the result, e.g. "No issues found!">*

### Learned
- **Static analysis** finds problems *before* running any code. It's the cheapest point to catch a bug, an idea known as "shift-left" testing. Ref: <https://dart.dev/tools/analysis>
- Strict modes mean that when parsing Firestore or JSON data, I'll need explicit casts or proper model classes (`Exercise.fromJson`). That's more typing but it's safer.

### Problems
- **To check:** this is a *Flutter* app and the Flutter docs recommend `flutter_lints` (`include: package:flutter_lints/flutter.yaml`). It contains the same `lints/recommended` rules **plus** Flutter-specific ones such as `use_key_in_widget_constructors`. `flutter create` usually adds it already. Next step: check `pubspec.yaml` and if `flutter_lints` is there, switch the include to it and remove the plain `lints` package.
- Not added yet: `public_member_api_docs`, the rule that enforces `///` comments on public classes. It was planned in the coding standards.

---

- Enabled the `public_member_api_docs` lint rule:
  ```yaml
  linter:
    rules:
      - public_member_api_docs # Flags any public class/method missing a /// comment
  ```
  **Why:** it turns "comment as you go" from something I have to remember into something the analyzer checks automatically. Any public class, method or field without a `///` doc comment shows up as a warning in `flutter analyze` and in the IDE so documentation can't quietly get skipped under deadline pressure.

  | Case | Needs a `///` comment? | Example |
  |---|---|---|
  | Public class / method / field | **Yes** | `class LoginScreen`, `bool isValidEmail(String email)` |
  | Private member (starts with `_`) | No | `_LoginScreenState`, `_submit()` |
  | Overriding member (`@override`) | No because the parent class already documents it | `Widget build(BuildContext context)` |

  **Example of a compliant class:**
  ```dart
  /// Checks sign-in and sign-up form input before anything is sent to Firebase.
  ///
  /// Kept separate from the UI so the rules can be unit tested (see TC-AUTH-011, TC-AUTH-023).
  class AuthValidators {
    /// Returns an error message if [email] is not a valid address, otherwise `null`.
    static String? email(String? email) { ... }
  }
  ```

### Evidence
- `flutter analyze` -> *<paste the result>*
- Expected: the rule flags the starter code (`main()` and `MyApp` in `main.dart` have no `///`). That's the rule working, not a problem. Add doc comments or leave it until the starter code is replaced by the real screens.

### Learned
- **Static analysis** finds problems *before* running any code. It's the cheapest point to catch a bug, an idea known as "shift-left" testing. Ref: <https://dart.dev/tools/analysis>
- Strict modes mean that when parsing Firestore or JSON data, I'll need explicit casts or proper model classes (`Exercise.fromJson`). That's more typing but it's safer.
- A `///` comment is a **doc comment**: it shows up in IDE hover tooltips and in generated API docs (`dart doc`). A normal `//` comment does neither. Doc comments say *what something is and why it exists*; `//` comments inside a method explain a tricky line. Ref: <https://dart.dev/tools/linter-rules/public_member_api_docs>, <https://dart.dev/effective-dart/documentation>
- Private members (`_name`) and `@override` methods are exempt so keeping helper widgets private (`_EmailField`) also cuts down on required comments.

### Problems
- **Open:** this is a *Flutter* app and the Flutter docs recommend `flutter_lints` (`include: package:flutter_lints/flutter.yaml`). It contains the same `lints/recommended` rules **plus** Flutter-specific ones such as `use_key_in_widget_constructors`. `flutter create` usually adds it already. Next step: check `pubspec.yaml` and if `flutter_lints` is there, switch the include to it and remove the plain `lints` package.
- **Resolved (21-09-2026):** `public_member_api_docs` was not yet enabled -> added under `linter: rules:`