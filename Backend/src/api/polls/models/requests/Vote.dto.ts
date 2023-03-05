import { ApiProperty } from "@nestjs/swagger";
import { IsOptional, IsString } from "class-validator";

export class VoteDto {
	@ApiProperty()
	@IsString()
	@IsOptional()
	pollId?: string;
	@ApiProperty()
	@IsString()
	@IsOptional()
	userId?: string;
	@ApiProperty()
	@IsString({ each: true })
	optionIds: string[];
}
