import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getTutor() {
    console.log('this is new');
    console.log(this.prisma.profiles);
    console.log('--------------------------------');
    return this.prisma.profiles.findMany();
  }
}
