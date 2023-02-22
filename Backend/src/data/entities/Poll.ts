import { Poll_Option } from "./Poll_Option";
import { Vote } from "./Vote";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { uuid } from "../../utils/util";

export class Poll {
	id: string; // matches team ID
	topic: string;
	description: string;
	time: Date;
	location: string;
	isMultichoice: boolean;
	options: Poll_Option[];
	votes: Vote[];
	stage: PollStage;

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
			time: dto.time,
			location: dto.location,
			isMultichoice: dto.isMultichoice,
			options: options,
			votes: [],
			stage: PollStage.NOT_STARTED
		};
	}
}

export enum PollStage {
	NOT_STARTED = "NOT_STARTED",
	IN_PROGRESS = "IN_PROGRESS",
	FINISHED = "FINISHED"
}
