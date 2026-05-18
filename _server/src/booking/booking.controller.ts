import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Request,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { BookingService } from './booking.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { ReviewsService } from 'src/reviews/reviews.service';
import { CreateReviewDto } from 'src/reviews/dto/create-review.dto';

@UseGuards(AuthGuard('jwt'))
@Controller('booking')
export class BookingController {
  constructor(
    private readonly bookingService: BookingService,
    private readonly reviewsService: ReviewsService,
  ) {}

  // POST /booking — student creates a booking
  @Post()
  createBooking(@Request() req: any, @Body() dto: CreateBookingDto) {
    const userId = req.user.userId || req.user.sub;
    if (!userId) throw new UnauthorizedException('Missing user identity.');
    return this.bookingService.createBooking(userId, dto);
  }

  // GET /booking/student?status=pending — my bookings as a student
  @Get('student')
  getStudentBookings(@Request() req: any, @Query('status') status?: string) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.getStudentBookings(userId, status);
  }

  // GET /booking/tutor?status=confirmed — my bookings as a tutor
  @Get('tutor')
  getTutorBookings(@Request() req: any, @Query('status') status?: string) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.getTutorBookings(userId, status);
  }

  // GET /booking/:id — student or tutor fetches a single booking detail
  @Get(':id')
  getBookingById(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.getBookingById(id, userId);
  }

  // PATCH /booking/:id/cancel
  @Patch(':id/cancel')
  cancelBooking(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.cancelBooking(id, userId);
  }

  // PATCH /booking/:id/confirm — tutor confirms
  @Patch(':id/confirm')
  confirmBooking(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.confirmBooking(id, userId);
  }

  // PATCH /booking/:id/complete — tutor marks session done, releases coins to tutor
  @Patch(':id/complete')
  completeBooking(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.completeBooking(id, userId);
  }

  // PATCH /booking/:id/decline — tutor declines pending booking, refunds student
  @Patch(':id/decline')
  declineBooking(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId || req.user.sub;
    return this.bookingService.declineBooking(id, userId);
  }

  // POST /booking/:id/review — student submits review for completed booking
  @Post(':id/review')
  createReview(@Param('id') id: string, @Request() req: any, @Body() dto: CreateReviewDto) {
    const userId = req.user.userId || req.user.sub;
    return this.reviewsService.createReview(userId, dto, id);
  }
}
