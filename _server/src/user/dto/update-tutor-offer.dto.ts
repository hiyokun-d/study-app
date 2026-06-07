import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  IsUUID,
  Matches,
  MaxLength,
  Min,
} from 'class-validator';
import { SUBJECT_CATEGORIES, WEEK_DAYS } from './create-tutor-offer.dto';

export class UpdateTutorOfferDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  title?: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  summary?: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  about?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  coins_per_session?: number;

  @IsOptional()
  @IsInt()
  @Min(15)
  duration_minutes?: number;

  @IsOptional()
  @IsArray()
  @IsUUID('all', { each: true })
  subject_ids?: string[];

  @IsOptional()
  @IsBoolean()
  is_active?: boolean;

  @IsOptional()
  @IsUrl()
  thumbnail_url?: string;

  @IsOptional()
  @IsIn(SUBJECT_CATEGORIES)
  subject_category?: string;

  @IsOptional()
  @IsDateString()
  expires_at?: string;

  @IsOptional()
  @IsArray()
  @IsIn(WEEK_DAYS, { each: true })
  available_days?: string[];

  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'available_time_from must be HH:MM' })
  available_time_from?: string;

  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'available_time_to must be HH:MM' })
  available_time_to?: string;
}
