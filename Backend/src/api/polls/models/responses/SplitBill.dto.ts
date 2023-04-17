import { ApiProperty } from "@nestjs/swagger";

export class SplitBillDto {
	@ApiProperty()
	tip: number;
}
