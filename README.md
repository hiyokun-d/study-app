<div align="center">

<img src="lib/assets/images/logo.jpeg" width="120" alt="StudyApp Logo" />

# StudyApp

> Built with ❤️ by the StudyApp team.

### Peer-to-Peer Tutoring Marketplace

_Connect with expert tutors. Learn on your terms._

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)](https://www.prisma.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)

[![GitHub Stars](https://img.shields.io/github/stars/hiyokun-d/study-app?style=social)](https://github.com/hiyokun-d/study-app/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/hiyokun-d/study-app?style=social)](https://github.com/hiyokun-d/study-app/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/pulls)

</div>

---

## What is StudyApp?

**StudyApp** is a modern peer-to-peer tutoring marketplace that connects students directly with expert tutors. Students choose what to learn, who to learn from, and when — on their own terms.

The app is split into two independent codebases:

- **Flutter frontend** — cross-platform app (Android, iOS, Web)
- **NestJS backend** — REST API backed by PostgreSQL on Supabase

See [`_server/README.md`](./_server/README.md) for detailed API documentation.

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                   Flutter App (Client)                       │
│                                                              │
│  features/auth/    features/student/    features/teacher/    │
│  features/chat/    features/subscription/                    │
│                                                              │
│  core/services/                                              │
│    AuthService       ← all auth HTTP calls (login/register)  │
│    AuthState         ← singleton: JWT token, userId, role    │
│    UserApiService    ← all user HTTP calls (profile, etc.)   │
│                                                              │
│  core/themes/        AppColors · AppTypography · AppSizes    │
│  core/widgets/       PrimaryButton · TextInput · AvatarWidget│
│  routes/             named routes, Navigator.pushNamed(...)  │
└──────────────────────────────┬───────────────────────────────┘
                               │ HTTP / JSON (REST)
                               ▼
┌──────────────────────────────────────────────────────────────┐
│              NestJS Backend  (_server/)  — Modular Monolith  │
│   AuthModule · UserModule · BookingModule · MessagesModule   │
│   CoinsModule · ReviewsModule · NotificationsModule          │
│   OffersModule · DailyModule · AdminModule · InternalModule  │
└──────────────────────────────┬───────────────────────────────┘
                               │ SQL via Prisma ORM
                               ▼
┌──────────────────────────────────────────────────────────────┐
│          PostgreSQL on Supabase                              │
│  profiles · bookings · messages · reviews · transactions     │
│  tutor_offers · tutor_availabilities · subjects · notifications│
└──────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
study-app/
│
├── lib/                              # Flutter Frontend
│   ├── main.dart                     # App entry point
│   │
│   ├── features/                     # Feature modules (screens + widgets)
│   │   ├── auth/
│   │   │   └── screens/
│   │   │       ├── splash_screen.dart          ✅ done
│   │   │       ├── onboarding_screen.dart      ✅ done
│   │   │       ├── login_screen.dart           ✅ done
│   │   │       ├── register_screen.dart        ✅ done
│   │   │       └── update_profile_screen.dart  ✅ done
│   │   │
│   │   ├── student/
│   │   │   └── screens/
│   │   │       ├── student_dashboard.dart      ✅ done (5-tab nav)
│   │   │       ├── course_detail_screen.dart   ✅ done (UI)
│   │   │       └── live_class_screen.dart      ✅ done (UI)
│   │   │
│   │   ├── teacher/
│   │   │   └── screens/
│   │   │       └── teacher_dashboard.dart      ✅ done (5-tab nav)
│   │   │
│   │   ├── chat/
│   │   │   └── screens/
│   │   │       └── chat_detail_screen.dart     ✅ done (UI only, not wired to API)
│   │   │
│   │   ├── subscription/
│   │   │   └── screens/
│   │   │       ├── subscription_plans_screen.dart  ✅ done (UI only)
│   │   │       ├── payment_screen.dart             ✅ done (UI only)
│   │   │       └── payment_success_screen.dart     ✅ done (UI only)
│   │   │
│   │   └── test/                     # Test/playground screens
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_config.dart       ✅ done (useMock toggle, apiUrl, timeout)
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart     ✅ done (login, register, logout — centralized)
│   │   │   ├── auth_state.dart       ✅ done (JWT singleton: token, userId, role)
│   │   │   └── user_api_service.dart ✅ done (updateProfile)
│   │   │
│   │   ├── themes/
│   │   │   ├── app_theme.dart        ✅ done
│   │   │   ├── app_colors.dart       ✅ done (primary: #1479FF)
│   │   │   ├── app_typography.dart   ✅ done
│   │   │   └── app_sizes.dart        ✅ done
│   │   │
│   │   └── widgets/
│   │       ├── primary_button.dart   ✅ done
│   │       ├── text_input.dart       ✅ done
│   │       ├── password_text_field.dart  ✅ done
│   │       ├── avatar_widget.dart    ✅ done
│   │       └── search_input.dart     ✅ done
│   │
│   ├── models/                       # Shared data models
│   │   ├── user_model.dart           ✅ done
│   │   ├── course_model.dart         ✅ done
│   │   ├── teacher_model.dart        ✅ done
│   │   └── live_class_model.dart     ✅ done
│   │
│   ├── routes/
│   │   └── app_routes.dart           ✅ done (all named routes)
│   │
│   └── assets/images/
│       └── logo.jpeg                 ✅ app logo
│
├── _server/                          # NestJS Backend — see _server/README.md
│   ├── src/
│   │   ├── auth/                     ✅ complete
│   │   ├── user/                     ✅ complete
│   │   └── generated/prisma/         ✅ auto-generated
│   └── prisma/
│       ├── schema.prisma             ✅ complete (9 tables)
│       └── migrations/
│
├── docs.md                           # Full architectural documentation
├── pubspec.yaml                      # Flutter dependencies
└── README.md                         # This file
```

---

## Current Progress

### App (Flutter Frontend)

#### ✅ Complete

| Area                  | What's done                                                                        |
| --------------------- | ---------------------------------------------------------------------------------- |
| **Auth flow**         | Full end-to-end: splash → onboarding → login/register → update profile → dashboard |
| **Auth service**      | Centralized `AuthService` — login, register, logout, mock mode for dev             |
| **Auth state**        | `AuthState` singleton — stores JWT token, userId, email, role across the whole app |
| **Mock mode**         | `AppConfig.useMock = true` — screens work without a live backend for development   |
| **Login screen**      | Email + password form, error display, loading state                                |
| **Register screen**   | Email + password + confirm, delegates to `AuthService`                             |
| **Update profile**    | Full name, username, bio, role picker — calls `UserApiService.updateProfile`       |
| **Student dashboard** | 5-tab nav: Home, Explore, Learning, Messages, Profile                              |
| **Teacher dashboard** | 5-tab nav: Home, Courses, Students, Earnings, Profile                              |
| **Chat UI**           | Full chat detail screen with message list + input (UI only)                        |
| **Subscription UI**   | Plans screen (Free/Premium/Pro, monthly/yearly toggle)                             |
| **Payment UI**        | Payment method selection + order summary                                           |
| **Payment success**   | Animated success screen                                                            |
| **Shared widgets**    | `PrimaryButton`, `TextInput`, `PasswordTextField`, `AvatarWidget`, `SearchInput`   |
| **Theme system**      | Material 3, `AppColors`, `AppTypography`, `AppSizes`                               |
| **Routing**           | All named routes in `AppRoutes`, navigator helpers                                 |

#### 🔄 In Progress (branch: `api/expanding-the-api`)

| Task                                 | Status                                                          |
| ------------------------------------ | --------------------------------------------------------------- |
| Centralized `AuthService` refactor   | ✅ done on this branch — replacing inline HTTP calls in screens |
| `AppConfig` mock/live toggle         | ✅ done — `useMock` flag for dev without backend                |
| Wiring auth screens to `AuthService` | ✅ login, register, update profile all use it                   |
| Student dashboard API integration    | 🔄 in progress — real tutor data from `GET /user/tutors/all`    |

#### 🔲 Todo (App)

| Priority | Task                                                                                     |
| -------- | ---------------------------------------------------------------------------------------- |
| High     | Wire student dashboard to live API (tutor browse, search, filter)                        |
| High     | Google Sign-In integration on login screen                                               |
| High     | `AuthState` persistence — survive app kill/restart (SharedPreferences or secure storage) |
| High     | Tutor detail screen — show profile + offers from `GET /user/tutor/:id`                   |
| High     | Booking flow — select offer → confirm → payment                                          |
| Medium   | Chat API integration — send/receive real messages                                        |
| Medium   | Teacher dashboard API integration — show real bookings, students                         |
| Medium   | Profile screen — display and edit own profile                                            |
| Medium   | Subscription backend integration                                                         |
| Medium   | Tutor availability management (teacher side)                                             |
| Low      | Push notifications                                                                       |
| Low      | Review/rating UI                                                                         |
| Low      | Offline mode / error states                                                              |
| Low      | Dark mode                                                                                |
| Low      | iOS build testing                                                                        |

---

### API (NestJS Backend)

See [`_server/README.md`](./_server/README.md) for full details.

| Module                                          | Status      |
| ----------------------------------------------- | ----------- |
| Auth (signup, login, Google OAuth, JWT)         | ✅ Complete |
| User profiles (CRUD, tutor search/filter)       | ✅ Complete |
| Booking (create, confirm, reschedule, expire)   | ✅ Complete |
| Messages (per-booking chat)                     | ✅ Complete |
| Reviews (post-session rating)                   | ✅ Complete |
| Tutor offers (create, manage, pricing)          | ✅ Complete |
| Coins (balance, transactions, price proposals)  | ✅ Complete |
| Notifications                                   | ✅ Complete |
| Admin module (ban, verify tutors, refunds)      | ✅ Complete |
| Payment (Midtrans QRIS integration)             | ✅ Complete |
| Withdrawal requests (tutor cashout)             | ✅ Complete |
| Daily jobs (auto-expire bookings, etc.)         | ✅ Complete |
| Unit tests — 62 tests, 5 suites                 | ✅ Passing  |

---

## Tech Stack

### Frontend — Flutter (Dart)

| Tool                     | Purpose                     |
| ------------------------ | --------------------------- |
| **Flutter 3.5+**         | Cross-platform UI framework |
| **Dart**                 | Language                    |
| **HTTP**                 | REST API calls              |
| **Google Sign-In**       | OAuth                       |
| **Google Fonts**         | Typography                  |
| **Font Awesome Flutter** | Icons                       |
| **Material 3**           | Design system               |

### Backend — NestJS (TypeScript)

| Tool                    | Purpose                              |
| ----------------------- | ------------------------------------ |
| **NestJS v11**          | Modular Node.js framework            |
| **TypeScript**          | Language                             |
| **Prisma ORM v7**       | Type-safe DB access + migrations     |
| **PostgreSQL**          | Database (hosted on Supabase)        |
| **argon2**              | Password hashing                     |
| **JWT + Passport**      | Stateless auth + strategy guards     |
| **Helmet**              | HTTP security headers                |
| **@nestjs/throttler**   | Rate limiting                        |
| **Midtrans**            | Payment gateway (QRIS, Indonesia)    |
| **Jest + ts-jest**      | Unit testing                         |

---

## App Screens & Routes

| Route              | Screen                                       | Status       |
| ------------------ | -------------------------------------------- | ------------ |
| `/`                | Splash screen — animated logo, auto-navigate | ✅           |
| `/onboarding`      | 4-page swipeable intro                       | ✅           |
| `/login`           | Email + password login                       | ✅           |
| `/register`        | Email + password registration                | ✅           |
| `/update-profile`  | Name, username, bio, role                    | ✅           |
| `/student`         | Student dashboard (5-tab)                    | ✅           |
| `/teacher`         | Teacher dashboard (5-tab)                    | ✅           |
| `/chat`            | Chat detail                                  | ✅ (UI only) |
| `/subscription`    | Subscription plans                           | ✅ (UI only) |
| `/payment`         | Payment screen                               | ✅ (UI only) |
| `/payment-success` | Payment success                              | ✅ (UI only) |
| `/tutor/:id`       | Tutor detail + offers                        | 🔲 Not built |
| `/booking`         | Booking flow                                 | 🔲 Not built |
| `/profile`         | Own profile view/edit                        | 🔲 Not built |

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.5.0`
- [Node.js](https://nodejs.org/) `v18+` & npm
- [Supabase](https://supabase.com/) project (PostgreSQL)
- [Git](https://git-scm.com/)

### 1. Clone

```bash
git clone https://github.com/hiyokun-d/study-app.git
cd study-app
```

### 2. Backend

```bash
cd _server
npm install
cp .env.example .env       # fill in DATABASE_URL, DIRECT_URL, JWT_SECRET, GOOGLE_CLIENT_ID
npx prisma generate
npx prisma migrate deploy
npm run start:dev           # API at http://localhost:3000
```

### 3. Flutter App

```bash
# From project root
flutter pub get
flutter run -d android     # Android emulator (API URL is pre-configured)
flutter run -d chrome      # Web
flutter run                # First available device
```

> **Note:** The app is currently in **mock mode** (`AppConfig.useMock = true`). Screens work without a running backend. To use the real API, set `useMock = false` in `lib/core/constants/app_config.dart`.

> **Android emulator:** API URL is `http://10.0.2.2:3000` — that's how Android emulators reach `localhost` on the host machine.

---

## Key Patterns

### Auth flow (Frontend)

```
/login → AuthService.login() → AuthState.setFromResponse() → navigate to /student or /teacher
/register → AuthService.register() → AuthState.setFromResponse() → navigate to /update-profile
/update-profile → UserApiService.updateProfile() → AuthState.role = result → navigate to dashboard
```

### Adding a new API call (Flutter)

1. Add method to `UserApiService` (or create a new service)
2. Check `AuthState.instance.isLoggedIn` for protected calls
3. Pass `AuthState.instance.authHeaders` for JWT
4. Return a result object — never throw
5. Handle `result.success` / `result.errorMessage` in the widget

### Adding a new API endpoint (Backend)

1. Add method to the service (`user.service.ts` or create new module)
2. Add route to the controller with optional `@UseGuards(AuthGuard('jwt'))`
3. Write tests (service: mock Prisma; controller: mock service)
4. Run `npm test`

See `docs.md` for complete step-by-step guides.

---

## Testing

### Backend (62 tests · all passing)

```bash
cd _server
npm run test         # all unit tests
npm run test:watch   # watch mode
npm run test:cov     # with coverage
npm run test:e2e     # end-to-end
```

### Flutter

```bash
flutter test
```

---

## GitHub Collaboration Guide

**Never push directly to `main`.** All changes go through Feature Branch + Pull Request.

### Branch naming

| Prefix      | When             |
| ----------- | ---------------- |
| `feat/`     | New feature      |
| `fix/`      | Bug fix          |
| `api/`      | Backend API work |
| `docs/`     | Documentation    |
| `refactor/` | Cleanup          |

### Commit style

```
feat: add tutor detail screen
fix: resolve login crash on empty password
api: add booking module with create endpoint
docs: update API reference for /user/tutor/:id
```

### PR process

1. Push branch: `git push origin feat/your-feature`
2. Open PR on GitHub
3. Describe what and why
4. Wait for review → address feedback
5. Squash-merge into `main`

---

## Documentation

| File                | Contents                                                                |
| ------------------- | ----------------------------------------------------------------------- |
| `README.md`         | This file — app overview, structure, progress                           |
| `_server/README.md` | API server documentation — endpoints, architecture, tests               |
| `docs.md`           | Full developer reference — every pattern, how-to guide, troubleshooting |

---

## Contributors

<div align="center">

[![Contributors](https://contrib.rocks/image?repo=hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/graphs/contributors)

</div>

---

## License

Under development. Not licensed for public distribution. Contact the repository owner for licensing inquiries.

---

<div align="center">

Made with care by the StudyApp team — **keep learning, keep building.**

[![GitHub](https://img.shields.io/badge/GitHub-hiyokun--d%2Fstudy--app-181717?style=flat-square&logo=github)](https://github.com/hiyokun-d/study-app)

</div>
