import { IsOptional, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class TeamModifyDto {
	@ApiProperty()
	@IsString()
	@IsOptional()
	name?: string;
	@ApiProperty()
	@IsString()
	@IsOptional()
	description?: string;
}
