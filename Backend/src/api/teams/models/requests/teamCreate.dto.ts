import { IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamCreateDto {
	@ApiProperty()
	@IsString()
	name: string;
	@ApiProperty()
	@IsString()
	description: string;
}
