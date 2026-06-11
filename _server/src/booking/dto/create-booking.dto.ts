import { IsInt, IsOptional, IsString, IsUUID, Min, Matches } from 'class-validator';

// Require an explicit UTC offset (Z or ±HH:MM) so the server never guesses the timezone.
// Flutter must send `.toUtc().toIso8601String()` which appends "Z".
const ISO8601_WITH_TZ = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2}(\.\d+)?)?(Z|[+-]\d{2}:\d{2})$/;

export class CreateBookingDto {
  // Required only when NOT booking via an offer
  @IsOptional()
  @IsUUID()
  tutorId?: string;

  // If provided, tutorId / durationMinutes / endAt are all derived from the offer
  @IsOptional()
  @IsUUID()
  tutorOfferId?: string;

  @Matches(ISO8601_WITH_TZ, { message: 'startAt must be an ISO 8601 datetime with explicit timezone (e.g. 2025-06-11T10:00:00Z or +07:00)' })
  startAt: string;

  // Optional — auto-computed from offer duration when tutorOfferId is given
  @IsOptional()
  @Matches(ISO8601_WITH_TZ, { message: 'endAt must be an ISO 8601 datetime with explicit timezone' })
  endAt?: string;

  // Optional when tutorOfferId given
  @IsOptional()
  @IsInt()
  @Min(15)
  durationMinutes?: number;

  // Optional — link booking to a specific tutor availability slot
  @IsOptional()
  @IsUUID()
  availabilityId?: string;

  // Optional — student explains why they need the session (shown to tutor before confirm)
  @IsOptional()
  @IsString()
  description?: string;
}
