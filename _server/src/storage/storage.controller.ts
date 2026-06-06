import { Body, Controller, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { IsString, MinLength } from 'class-validator';
import { StorageService } from './storage.service';

class ChatFileUploadDto {
  @IsString()
  @MinLength(1)
  filename: string;

  @IsString()
  mime_type: string;
}

@UseGuards(AuthGuard('jwt'))
@Controller('storage')
export class StorageController {
  constructor(private readonly storageService: StorageService) {}

  // POST /storage/avatar-upload-url
  // Flow: get signed_url → PUT file to signed_url → save public_url via PATCH /user/update/profile
  @Post('avatar-upload-url')
  getAvatarUploadUrl(@Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.storageService.getAvatarUploadUrl(userId);
  }

  // POST /storage/file-upload-url
  // Flow: get signed_url → PUT file to signed_url → send message with attachment_url = public_url
  // Body: { filename: "photo.jpg", mime_type: "image/jpeg" }
  @Post('file-upload-url')
  getChatFileUploadUrl(@Request() req: any, @Body() dto: ChatFileUploadDto) {
    const userId = req.user.userId || req.user.sub;
    return this.storageService.getChatFileUploadUrl(userId, dto.filename, dto.mime_type);
  }
}
