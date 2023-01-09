import { ArrayNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class TeamQueryDTO {
  @ApiProperty()
  @IsString()
  teamName: string;
  @ApiProperty()
  @ArrayNotEmpty()
  user_ids: string[];
}
