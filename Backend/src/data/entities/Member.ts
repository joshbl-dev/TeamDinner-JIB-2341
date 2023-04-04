import { ApiProperty } from "@nestjs/swagger";

export class Member {
	@ApiProperty()
	id: string;
	@ApiProperty()
	debt: number;
}
