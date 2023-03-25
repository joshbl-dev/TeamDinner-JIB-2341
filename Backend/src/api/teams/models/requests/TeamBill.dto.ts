import { ApiProperty } from "@nestjs/swagger";
import { IsPositive } from "class-validator";

export class TeamBillDto {
	@ApiProperty()
	@IsPositive()
	amount: number;
}
