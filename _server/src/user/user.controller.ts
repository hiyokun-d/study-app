import { Controller, Get } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('profile')
  async getAllProfile() {
    return this.userService.getAllProfile();
  }

  @Get()
  async getDummyData() {
    return {
      message: 'This is a dummy response from the UserController.',
      timestamp: new Date(),
    };
  }
}
