import {
	ApiBadRequestResponse,
	ApiBearerAuth,
	ApiForbiddenResponse,
	ApiNotFoundResponse,
	ApiOperation,
	ApiQuery,
	ApiResponse,
	ApiTags,
	ApiUnauthorizedResponse
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { PollsService } from "../../domain/polls/polls.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "./models/requests/PollCreate.dto";
import { PollStageDto } from "./models/requests/PollStage.dto";
import { VoteDto } from "./models/requests/Vote.dto";
import { PollResultsDto } from "./models/responses/PollResults.dto";
import { TeamBillDto } from "../teams/models/requests/TeamBill.dto";
import { SplitBillDto } from "./models/responses/SplitBill.dto";

@ApiBearerAuth("access-token")
@ApiTags("polls")
@Controller("polls")
export class PollsController {
	constructor(private readonly pollsService: PollsService) {}

	@ApiOperation({ summary: "Create a new poll for team" })
	@ApiResponse({ status: 201, type: Poll })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Not owner of team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid poll" })
	@Post("create")
	async createPoll(@Body() pollCreateDto: PollCreateDto): Promise<Poll> {
		return await this.pollsService.createPoll(pollCreateDto);
	}

	@ApiOperation({ summary: "Get the current poll for team" })
	@ApiResponse({ status: 200, type: Poll })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiQuery({ name: "id", required: false })
	@Get("")
	async getPoll(@Query("id") id?: string): Promise<Poll> {
		return await this.pollsService.get(id);
	}

	@ApiOperation({ summary: "Set the current poll stage" })
	@ApiResponse({ status: 201, type: Poll })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Not owner of team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid poll stage" })
	@Post("stage")
	async setPollStage(@Body() pollStageDto: PollStageDto): Promise<Poll> {
		return await this.pollsService.setStage(pollStageDto);
	}

	@ApiOperation({ summary: "Vote for a poll" })
	@ApiResponse({ status: 201, type: Poll })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid poll vote" })
	@Post("vote")
	async vote(@Body() voteDto: VoteDto): Promise<Poll> {
		return await this.pollsService.vote(voteDto);
	}

	@ApiOperation({ summary: "Get the results of a poll" })
	@ApiQuery({ name: "id", required: false })
	@ApiResponse({ status: 200, type: PollResultsDto })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Get("results")
	async getResults(@Query("id") id?: string): Promise<PollResultsDto> {
		return await this.pollsService.getResults(id);
	}

	@ApiOperation({
		summary: "Split a bill between team members and get tip amount"
	})
	@ApiResponse({ status: 200, type: SplitBillDto })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Not owner of team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid bill" })
	@Post("split")
	async splitBill(@Body() teamBillDto: TeamBillDto): Promise<SplitBillDto> {
		return await this.pollsService.splitBill(teamBillDto);
	}
}
