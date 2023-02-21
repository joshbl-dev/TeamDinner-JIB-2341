import {
	ApiBearerAuth,
	ApiOperation,
	ApiQuery,
	ApiTags
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { PollsService } from "../../domain/polls/polls.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "./models/requests/PollCreate.dto";

@ApiBearerAuth("access-token")
@ApiTags("polls")
@Controller("polls")
export class PollsController {
	constructor(private readonly pollsService: PollsService) {}

	@ApiOperation({ summary: "Create a new poll for team" })
	@Post("create")
	async createPoll(@Body() pollCreateDto: PollCreateDto): Promise<Poll> {
		return await this.pollsService.createPoll(pollCreateDto);
	}

	@ApiOperation({ summary: "Get the current poll for team" })
	@ApiQuery({ name: "id", required: false })
	@Get("")
	async getPoll(@Query("id") id?: string): Promise<Poll> {
		return await this.pollsService.get(id);
	}
}
