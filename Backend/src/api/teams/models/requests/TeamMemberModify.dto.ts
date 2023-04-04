import { IsNotEmpty, IsOptional, IsPositive, IsString } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class TeamMemberModifyDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	teamId: string;
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	userId?: string;
	@ApiPropertyOptional()
	@IsPositive()
	@IsOptional()
	amount?: number;
}
