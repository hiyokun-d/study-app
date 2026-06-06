import { BadRequestException, Injectable, InternalServerErrorException } from '@nestjs/common';

const AVATAR_BUCKET = 'user pict';
const FILE_BUCKET = 'user file';

const ALLOWED_IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
const ALLOWED_FILE_TYPES = [
  ...ALLOWED_IMAGE_TYPES,
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'text/plain',
];

@Injectable()
export class StorageService {
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

  private async createSignedUrl(
    bucket: string,
    objectPath: string,
  ): Promise<{ signedURL: string }> {
    const encodedBucket = encodeURIComponent(bucket);
    const apiUrl = `${this.supabaseUrl}/storage/v1/object/sign/${encodedBucket}/${objectPath}`;

    const res = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${this.serviceKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ expiresIn: 3600 }),
    });

    if (!res.ok) {
      const err = await res.text();
      throw new InternalServerErrorException(`Failed to generate upload URL: ${err}`);
    }

    return res.json() as Promise<{ signedURL: string }>;
  }

  // Generate a signed upload URL for the user's profile picture.
  // Path in bucket: {userId}  (one file per user, overwritten on re-upload)
  async getAvatarUploadUrl(userId: string): Promise<{ signed_url: string; public_url: string }> {
    this.assertConfigured();

    const data = await this.createSignedUrl(AVATAR_BUCKET, userId);
    const encodedBucket = encodeURIComponent(AVATAR_BUCKET);
    const public_url = `${this.supabaseUrl}/storage/v1/object/public/${encodedBucket}/${userId}`;

    return {
      signed_url: `${this.supabaseUrl}${data.signedURL}`,
      public_url,
    };
  }

  // Generate a signed upload URL for a chat file attachment.
  // Path in bucket: {userId}/{timestamp}-{sanitized filename}
  async getChatFileUploadUrl(
    userId: string,
    filename: string,
    mimeType: string,
  ): Promise<{ signed_url: string; public_url: string; message_type: string }> {
    this.assertConfigured();

    if (!ALLOWED_FILE_TYPES.includes(mimeType)) {
      throw new BadRequestException(
        `File type "${mimeType}" not allowed. Allowed: images, PDF, Word, plain text.`,
      );
    }

    // Sanitize filename — strip path separators and limit length
    const safe = filename.replace(/[/\\?%*:|"<>]/g, '_').slice(0, 100);
    const objectPath = `${userId}/${Date.now()}-${safe}`;
    const encodedBucket = encodeURIComponent(FILE_BUCKET);

    const data = await this.createSignedUrl(FILE_BUCKET, objectPath);
    const public_url = `${this.supabaseUrl}/storage/v1/object/public/${encodedBucket}/${objectPath}`;

    const message_type = ALLOWED_IMAGE_TYPES.includes(mimeType) ? 'IMAGE' : 'FILE';

    return {
      signed_url: `${this.supabaseUrl}${data.signedURL}`,
      public_url,
      message_type,
    };
  }
}
