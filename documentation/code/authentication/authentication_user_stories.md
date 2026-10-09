# Authentication User Stories & Acceptance Criteria

> **Purpose:** Define the testable user behaviour for the MobiFlex authentication feature.

This file supports implementation and testing. It describes **what the user should be able to do**.

---

## 1. How to Use This File

Each story has:
- an ID;
- a priority;
- a user outcome;
- acceptance criteria written as observable behaviour.

Use these stories when:
- planning implementation tasks;
- creating feature branches/issues;
- deciding what tests are required;
- reviewing whether authentication is complete.

Acceptance criteria should stay focused on user visible or testable behaviour rather than internal Firebase/Riverpod implementation details.

---

## 2. Priority Guide

| Priority | Meaning |
|---|---|
| **Must**   | Required for the authentication MVP |
| **Should** | Important, but the core authentication flow can work without it temporarily |
| **Could**  | Useful future enhancement |

---

## AUTH-01 - Continue Without an Account

**Priority:** Must

### User story

> As a new user, I want to continue without creating a permanent account so that I can try MobiFlex before deciding to register.

### Acceptance criteria

- **Given** I am on the welcome screen, **when** I select `Continue without account`, **then** I can enter the app without entering an email or password.
- **Given** guest authentication is processing, **when** I press the action again, **then** a duplicate request is not started.
- **Given** guest authentication fails, **then** I see a simple error and can retry.
- **Given** I am using the app as a guest, **then** I can access the core public experience and complete sessions.

---

## AUTH-02 - Create an Account

**Priority:** Must

### User story

> As a user, I want to create an account so that my MobiFlex identity and progress can be protected.

### Acceptance criteria

- **Given** I enter a valid email and valid matching passwords, **when** I submit the form, **then** account creation can proceed.
- **Given** my password is shorter than 6 characters, **then** the form shows that the password requirement is not met.
- **Given** my password contains no uppercase character, **then** the form shows that the requirement is not met.
- **Given** my password contains no special character, **then** the form shows that the requirement is not met.
- **Given** the confirmation password does not match, **then** I see a clear validation message.
- **Given** account creation fails, **then** I see an understandable message rather than a raw backend error.
- **Given** account creation is processing, **then** repeated submissions are prevented.

---

## AUTH-03 - Upgrade a Guest Account

**Priority:** Must

### User story

> As a guest, I want to create a permanent account without intentionally losing the progress I have already made.

### Acceptance criteria

- **Given** I am using an anonymous guest account, **when** I successfully create permanent credentials, **then** my existing user identity/data remains associated with me.
- **Given** the upgrade fails, **then** my guest account remains usable.
- **Given** the email is already associated with another account, **then** I receive a clear message and my guest data is not deleted.
- **Given** an upgrade is successful, **then** the app recognises me as a registered user.

---

## AUTH-04 - Sign In

**Priority:** Must

### User story

> As a returning user, I want to sign in so that I can access my MobiFlex account.

### Acceptance criteria

- **Given** I enter valid credentials, **when** I sign in, **then** I am authenticated and returned to the app.
- **Given** sign-in is processing, **then** the form shows a loading state and repeated submissions are prevented.
- **Given** my credentials are rejected, **then** I see a simple user message.
- **Given** sign-in fails, **then** my email field is not unnecessarily cleared.
- **Given** I do not want to sign in, **then** I can still return to the guest/public experience.

---

## AUTH-05 - Restore Authentication State

**Priority:** Must

### User story

> As a returning user, I want the app to remember my valid authentication state so that I do not have to sign in every time I open MobiFlex.

### Acceptance criteria

- **Given** I have a valid existing authenticated session, **when** I reopen the app, **then** my authentication state is restored.
- **Given** the restored user is anonymous, **then** the app recognises me as a guest.
- **Given** the restored user has permanent credentials, **then** the app recognises me as registered.
- **Given** no valid authentication state exists, **then** the app falls back to the public/unauthenticated experience without crashing.

---

## AUTH-06 - Reset a Forgotten Password

**Priority:** Must

### User story

> As a registered user, I want to request a password reset so that I can recover access if I forget my password.

### Acceptance criteria

- **Given** I enter a valid email format, **when** I request a reset, **then** the reset request is submitted.
- **Given** the request completes, **then** I see a neutral confirmation message.
- **Given** the request fails because of a network/service problem, **then** I see a clear retryable error.
- The response should not unnecessarily confirm whether a specific email address is registered.

---

## AUTH-07 = Verify Email

**Priority:** Should

### User story

> As a registered user, I want to verify my email address so that my account can show that the address belongs to me.

### Acceptance criteria

- **Given** my email is not verified, **when** I request verification, **then** a verification email can be sent.
- **Given** my email is unverified, **then** normal MVP browsing, sessions, favourites and progress saving remain available.
- **Given** my verification status changes, **then** the app can refresh and display the latest state.
- **Given** my email is already verified, **then** the app should not continue prompting me unnecessarily.

---

## AUTH-08 = Sign Out

**Priority:** Must

### User story

> As a registered user, I want to sign out so that my private account is no longer active on the device.

### Acceptance criteria

- **Given** I am signed in, **when** I choose Sign out, **then** my authenticated session ends.
- **Given** sign-out completes, **then** private in-memory account state is cleared.
- **Given** I am signed out, **then** public MobiFlex content remains accessible.
- **Given** another user later signs in, **then** the previous user's private information is not displayed.

---

## AUTH-09 = Encourage Guest Registration

**Priority:** Should

### User story

> As a guest, I want registration prompts to appear when the benefit is relevant rather than repeatedly interrupting me.

### Acceptance criteria

- **Given** I complete my first session as a guest, **then** one soft account creation prompt may be shown.
- **Given** I dismiss that prompt, **then** it is not automatically shown after every later session.
- **Given** I open Profile as a guest, **then** I can see a clear account upgrade option.
- **Given** I select an account-only feature, **then** I see a contextual explanation of why an account is required.
- Registration prompts must provide a clear way to continue or dismiss where appropriate.

---

## AUTH-10 - Delete Account

**Priority:** Must

### User story

> As a registered user, I want to permanently delete my account and user owned data.

### Acceptance criteria

- **Given** I select Delete account, **then** I see a clear warning explaining that deletion is permanent.
- **Given** recent authentication is required, **then** I must confirm my identity before deletion continues.
- **Given** I cancel before the final confirmation, **then** no data is deleted.
- **Given** I confirm deletion and it succeeds, **then** my account and user owned data are removed.
- **Given** deletion completes, **then** private local state is cleared and I return to the public experience.
- **Given** deletion fails, **then** the app must not falsely report that the account was deleted.

---

## AUTH-11 - Protect Private User Data

**Priority:** Must

### User story

> As a user, I want my private MobiFlex information to be accessible only through my own authenticated identity.

### Acceptance criteria

- **Given** I am authenticated, **when** I access my own user owned data, **then** authorised access is allowed.
- **Given** I am authenticated as User A, **when** I attempt to access User B's protected data, **then** access is denied.
- **Given** I am using public exercise or routine content, **then** permitted public reads still work.
- Security must be enforced by backend rules rather than relying only on hidden buttons or UI navigation.

---

## 3. Acceptance Criteria -> Testing Map

| Story area | Main test type |
|---|---|
| Password/form validation | Unit + widget tests |
| Guest entry              | Widget + integration tests |
| Create account           | Unit/controller + widget + integration tests |
| Guest upgrade            | Repository/controller + integration tests |
| Sign in                  | Unit/controller + widget + integration tests |
| Auth-state restoration   | Provider/repository + integration tests |
| Password reset           | Unit/controller + widget tests |
| Verification status      | Repository/provider + widget tests |
| Sign out                 | Controller + integration tests |
| Registration prompts     | Widget tests |
| Account deletion         | Unit/controller + integration tests |
| Data ownership           | Firestore Security Rules tests |

Not every acceptance criterion requires its own individual test file. Tests should cover the important behaviour without creating unnecessary duplication.

---

## 4. Authentication MVP Completion

The authentication MVP is behaviourally complete when:

- [ ] AUTH-01 meets its acceptance criteria.
- [ ] AUTH-02 meets its acceptance criteria.
- [ ] AUTH-03 meets its acceptance criteria.
- [ ] AUTH-04 meets its acceptance criteria.
- [ ] AUTH-05 meets its acceptance criteria.
- [ ] AUTH-06 meets its acceptance criteria.
- [ ] AUTH-08 meets its acceptance criteria.
- [ ] AUTH-10 meets its acceptance criteria.
- [ ] AUTH-11 meets its acceptance criteria.
- [ ] AUTH-07 and AUTH-09 are implemented or explicitly deferred with a recorded reason.
- [ ] Relevant automated and manual tests pass.
- [ ] Any implementation deviation from these stories is reflected back into this file.

---
