import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamCreateDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	name: string;
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	description: string;
}
