import { IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamMemberModifyDto {
	@ApiProperty()
	@IsString()
	teamId: string;
	@ApiProperty()
	@IsString()
	userId?: string;
}
