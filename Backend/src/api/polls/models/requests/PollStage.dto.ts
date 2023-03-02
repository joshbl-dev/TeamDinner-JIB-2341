import { PollStage } from "../../../../data/entities/Poll";
import { ApiProperty } from "@nestjs/swagger";
import { IsEnum, IsOptional, IsString } from "class-validator";

export class PollStageDto {
	@ApiProperty()
	@IsString()
	@IsOptional()
	pollId?: string;
	@ApiProperty()
	@IsEnum(PollStage)
	stage: PollStage;
}
