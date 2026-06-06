import { Body, Controller, Get, Post, Request, ServiceUnavailableException, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CoinsService } from './coins.service';
import { WithdrawalRequestDto } from './dto/withdrawal-request.dto';

@Controller('coins')
export class CoinsController {
  constructor(private readonly coinsService: CoinsService) {}

  @Get('packages')
  getPackages() {
    return this.coinsService.getPackages();
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('balance')
  getBalance(@Request() req: any) {
    return this.coinsService.getBalance(req.user.userId || req.user.sub);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('history')
  getHistory(@Request() req: any) {
    return this.coinsService.getHistory(req.user.userId || req.user.sub);
  }

  // Payment gateway not integrated yet — re-enable when Midtrans is wired up
  @UseGuards(AuthGuard('jwt'))
  @Post('purchase')
  createOrder() {
    throw new ServiceUnavailableException('Payment gateway not yet available.');
  }

  @UseGuards(AuthGuard('jwt'))
  @Post('withdraw')
  requestWithdrawal(@Request() req: any, @Body() dto: WithdrawalRequestDto) {
    return this.coinsService.requestWithdrawal(req.user.userId || req.user.sub, dto);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('withdrawals')
  getWithdrawals(@Request() req: any) {
    return this.coinsService.getWithdrawals(req.user.userId || req.user.sub);
  }
}
