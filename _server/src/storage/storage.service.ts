import { Injectable, InternalServerErrorException } from '@nestjs/common';

@Injectable()
export class StorageService {
  private get supabaseUrl(): string {
    return process.env.SUPABASE_URL ?? '';
  }

  private get serviceKey(): string {
    return process.env.SUPABASE_SERVICE_KEY ?? '';
  }

  async getAvatarUploadUrl(userId: string): Promise<{ signed_url: string; public_url: string }> {
    if (!this.supabaseUrl || !this.serviceKey) {
      throw new InternalServerErrorException('Storage not configured. Set SUPABASE_URL and SUPABASE_SERVICE_KEY.');
    }

    // Supabase Storage: create signed upload URL for avatars/{userId}
    const path = userId;
    const apiUrl = `${this.supabaseUrl}/storage/v1/object/sign/avatars/${path}`;

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

    const data = (await res.json()) as { signedURL: string; token: string; path: string };

    const public_url = `${this.supabaseUrl}/storage/v1/object/public/avatars/${path}`;

    return {
      signed_url: `${this.supabaseUrl}${data.signedURL}`,
      public_url,
    };
  }
}
