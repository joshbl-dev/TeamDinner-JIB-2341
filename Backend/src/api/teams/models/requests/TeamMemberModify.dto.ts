import { IsNumber, IsOptional, IsString } from "class-validator";
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
	@IsNumber()
	@IsOptional()
	amount?: number;
}
