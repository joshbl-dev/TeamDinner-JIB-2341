import { IsBoolean, IsDateString, IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class PollCreateDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	topic: string;
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	description: string;
	@ApiProperty()
	@IsDateString()
	time: Date;
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	location: string;
	@ApiProperty()
	@IsBoolean()
	isMultichoice: boolean;
	@ApiProperty()
	@IsString({ each: true })
	@IsNotEmpty({ each: true })
	options: string[];
}
