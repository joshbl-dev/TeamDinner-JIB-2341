import { IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamModifyDto {
	@ApiProperty()
	@IsString()
	teamId: string;
	@ApiProperty()
	@IsString()
	userId: string;
}
