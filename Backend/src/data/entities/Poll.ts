import { Poll_Option } from "./Poll_Option";
import { Vote } from "./Vote";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { uuid } from "../../utils/util";
import { ApiProperty } from "@nestjs/swagger";

export enum PollStage {
	NOT_STARTED = "NOT_STARTED",
	IN_PROGRESS = "IN_PROGRESS",
	FINISHED = "FINISHED"
}

export class Poll {
	@ApiProperty()
	id: string; // matches team ID
	@ApiProperty()
	topic: string;
	@ApiProperty()
	description: string;
	@ApiProperty()
	time: Date;
	@ApiProperty()
	location: string;
	@ApiProperty()
	isMultichoice: boolean;
	@ApiProperty({ type: () => [Poll_Option] })
	options: Poll_Option[];
	@ApiProperty({ type: () => [Vote] })
	votes: Vote[];
	@ApiProperty({ enum: PollStage })
	stage: PollStage;

	static fromDto(dto: PollCreateDto, teamId: string): Poll {
		const options: Poll_Option[] = [];
		dto.options.forEach((option) =>
			options.push({
				id: uuid(),
				option: option
			})
		);
		options.push({
			id: "-1",
			option: "Opt Out"
		});
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
