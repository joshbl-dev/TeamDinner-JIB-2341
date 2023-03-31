import {
	ApiBearerAuth,
	ApiOperation,
	ApiQuery,
	ApiResponse,
	ApiTags
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { PollsService } from "../../domain/polls/polls.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "./models/requests/PollCreate.dto";
import { PollStageDto } from "./models/requests/PollStage.dto";
import { VoteDto } from "./models/requests/Vote.dto";
import { PollResultsDto } from "./models/responses/PollResults.dto";
import { TeamBillDto } from "../teams/models/requests/TeamBill.dto";

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

	@ApiOperation({ summary: "Set the current poll stage" })
	@Post("stage")
	async setPollStage(@Body() pollStageDto: PollStageDto): Promise<Poll> {
		return await this.pollsService.setStage(pollStageDto);
	}

	@ApiOperation({ summary: "Vote for a poll" })
	@Post("vote")
	async vote(@Body() voteDto: VoteDto): Promise<Poll> {
		return await this.pollsService.vote(voteDto);
	}

	@ApiOperation({ summary: "Get the results of a poll" })
	@ApiQuery({ name: "id", required: false })
	@ApiResponse({ status: 200, type: PollResultsDto })
	@Get("results")
	async getResults(@Query("id") id?: string): Promise<PollResultsDto> {
		return await this.pollsService.getResults(id);
	}

	@ApiOperation({ summary: "Split a bill between team members" })
	@Post("split")
	async splitBill(@Body() teamBillDto: TeamBillDto): Promise<void> {
		await this.pollsService.splitBill(teamBillDto);
	}
}
