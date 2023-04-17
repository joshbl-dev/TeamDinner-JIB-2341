import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsNotEmpty, IsOptional, IsString } from "class-validator";

export class VoteDto {
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	pollId?: string;
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	userId?: string;
	@ApiProperty()
	@IsString({ each: true })
	@IsNotEmpty({ each: true })
	optionIds: string[];
}
