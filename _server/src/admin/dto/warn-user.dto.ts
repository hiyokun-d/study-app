import { IsInt, IsNumber, Max, Min } from 'class-validator';

export class WarnUserDto {
  @IsInt()
  @Min(1)
  penalty_days: number;

  @IsNumber()
  @Min(0)
  @Max(5)
  rating_knock: number;

  @IsInt()
  @Min(0)
  @Max(100)
  price_pct: number;
}
