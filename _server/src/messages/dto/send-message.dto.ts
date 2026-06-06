import { IsIn, IsObject, IsOptional, IsString, IsUrl, IsUUID } from 'class-validator';

export class SendMessageDto {
  @IsUUID()
  to_id: string;

  @IsOptional()
  @IsString()
  content?: string;

  @IsOptional()
  @IsUUID()
  booking_id?: string;

  @IsOptional()
  @IsObject()
  metadata?: Record<string, any>;

  @IsOptional()
  @IsIn(['TEXT', 'IMAGE', 'FILE'])
  message_type?: string;

  @IsOptional()
  @IsUrl()
  attachment_url?: string;
}
