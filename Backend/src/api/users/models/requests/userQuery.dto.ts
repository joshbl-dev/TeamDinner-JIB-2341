import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UserQueryDTO {
  @ApiProperty()
  @IsString()
  username: string;
}
