import { IsOptional, IsString, Matches } from 'class-validator';

const ISO8601_WITH_TZ = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2}(\.\d+)?)?(Z|[+-]\d{2}:\d{2})$/;

export class ProposeRescheduleDto {
  @Matches(ISO8601_WITH_TZ, { message: 'new_start_at must be an ISO 8601 datetime with explicit timezone' })
  new_start_at: string;

  @Matches(ISO8601_WITH_TZ, { message: 'new_end_at must be an ISO 8601 datetime with explicit timezone' })
  new_end_at: string;

  @IsOptional()
  @IsString()
  reason?: string;
}
