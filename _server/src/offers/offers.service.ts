import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

const TUTOR_SELECT = {
  id: true,
  full_name: true,
  username: true,
  avatar_url: true,
  overall_rating: true,
  rating_count: true,
  verification_status: true,
  penalty_until: true,
  penalty_rating_knock: true,
  penalty_price_pct: true,
};

function applyTutorPenalty(tutor: any) {
  const now = new Date();
  const penalized = tutor.penalty_until && tutor.penalty_until > now;
  const { penalty_until, penalty_rating_knock, penalty_price_pct, ...rest } = tutor;
  if (!penalized) return rest;
  const knock = Number(penalty_rating_knock ?? 0);
  rest.overall_rating = Math.max(0, Number(rest.overall_rating) - knock);
  return rest;
}

function applyOfferPenalty(offer: any, tutor: any) {
  const now = new Date();
  const penalized = tutor.penalty_until && tutor.penalty_until > now;
  if (!penalized) return offer;
  const pct = Number(tutor.penalty_price_pct ?? 0);
  if (pct <= 0) return offer;
  const discountedRate = Math.ceil(offer.coins_per_hour * (1 - pct / 100));
  return { ...offer, coins_per_hour: discountedRate };
}

@Injectable()
export class OffersService {
  constructor(private prisma: PrismaService) {}

  async browseOffers(opts: {
    search?: string;
    subject?: string;
    maxCoins?: number;
    minRating?: number;
    page?: number;
    limit?: number;
  }) {
    const { search, subject, maxCoins, minRating, page = 1, limit = 20 } = opts;
    const skip = (page - 1) * limit;

    const where: any = {
      is_active: true,
      profiles: {
        verification_status: 'APPROVED',
        is_active: true,
        is_banned: false,
        ...(minRating && { overall_rating: { gte: minRating } }),
      },
      ...(search && {
        OR: [
          { title: { contains: search, mode: 'insensitive' } },
          { summary: { contains: search, mode: 'insensitive' } },
        ],
      }),
      ...(maxCoins && { coins_per_hour: { lte: maxCoins } }),
      ...(subject && { subject_ids: { has: subject } }),
    };

    const [raw, total] = await Promise.all([
      this.prisma.tutor_offers.findMany({
        where,
        skip,
        take: limit,
        orderBy: { created_at: 'desc' },
        select: {
          id: true,
          title: true,
          summary: true,
          thumbnail_url: true,
          coins_per_hour: true,
          duration_minutes: true,
          subject_ids: true,
          created_at: true,
          profiles: { select: TUTOR_SELECT },
        },
      }),
      this.prisma.tutor_offers.count({ where }),
    ]);

    const offers = raw.map((o) => {
      const adjustedOffer = applyOfferPenalty(o, o.profiles);
      const adjustedTutor = applyTutorPenalty(o.profiles);
      return {
        ...adjustedOffer,
        profiles: adjustedTutor,
        coins_per_session: Math.ceil((adjustedOffer.coins_per_hour * o.duration_minutes) / 60),
      };
    });

    return { data: offers, total, page, limit };
  }

  async getOfferDetail(offerId: string) {
    const offer = await this.prisma.tutor_offers.findFirst({
      where: { id: offerId, is_active: true, profiles: { is_active: true, is_banned: false } },
      select: {
        id: true,
        title: true,
        summary: true,
        about: true,
        thumbnail_url: true,
        coins_per_hour: true,
        duration_minutes: true,
        subject_ids: true,
        created_at: true,
        updated_at: true,
        profiles: {
          select: {
            ...TUTOR_SELECT,
            bio: true,
            subjects: true,
            book_price_coins: true,
          },
        },
      },
    });

    if (!offer) throw new NotFoundException('Offer not found.');

    // Recent reviews for this tutor
    const reviews = await this.prisma.reviews.findMany({
      where: { reviewee_id: offer.profiles.id },
      orderBy: { created_at: 'desc' },
      take: 5,
      select: {
        id: true,
        rating: true,
        comment: true,
        created_at: true,
        profiles_reviews_reviewer_idToprofiles: {
          select: { id: true, full_name: true, avatar_url: true },
        },
      },
    });

    const adjustedOffer = applyOfferPenalty(offer, offer.profiles);
    const adjustedTutor = applyTutorPenalty(offer.profiles);

    return {
      ...adjustedOffer,
      profiles: adjustedTutor,
      coins_per_session: Math.ceil((adjustedOffer.coins_per_hour * offer.duration_minutes) / 60),
      tutor_reviews: reviews,
    };
  }
}
