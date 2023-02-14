import { IsEmail, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamInviteDto {
	@ApiProperty()
	@IsString()
	teamId: string;
	@ApiProperty()
	@IsEmail()
	email: string;
}
