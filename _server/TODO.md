# Backend TODO

> Work in order. Top = highest priority.

---

## ✅ Done

- [x] Auth — signup, login, Google OAuth, JWT
- [x] User module — getAllTutors, filterTutors, getTutorDetail, updateProfile
- [x] Booking — create, list (student/tutor), cancel, confirm, **complete** (coins released)
- [x] GET /booking/:id — single booking detail, auth-gated to student/tutor only
- [x] Conflict detection on createBooking — 409 if tutor slot overlaps pending/confirmed
- [x] Admin — stats, user list, tutor verify, payment orders, refunds, withdrawal management
- [x] Coin system — balance, purchase order, history, QRIS stub, withdrawal request
- [x] DB schema — coins_cost, book_price_coins, coins_per_hour, withdrawal_requests
- [x] DB migrated to Supabase (db push ✅)
- [x] TutorOffer CRUD — create, list mine, update, soft-delete (with coins_per_hour)
- [x] UpdateProfile — book_price_coins + subjects fields added
- [x] Reviews — POST /reviews, GET /reviews/tutor/:id, auto-recalculates overall_rating
- [x] Notifications module — GET /notifications, PATCH seen/:id, PATCH seen-all, unseen-count
- [x] Booking events → notifications wired (NEW_BOOKING, BOOKING_CONFIRMED, BOOKING_CANCELLED, SESSION_COMPLETED)
- [x] Filter bookings by status — `GET /booking/student?status=` and `GET /booking/tutor?status=`
- [x] TutorAvailability CRUD — POST /user/tutor/availability, GET /user/tutor/:id/availability, DELETE /user/tutor/availability/:id
- [x] Booking → link to availability slot — optional `availabilityId` in CreateBookingDto
- [x] Booking — tutor decline (PATCH /booking/:id/decline, refunds coins, notifies student)
- [x] Admin — ban/unban user (PATCH /admin/users/:id/ban, /unban)
- [x] Admin — activate/deactivate user (PATCH /admin/users/:id/activate, /deactivate)
- [x] Admin — warn user with penalty (POST /admin/users/:id/warn — penalty_days, rating_knock, price_pct)
- [x] Admin — grant coins ⚠️ TEMP (POST /admin/users/:id/grant-coins)
- [x] Auth guard — banned/inactive accounts get 403 on every request
- [x] Public listings — filter out banned/inactive tutors everywhere (offers, tutor list, detail)
- [x] Penalty display — rating and price reduced in public listings while penalty active

---

## 🟡 Still needed before ship

- [ ] **Run `prisma db push`** — schema has new fields (is_active, is_banned, penalty_*, tutor_availability_id on bookings, declined enum value)

---

## 🟢 Nice to have

- [ ] **Messages / Chat**
  - `GET /messages/:userId` — conversation (paginated)
  - `POST /messages` — send message
  - `PATCH /messages/:userId/read` — mark read

- [ ] **Pagination** on `GET /booking/student`, `GET /booking/tutor`, `GET /user/tutors`

- [ ] **Refresh token system**

- [ ] **Subjects endpoint** — `GET /subjects` (public, seed subjects table)

---

## ⚠️ Before any demo or deploy

- [ ] **DELETE `devToken()`** from `auth.controller.ts` and `auth.service.ts` (lines marked `// ⚠️ TEMP`)
- [ ] **REMOVE or gate** `POST /admin/users/:id/grant-coins` behind `NODE_ENV !== 'production'`
- [ ] **REMOVE or gate** `POST /coins/dev/fulfill/:orderId` behind `NODE_ENV !== 'production'`
