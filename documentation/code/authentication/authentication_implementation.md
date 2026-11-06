# MobiFlex Authentication

Updated 6 November 2026. Covers the initial authentication flow and login repository refactor.

## What I implemented

I built authentication using Flutter and Firebase Authentication:

- Email/password registration with password confirmation.
- Login, logout, password-reset requests, and session restoration.
- Required-field and email-format validation, loading feedback, and friendly errors.
- An authentication repository for login, with injectable dependencies for testing.
- App-level failures so the login screen no longer handles Firebase error codes.

## How the code works

Paths are relative to `mobiflex_application/lib/`.

| File | Responsibility |
| --- | --- |
| `main.dart` | Initialises Firebase and starts the app. |
| `screens/auth_gate.dart` | Watches the Firebase session and displays login or home. |
| `screens/login_screen.dart` | Validates input, calls the repository, and displays results. |
| `data/repositories/auth_repository.dart` | Defines the sign-in contract. |
| `data/repositories/firebase_auth_repository.dart` | Performs sign-in and translates Firebase errors into `AuthFailure`. |
| `domain/auth/auth_failure.dart` | Defines invalid credentials, request limits, network, unavailable, and unknown failures. |
| `screens/register_screen.dart` | Creates an account, signs it in, and closes registration to reveal home. |
| `screens/reset_password_screen.dart` | Requests a reset link with a neutral confirmation. |
| `screens/home_screen.dart` | Displays the placeholder home screen and provides logout. |

Login now follows `LoginScreen → AuthRepository → FirebaseAuthRepository → Firebase`. The repository translates backend errors; the screen chooses the user-facing message. Registration, reset, logout, and session listening still use Firebase directly.

`AuthGate` responds automatically to sign-in and sign-out. Registration also calls `Navigator.pop()` because its page was pushed above the gate.

Firebase manages accounts and saved sessions. Controllers temporarily hold input; my code does not save passwords to a local file. Progress and favourites will need separate database storage and access rules.

## What I learned

- A repository contract separates authentication behaviour from the screen. Dependency injection lets tests supply a fake implementation.
- App-level failures keep Firebase-specific error codes inside the repository.
- Validators return an error message for invalid input, or `null` when validation passes.
- `setState()` requests UI updates; `await` waits for asynchronous work; `mounted` checks protect updates after a screen closes. Controllers are released in `dispose()`.
- Authentication identifies a user; backend permissions control data access.

## Verification

The old counter test has been replaced. Automated coverage now includes:

- **Two login widget tests:** empty-field validation and loading/error recovery.
- **Eight repository tests:** translation of seven recognised Firebase error codes and an unknown code.

These tests use controlled dependencies without real Firebase requests. Session routing, registration, reset, and logout still need automated coverage.

I previously confirmed the core authentication journeys manually and obtained **“No issues found!”** from the analyzer. Record subsequent analyzer and test results against the relevant commit.

## Next update

1. Extend the repository to registration, password reset, and logout, with relevant tests.
2. Separate session handling from Firebase types and test `AuthGate` transitions.
3. Align registration with the agreed password policy; improve password visibility, autofill, keyboard actions, and loading behaviour.

Guest access, guest-account upgrading, account deletion, email verification, and private-data security rules remain planned. Registration currently requires a nonempty password and matching confirmation; Firebase password-policy configuration still needs checking.
