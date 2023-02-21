import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { Body, Controller, Post } from "@nestjs/common";
import { PollsService } from "../../domain/polls/polls.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "./models/requests/PollCreate.dto";

@ApiBearerAuth("access-token")
@ApiTags("polls")
@Controller("polls")
export class PollsController {
	constructor(private readonly pollsService: PollsService) {}

	@Post("create")
	async createPoll(@Body() pollCreateDto: PollCreateDto): Promise<Poll> {
		return await this.pollsService.createPoll(pollCreateDto);
	}
}
