import { Poll_Option } from "./Poll_Option";
import { Vote } from "./Vote";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { uuid } from "../../utils/util";

export class Poll {
	id: string; // matches team ID
	topic: string;
	description: string;
	isMultichoice: boolean;
	options: Poll_Option[];
	votes: Vote[];

	static fromDto(dto: PollCreateDto, teamId: string): Poll {
		const options: Poll_Option[] = [];
		dto.options.forEach((option) =>
			options.push({
				id: uuid(),
				option: option
			})
		);
		return {
			id: teamId,
			topic: dto.topic,
			description: dto.description,
			isMultichoice: dto.isMultichoice,
			options: options,
			votes: []
		};
	}
}
