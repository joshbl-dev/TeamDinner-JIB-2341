import { IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamCreateDto {
	@ApiProperty()
	@IsString()
	teamName: string;
	@ApiProperty()
	@IsString()
	description: string;
}
