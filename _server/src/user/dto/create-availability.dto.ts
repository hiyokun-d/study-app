import { IsInt, IsISO8601, IsOptional, IsString, Min } from 'class-validator';

export class CreateAvailabilityDto {
  @IsISO8601()
  available_from: string;

  @IsISO8601()
  available_to: string;

  @IsOptional()
  @IsString()
  timezone?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  max_capacity?: number;
}
