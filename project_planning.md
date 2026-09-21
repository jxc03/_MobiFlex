# Project Planning

## I. Concept

- Allow users to know and improve mobility.
- Allow users to know and improve flexibility.
- Allow users to reduce stiffness.

**Flexibility** is primarily the ability of tissues to lengthen and allow a range of motion.
**Mobility** is the ability to actively control movement through a range of motion.

### Examples
- **Static Flexibility:** Hamstring stretch - sitting and reaching toward your toes, holding 20–30 seconds.
- **Dynamic Flexibility:** Leg swings - forward/backward or side-to-side.
- **Joint Mobility:** Ankle dorsiflexion rocks - knee over toes while heel stays down.
- **Dynamic Mobility:** Walking lunges with rotation - step → lunge → rotate toward front leg.

---

## II. Target Users & User Needs

| User Type | Typical Thought | What the App Should Do |
|---|---|---|
| Quick use user | "My hips feel stiff. I just want something now" | Offer body area and quick duration routes in a few taps. |
| Unsure user | "I feel stiff but I do not know what I need" | Offer situations, movement goals, full body routines and help me choose. |
| Training focused user | "I want better squat or overhead mobility" | Provide goal specific routines spanning relevant areas. |
| Structured user | "I want to improve over several weeks" | Offer a personal programme, progression, history and optional reassessment. |
| Explorer | "I want to learn individual stretches" | Provide a searchable exercise library with clear instructions and education. |

---

## III. Example Navigation

| Section | Purpose |
|---|---|
| Home | Start quickly, show quick sessions, recent routines and a personal recommendation when available. |
| Explore | Browse by body area, goal situation, routine or individual exercise. |
| Programme | Structured personal plan for users who want more guidance. |
| Progress | Session history, consistency, favourites and later mobility trends. |
| Profile / Settings | Preferences, reminders, account, safety information and data controls. |

---

## IV. Example First Use Flow

**Open app -> Choose how to start -> Start useful content -> Complete session -> Optional feedback -> Personalise later**

1. A lightweight welcome screen explaining the app in 1 or 2 sentences.
2. Allow the user to continue as a guest or create / sign into an account, account creation should not be required simply to browse.
3. Offer 3 paths:
   - "I know what I want"
   - "Help me choose"
   - "Explore"
4. User can choose body area, goal, situation, or quick full body routine.
5. Ask session duration only when it changes the result, for example:
   - 5 minutes
   - 10 minutes
   - 15 minutes
   - 20+ minutes
6. After the session, ask for feedback such as:
   - Easy
   - Good
   - Difficult
   - Uncomfortable
7. After value has been demonstrated, invite the user to create a profile or personalise future recommendations.

---

## V. Brainstorming the Application

| Area | Possible Functionality |
|---|---|
| Onboarding | Goals, experience, activity level, available time |
| Mobility assessment | Simple guided movement tests |
| Body map | Shoulders, spine, hips, knees, ankles, etc |
| Personal program | Automatically generated mobility programme |
| Daily session | Follow along routine |
| Exercise library | Searchable mobility/flexibility exercises |
| Instructions | Written instructions + video/animation |
| Timer | Built-in stretching timer |
| Progress | Mobility scores and range-of-motion history |
| Feedback | Easy / difficult / uncomfortable |
| Personalisation | Adapt exercises and duration |
| Scheduling | Morning, evening, pre-workout, etc |
| Streaks | Sessions completed |
| Goals | Squat depth, toe touch, overhead mobility, etc |
| Education | Why each exercise is being performed |
| Favourites | Save exercises / routines |
| Custom routine | Build your own routine |
| Smart recommendations | Suggest exercises based on assessments |
| Reminders | Scheduled mobility sessions |

---

## VI. Example MVP Screens

| Screen | Purpose | Key Elements |
|---|---|---|
| Welcome / Entry | Explain value without blocking use | Continue as guest, sign in/create account, short explanations |
| Home | Fast access to useful actions | - |
| Explore | Discover content | Body area, situation, routine search, exercise search |
| Routine detail | Understand what will happen | Duration, focus areas, exercise list, equipment, start |
| Session player | Perform the routine | Controls, timer / reps, demo media, instructions, skip/previous/pause |
| Exercise detail | Learn one movement | Purpose, steps, common mistakes, easier/harder options, safety notes |
| Feedback | Capture simple session response | Easy / Good / Difficult / Uncomfortable, optional note |
| Progress / History | Encourage consistency | Recent sessions, minutes, favourite routines, tracking of progression |
| Profile / Settings | Manage personal data and preferences | Account, reminders, privacy, safety information |

---

## VII. Technical Implementation

| Layer / Service | Technology | Responsibility |
|---|---|---|
| Client | Flutter / Dart | Android and iOS UI, navigation, local session state and presentation logic |
| Authentication | Firebase Authentication | Accounts and cross device identity |
| Database | Firebase Realtime Database or Cloud Firestore | Exercise catalogue, profiles, favourites, sessions, plans and progress |
| Media | Store in app or Firebase Storage | Exercise images / videos |
| Quality / Operations | Firebase Crashlytics + Analytics | Crash reporting and product usage signals |

---

## VIII. Flutter Project Structure

> To be continued.

---

## IX. Example Data Model

| Entity | Important Fields / Relationships |
|---|---|
| `users` | `uid`, `displayName`, `preferences`, `goals`, `preferredDurration`, `createdAt` |
| `exercises` | `exerciseId`, `name`, `category`, `bodyRegions`, `movementGoals`, `difficulty`, `instructions`, `commonMistakes`, `duration/reps`, `media`, `equipment`, `safetyNotes` |
| `routines` | `routineId`, `title`, `description`, `duration`, `goals`, `bodyRegions`, `situationTags`, `difficulty`, ordered exercise blocks |
| `sessions` | `sessionId`, `userId`, `routineId`, `startedAt`, `completedAt`, `duration`, `completedExercises`, `feedback` |
| `favourites` | `userId` + exercise/routine references |
| `programmes` | `programmed`, `userId`, `goals`, `schedule`, routine references, current phase |
| `assessmentResults` | `userId`, `assessmentType`, `measurement`, `unit`, `date`, `confidence/source` |
| `recommendationEvents` | Inputs/rules used, recommended routine IDs, accepted/ignored result |

### Exercise Classification

Each exercise should be tagged so the system can find it by different user intents:

- **Category:** static flexibility, dynamic flexibility, joint mobility, active mobility, stability/control, activation
- **Body region:** shoulders, thoracic spine, lumbar region, hips, knees, calves, ankles, wrists, etc
- **Movement / Goal tags:** squat, overhead reach, running, martial arts, desk reset, warm-up, cooldown
- **Difficulty and progression/regression relationships**
- **Equipment requirements and available alternatives**
- **Safety notes, stop conditions, and contraindication flags where appropriate**

---

## X. Personalisation, Recommendations & Assessment

> To be continued.

---

## XI. Development & Implementation Best Practices

> To be continued.

---

## XII. Example Testing Strategy

| Test Level | Examples | When |
|---|---|---|
| Unit test | Recommendation rules, timer logic, validation, mapping, repositories with mocks | Every feature |
| Widget test | Routine cards, empty/error/loading states, session controls | Every important UI component/flow |
| Integration test | Explore -> routine -> session -> completion; sign-in -> history | Critical journeys before release |
| Firebase rules tests | User A cannot read/write User B data; permitted public catalogue reads | Whenever rules/data model change |
| Manual device tests | Background/foreground, orientation, slow network, offline behaviour, different screen size | Before milestone/releases |
| Usability tests | Can a new user find a routine without explanation? Can they use controls while exercising? | Prototype + pre-release |
| Accessibility checks | Text scaling, contrast, labels, keyboard/focus where relevant, touch targets | Throughout |

### Definition of a Done Feature

1. Loading, empty, and failure states are handled
2. Unit/widget tests cover important logic and/or UI behaviour
3. Analytic events are added if necessary/ideal
4. Accessibility and responsive layout are checked
5. No warnings
6. Documentation/decision notes are made and/or updated

---

## XIII. CI/CD, Deployment & Operations

> To be continued.
