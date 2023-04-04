import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class Auth {
	@ApiProperty()
	id: string;
	@ApiProperty()
	email: string;
	@ApiPropertyOptional()
	password?: string;
	@ApiPropertyOptional()
	isAdmin?: boolean;
}
