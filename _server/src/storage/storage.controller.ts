import { Controller, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { StorageService } from './storage.service';

@UseGuards(AuthGuard('jwt'))
@Controller('storage')
export class StorageController {
  constructor(private readonly storageService: StorageService) {}

  // POST /storage/avatar-upload-url
  // Returns a signed Supabase URL so client can PUT the file directly,
  // plus the final public_url to save via PATCH /user/update/profile.
  @Post('avatar-upload-url')
  getAvatarUploadUrl(@Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.storageService.getAvatarUploadUrl(userId);
  }
}
