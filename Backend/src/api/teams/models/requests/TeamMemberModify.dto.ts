import { IsOptional, IsPositive, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamMemberModifyDto {
	@ApiProperty()
	@IsString()
	teamId: string;
	@ApiProperty()
	@IsString()
	@IsOptional()
	userId?: string;
	@ApiProperty()
	@IsPositive()
	@IsOptional()
	amount?: number;
}
