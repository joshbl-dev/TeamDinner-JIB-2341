import { ApiProperty } from "@nestjs/swagger";

export class Poll_Option {
	@ApiProperty()
	id: string;
	@ApiProperty()
	option: string;
}
