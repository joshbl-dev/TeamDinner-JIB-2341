import { Member } from "./Member";
import { ApiProperty } from "@nestjs/swagger";

export class Team {
	@ApiProperty()
	id: string;
	@ApiProperty()
	name: string;
	@ApiProperty()
	description: string;
	@ApiProperty()
	owner: string;
	@ApiProperty()
	members: Member[];
	@ApiProperty()
	invitations: string[];
}
