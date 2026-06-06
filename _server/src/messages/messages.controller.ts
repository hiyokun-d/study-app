import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { IsString, MinLength } from 'class-validator';
import { MessagesService } from './messages.service';
import { SendMessageDto } from './dto/send-message.dto';

class ReportMessageDto {
  @IsString()
  @MinLength(5)
  reason: string;
}

@UseGuards(AuthGuard('jwt'))
@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  // POST /messages — send a message
  @Post()
  sendMessage(@Request() req: any, @Body() dto: SendMessageDto) {
    return this.messagesService.sendMessage(req.user.userId || req.user.sub, dto);
  }

  // GET /messages/unread-count — total unread across all conversations
  @Get('unread-count')
  getUnreadCount(@Request() req: any) {
    return this.messagesService.getUnreadCount(req.user.userId || req.user.sub);
  }

  // GET /messages/conversations — inbox: all threads with last message + unread count
  @Get('conversations')
  getConversations(@Request() req: any) {
    return this.messagesService.getConversations(req.user.userId || req.user.sub);
  }

  // GET /messages/conversation/:userId?cursor=&limit= — paginated history with one user
  @Get('conversation/:userId')
  getConversation(
    @Param('userId') partnerId: string,
    @Request() req: any,
    @Query('cursor') cursor?: string,
    @Query('limit') limit?: string,
  ) {
    return this.messagesService.getConversation(
      req.user.userId || req.user.sub,
      partnerId,
      cursor,
      limit ? parseInt(limit, 10) : 30,
    );
  }

  // PATCH /messages/conversation/:userId/read-all — mark all unread from that user as read
  @Patch('conversation/:userId/read-all')
  markAllRead(@Param('userId') partnerId: string, @Request() req: any) {
    return this.messagesService.markAllRead(
      req.user.userId || req.user.sub,
      partnerId,
    );
  }

  // PATCH /messages/:id/read — mark single message read
  @Patch(':id/read')
  markRead(@Param('id') id: string, @Request() req: any) {
    return this.messagesService.markRead(req.user.userId || req.user.sub, id);
  }

  // POST /messages/:id/report — report a message for admin review
  @Post(':id/report')
  reportMessage(
    @Param('id') id: string,
    @Request() req: any,
    @Body() dto: ReportMessageDto,
  ) {
    return this.messagesService.reportMessage(
      req.user.userId || req.user.sub,
      id,
      dto.reason,
    );
  }
}
