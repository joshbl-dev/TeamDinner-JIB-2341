import { VoteDto } from "../../api/polls/models/requests/Vote.dto";

export class Vote {
	optionIds: string[];
	userId: string;

	static fromDto(dto: VoteDto): Vote {
		return {
			optionIds: dto.optionIds,
			userId: dto.userId
		};
	}
}
