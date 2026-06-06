import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { COIN_PACKAGES, COIN_TO_IDR } from './dto/create-payment-order.dto';
import { WithdrawalRequestDto } from './dto/withdrawal-request.dto';

@Injectable()
export class CoinsService {
  constructor(private prisma: PrismaService) {}

  getPackages() {
    return COIN_PACKAGES.map((p) => ({
      ...p,
      currency: 'IDR',
      label: `${p.coins} coins — Rp ${p.fiat.toLocaleString('id-ID')}`,
    }));
  }

  async getBalance(userId: string) {
    const user = await this.prisma.profiles.findUnique({
      where: { id: userId },
      select: { coins_balance: true },
    });
    if (!user) throw new NotFoundException('User not found.');
    return { coins_balance: user.coins_balance };
  }

  async getHistory(userId: string) {
    return this.prisma.coin_transactions.findMany({
      where: { profile_id: userId },
      orderBy: { created_at: 'desc' },
      take: 50,
    });
  }

  async fulfillOrder(orderId: string) {
    const order = await this.prisma.payment_orders.findUnique({
      where: { id: orderId },
    });

    if (!order) throw new NotFoundException('Payment order not found.');
    if (order.status === 'COMPLETED') {
      return { message: 'Order already fulfilled.' };
    }

    await this.prisma.$transaction([
      this.prisma.payment_orders.update({
        where: { id: orderId },
        data: { status: 'COMPLETED', updated_at: new Date() },
      }),
      this.prisma.profiles.update({
        where: { id: order.profile_id },
        data: { coins_balance: { increment: order.coins_amount } },
      }),
      this.prisma.coin_transactions.create({
        data: {
          profile_id: order.profile_id,
          amount: order.coins_amount,
          kind: 'PURCHASE',
          ref_id: orderId,
          note: `Purchased via QRIS (Rp ${Number(order.fiat_amount).toLocaleString('id-ID')})`,
        },
      }),
    ]);

    return { message: 'Order fulfilled.', coins_added: order.coins_amount };
  }

  async requestWithdrawal(tutorId: string, dto: WithdrawalRequestDto) {
    const profile = await this.prisma.profiles.findUnique({
      where: { id: tutorId },
      select: { coins_balance: true, role: true },
    });

    if (!profile) throw new NotFoundException('User not found.');
    if (profile.role !== 'TUTOR') {
      throw new BadRequestException('Only tutors can request withdrawals.');
    }
    if (profile.coins_balance < dto.coins_amount) {
      throw new BadRequestException(
        `Insufficient balance. Have ${profile.coins_balance} coins, need ${dto.coins_amount}.`,
      );
    }

    const idrAmount = dto.coins_amount * COIN_TO_IDR;

    const [withdrawal] = await this.prisma.$transaction([
      this.prisma.withdrawal_requests.create({
        data: {
          tutor_id: tutorId,
          coins_amount: dto.coins_amount,
          idr_amount: idrAmount,
          status: 'PENDING',
          account_name: dto.account_name,
          account_number: dto.account_number,
          payment_method: dto.payment_method ?? 'QRIS',
          bank_name: dto.bank_name,
        },
      }),
      this.prisma.profiles.update({
        where: { id: tutorId },
        data: { coins_balance: { decrement: dto.coins_amount } },
      }),
      this.prisma.coin_transactions.create({
        data: {
          profile_id: tutorId,
          amount: -dto.coins_amount,
          kind: 'WITHDRAWAL',
          note: `Withdrawal request submitted — Rp ${idrAmount.toLocaleString('id-ID')}`,
        },
      }),
    ]);

    return {
      withdrawal_id: withdrawal.id,
      coins_amount: dto.coins_amount,
      idr_amount: idrAmount,
      status: 'PENDING',
      message: 'Withdrawal request submitted. Admin will process within 1-3 business days.',
    };
  }

  async getWithdrawals(tutorId: string) {
    return this.prisma.withdrawal_requests.findMany({
      where: { tutor_id: tutorId },
      orderBy: { created_at: 'desc' },
      take: 50,
    });
  }
}
