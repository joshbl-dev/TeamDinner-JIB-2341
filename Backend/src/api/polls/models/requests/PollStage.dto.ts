import { PollStage } from "../../../../data/entities/Poll";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsEnum, IsOptional, IsString } from "class-validator";

export class PollStageDto {
	@ApiPropertyOptional()
	@IsString()
	@IsOptional()
	pollId?: string;
	@ApiProperty({ enum: PollStage })
	@IsEnum(PollStage)
	stage: PollStage;
}
