import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  // Implement your user service methods here
  async getAllProfile() {
    return this.prisma.profiles.findMany({
      where: {
        is_tutor: true,
      },
    });
  }
}
