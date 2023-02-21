import { IsBoolean, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class PollCreateDto {
	@ApiProperty()
	@IsString()
	topic: string;
	@ApiProperty()
	@IsString()
	description: string;
	@ApiProperty()
	@IsBoolean()
	isMultichoice: boolean;
	@ApiProperty()
	@IsString({ each: true })
	options: string[];
}
