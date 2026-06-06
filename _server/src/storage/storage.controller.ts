import { Body, Controller, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { IsNumber, IsString, Min, MinLength } from 'class-validator';
import { StorageService } from './storage.service';

class AvatarUploadDto {
  @IsString()
  @MinLength(1)
  mime_type: string;

  @IsNumber()
  @Min(1)
  file_size: number;
}

class ChatFileUploadDto {
  @IsString()
  @MinLength(1)
  filename: string;

  @IsString()
  mime_type: string;

  @IsNumber()
  @Min(1)
  file_size: number;
}

@UseGuards(AuthGuard('jwt'))
@Controller('storage')
export class StorageController {
  constructor(private readonly storageService: StorageService) {}

  // POST /storage/avatar-upload-url
  // Body: { mime_type: "image/jpeg", file_size: 102400 }
  // Validates MIME (image/*) and size (≤6 MB), auto-saves avatar_url in profile.
  // Client only needs to PUT file to signed_url — no separate profile update needed.
  @Post('avatar-upload-url')
  getAvatarUploadUrl(@Request() req: any, @Body() dto: AvatarUploadDto) {
    const userId = req.user.userId || req.user.sub;
    return this.storageService.getAvatarUploadUrl(userId, dto.mime_type, dto.file_size);
  }

  // POST /storage/file-upload-url
  // Body: { filename: "photo.jpg", mime_type: "image/jpeg", file_size: 204800 }
  @Post('file-upload-url')
  getChatFileUploadUrl(@Request() req: any, @Body() dto: ChatFileUploadDto) {
    const userId = req.user.userId || req.user.sub;
    return this.storageService.getChatFileUploadUrl(
      userId,
      dto.filename,
      dto.mime_type,
      dto.file_size,
    );
  }
}
