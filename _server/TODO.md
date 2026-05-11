# Backend TODO

> Work on these in order. Top = highest priority.

---

## 🔴 Booking — missing critical pieces

- [ ] **1. Conflict detection** — `POST /booking`
  - Before creating, query overlapping bookings for same tutor
  - Block if another booking exists in that `start_at`/`end_at` window
  - Status: `pending` or `confirmed` count as occupied

- [ ] **2. Complete a booking** — `PATCH /booking/:id/complete`
  - Only tutor can call this
  - Only `confirmed` → `completed` (reject any other status)

- [ ] **3. Get single booking** — `GET /booking/:id`
  - Return full detail
  - Only accessible by the student or tutor of that booking

- [ ] **4. Filter by status** — `GET /booking/student?status=pending`
  - Add optional `?status=` query param to student + tutor list endpoints
  - Valid values: `pending`, `confirmed`, `cancelled`, `completed`

- [ ] **5. Validate against tutor availability** — `POST /booking`
  - Check `start_at` falls inside a `tutor_availabilities` slot before creating
  - Return 400 if tutor not available at that time

- [ ] **6. Notify tutor on new booking** — inside `createBooking`
  - Insert row to `notifications` table: `type: "new_booking"`, `profile_id: tutorId`

- [ ] **7. Notify student on confirm/cancel** — inside `confirmBooking` / `cancelBooking`
  - Insert row to `notifications` table: `type: "booking_confirmed"` or `"booking_cancelled"`

---

## 🟡 Missing modules (schema ready, zero endpoints)

- [ ] **8. Reviews module**
  - `POST /review` — only allowed after booking status is `completed`
  - `GET /user/tutor/:id/reviews` — list reviews for a tutor
  - After insert: recalculate `overall_rating` + `rating_count` on `profiles` table

- [ ] **9. Notifications module**
  - `GET /notifications` — list my notifications (JWT required)
  - `PATCH /notifications/:id/seen` — mark one as seen
  - `PATCH /notifications/seen-all` — mark all as seen

- [ ] **10. TutorOffer CRUD**
  - `POST /user/tutor/offer` — create offer (tutor only)
  - `GET /user/tutor/offers` — list my offers (tutor only)
  - `PATCH /user/tutor/offer/:id` — update offer
  - `DELETE /user/tutor/offer/:id` — soft delete (`is_active = false`)

- [ ] **11. TutorAvailability**
  - `POST /user/tutor/availability` — add availability slot (tutor only)
  - `GET /user/tutor/:id/availability` — get tutor's available slots (public)
  - `DELETE /user/tutor/availability/:id` — remove a slot (tutor only)

- [ ] **12. Subjects**
  - `GET /subjects` — list all subjects (public, used for filter dropdowns)
  - Seed the `subjects` table with initial data

- [ ] **13. Messages / Chat**
  - `GET /messages/:userId` — get conversation with a user (paginated)
  - `POST /messages` — send a message
  - `PATCH /messages/:userId/read` — mark conversation as read

---

## 🟢 Smaller fixes on existing code

- [ ] **14. Add `book_price` to UpdateProfileDTO**
  - Tutors need to set their price
  - Add `@IsNumber()` `@IsOptional()` `book_price?: number` to `update-profile.dto.ts`
  - Update `user.service.ts` `updateProfile` to include it

- [ ] **15. Pagination on list endpoints**
  - `GET /booking/student`, `GET /booking/tutor`, `GET /user/tutors`
  - Add `?page=1&limit=10` query params

- [ ] **16. Subjects filter uses DB**
  - `GET /user/tutors?subject=Math` currently string-matches on array column
  - After subjects table is seeded (#12), validate subject param against it

---

## ⚠️ Before any demo or deploy

- [ ] **DELETE `devToken()` from `auth.controller.ts`** (line with `// ⚠️ TEMP`)
- [ ] **DELETE `devToken()` from `auth.service.ts`** (line with `// ⚠️ TEMP`)

---

## Suggested order

```
1 → 2 → 3 → 4 → 8 → 14 → 10 → 11 → 9 → 12 → 13 → 15 → 16 → 5 → 6 → 7
```
