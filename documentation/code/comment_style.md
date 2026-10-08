# Comment Style Guide

> **Purpose:** Keep comments useful as the MobiFlex codebase grows.

> The core rule is simple: **Comment the _why_, not the _what_.**

Code should explain what it does. Comments should explain decisions, context, constraints or behaviour that would not otherwise be obvious.

---

## 1. Public APIs Use Dartdoc

Every public class, widget, and method should have a short `///` dartdoc comment.

### Rule

Describe:
1. what the public API represents; and
2. why it exists when that is not obvious.

Keep it to one or two useful lines where possible.

```dart
/// Lets a returning user sign in with email and password or continue as
/// a guest without making account creation a requirement.
class LoginScreen extends StatelessWidget {
  /// Creates the login screen.
  const LoginScreen({
    required this.onGuestContinue,
    super.key,
  });

  final VoidCallback onGuestContinue;
}
```

The `public_member_api_docs` lint rule makes missing public documentation visible through `flutter analyze`.

### Exceptions

- `@override` methods do not need a duplicate comment when the inherited API is already documented.
- A documented getter can cover its paired setter.

---

## 2. Inline Comments Explain Decisions

Use inline comments for information the code cannot clearly communicate on its own.

### Avoid this

```dart
// Set loading to true.
setState(() => _isLoading = true);
```

The comment only repeats the next line.

### Prefer this

```dart
// Show progress immediately because Firebase authentication may take
// noticeable time on a cold start.
setState(() => _isLoading = true);
```

### Good reasons for an inline comment

- a non-obvious workaround;
- behaviour that looks unusual but is intentional;
- a platform specific limitation;
- a performance or accessibility reason;
- a reference to an ADR or planning decision;
- a temporary constraint that another developer could otherwise misinterpret.

If the comment can be removed without losing useful context, it probably does not need to exist.

---

## 3. Screen Notes Explain Screen-Specific Reasoning

Use a short `SCREEN NOTES` block at the top of a screen file when the screen has important design or implementation decisions.

```dart
// SCREEN NOTES - login_screen.dart
//
// Why:
// Email/password is the account method for the MVP. Users can still browse
// without creating an account.
//
// Error handling:
// AuthRepository returns typed authentication failures. This screen maps
// them to simple user facing messages.
//
// Future:
// Additional sign-in providers can be added later without moving Firebase
// calls into the screen.
```

### Keep screen notes focused

A screen note should explain things such as:

- why the screen behaves a certain way;
- important architecture boundaries;
- known limitations;
- safe extension points.

If the notes become large enough to dominate the source file, move the detail to a feature-level `README.md` and leave a short reference at the top of the screen.

---

## 4. TODOs Must Be Useful

A TODO should make unfinished work easy to understand and find.

```dart
// TODO(JC, 08-10-2026): handle expired authentication state on session resume.
```

Include:

- an owner or initials;
- a date or month;
- a short description of the remaining work.

Remove the TODO when the work is completed.

Do not use TODOs as a substitute for creating a proper issue when the work is large, risky or likely to span multiple features.

---

## 5. Do Not Keep Commented Out Code

Delete code that is no longer used.

Git history is the record of previous implementations so old code does not need to remain inside source files as comments.

### Acceptable exception

A very short note about a deliberately rejected approach can be useful when it prevents the same mistake from being repeated.

```dart
// Rejected: rebuilding the full form on every keystroke caused unnecessary
// updates. Validation is kept local to the relevant field instead.
```

---

## 6. Comments and Logs Have Different Jobs

Comments help someone **read the code**.

Logs help someone **understand what happened while the app was running**.

```dart
/// Starts the countdown for the current exercise.
void startTimer() {
  _log.info(
    'SessionPlayer: timer started for exercise=$_currentExerciseId',
  );

  // Timer implementation...
}
```

### Use comments for

- reasoning;
- constraints;
- workarounds;
- design decisions.

### Use logs for

- important runtime events;
- failures;
- state transitions useful during debugging.

Do not write a comment that merely repeats a log message or a log that merely narrates obvious source code.

Never log passwords, authentication tokens or private user information.

---

## 7. Quick Comment Checklist

Before committing:

- [ ] New public classes and methods have useful `///` dartdoc comments.
- [ ] Inline comments explain **why**, not what the next line does.
- [ ] Important screen specific reasoning is documented in `SCREEN NOTES` or a feature `README.md`.
- [ ] TODOs are dated, owned and specific.
- [ ] Large unfinished work is tracked as an issue rather than hidden in a TODO.
- [ ] Commented out code has been removed.
- [ ] Logs and comments are being used for different purposes.
- [ ] No sensitive information is written to logs.

