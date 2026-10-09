# Authentication Planning

> **Purpose:** Define how authentication should work in MobiFlex before implementation begins.

Authentication should support the app without becoming a barrier to using it. Users should be able to explore mobility and flexibility content quickly while accounts provide persistence, syncing and protected user data.

---

## 1. Authentication Goals

The authentication system should:
- allow users to use the app without being forced to create an account;
- support email and password registration;
- support email and password sign-in;
- allow users to continue as a guest;
- keep a signed-in user authenticated between app launches;
- allow users to reset a forgotten password;
- allow users to sign out;
- allow guest progress to be kept if the user later creates an account;
- protect private user data;
- provide simple and understandable validation and error messages;
- remain easy to extend later.

The authentication experience should follow the wider product principle:

> **Value before data. Let users use the app first then personalise and register when it becomes useful.**

---

## 2. MVP Scope

### Included in the first authentication version

| Feature | MVP |
|---|---:|
| Continue as guest                   | Yes |
| Email/password registration         | Yes |
| Email/password sign-in              | Yes |
| Persistent authentication state     | Yes |
| Sign out                            | Yes |
| Forgot password                     | Yes |
| Guest -> registered account upgrade | Yes |
| Friendly validation and errors      | Yes |
| Protected user data                 | Yes |
| Account deletion                    | Yes |
| Email verification                  | Later |
| Google sign-in                      | Later |
| Apple sign-in                       | Later |
| Multi-factor authentication         | Not required for MVP |

The MVP should stay focused. Additional identity providers should only be added when there is a clear product need.

---

## 3. Main Authentication Principle

Authentication should **not** block the whole application.

Public content such as exercises and routines should remain accessible without requiring a permanent account.

```text
App
│
├── Public content
│   ├── Home
│   ├── Explore
│   ├── Exercise details
│   └── Routine details
│
└── User-specific features
    ├── Progress
    ├── Favourites
    ├── Saved preferences
    ├── Account
    └── Cross-device sync
```

A user's authentication state changes what can be saved and synced rather than deciding whether the app can open.

---

## 4. First-Launch User Flow

The first launch should be low friction.

```text
Open MobiFlex
      ↓ 
Welcome
      ↓
┌─────────────────────┐
│ Continue as guest   │
├─────────────────────┤
│ Sign in             │
├─────────────────────┤
│ Create account      │
└─────────────────────┘
      ↓
App
```

### UX rules

- Do not force registration before browsing.
- Keep the welcome screen short.
- Avoid unnecessary personal questions.
- Make guest mode clearly available.
- Explain the benefit of creating an account only when relevant.

---

## 5. Guest Mode

### Proposed approach

Use Firebase Anonymous Authentication for guest users.

The user sees:
```text
Continue as guest
```

Behind the scenes:
```text
Guest action
    ↓
Anonymous Firebase user
    ↓
Temporary authenticated UID
    ↓
User can safely own private app data
```

This gives guest users a secure identity without requiring an email address or password.

### Why this approach is useful

A guest may still want to:
- complete routines;
- save session history;
- favourite exercises;
- save preferences;
- start building progress.

Using an anonymous account means that data can already belong to a Firebase UID.

Later:

```text
Anonymous user
      ↓
Create account
      ↓
Link email/password credentials
      ↓
Same user identity
      ↓
Existing progress can remain
```

### Guest UX

The app may display a message in Profile such as:
> You're using MobiFlex as a guest. Create an account to keep your progress if you change devices.

This should be informative rather than disruptive.

---

## 6. Create Account Flow

```text
Create account
      ↓
Email
Password
Confirm password
      ↓
Client-side validation
      ↓
Create account
      ↓
Authentication succeeds
      ↓
Home / previous intended destination
```

### Required validation

| Field | Validation |
|---|---|
| Email            | Required and valid format |
| Password         | Required and meets agreed minimum requirements |
| Confirm password | Must match password |

Client-side validation improves usability but Firebase remains the final authority on whether registration succeeds.

### Registration errors should be understandable

Example:
```text
Backend failure
email-already-in-use
        ↓
App failure
AuthFailure.emailAlreadyInUse
        ↓
User message
"An account already exists with this email."
```

Do not expose raw backend error codes directly to the user.

---

## 7. Sign-In Flow

```text
Sign in
   ↓
Email
Password
   ↓
Validate fields
   ↓
Authenticate
   ↓
Success
   ↓
Return to app
```

The sign-in screen should also provide:
- **Forgot password**
- **Continue as guest**
- **Create account**

### Sign-in behaviour

- Show a loading state while authentication is in progress.
- Prevent repeated submissions while loading.
- Keep entered values if authentication fails.
- Show simple, useful error messages.
- Do not reveal sensitive backend details.

---

## 8. Forgot Password Flow

```text
Forgot password
      ↓
Enter email
      ↓
Send reset request
      ↓
Show confirmation
```

Recommended user-facing response:
> If an account exists for that email, check your inbox for password reset instructions.

This avoids unnecessarily confirming whether a particular email address is registered.

---

## 9. Sign-Out Flow

```text
Profile / Account
      ↓
Sign out
      ↓
Confirmation if needed
      ↓
Firebase session ends
      ↓
User-specific state cleared
      ↓
Return to guest/public experience
```

### Sign-out rules

- Private cached account state must not remain visible after sign-out.
- Public exercise and routine content should still be usable.
- Signing out should not crash or restart the app unexpectedly.

---

## 10. Guest Account Upgrade

A guest should be able to create a permanent account without intentionally losing their existing app data.

```text
Anonymous user
      ↓
Create account
      ↓
Enter email/password
      ↓
Link new credentials
      ↓
Anonymous identity becomes permanent
      ↓
Existing UID/data remains available
```

### Important failure cases

Plan for:
- email already in use;
- weak password;
- lost network connection;
- anonymous session no longer valid;
- credential already linked.

The upgrade process should fail safely and should not delete guest data simply because registration failed.

---

## 11. Authentication Architecture

Authentication should follow the same separation used throughout the project.

```text
Firebase Authentication
        ↓
FirebaseAuthRepository
        ↓
AuthRepository
        ↓
AuthController
        ↓
Authentication UI
```

### Responsibility by layer

| Layer | Responsibility |
|---|---|
| Authentication UI        | Forms, loading states, navigation, user-facing messages |
| `AuthController`         | Coordinates authentication actions and UI state |
| `AuthRepository`         | Defines the authentication behaviour the app depends on |
| `FirebaseAuthRepository` | Implements the repository using Firebase Authentication |
| Firebase                 | Provides authentication backend and user identity |

The UI should **not** call `FirebaseAuth.instance` directly.

---

## 12. Proposed Folder Structure

```text
lib/
  data/
    repositories/
      auth_repository.dart
      firebase_auth_repository.dart

  features/
    auth/
      auth_controller.dart

      login/
        login_screen.dart
        login_form.dart

      register/
        create_account_screen.dart

      password_reset/
        forgot_password_screen.dart

      widgets/
        auth_text_field.dart
        password_field.dart
```

This structure can be adjusted during implementation if the feature grows but the separation between UI, state and Firebase-specific code should remain.

---

## 13. Domain User Model

Avoid passing Firebase `User` objects throughout the application.

Create a small app-owned authentication model.

```text
AuthUser
├── id
├── email
├── isAnonymous
└── isEmailVerified
```

Flow:

```text
Firebase User
     ↓
FirebaseAuthRepository
     ↓
AuthUser
     ↓
Rest of MobiFlex
```

This reduces coupling between Firebase and the rest of the application.

---

## 14. Proposed Repository Contract

The exact Dart interface will be decided during implementation but the authentication repository is expected to support behaviour such as:

```text
authState
currentUser

signIn(email, password)

createAccount(email, password)

continueAsGuest()

upgradeGuestAccount(email, password)

sendPasswordReset(email)

signOut()

deleteAccount()
```

Only add methods that the application genuinely needs. Avoid speculative methods for future providers until those features are actually planned.

---

## 15. Authentication State

The application needs one clear source of truth for the current authentication state.

Possible states include:
```text
Initial
Loading
Authenticated
Anonymous
Unauthenticated
Failure
```

The UI should respond to the state rather than manually checking Firebase in multiple screens.

Examples:
```text
Authenticated
-> show account and synced progress
```

```text
Anonymous
-> allow app use and offer account upgrade
```

```text
Unauthenticated
-> allow public experience
```

---

## 16. Error Handling

Firebase specific exceptions should be mapped into app level failures.

Example structure:
```text
FirebaseAuthException
       ↓
FirebaseAuthRepository
       ↓
AuthFailure
       ↓
AuthController
       ↓
Simple UI message
```

Possible app-level failures:
```text
invalidEmail
wrongCredentials
emailAlreadyInUse
weakPassword
network
tooManyRequests
requiresRecentLogin
unknown
```

### Error-handling rules

- Do not show raw Firebase exception text to users.
- Keep user messages short and understandable.
- Log technical details where useful.
- Never log passwords, tokens or sensitive account information.
- Unknown failures should still produce a safe generic message.

---

## 17. Data Access and Security

Authentication and Firestore security should work together.

### Public data

Examples:
```text
/exercises/*
/routines/*
```

Expected access:
```text
Read: public
Write: restricted/admin only
```

### Private user data

Examples:
```text
/users/{uid}
/users/{uid}/sessions/*
/users/{uid}/favourites/*
/users/{uid}/preferences/*
```

Expected access:
```text
Read/write:
authenticated owner only
```

Conceptually:
```text
request.auth != null
AND
request.auth.uid == userId
```

Security Rules must be tested and must not depend only on UI restrictions.

---

## 18. Local Development and Environments

Authentication development should not use production Firebase data.

### Local development

Use:
```text
Flutter
   ↓
Firebase Emulator Suite
   ↓
Authentication Emulator
```

### Cloud environments

Use separate Firebase projects/configuration for:
```text
Development
    ↓
Staging
    ↓
Production
```

The same source code should move through these environments using configuration rather than duplicated development and production code folders.

---

## 19. Testing Strategy

Authentication is a critical feature and should be tested at multiple levels.

### Unit tests

Test business and state behaviour.

Examples:
- successful sign-in;
- failed sign-in;
- loading state;
- account creation;
- password confirmation validation;
- guest authentication;
- guest account upgrade;
- sign-out;
- reset-password request;
- authentication failure mapping.

### Repository tests

Use fake repository implementations where possible.

```text
Authentication UI
      ↓
FakeAuthRepository
```

This lets UI and controller behaviour be tested without depending on Firebase.

### Widget tests

Examples:
| Screen/behaviour | Test |
|---|---|
| Sign-in screen  | Required fields render |
| Empty form      | Validation messages appear |
| Loading state   | Submit button cannot be repeatedly pressed |
| Failed sign-in  | Friendly error is shown |
| Create account  | Password mismatch is detected |
| Forgot password | Confirmation state is displayed |
| Guest option    | Guest action is available |

### Integration tests

Use the Firebase Authentication Emulator for real authentication flows.

Critical flows:
```text
Launch
  ↓
Continue as guest
  ↓
Authenticated anonymous user
  ↓
Home
```

```text
Create account
  ↓
Sign out
  ↓
Sign in
  ↓
Authenticated user restored
```

```text
Guest
  ↓
Create permanent account
  ↓
Existing guest identity/data retained
```

### Security tests

Test Firestore rules separately.

Examples:
```text
User A
-> read User A data
-> ALLOWED
```

```text
User A
-> read User B data
-> DENIED
```

```text
Guest/authenticated user
-> read public exercise data
-> ALLOWED
```

---

## 20. CI Checks for Authentication

Authentication work should pass the normal project checks:
```bash
dart format .
flutter analyze
flutter test
```

Before authentication is considered release ready, CI should also include relevant:
- unit tests;
- widget tests;
- repository tests;
- emulator-backend integration tests where configured;
- Firestore Security Rules tests.

A failed critical authentication test should block the change from being merged.

---

## 21. Implementation Order

Build authentication from the inside out rather than starting with the visual login screen.

```text
1. Configure Firebase development environment
        ↓
2. Configure FlutterFire
        ↓
3. Add Firebase Authentication dependency
        ↓
4. Enable Email/Password and Anonymous providers
        ↓
5. Create AuthUser model
        ↓
6. Create AuthRepository interface
        ↓
7. Create FakeAuthRepository
        ↓
8. Write initial repository/controller tests
        ↓
9. Create FirebaseAuthRepository
        ↓
10. Create AuthController
        ↓
11. Build sign-in UI
        ↓
12. Build registration UI
        ↓
13. Implement guest flow
        ↓
14. Implement forgot password
        ↓
15. Implement sign-out
        ↓
16. Implement guest account upgrade
        ↓
17. Add widget tests
        ↓
18. Add emulator integration tests
        ↓
19. Add/test Firestore Security Rules
        ↓
20. Run CI and milestone testing
```

This keeps the UI dependent on tested application behaviour rather than embedding Firebase logic directly inside widgets.

---

## 22. Definition of Done via Authentication

Authentication is complete for the MVP when:
- [ ] Users can continue as a guest.
- [ ] Users can create an email/password account.
- [ ] Users can sign in with valid credentials.
- [ ] Invalid form input is handled clearly.
- [ ] Authentication failures show understandable messages.
- [ ] Users can reset a forgotten password.
- [ ] Users can sign out.
- [ ] Authentication state persists correctly between app launches.
- [ ] A guest can upgrade to a permanent account without intentionally losing existing data.
- [ ] Public app content remains usable without permanent registration.
- [ ] Private user data is protected by Firestore Security Rules.
- [ ] Firebase specific calls are kept out of UI widgets.
- [ ] Important repository and controller logic has unit tests.
- [ ] Important auth screens have widget tests.
- [ ] Critical authentication journeys have integration tests.
- [ ] Security Rules tests pass.
- [ ] `dart format .` passes.
- [ ] `flutter analyze` returns zero warnings and zero errors.
- [ ] `flutter test` passes.
- [ ] No passwords, tokens or private account information are written to logs.
- [ ] Relevant architectural decisions are recorded in `docs/decisions.md`.

---

## 23. Future Enhancements

Possible later additions:
- email verification;
- Google sign-in;
- Apple sign-in;
- stronger account recovery options;
- multi-factor authentication if product risk changes;
- account/device management;
- clearer cross-device sync status.

These should not complicate the MVP until there is a clear requirement for them.

---

## 24. Open Decisions Before Coding

Resolve or confirm these during implementation planning:
- [ ] Final password requirements.
- [ ] Exact welcome/auth screen layout.
- [ ] Whether guest users can save all progress or only selected data.
- [ ] When the app should encourage a guest to create an account.
- [ ] Account deletion UX and confirmation flow.
- [ ] Final `AuthController` state-management approach.
- [ ] Exact Firestore path for user-owned data.
- [ ] Whether email verification is required before any specific feature.
- [ ] Which authentication events should be logged for debugging/analytics.

Once these are agreed, implementation can begin without needing to redesign the authentication flow midway through development.
