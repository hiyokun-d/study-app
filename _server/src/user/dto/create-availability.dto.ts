import { IsISO8601, IsOptional, IsString } from 'class-validator';

export class CreateAvailabilityDto {
  @IsISO8601()
  available_from: string;

  @IsISO8601()
  available_to: string;

  @IsOptional()
  @IsString()
  timezone?: string;
}
