import { IsInt, IsOptional, IsString, Min } from 'class-validator';

// ⚠️ TEMP — testing only. Remove or gate behind env flag before prod.
export class GrantCoinsDto {
  @IsInt()
  @Min(1)
  amount: number;

  @IsOptional()
  @IsString()
  note?: string;
}
