# Comment Style Guide

This file exists so that comments stay useful as the codebase grows. 
The rule behind every guideline below is the same: **comment the *why*, not the *what*** 
Dart syntax already says what a line does; a comment earns its place only when it adds something the code can't say for itself.

---

## 1. Public API gets a dartdoc comment

Every public class, widget and method gets a `///` doc comment: what it is and why it exists in one or two lines. 
This is enforced by the `public_member_api_docs` lint rule so `flutter analyze` will flag anything missing one.

```dart
/// Lets a returning user sign in with email and password, or continue as
/// a guest. Guest mode is first-class per the app's "account creation
/// should not be required simply to browse" requirement (see
/// docs/decisions.md, ADR-003).
class LoginScreen extends StatelessWidget {
  /// Creates the login screen. [onGuestContinue] is called when the user
  /// picks "Continue as guest" instead of signing in.
  const LoginScreen({required this.onGuestContinue, super.key});

  final VoidCallback onGuestContinue;

  ...
}
```

**Exceptions** (per the lint rule itself):
- `@override` methods don't need their own doc comment if the parent's is
  documented.
- A documented getter covers its paired setter.

---

## 2. Inline comments explain *why*, never *what*

```dart
// BAD - restates the code
// set loading to true
setState(() => _isLoading = true);

// GOOD - explains a decision the code alone doesn't reveal
// Firebase's signInWithEmailAndPassword can take >2s on cold start;
// show a spinner rather than let the button appear unresponsive.
setState(() => _isLoading = true);
```

If you're about to write a comment and it just repeats the next line in
English, delete it — it's adding reading time without adding information.

Good reasons to write an inline comment:
- A non-obvious workaround ("Firebase throws X here on iOS simulators only")
- A decision that could look wrong out of context ("intentionally not
  awaited - fire and forget analytics event")
- A reference back to the planning doc or an ADR that explains *why* this
  behaviour exists

---

## 3. Screen level notes live at the top of the file

Every screen file (`lib/features/<feature>/<screen>.dart`) opens with a
short header block covering reasoning and extension points specific to that
screen. This travels with the code unlike a separate notes file.

```dart
// SCREEN NOTES - login_screen.dart
//
// Why: Email/password only for MVP (see decisions.md, ADR-003). Client side
// validates format; server side errors (wrong password, no such account)
// come back from AuthRepository as typed exceptions, mapped to copy in
// _mapAuthError().
//
// Extensibility: Google/Apple sign in can be added as buttons below the
// divider without touching form logic - AuthRepository already exposes
// signInWithGoogle() as an unused stub for this.
//
// Known gaps: no "forgot password" flow yet.
```

If a screen's reasoning is long enough that this block would dominate the
file (Session Player is the likely candidate), move it to a `README.md` in
that feature's folder instead and leave a one line pointer here.

---

## 4. TODOs are dated and owned

```dart
// TODO(JC, 2026-09): handle expired-token case on session resume
```

An un-dated, un-owned TODO tends to live forever. This format makes it
searchable and gives it a rough "how stale is this" signal at a glance.

---

## 5. No commented out code

Delete code you're not using - git history is the record of what used to be
there, not a `//` block in the middle of a widget. An exception: a single
line showing an alternative approach you deliberately rejected with a
one line reason attached is fine if it saves re-deriving the decision
later. That's a decision note, not a leftover.

```dart
// Rejected: StreamBuilder here caused a rebuild storm on every keystroke.
// Using a debounced Riverpod provider instead — see decisions.md ADR-005.
```

---

## 6. Logging is not a substitute for comments (and vice versa)

Comments explain code to a reader; logs explain *behaviour* to whoever is
debugging a running app. Use both, for different jobs:

```dart
/// Starts the countdown timer for the current exercise.
void startTimer() {
  _log.info('SessionPlayer: timer started for exercise=$_currentExerciseId');
  ...
}
```

A comment that only restates a log line (or vice versa) is redundant -
write one or the other, whichever a reader actually needs at that point.

---

## Quick checklist before committing

- [ ] Every new public class/method has a `///` doc comment
- [ ] No comment just restates the line beneath it
- [ ] New screen file has a SCREEN NOTES header (or a feature README, if long)
- [ ] Any TODO is dated and owned
- [ ] No commented-out code left in
