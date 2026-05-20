import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

// RSA-OAEP + AES-256-GCM hybrid encryption.
// Encrypt uses only the public key — any part of the app can encrypt.
// Decrypt requires the private key — only admin service should call decrypt().
// Even with full DB access, ciphertext is unreadable without ADMIN_PRIVATE_KEY_B64.

const AES_ALGO = 'aes-256-gcm';
const IV_LENGTH = 12;
const RSA_PADDING = crypto.constants.RSA_PKCS1_OAEP_PADDING;

@Injectable()
export class EncryptionService {
  private readonly publicKey: string;
  private readonly privateKey: string | null;

  constructor() {
    const pubB64 = process.env.ADMIN_PUBLIC_KEY_B64;
    const privB64 = process.env.ADMIN_PRIVATE_KEY_B64;

    if (!pubB64) throw new Error('ADMIN_PUBLIC_KEY_B64 must be set in .env');

    this.publicKey = Buffer.from(pubB64, 'base64').toString('utf8');
    this.privateKey = privB64 ? Buffer.from(privB64, 'base64').toString('utf8') : null;
  }

  encrypt(plaintext: string): string {
    const aesKey = crypto.randomBytes(32);
    const iv = crypto.randomBytes(IV_LENGTH);

    const cipher = crypto.createCipheriv(AES_ALGO, aesKey, iv);
    const ciphertext = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
    const tag = cipher.getAuthTag();

    // Seal the AES key with RSA-4096-OAEP-SHA256
    const sealedKey = crypto.publicEncrypt(
      { key: this.publicKey, padding: RSA_PADDING, oaepHash: 'sha256' },
      aesKey,
    );

    // sealedKey:iv:tag:ciphertext  (all base64, 4 segments)
    return [
      sealedKey.toString('base64'),
      iv.toString('base64'),
      tag.toString('base64'),
      ciphertext.toString('base64'),
    ].join(':');
  }

  decrypt(ciphertext: string): string {
    if (!this.privateKey) {
      throw new Error('ADMIN_PRIVATE_KEY_B64 is not set — decryption unavailable');
    }

    const parts = ciphertext.split(':');
    if (parts.length !== 4) throw new Error('Invalid ciphertext format');

    const [sealedKeyB64, ivB64, tagB64, dataB64] = parts;
    const sealedKey = Buffer.from(sealedKeyB64, 'base64');
    const iv = Buffer.from(ivB64, 'base64');
    const tag = Buffer.from(tagB64, 'base64');
    const data = Buffer.from(dataB64, 'base64');

    // Recover AES key using RSA private key
    const aesKey = crypto.privateDecrypt(
      { key: this.privateKey, padding: RSA_PADDING, oaepHash: 'sha256' },
      sealedKey,
    );

    const decipher = crypto.createDecipheriv(AES_ALGO, aesKey, iv);
    decipher.setAuthTag(tag);
    return decipher.update(data) + decipher.final('utf8');
  }

  encryptIfPresent(value: string | undefined | null): string | undefined {
    return value ? this.encrypt(value) : undefined;
  }

  decryptIfPresent(value: string | undefined | null): string | undefined {
    return value ? this.decrypt(value) : undefined;
  }
}
