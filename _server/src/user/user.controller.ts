import { Controller, Get } from '@nestjs/common';

@Controller('user')
export class UserController {
  @Get()
  GetUserInformation(): object {
    return {
      id: 1,
      firstname: 'Marjory',
      lastname: 'Ebert',
      email: 'lfriesen@leffler.com',
      phone: '+14782104859',
      birthday: '2006-06-06',
      gender: 'female',
      address: {
        id: 1,
        street: '441 King Camp',
        streetName: 'Carson Courts',
        buildingNumber: '8474',
        city: 'Bashirianberg',
        zipcode: '63301',
        country: 'Côte d’Ivoire',
        country_code: 'CI',
        latitude: -85.815784,
        longitude: -10.396145,
      },
      website: 'http://kunze.com',
      image: 'http://placeimg.com/640/480/people',
    };
  }

  @Get('simple')
  UserInformationInSimple(): object {
    return {
      id: 1,
      firstname: 'Marjory',
      lastname: 'Ebert',
      email: 'lfriesen@leffler.com',
      phone: '+14782104859',
      birthday: '2006-06-06',
      gender: 'female',
    };
  }
}
