import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional } from "class-validator";

export class User {
	@ApiProperty()
	id: string;
	@ApiProperty()
	@IsOptional()
	firstName?: string;
	@ApiPropertyOptional()
	lastName?: string;
	@ApiPropertyOptional({ type: [String] })
	teams?: string[];
	@ApiPropertyOptional()
	venmo?: string;
	@ApiPropertyOptional()
	tips?: number;
}
