import { VoteDto } from "../../api/polls/models/requests/Vote.dto";
import { ApiProperty } from "@nestjs/swagger";

export class Vote {
	@ApiProperty({ type: [String] })
	optionIds: string[];
	@ApiProperty()
	userId: string;

	static fromDto(dto: VoteDto): Vote {
		return {
			optionIds: dto.optionIds,
			userId: dto.userId
		};
	}
}
