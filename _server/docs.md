# API Documentation

Base URL: `http://localhost:3000` (local dev) · Deployed via Vercel (serverless).

All request and response bodies are **JSON**. Protected endpoints require:

```
Authorization: Bearer <jwt_token>
```

Rate limits apply to auth endpoints (noted per route). Non-auth endpoints are throttled at the global default.

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Users & Profiles](#2-users--profiles)
3. [Tutor Offers](#3-tutor-offers)
4. [Bookings](#4-bookings)
5. [Coins & Payments](#5-coins--payments)
6. [Messages](#6-messages)
7. [Notifications](#7-notifications)
8. [Reviews](#8-reviews)
9. [Storage](#9-storage)
10. [Admin](#10-admin)
11. [Internal / Cron](#11-internal--cron)

---

## 1. Authentication

Base path: `/auth`

---

### `POST /auth/signup`

Create a new user account.

**Rate limit:** 5 requests / 60 s

**Request body**

| Field      | Type   | Required | Description                              |
|------------|--------|----------|------------------------------------------|
| `email`    | string | Yes      | Valid email address                      |
| `password` | string | Yes      | Minimum 8 characters                     |
| `role`     | string | No       | `STUDENT` or `TUTOR`. Defaults to `STUDENT` |

```json
{
  "email": "user@example.com",
  "password": "secret123",
  "role": "STUDENT"
}
```

**Response `201`**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "STUDENT"
  }
}
```

---

### `POST /auth/login`

Sign in with email and password.

**Rate limit:** 5 requests / 60 s

**Request body**

| Field      | Type   | Required | Description   |
|------------|--------|----------|---------------|
| `email`    | string | Yes      | Registered email |
| `password` | string | Yes      | Account password |

```json
{
  "email": "user@example.com",
  "password": "secret123"
}
```

**Response `200`**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "STUDENT"
  }
}
```

---

### `POST /auth/google`

Sign in or sign up using a Google ID token (from Google Sign-In on the client).

**Rate limit:** 10 requests / 60 s

**Request body**

| Field     | Type   | Required | Description                             |
|-----------|--------|----------|-----------------------------------------|
| `idToken` | string | Yes      | Google ID token from the client SDK      |
| `role`    | string | Yes      | `STUDENT` or `TUTOR`                    |

```json
{
  "idToken": "google_id_token_here",
  "role": "TUTOR"
}
```

**Response `200`**

Same shape as `/auth/login`.

---

### `POST /auth/admin/login`

Sign in as an admin.

**Rate limit:** 5 requests / 60 s

**Request body**

| Field      | Type   | Required | Description       |
|------------|--------|----------|-------------------|
| `admin_id` | string | Yes      | Admin account ID  |
| `password` | string | Yes      | Admin password    |

```json
{
  "admin_id": "admin_uuid",
  "password": "adminpass"
}
```

**Response `200`**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### `GET /auth/me`

**Auth required**

Return the current user's profile from the JWT.

**Response `200`**

```json
{
  "id": "uuid",
  "email": "user@example.com",
  "role": "STUDENT",
  "profile": { ... }
}
```

---

## 2. Users & Profiles

Base path: `/user`

---

### `GET /user/tutors`

Browse and filter tutors. Public endpoint.

**Query parameters**

| Param      | Type   | Description                                      |
|------------|--------|--------------------------------------------------|
| `search`   | string | Search by name or bio keyword                    |
| `subject`  | string | Filter by subject name                           |
| `maxCoins` | number | Max coins-per-hour (integer)                     |

```
GET /user/tutors?search=math&maxCoins=20
```

**Response `200`**

```json
[
  {
    "id": "uuid",
    "full_name": "Alice",
    "bio": "...",
    "book_price_coins": 15,
    "average_rating": 4.8,
    "subjects": ["Math", "Physics"]
  }
]
```

---

### `GET /user/tutors/all`

Return all tutor profiles without filtering. Public endpoint.

**Response `200`** — array of tutor profile objects.

---

### `GET /user/tutor/:id`

Get a single tutor's full public profile.

**Path parameter:** `id` — tutor UUID

**Response `200`**

```json
{
  "id": "uuid",
  "full_name": "Alice",
  "bio": "Expert in calculus",
  "book_price_coins": 15,
  "average_rating": 4.8,
  "subjects": ["Math"],
  "offers": [ ... ]
}
```

---

### `GET /user/tutor/:id/availability`

Get a tutor's available time slots. Public endpoint.

**Path parameter:** `id` — tutor UUID

**Response `200`**

```json
[
  {
    "id": "uuid",
    "available_from": "2026-06-10T08:00:00Z",
    "available_to": "2026-06-10T12:00:00Z",
    "timezone": "Asia/Jakarta"
  }
]
```

---

### `GET /user/student`

Return all student profiles. Public endpoint.

**Response `200`** — array of student profile objects.

---

### `PATCH /user/update/profile`

**Auth required**

Update the current user's profile. All fields are optional — only send what you want to change.

**Request body**

| Field             | Type     | Description                                    |
|-------------------|----------|------------------------------------------------|
| `full_name`       | string   | Max 100 characters                             |
| `username`        | string   | Max 50 characters                              |
| `bio`             | string   | Max 500 characters                             |
| `avatar_url`      | string   | Full URL to avatar image                       |
| `role`            | string   | `STUDENT` or `TUTOR`                           |
| `book_price_coins`| number   | Tutor's hourly booking price in coins (min 1)  |
| `subjects`        | string[] | Array of subject names                         |

```json
{
  "full_name": "Alice Smith",
  "bio": "I love teaching math!",
  "book_price_coins": 20
}
```

**Response `200`** — updated profile object.

---

### `PATCH /user/status`

**Auth required**

Update the current user's online presence status.

**Request body**

| Field    | Type   | Required | Values                       |
|----------|--------|----------|------------------------------|
| `status` | string | Yes      | `ONLINE`, `OFFLINE`, `BUSY`  |

```json
{
  "status": "ONLINE"
}
```

**Response `200`** — updated profile with new status.

---

### `POST /user/tutor/availability`

**Auth required · Tutor only**

Create an availability time slot for yourself.

**Request body**

| Field            | Type   | Required | Description                          |
|------------------|--------|----------|--------------------------------------|
| `available_from` | string | Yes      | ISO 8601 datetime (e.g. `2026-06-10T08:00:00Z`) |
| `available_to`   | string | Yes      | ISO 8601 datetime                    |
| `timezone`       | string | No       | IANA timezone (e.g. `Asia/Jakarta`)  |

```json
{
  "available_from": "2026-06-10T08:00:00Z",
  "available_to": "2026-06-10T12:00:00Z",
  "timezone": "Asia/Jakarta"
}
```

**Response `201`** — created availability slot.

---

### `DELETE /user/tutor/availability/:id`

**Auth required · Tutor only**

Delete one of your availability slots.

**Path parameter:** `id` — availability UUID

**Response `200`** — success message.

---

### `POST /user/tutor/offer`

**Auth required · Tutor only**

Create a new tutor offer (a service listing students can book).

**Request body**

| Field              | Type     | Required | Description                                           |
|--------------------|----------|----------|-------------------------------------------------------|
| `title`            | string   | Yes      | Max 100 characters                                    |
| `summary`          | string   | No       | Short description, max 300 characters                 |
| `about`            | string   | No       | Long description, max 2000 characters                 |
| `coins_per_hour`   | number   | Yes      | Price in coins per hour (min 1)                       |
| `duration_minutes` | number   | No       | Fixed session length in minutes (min 15)              |
| `subject_ids`      | string[] | No       | Array of subject UUIDs to tag the offer               |
| `subject_category` | string   | No       | One of the [subject categories](#subject-categories)  |
| `thumbnail_url`    | string   | No       | Full URL to a thumbnail image                         |
| `expires_at`       | string   | No       | ISO 8601 datetime — offer auto-deactivates after this |

```json
{
  "title": "Calculus for Beginners",
  "summary": "Learn derivatives and integrals step by step.",
  "coins_per_hour": 20,
  "duration_minutes": 60,
  "subject_category": "MATH"
}
```

**Response `201`** — created offer object.

---

### `GET /user/tutor/offer/mine`

**Auth required · Tutor only**

Get all offers created by the current tutor (including inactive ones).

**Response `200`** — array of offer objects.

---

### `PATCH /user/tutor/offer/:id`

**Auth required · Tutor only**

Update one of your offers. All fields are optional.

**Path parameter:** `id` — offer UUID

**Request body** — same fields as `POST /user/tutor/offer`, all optional, plus:

| Field       | Type    | Description                                |
|-------------|---------|--------------------------------------------|
| `is_active` | boolean | `true` to re-activate, `false` to deactivate |

```json
{
  "coins_per_hour": 25,
  "is_active": false
}
```

**Response `200`** — updated offer object.

---

### `DELETE /user/tutor/offer/:id`

**Auth required · Tutor only**

Delete one of your offers.

**Path parameter:** `id` — offer UUID

**Response `200`** — success message.

---

### `POST /user/tutor/verification`

**Auth required · Tutor only**

Submit identity and credential documents for admin review. All fields are optional but at least one should be provided.

**Request body**

| Field              | Type     | Description                         |
|--------------------|----------|-------------------------------------|
| `phone`            | string   | Phone number                        |
| `address`          | string   | Physical address                    |
| `id_document_url`  | string   | URL to uploaded ID document         |
| `certificate_urls` | string[] | URLs to uploaded certificate images |

```json
{
  "id_document_url": "https://cdn.example.com/id-doc.jpg",
  "certificate_urls": [
    "https://cdn.example.com/cert1.jpg"
  ]
}
```

**Response `201`** — verification submission record.

---

#### Subject Categories

Valid values for `subject_category`:

`MATH` · `PHYSICS` · `CHEMISTRY` · `BIOLOGY` · `COMPUTER_SCIENCE` · `PROGRAMMING` · `LANGUAGE` · `ENGLISH` · `HISTORY` · `GEOGRAPHY` · `ECONOMICS` · `ACCOUNTING` · `LITERATURE` · `PHILOSOPHY` · `PSYCHOLOGY` · `SOCIAL_STUDIES` · `MUSIC` · `ART` · `ENGINEERING` · `MEDICINE` · `LAW` · `BUSINESS` · `STATISTICS` · `GENERAL` · `CUSTOM`

---

## 3. Tutor Offers (Browse)

Base path: `/offers`

---

### `GET /offers`

Browse all active tutor offers with filtering. Public endpoint.

**Query parameters**

| Param       | Type   | Default | Description                                     |
|-------------|--------|---------|-------------------------------------------------|
| `search`    | string | —       | Search by offer title or tutor name             |
| `subject`   | string | —       | Filter by subject UUID                          |
| `category`  | string | —       | Filter by subject category (see categories above) |
| `maxCoins`  | number | —       | Maximum coins per hour                          |
| `minRating` | number | —       | Minimum average tutor rating (e.g. `4.0`)       |
| `page`      | number | `1`     | Page number                                     |
| `limit`     | number | `20`    | Results per page                                |

```
GET /offers?category=MATH&maxCoins=25&minRating=4&page=1&limit=10
```

**Response `200`**

```json
{
  "data": [
    {
      "id": "uuid",
      "title": "Calculus for Beginners",
      "summary": "Learn derivatives step by step.",
      "coins_per_hour": 20,
      "duration_minutes": 60,
      "subject_category": "MATH",
      "tutor": {
        "id": "uuid",
        "full_name": "Alice",
        "average_rating": 4.8
      }
    }
  ],
  "total": 42,
  "page": 1,
  "limit": 10
}
```

---

### `GET /offers/:id`

Get a single offer's full detail, including the tutor's profile and recent reviews. Public endpoint.

**Path parameter:** `id` — offer UUID

**Response `200`**

```json
{
  "id": "uuid",
  "title": "Calculus for Beginners",
  "about": "Long description...",
  "coins_per_hour": 20,
  "duration_minutes": 60,
  "tutor": {
    "id": "uuid",
    "full_name": "Alice",
    "bio": "...",
    "average_rating": 4.8,
    "subjects": ["Math"]
  },
  "reviews": [ ... ]
}
```

---

## 4. Bookings

Base path: `/booking`

**All booking endpoints require auth.**

---

### `POST /booking`

Create a new booking. The student sends this to request a session with a tutor.

You can book in two ways:
- **Via an offer** — provide `tutorOfferId`. Price and duration are derived from the offer automatically.
- **Direct** — provide `tutorId`, `durationMinutes`, and `endAt` manually.

**Request body**

| Field            | Type   | Required     | Description                                                  |
|------------------|--------|--------------|--------------------------------------------------------------|
| `tutorOfferId`   | string | Conditional  | UUID of the offer to book. Derives tutorId, duration, endAt  |
| `tutorId`        | string | Conditional  | UUID of the tutor (only if not using an offer)               |
| `startAt`        | string | Yes          | ISO 8601 start datetime                                      |
| `endAt`          | string | Conditional  | ISO 8601 end datetime (required if no offer provided)        |
| `durationMinutes`| number | Conditional  | Session length in minutes, min 15 (required if no offer)     |
| `availabilityId` | string | No           | UUID of a specific availability slot to link                 |
| `description`    | string | No           | Why you need this session (shown to tutor before confirming) |

```json
{
  "tutorOfferId": "offer-uuid",
  "startAt": "2026-06-15T10:00:00Z",
  "description": "I need help with integration by parts."
}
```

**Response `201`** — created booking object.

> Coins are deducted from the student's balance immediately. If the tutor declines or the booking expires, coins are refunded automatically.

---

### `GET /booking/student`

Get the current student's booking history.

**Query parameters**

| Param    | Type   | Default | Description                                                     |
|----------|--------|---------|-----------------------------------------------------------------|
| `status` | string | —       | Filter by status: `pending`, `confirmed`, `completed`, `cancelled`, `declined`, `expired` |
| `from`   | string | —       | ISO 8601 start of date range                                    |
| `to`     | string | —       | ISO 8601 end of date range                                      |
| `page`   | number | `1`     | Page number                                                     |
| `limit`  | number | `50`    | Results per page                                                |

**Response `200`** — paginated array of booking objects.

---

### `GET /booking/tutor`

Get the current tutor's received bookings. Same query parameters as `GET /booking/student`.

**Response `200`** — paginated array of booking objects.

---

### `GET /booking/:id`

Get full detail of a single booking. Only the student or tutor involved can access it.

**Path parameter:** `id` — booking UUID

**Response `200`** — full booking object.

---

### `GET /booking/:id/join`

Get the video call / session join information for a confirmed booking. Only the student and tutor of that booking can call this.

**Path parameter:** `id` — booking UUID

**Response `200`**

```json
{
  "room_url": "https://meet.example.com/session-abc",
  "token": "participant_token"
}
```

---

### `PATCH /booking/:id/confirm`

**Tutor only**

Confirm a pending booking request. This signals to the student that the session is accepted.

**Response `200`** — updated booking with `status: "confirmed"`.

---

### `PATCH /booking/:id/decline`

**Tutor only**

Decline a pending booking. Coins are refunded to the student.

**Response `200`** — updated booking with `status: "declined"`.

---

### `PATCH /booking/:id/cancel`

Cancel a confirmed booking. Either the student or tutor may cancel.

**Response `200`** — updated booking with `status: "cancelled"`.

---

### `PATCH /booking/:id/complete`

**Tutor only**

Mark a confirmed session as completed. Coins are transferred from the student's reserved balance to the tutor.

**Response `200`** — updated booking with `status: "completed"`.

---

### `PATCH /booking/:id/propose-price`

**Tutor only**

Propose a custom price for an existing booking (price negotiation). The proposal expires after 2 hours if not accepted.

**Request body**

| Field             | Type   | Required | Description                            |
|-------------------|--------|----------|----------------------------------------|
| `proposed_coins`  | number | Yes      | New price in coins (min 1)             |
| `message`         | string | No       | Optional message to the student        |

```json
{
  "proposed_coins": 30,
  "message": "This session requires extra prep time."
}
```

**Response `200`** — updated booking with proposal details.

---

### `PATCH /booking/:id/accept-price`

**Student only**

Accept the tutor's proposed price. The coin difference is adjusted on the student's balance.

**Response `200`** — updated booking.

---

### `PATCH /booking/:id/reject-price`

**Student only**

Reject the tutor's proposed price. The proposal is cleared; original price stays.

**Response `200`** — updated booking.

---

### `PATCH /booking/:id/propose-reschedule`

Propose rescheduling an existing confirmed booking. Either party may propose.

**Request body**

| Field         | Type   | Required | Description                    |
|---------------|--------|----------|--------------------------------|
| `new_start_at`| string | Yes      | ISO 8601 new start datetime    |
| `new_end_at`  | string | Yes      | ISO 8601 new end datetime      |
| `reason`      | string | No       | Reason for the reschedule      |

```json
{
  "new_start_at": "2026-06-16T10:00:00Z",
  "new_end_at": "2026-06-16T11:00:00Z",
  "reason": "Can't make the original time."
}
```

**Response `200`** — updated booking with reschedule proposal.

---

### `PATCH /booking/:id/accept-reschedule`

Accept the pending reschedule proposal. The other party calls this.

**Response `200`** — updated booking with new times applied.

---

### `PATCH /booking/:id/reject-reschedule`

Reject the pending reschedule proposal. Original times remain.

**Response `200`** — updated booking.

---

### `POST /booking/:id/review`

**Student only**

Submit a review for a completed booking. Only allowed once per booking.

**Path parameter:** `id` — booking UUID

**Request body**

| Field     | Type   | Required | Description                         |
|-----------|--------|----------|-------------------------------------|
| `rating`  | number | Yes      | Integer from 1 to 5                 |
| `comment` | string | No       | Written feedback, max 1000 characters |

```json
{
  "rating": 5,
  "comment": "Alice explained everything so clearly!"
}
```

**Response `201`** — created review object.

---

## 5. Coins & Payments

Base path: `/coins`

---

### `GET /coins/packages`

Get available coin purchase packages. Public endpoint.

**Response `200`**

```json
[
  { "id": "starter", "coins": 50, "price_idr": 25000 },
  { "id": "pro", "coins": 150, "price_idr": 65000 }
]
```

---

### `GET /coins/balance`

**Auth required**

Get the current user's coin balance.

**Response `200`**

```json
{
  "coins_balance": 120
}
```

---

### `GET /coins/history`

**Auth required**

Get the current user's full coin transaction history.

**Response `200`**

```json
[
  {
    "id": "uuid",
    "amount": 50,
    "kind": "PURCHASE",
    "note": "Coin top-up",
    "created_at": "2026-06-01T10:00:00Z"
  },
  {
    "id": "uuid",
    "amount": -20,
    "kind": "BOOKING_PAYMENT",
    "ref_id": "booking-uuid",
    "created_at": "2026-06-03T14:00:00Z"
  }
]
```

Transaction kinds: `PURCHASE` · `BOOKING_PAYMENT` · `REFUND` · `TUTOR_EARNING` · `ADMIN_GRANT` · `WITHDRAWAL`

---

### `POST /coins/purchase`

**Auth required**

> **Currently unavailable.** Returns `503 Service Unavailable`. Payment gateway integration (Midtrans) is pending.

---

### `POST /coins/withdraw`

**Auth required · Tutor only**

Request a withdrawal of earned coins to a bank account or e-wallet.

**Request body**

| Field            | Type   | Required | Description                                              |
|------------------|--------|----------|----------------------------------------------------------|
| `coins_amount`   | number | Yes      | Coins to withdraw (min 10)                               |
| `account_name`   | string | Yes      | Account holder name                                      |
| `account_number` | string | Yes      | Account or phone number                                  |
| `payment_method` | string | No       | `QRIS`, `BANK_TRANSFER`, `GOPAY`, `OVO`, `DANA`          |
| `bank_name`      | string | No       | Bank name (required when `payment_method` is `BANK_TRANSFER`) |

```json
{
  "coins_amount": 100,
  "account_name": "Alice Smith",
  "account_number": "081234567890",
  "payment_method": "GOPAY"
}
```

**Response `201`** — withdrawal request record with `status: "PENDING"`.

---

### `GET /coins/withdrawals`

**Auth required**

Get all of the current user's withdrawal requests.

**Response `200`**

```json
[
  {
    "id": "uuid",
    "coins_amount": 100,
    "payment_method": "GOPAY",
    "status": "PENDING",
    "created_at": "2026-06-05T09:00:00Z"
  }
]
```

Withdrawal statuses: `PENDING` · `APPROVED` · `REJECTED` · `PAID`

---

## 6. Messages

Base path: `/messages`

**All message endpoints require auth.**

---

### `POST /messages`

Send a message to another user. Can be a plain text message, an image, or a file attachment. Can optionally be linked to a booking thread.

**Request body**

| Field            | Type   | Required | Description                                          |
|------------------|--------|----------|------------------------------------------------------|
| `to_id`          | string | Yes      | UUID of the recipient user                           |
| `content`        | string | No       | Text content of the message                          |
| `booking_id`     | string | No       | UUID of a booking to associate this message with     |
| `message_type`   | string | No       | `TEXT` (default), `IMAGE`, or `FILE`                 |
| `attachment_url` | string | No       | URL of the uploaded file (use `/storage` first)      |
| `metadata`       | object | No       | Arbitrary key-value pairs for client-side use        |

```json
{
  "to_id": "recipient-uuid",
  "content": "Hi! I have a question about the session.",
  "booking_id": "booking-uuid"
}
```

**Sending a file:**

```json
{
  "to_id": "recipient-uuid",
  "message_type": "IMAGE",
  "attachment_url": "https://cdn.example.com/uploads/chat/photo.jpg"
}
```

**Response `201`** — the created message object.

---

### `GET /messages/conversations`

Get the inbox — all active conversation threads with the last message and unread count per thread.

**Response `200`**

```json
[
  {
    "partner": {
      "id": "uuid",
      "full_name": "Alice",
      "avatar_url": "https://..."
    },
    "last_message": {
      "content": "See you tomorrow!",
      "created_at": "2026-06-06T20:00:00Z"
    },
    "unread_count": 2
  }
]
```

---

### `GET /messages/conversation/:userId`

Get paginated message history with one specific user, from newest to oldest.

**Path parameter:** `userId` — the other user's UUID

**Query parameters**

| Param    | Type   | Default | Description                                        |
|----------|--------|---------|----------------------------------------------------|
| `cursor` | string | —       | Message UUID to paginate from (load older messages)|
| `limit`  | number | `30`    | Number of messages to return                       |

```
GET /messages/conversation/partner-uuid?limit=30
GET /messages/conversation/partner-uuid?cursor=last-message-uuid&limit=30
```

**Response `200`**

```json
{
  "messages": [
    {
      "id": "uuid",
      "from_id": "uuid",
      "to_id": "uuid",
      "content": "Hello!",
      "message_type": "TEXT",
      "is_read": true,
      "created_at": "2026-06-06T20:00:00Z"
    }
  ],
  "next_cursor": "uuid-of-oldest-message-returned"
}
```

---

### `GET /messages/unread-count`

Get the total number of unread messages across all conversations.

**Response `200`**

```json
{
  "unread_count": 5
}
```

---

### `PATCH /messages/conversation/:userId/read-all`

Mark all unread messages from a specific user as read.

**Path parameter:** `userId` — the sender's UUID

**Response `200`** — `{ "marked": 3 }` (number of messages marked).

---

### `PATCH /messages/:id/read`

Mark a single message as read.

**Path parameter:** `id` — message UUID

**Response `200`** — updated message object.

---

### `POST /messages/:id/report`

Report a message for admin review.

**Path parameter:** `id` — message UUID

**Request body**

| Field    | Type   | Required | Description                           |
|----------|--------|----------|---------------------------------------|
| `reason` | string | Yes      | Min 5 characters describing the issue |

```json
{
  "reason": "This message contains inappropriate content."
}
```

**Response `201`** — report record.

---

## 7. Notifications

Base path: `/notifications`

**All notification endpoints require auth.**

---

### `GET /notifications`

Get the current user's notification feed, newest first.

**Query parameters**

| Param   | Type   | Default | Description         |
|---------|--------|---------|---------------------|
| `page`  | number | `1`     | Page number         |
| `limit` | number | `20`    | Results per page    |

**Response `200`**

```json
{
  "data": [
    {
      "id": "uuid",
      "type": "BOOKING_CONFIRMED",
      "payload": { "booking_id": "uuid" },
      "seen": false,
      "created_at": "2026-06-06T10:00:00Z"
    }
  ],
  "total": 12,
  "page": 1
}
```

**Notification types:**

| Type                     | Triggered when                                         |
|--------------------------|--------------------------------------------------------|
| `BOOKING_CONFIRMED`      | Tutor confirms your booking                           |
| `BOOKING_DECLINED`       | Tutor declines your booking                           |
| `BOOKING_CANCELLED`      | A booking is cancelled                                |
| `BOOKING_EXPIRED`        | Booking timed out — tutor didn't respond              |
| `BOOKING_EXPIRED_TUTOR`  | Sent to tutor when their pending booking expired      |
| `SESSION_REMINDER`       | 10–20 min before a confirmed session starts           |
| `SESSION_COMPLETED`      | Session marked complete (coins transferred)           |
| `PRICE_PROPOSAL`         | Tutor proposed a new price for your booking           |
| `PRICE_PROPOSAL_EXPIRED` | Price proposal window (2 h) passed without response   |
| `RESCHEDULE_PROPOSED`    | Other party proposed new session time                 |
| `RESCHEDULE_ACCEPTED`    | Your reschedule proposal was accepted                 |
| `RESCHEDULE_REJECTED`    | Your reschedule proposal was rejected                 |

---

### `GET /notifications/unseen-count`

Get the count of unseen (not yet acknowledged) notifications.

**Response `200`**

```json
{
  "unseen_count": 3
}
```

---

### `PATCH /notifications/seen-all`

Mark all notifications as seen in one request.

**Response `200`** — `{ "marked": 7 }`.

---

### `PATCH /notifications/:id/seen`

Mark a single notification as seen.

**Path parameter:** `id` — notification UUID

**Response `200`** — updated notification object.

---

## 8. Reviews

Base path: `/reviews`

---

### `POST /reviews`

**Auth required · Student only**

Submit a review for a tutor. Requires a completed booking with that tutor. You may also use `POST /booking/:id/review` to submit inline from the booking.

**Request body**

| Field       | Type   | Required | Description                         |
|-------------|--------|----------|-------------------------------------|
| `booking_id`| string | Yes      | UUID of the completed booking       |
| `rating`    | number | Yes      | Integer from 1 to 5                 |
| `comment`   | string | No       | Written feedback, max 1000 characters |

```json
{
  "booking_id": "booking-uuid",
  "rating": 5,
  "comment": "Best tutor I've had. Highly recommend!"
}
```

**Response `201`** — created review object.

---

### `GET /reviews/tutor/:id`

Public endpoint. Get all reviews for a specific tutor.

**Path parameter:** `id` — tutor UUID

**Response `200`**

```json
[
  {
    "id": "uuid",
    "rating": 5,
    "comment": "Excellent!",
    "student": { "full_name": "Bob", "avatar_url": "https://..." },
    "created_at": "2026-06-01T10:00:00Z"
  }
]
```

---

## 9. Storage

Base path: `/storage`

**All storage endpoints require auth.**

File uploads use a two-step presigned URL flow:
1. Call this API to get a signed upload URL and the final public URL.
2. `PUT` the file directly to the signed URL from the client — no server involved.

---

### `POST /storage/avatar-upload-url`

Get a presigned URL to upload a profile avatar. After the upload, the user's `avatar_url` in their profile is **automatically updated** — no separate profile update call is needed.

**Constraints:** MIME type must be `image/*`. Max file size: **6 MB**.

**Request body**

| Field       | Type   | Required | Description                          |
|-------------|--------|----------|--------------------------------------|
| `mime_type` | string | Yes      | e.g. `image/jpeg`, `image/png`       |
| `file_size` | number | Yes      | File size in bytes (min 1)           |

```json
{
  "mime_type": "image/jpeg",
  "file_size": 204800
}
```

**Response `200`**

```json
{
  "upload_url": "https://storage.provider.com/signed-url...",
  "public_url": "https://cdn.example.com/avatars/user-uuid.jpg"
}
```

**Upload the file:**

```http
PUT <upload_url>
Content-Type: image/jpeg

<binary file data>
```

---

### `POST /storage/file-upload-url`

Get a presigned URL to upload a file for chat (image or document attachment).

**Request body**

| Field       | Type   | Required | Description                          |
|-------------|--------|----------|--------------------------------------|
| `filename`  | string | Yes      | Original filename (e.g. `photo.jpg`) |
| `mime_type` | string | Yes      | e.g. `image/jpeg`, `application/pdf` |
| `file_size` | number | Yes      | File size in bytes (min 1)           |

```json
{
  "filename": "homework.pdf",
  "mime_type": "application/pdf",
  "file_size": 512000
}
```

**Response `200`**

```json
{
  "upload_url": "https://storage.provider.com/signed-url...",
  "public_url": "https://cdn.example.com/uploads/chat/homework.pdf"
}
```

Use the returned `public_url` as the `attachment_url` when sending a message.

---

## 10. Admin

Base path: `/admin`

**All endpoints except `POST /admin/create` require an Admin JWT** (role `ADMIN`).

---

### `POST /admin/create`

Create an admin account. During initial setup (when no admins exist), this is open. Once an admin exists, you must provide a valid Admin JWT to call this.

**Request body**

| Field              | Type   | Required | Description                              |
|--------------------|--------|----------|------------------------------------------|
| `full_name`        | string | Yes      | Min 3 characters                         |
| `password`         | string | Yes      | Min 8 characters                         |
| `bootstrap_secret` | string | No       | One-time secret for first-admin bootstrap |

```json
{
  "full_name": "Super Admin",
  "password": "adminpassword"
}
```

---

### `GET /admin/stats`

Get platform-wide statistics.

**Response `200`**

```json
{
  "total_users": 150,
  "total_tutors": 40,
  "total_bookings": 320,
  "total_completed_sessions": 280,
  "coins_in_circulation": 5000
}
```

---

### `GET /admin/users`

Get a paginated list of all users.

**Query parameters:** `page` (default `1`), `limit` (default `20`)

**Response `200`** — paginated user list.

---

### `GET /admin/users/:id`

Get a single user's full profile and account details.

**Path parameter:** `id` — user UUID

---

### `PATCH /admin/users/:id/ban`

Ban a user. They lose access to the platform.

**Path parameter:** `id` — user UUID

**Request body**

| Field    | Type   | Required | Description           |
|----------|--------|----------|-----------------------|
| `reason` | string | Yes      | Reason for the ban    |

```json
{
  "reason": "Repeated policy violations"
}
```

---

### `PATCH /admin/users/:id/unban`

Lift the ban on a user.

**Path parameter:** `id` — user UUID

---

### `PATCH /admin/users/:id/deactivate`

Deactivate a user's account (softer than a ban).

**Path parameter:** `id` — user UUID

---

### `PATCH /admin/users/:id/activate`

Re-activate a deactivated account.

**Path parameter:** `id` — user UUID

---

### `POST /admin/users/:id/warn`

Issue a formal warning to a user. Can include a temporary penalty period and rating knock.

**Path parameter:** `id` — user UUID

**Request body**

| Field          | Type   | Required | Description                                   |
|----------------|--------|----------|-----------------------------------------------|
| `penalty_days` | number | Yes      | Days the penalty applies (min 1)              |
| `rating_knock` | number | Yes      | Rating points to deduct (0–5)                 |
| `price_pct`    | number | Yes      | Percentage price restriction to apply (0–100) |

```json
{
  "penalty_days": 7,
  "rating_knock": 0.5,
  "price_pct": 20
}
```

---

### `GET /admin/tutors/pending`

Get all tutors with a pending verification submission.

**Response `200`** — array of tutor profiles with their verification documents.

---

### `GET /admin/tutors/:id`

Get a tutor's full admin view including verification details.

**Path parameter:** `id` — tutor UUID

---

### `PATCH /admin/tutors/:id/verify`

Approve or reject a tutor's verification submission.

**Path parameter:** `id` — tutor UUID

**Request body**

| Field         | Type   | Required | Description                                      |
|---------------|--------|----------|--------------------------------------------------|
| `status`      | string | Yes      | `APPROVED` or `REJECTED`                         |
| `admin_notes` | string | No       | Internal notes or rejection reason               |

```json
{
  "status": "APPROVED",
  "admin_notes": "All documents verified."
}
```

---

### `GET /admin/bookings`

Get a paginated list of all bookings on the platform.

**Query parameters:** `page` (default `1`), `limit` (default `20`)

---

### `GET /admin/bookings/:id`

Get full detail of a specific booking.

**Path parameter:** `id` — booking UUID

---

### `GET /admin/bookings/:id/join`

Get session join info for a booking (for admin monitoring purposes).

**Path parameter:** `id` — booking UUID

---

### `GET /admin/payments`

Get a paginated list of payment orders.

**Query parameters:** `page`, `limit`, `status` (filter by payment status)

---

### `POST /admin/refunds`

Process a refund decision for a payment order.

**Request body**

| Field      | Type   | Required | Description                               |
|------------|--------|----------|-------------------------------------------|
| `order_id` | string | Yes      | UUID of the payment order                 |
| `decision` | string | Yes      | `APPROVED` or `REJECTED`                  |
| `reason`   | string | No       | Reason (especially useful for rejections) |

```json
{
  "order_id": "order-uuid",
  "decision": "APPROVED"
}
```

---

### `GET /admin/withdrawals`

Get a paginated list of withdrawal requests.

**Query parameters:** `page`, `limit`, `status` (filter by `PENDING`, `APPROVED`, `REJECTED`, `PAID`)

---

### `PATCH /admin/withdrawals/:id`

Process a withdrawal request.

**Path parameter:** `id` — withdrawal request UUID

**Request body**

| Field         | Type   | Required | Description                                   |
|---------------|--------|----------|-----------------------------------------------|
| `decision`    | string | Yes      | `APPROVED`, `REJECTED`, or `PAID`             |
| `admin_notes` | string | No       | Internal notes                                |

```json
{
  "decision": "PAID",
  "admin_notes": "Transferred via BCA."
}
```

---

### `GET /admin/reports/messages`

Get a paginated list of reported messages pending review.

**Query parameters:** `page` (default `1`), `limit` (default `20`)

---

### `PATCH /admin/reports/messages/:id/dismiss`

Dismiss a message report (no action taken on the message).

**Path parameter:** `id` — report UUID

---

### `POST /admin/reports/messages/:id/delete`

Delete the reported message from the platform.

**Path parameter:** `id` — report UUID

---

## 11. Internal / Cron

Base path: `/internal`

These endpoints are called by automated Vercel Cron jobs, not by clients. All require the `x-internal-secret` header matching the `INTERNAL_SECRET` environment variable.

```
x-internal-secret: <INTERNAL_SECRET>
```

---

### `GET /internal/notify-upcoming-sessions`

Sends `SESSION_REMINDER` notifications to both parties of any confirmed session starting in 10–20 minutes. Runs every 10 minutes.

**Response `200`**

```json
{ "notified": 4 }
```

---

### `GET /internal/process-expirations`

Handles three cleanup tasks, runs every 10 minutes:

1. **Expire pending bookings** — bookings pending for over 1 hour are set to `expired` and coins are refunded to the student.
2. **Clear stale price proposals** — proposals older than 2 hours with no response are removed.
3. **Auto-complete stale sessions** — confirmed sessions whose `end_at` passed more than 2 hours ago are automatically completed and coins are transferred to the tutor.

**Response `200`**

```json
{
  "expired_bookings": 2,
  "cleared_price_proposals": 1,
  "auto_completed_sessions": 3
}
```

---

### `GET /internal/cleanup`

Daily maintenance job. Runs once per day.

1. Deletes messages older than 3 days.
2. Deletes all messages from closed booking threads (completed / cancelled / declined / expired).
3. Deactivates tutor offers whose `expires_at` has passed.
4. Deletes seen notifications older than 30 days.

**Response `200`**

```json
{
  "deleted_old_messages": 120,
  "deleted_closed_thread_messages": 45,
  "deactivated_expired_offers": 8,
  "deleted_old_notifications": 200
}
```

---

## Error Responses

All errors follow this shape:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request"
}
```

| Status | Meaning                                              |
|--------|------------------------------------------------------|
| `400`  | Bad request — validation failed or malformed body    |
| `401`  | Unauthorized — JWT missing or invalid                |
| `403`  | Forbidden — correct JWT but wrong role/ownership     |
| `404`  | Not found                                            |
| `409`  | Conflict — e.g. duplicate booking or existing review |
| `429`  | Too many requests — rate limit exceeded              |
| `503`  | Service unavailable — feature not yet enabled        |
