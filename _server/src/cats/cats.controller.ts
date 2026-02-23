import { Controller, Get, Post } from '@nestjs/common';
let catTotal: number = 0;

@Controller('cats')
export class CatsController {
  @Post()
  addingNewCat(): number | string {
    return (catTotal += 2);
  }

  @Get()
  findAll(): string {
    return `this a cat action, HIDUP JOKOWI!, the total cat is: ${catTotal}`;
  }
}
