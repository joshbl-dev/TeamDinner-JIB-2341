import { IsEmail, IsOptional, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class ModifyDto {
	@ApiProperty()
	@IsOptional()
	@IsString()
	firstName?: string;
	@ApiProperty()
	@IsOptional()
	@IsString()
	lastName?: string;
	@ApiProperty()
	@IsOptional()
	@IsString()
	password?: string;
	@ApiProperty()
	@IsOptional()
	@IsEmail()
	email?: string;
	@ApiProperty()
	@IsOptional()
	@IsString()
	venmo?: string;
}
