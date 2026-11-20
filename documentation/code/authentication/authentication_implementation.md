# MobiFlex Authentication

Updated 1 November 2026. Describes the uploaded authentication snapshot (`3c6ffe0`).

## What I implemented

I built the initial authentication flow using Flutter and Firebase Authentication:

- Email/password registration with password confirmation.
- Login, logout, and password reset through an emailed link.
- Session restoration using Firebase's default persistence.
- Required-field and email-format validation.
- Loading feedback, prevention of repeated form submissions, and friendly error messages.

- Users can show or hide their passwords and complete the login, registration, and password reset forms using the keyboard.

## How the code works

Paths are relative to `mobiflex_application/lib/`.

| File | Responsibility |
| --- | --- |
| `main.dart` | Initialises Firebase before starting the app. |
| `screens/auth_gate.dart` | Listens to session changes and displays login or home, with loading/error states. |
| `screens/login_screen.dart` | Validates input and requests sign-in. |
| `screens/register_screen.dart` | Creates an account, signs the user in, and closes registration to reveal home. |
| `screens/reset_password_screen.dart` | Requests a reset link without confirming whether an account exists. |
| `screens/home_screen.dart` | Displays the placeholder home screen and provides logout. |

Login and logout change the Firebase session. `AuthGate` responds automatically, so those actions do not need to push another home or login page. Registration uses `Navigator.pop()` because it was opened as a separate page above the gate.

Firebase Authentication manages accounts and saved sessions. Controllers temporarily hold entered text; my code does not save passwords to a local file. Progress and favourites would need separate database storage and access rules.

## What I learned

- Validators return an error message for invalid input, or `null` when validation passes.
- `setState()` requests a rebuild after local state changes; `StreamBuilder` responds to session updates.
- `await` waits for asynchronous operations. After waiting, `mounted` checks prevent updates to a removed screen.
- Controllers provide access to field text and are released in `dispose()`.
- Authentication identifies the user; backend permissions control access to data.

## Verification

I previously confirmed registration, login, logout, browser-refresh session restoration, and password reset manually. During development, `flutter analyze` also returned **“No issues found!”**

These are earlier results, not a fresh test of this snapshot. Two login widget tests pass: one checks password visibility, and the other checks that an empty login form asks for both an email and a password, the login widget test shows and hides a typed password and checks that the text stays the same. Future results should record the date, commit, platform, and outcome.


## Next update

1. Move Firebase calls out of screens into an authentication repository so behaviour can be tested independently.
2. Align registration with the agreed password policy, improve field loading behaviour, autofill.

Guest access, guest-account upgrading, account deletion, email verification, and private-data security rules remain planned. The current registration form only requires a nonempty password and matching confirmation; the configured Firebase password policy still needs checking.
