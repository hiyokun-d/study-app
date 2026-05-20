import { Module } from '@nestjs/common';
import { BookingController } from './booking.controller';
import { BookingService } from './booking.service';
import { ReviewsModule } from 'src/reviews/reviews.module';

@Module({
  imports: [ReviewsModule],
  controllers: [BookingController],
  providers: [BookingService],
})
export class BookingModule {}
