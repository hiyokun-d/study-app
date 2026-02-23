import { Controller, Get } from '@nestjs/common';

@Controller('dogs')
export class DogsController {
  @Get()
  CheckingTheDog(): string {
    return "there's a dog here";
  }
}
