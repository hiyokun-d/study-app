import {
  IsArray,
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  IsUUID,
  MaxLength,
  Min,
} from 'class-validator';

export const SUBJECT_CATEGORIES = [
  'MATH', 'PHYSICS', 'CHEMISTRY', 'BIOLOGY', 'COMPUTER_SCIENCE', 'PROGRAMMING',
  'LANGUAGE', 'ENGLISH', 'HISTORY', 'GEOGRAPHY', 'ECONOMICS', 'ACCOUNTING',
  'LITERATURE', 'PHILOSOPHY', 'PSYCHOLOGY', 'SOCIAL_STUDIES', 'MUSIC', 'ART',
  'ENGINEERING', 'MEDICINE', 'LAW', 'BUSINESS', 'STATISTICS', 'GENERAL', 'CUSTOM',
] as const;

export class CreateTutorOfferDto {
  @IsString()
  @MaxLength(100)
  title: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  summary?: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  about?: string;

  @IsInt()
  @Min(1)
  coins_per_hour: number;

  @IsOptional()
  @IsInt()
  @Min(15)
  duration_minutes?: number;

  @IsOptional()
  @IsArray()
  @IsUUID('all', { each: true })
  subject_ids?: string[];

  @IsOptional()
  @IsUrl()
  thumbnail_url?: string;

  @IsOptional()
  @IsIn(SUBJECT_CATEGORIES)
  subject_category?: string;

  @IsOptional()
  @IsDateString()
  expires_at?: string;
}
