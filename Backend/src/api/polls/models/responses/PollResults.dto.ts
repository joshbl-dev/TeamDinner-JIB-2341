import { Poll } from "../../../../data/entities/Poll";
import { ApiProperty } from "@nestjs/swagger";
import { IsObject } from "class-validator";

export class PollResultsDto {
	@ApiProperty()
	id: string;
	@ApiProperty({
		example: { optionId: "voteCount" }
	})
	@IsObject()
	results: { [key: string]: number };

	static fromPoll(poll: Poll): PollResultsDto {
		const results = {};
		poll.votes.forEach((vote) => {
			vote.optionIds.forEach((optionId) => {
				if (results[optionId]) {
					results[optionId] += 1;
				} else {
					results[optionId] = 1;
				}
			});
		});

		return {
			id: poll.id,
			results: results
		};
	}
}
