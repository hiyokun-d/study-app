# Application Documentation: StudyApp (Peer-to-Peer Tutoring Marketplace)

## Project Overview

StudyApp is a comprehensive peer-to-peer learning platform designed to connect students with qualified tutors. The application facilitates knowledge sharing through a structured marketplace where tutors can offer their expertise in various subjects, and students can book personalized learning sessions.

---

## Technical Stack

The application follows a modern decoupled architecture, ensuring scalability, maintainability, and a seamless user experience across platforms.

### Frontend (Mobile Application)

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Architecture:** Feature-first modular structure, promoting high cohesion and low coupling.
- **UI/UX:** Custom-built design system using Material Design principles, featuring specialized widgets for consistent branding.
- **Key Capabilities:** Cross-platform support (Android, iOS, Web), reactive UI components, and integrated navigation routing.

### Backend (Server-side)

- **Framework:** [NestJS](https://nestjs.com/) (Node.js/TypeScript)
- **Database ORM:** [Prisma](https://www.prisma.io/)
- **Language:** TypeScript for type-safe server-side logic.
- **Key Capabilities:** RESTful API architecture, modular dependency injection, and integrated authentication modules.

### Infrastructure & Database

- **Database:** [PostgreSQL](https://www.postgresql.org/)
- **Platform:** [Supabase](https://supabase.com/) for database hosting and potentially Auth/Storage services.
- **ORM Layer:** Prisma Client for advanced query optimization and type-safe database access.

---

## Application Concept & Workflow

StudyApp operates on a dual-role ecosystem:

1. **Students:** Users seeking to improve their skills. They can browse tutor profiles, view specific learning offers, book sessions based on real-time availability, and engage in live learning environments.
2. **Tutors:** Subject matter experts who create "Tutor Offers." They manage their own pricing, set availability windows, and communicate directly with students to facilitate learning.

### Core Business Logic

- **Booking System:** A robust state-machine-based booking flow (Pending, Confirmed, Cancelled, Completed).
- **Tutor Offers:** Unlike generic profiles, tutors can create specific "Offers" with different durations and prices per subject.
- **Review & Rating:** A bi-directional rating system to ensure quality and trust within the community.
- **Financial Integrity:** Transaction tracking for every booking, ensuring transparency in payments and refunds.

---

## Current Features & Modules

### 1. Authentication & User Management

- **Secure Onboarding:** Multi-step registration and login flow.
- **Role Selection:** Specialized workflows for Students and Teachers during the first-time setup.
- **Profile Customization:** Users can manage their bios, avatars, and subject expertise.

### 2. Marketplace & Discovery

- **Student Dashboard:** Personalized view of recommended courses and upcoming sessions.
- **Tutor Offers:** Detailed viewing of teaching services including duration, price, and tutor background.
- **Subject-Based Filtering:** Ability to find experts based on specific academic or professional categories.

### 3. Scheduling & Live Sessions

- **Availability Management:** Tutors can define precise time slots for their services.
- **Live Class Interface:** Dedicated screens for active learning sessions and live interactions.
- **Booking Management:** Real-time tracking of session status for both parties.

### 4. Communication System

- **Integrated Messaging:** Context-aware chat system linked directly to bookings, allowing students and tutors to coordinate effectively.
- **Read Receipts & Metadata:** Enhanced messaging capabilities for a better coordination experience.

### 5. Payment & Subscription

- **Subscription Plans:** Flexible tiered access for premium platform features.
- **Transaction Processing:** Dedicated payment flow including checkout and success confirmation.
- **Financial History:** Transparent logging of all booking-related transactions.

---

## Project Structure (Development Progress)

The project is currently organized into the following key directories:

- `lib/features/`: Contains the modular UI and logic for Auth, Chat, Student, Teacher, and Subscription modules.
- `lib/models/`: Centralized data models shared across the application.
- `_server/src/`: The NestJS source code, organized into Auth, User, and Prisma service modules.
- `_server/prisma/`: Defines the database schema and relational mapping for the entire ecosystem.
