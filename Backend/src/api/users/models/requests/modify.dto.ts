import { IsEmail, IsOptional, IsString, Min } from "class-validator";
import { ApiPropertyOptional } from "@nestjs/swagger";

export class ModifyDto {
	@ApiPropertyOptional()
	@IsOptional()
	@IsString()
	firstName?: string;
	@ApiPropertyOptional()
	@IsOptional()
	@IsString()
	lastName?: string;
	@ApiPropertyOptional()
	@IsOptional()
	@IsString()
	password?: string;
	@ApiPropertyOptional()
	@IsOptional()
	@IsEmail()
	email?: string;
	@ApiPropertyOptional()
	@IsOptional()
	@IsString()
	venmo?: string;
	@ApiPropertyOptional()
	@IsOptional()
	@Min(0)
	tipAmount?: number;
}
