import { BadRequestException, Injectable, InternalServerErrorException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

const AVATAR_BUCKET = 'user pict';
const FILE_BUCKET = 'user file';

const AVATAR_MAX_BYTES = 6 * 1024 * 1024; // 6 MB — mirrors Supabase bucket policy
const FILE_MAX_BYTES = 10 * 1024 * 1024;  // 10 MB for chat attachments

const ALLOWED_FILE_TYPES = [
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
  'image/avif',
  'image/heic',
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'text/plain',
];

@Injectable()
export class StorageService {
  constructor(private prisma: PrismaService) {}

  private get supabaseUrl(): string {
    return process.env.SUPABASE_URL ?? '';
  }

  private get serviceKey(): string {
    return process.env.SUPABASE_SERVICE_KEY ?? '';
  }

  private assertConfigured() {
    if (!this.supabaseUrl || !this.serviceKey) {
      throw new InternalServerErrorException(
        'Storage not configured. Set SUPABASE_URL and SUPABASE_SERVICE_KEY.',
      );
    }
  }

  private async createSignedUploadUrl(
    bucket: string,
    objectPath: string,
  ): Promise<string> {
    const encodedBucket = encodeURIComponent(bucket);
    const apiUrl = `${this.supabaseUrl}/storage/v1/object/upload/sign/${encodedBucket}/${objectPath}`;

    const res = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${this.serviceKey}`,
        'Content-Type': 'application/json',
      },
    });

    if (!res.ok) {
      const err = await res.text();
      throw new InternalServerErrorException(`Failed to generate upload URL: ${err}`);
    }

    const json = (await res.json()) as { url: string };
    return `${this.supabaseUrl}${json.url}`;
  }

  // Generate a signed upload URL for the user's profile picture.
  // Validates MIME (must be image/*) and size (≤6 MB) before issuing URL.
  // Auto-saves avatar_url in profiles so the client only needs to PUT the file.
  async getAvatarUploadUrl(
    userId: string,
    mimeType: string,
    fileSize: number,
  ): Promise<{ signed_url: string; public_url: string }> {
    this.assertConfigured();

    if (!mimeType.startsWith('image/')) {
      throw new BadRequestException('Avatar must be an image file (image/*).');
    }
    if (fileSize > AVATAR_MAX_BYTES) {
      throw new BadRequestException('Avatar exceeds 6 MB limit.');
    }

    // Path is deterministic: one slot per user, overwrites on re-upload
    const signed_url = await this.createSignedUploadUrl(AVATAR_BUCKET, userId);
    const encodedBucket = encodeURIComponent(AVATAR_BUCKET);
    const public_url = `${this.supabaseUrl}/storage/v1/object/public/${encodedBucket}/${userId}`;

    // Auto-save so client doesn't need a separate PATCH /user/update/profile call
    await this.prisma.profiles.update({
      where: { id: userId },
      data: { avatar_url: public_url },
    });

    return { signed_url, public_url };
  }

  // Generate a signed upload URL for a chat file attachment.
  // Path in bucket: {userId}/{timestamp}-{sanitized filename}
  async getChatFileUploadUrl(
    userId: string,
    filename: string,
    mimeType: string,
    fileSize: number,
  ): Promise<{ signed_url: string; public_url: string; message_type: string }> {
    this.assertConfigured();

    if (!ALLOWED_FILE_TYPES.includes(mimeType)) {
      throw new BadRequestException(
        `File type "${mimeType}" not allowed. Allowed: images, PDF, Word, plain text.`,
      );
    }
    if (fileSize > FILE_MAX_BYTES) {
      throw new BadRequestException('File exceeds 10 MB limit.');
    }

    // Sanitize filename — strip path separators and limit length
    const safe = filename.replace(/[/\\?%*:|"<>]/g, '_').slice(0, 100);
    const objectPath = `${userId}/${Date.now()}-${safe}`;
    const encodedBucket = encodeURIComponent(FILE_BUCKET);

    const signed_url = await this.createSignedUploadUrl(FILE_BUCKET, objectPath);
    const public_url = `${this.supabaseUrl}/storage/v1/object/public/${encodedBucket}/${objectPath}`;
    const message_type = mimeType.startsWith('image/') ? 'IMAGE' : 'FILE';

    return { signed_url, public_url, message_type };
  }
}
