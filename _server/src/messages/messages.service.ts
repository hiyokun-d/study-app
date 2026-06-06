import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from 'src/generated/prisma/client';
import { PrismaService } from 'src/prisma.service';
import { SendMessageDto } from './dto/send-message.dto';

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const MSG_SELECT = {
  id: true,
  from_id: true,
  to_id: true,
  booking_id: true,
  content: true,
  metadata: true,
  message_type: true,
  attachment_url: true,
  is_read: true,
  read_at: true,
  created_at: true,
} as const;

@Injectable()
export class MessagesService {
  constructor(private prisma: PrismaService) {}

  async sendMessage(fromId: string, dto: SendMessageDto) {
    if (fromId === dto.to_id) {
      throw new BadRequestException('Cannot message yourself.');
    }
    if (!dto.content && !dto.attachment_url) {
      throw new BadRequestException('Message must have content or an attachment.');
    }

    const recipient = await this.prisma.profiles.findUnique({
      where: { id: dto.to_id },
      select: { id: true },
    });
    if (!recipient) throw new NotFoundException('Recipient not found.');

    return this.prisma.messages.create({
      data: {
        from_id: fromId,
        to_id: dto.to_id,
        booking_id: dto.booking_id ?? null,
        content: dto.content ?? '',
        metadata: dto.metadata ?? {},
        message_type: dto.message_type ?? 'TEXT',
        attachment_url: dto.attachment_url ?? null,
      },
      select: MSG_SELECT,
    });
  }

  // Optimized: 2 DB queries instead of N×3
  async getConversations(userId: string) {
    type RawRow = {
      id: string;
      from_id: string;
      to_id: string;
      content: string;
      is_read: boolean;
      read_at: Date | null;
      message_type: string;
      attachment_url: string | null;
      created_at: Date;
      partner_id: string;
      unread_count: number;
    };

    const rows = await this.prisma.$queryRaw<RawRow[]>(Prisma.sql`
      WITH last_msgs AS (
        SELECT DISTINCT ON (partner_id)
          id, from_id, to_id, content, is_read, read_at, message_type, attachment_url, created_at,
          CASE WHEN from_id = ${userId}::uuid THEN to_id ELSE from_id END AS partner_id
        FROM messages
        WHERE from_id = ${userId}::uuid OR to_id = ${userId}::uuid
        ORDER BY partner_id, created_at DESC
      ),
      unread AS (
        SELECT from_id AS partner_id, COUNT(*)::int AS cnt
        FROM messages
        WHERE to_id = ${userId}::uuid AND is_read = false
        GROUP BY from_id
      )
      SELECT lm.*, COALESCE(u.cnt, 0) AS unread_count
      FROM last_msgs lm
      LEFT JOIN unread u ON u.partner_id = lm.partner_id
      ORDER BY lm.created_at DESC
    `);

    if (rows.length === 0) return [];

    const partnerIds = rows.map((r) => r.partner_id);

    const partners = await this.prisma.profiles.findMany({
      where: { id: { in: partnerIds } },
      select: {
        id: true,
        full_name: true,
        username: true,
        avatar_url: true,
        user_status: true,
        role: true,
      },
    });

    const partnerMap = new Map(partners.map((p) => [p.id, p]));

    return rows.map((r) => ({
      partner: partnerMap.get(r.partner_id) ?? null,
      last_message: {
        id: r.id,
        from_id: r.from_id,
        to_id: r.to_id,
        content: r.content,
        message_type: r.message_type,
        attachment_url: r.attachment_url,
        is_read: r.is_read,
        read_at: r.read_at,
        created_at: r.created_at,
      },
      unread_count: Number(r.unread_count),
    }));
  }

  async getConversation(
    userId: string,
    partnerId: string,
    cursor?: string,
    limit = 30,
  ) {
    if (!UUID_RE.test(partnerId)) throw new BadRequestException('Invalid partner ID.');

    const partner = await this.prisma.profiles.findUnique({
      where: { id: partnerId },
      select: {
        id: true,
        full_name: true,
        username: true,
        avatar_url: true,
        user_status: true,
        last_seen_at: true,
      },
    });
    if (!partner) throw new NotFoundException('User not found.');

    const messages = await this.prisma.messages.findMany({
      where: {
        OR: [
          { from_id: userId, to_id: partnerId },
          { from_id: partnerId, to_id: userId },
        ],
        ...(cursor ? { created_at: { lt: new Date(cursor) } } : {}),
      },
      orderBy: { created_at: 'desc' },
      take: limit,
      select: MSG_SELECT,
    });

    return {
      partner,
      messages: messages.reverse(),
      next_cursor:
        messages.length === limit ? messages[0].created_at?.toISOString() : null,
    };
  }

  async markRead(userId: string, messageId: string) {
    const message = await this.prisma.messages.findUnique({
      where: { id: messageId },
    });
    if (!message) throw new NotFoundException('Message not found.');
    if (message.to_id !== userId) throw new ForbiddenException('Not your message.');

    await this.prisma.messages.update({
      where: { id: messageId },
      data: { is_read: true, read_at: new Date() },
    });
    return { message: 'Marked as read.' };
  }

  async markAllRead(userId: string, partnerId: string) {
    if (!UUID_RE.test(partnerId)) throw new BadRequestException('Invalid partner ID.');

    const { count } = await this.prisma.messages.updateMany({
      where: { from_id: partnerId, to_id: userId, is_read: false },
      data: { is_read: true, read_at: new Date() },
    });
    return { marked_count: count };
  }

  async getUnreadCount(userId: string) {
    const count = await this.prisma.messages.count({
      where: { to_id: userId, is_read: false },
    });
    return { count };
  }

  async reportMessage(userId: string, messageId: string, reason: string) {
    const message = await this.prisma.messages.findUnique({
      where: { id: messageId },
      select: { id: true, from_id: true, to_id: true, is_reported: true },
    });
    if (!message) throw new NotFoundException('Message not found.');
    if (message.to_id !== userId && message.from_id !== userId) {
      throw new ForbiddenException('You are not part of this conversation.');
    }
    if (message.is_reported) {
      throw new BadRequestException('Message already reported.');
    }
    if (!reason?.trim()) {
      throw new BadRequestException('Report reason is required.');
    }

    await this.prisma.messages.update({
      where: { id: messageId },
      data: { is_reported: true, report_reason: reason.trim() },
    });

    return { message: 'Message reported. Admin will review it.' };
  }
}
