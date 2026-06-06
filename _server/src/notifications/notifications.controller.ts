import { Controller, Get, Param, ParseUUIDPipe, Patch, Query, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { NotificationsService } from './notifications.service';

@UseGuards(AuthGuard('jwt'))
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  // GET /notifications?page=1&limit=20
  @Get()
  getMyNotifications(
    @Request() req: any,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.notificationsService.getMyNotifications(
      req.user.userId || req.user.sub,
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  // GET /notifications/unseen-count
  @Get('unseen-count')
  getUnseenCount(@Request() req: any) {
    return this.notificationsService.getUnseenCount(req.user.userId || req.user.sub);
  }

  // PATCH /notifications/seen-all
  @Patch('seen-all')
  markAllSeen(@Request() req: any) {
    return this.notificationsService.markAllSeen(req.user.userId || req.user.sub);
  }

  // PATCH /notifications/:id/seen
  @Patch(':id/seen')
  markSeen(@Request() req: any, @Param('id', ParseUUIDPipe) id: string) {
    return this.notificationsService.markSeen(req.user.userId || req.user.sub, id);
  }
}
