import { IsEmail, IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamInviteDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	teamId: string;
	@ApiProperty()
	@IsEmail()
	@IsNotEmpty()
	email: string;
}
