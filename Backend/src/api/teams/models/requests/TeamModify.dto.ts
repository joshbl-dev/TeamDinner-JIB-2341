import { IsOptional, IsString } from "class-validator";
import { ApiPropertyOptional } from "@nestjs/swagger";

export class TeamModifyDto {
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	name?: string;
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	description?: string;
}
