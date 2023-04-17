import {
	ApiBadRequestResponse,
	ApiBearerAuth,
	ApiCreatedResponse,
	ApiForbiddenResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
	ApiOperation,
	ApiQuery,
	ApiTags,
	ApiUnauthorizedResponse
} from "@nestjs/swagger";
import { Body, Controller, Delete, Get, Post, Query } from "@nestjs/common";
import { TeamsService } from "../../domain/teams/teams.service";
import { Team } from "../../data/entities/Team";
import { TeamCreateDto } from "./models/requests/TeamCreate.dto";
import { TeamMemberModifyDto } from "./models/requests/TeamMemberModify.dto";
import { TeamInviteDto } from "./models/requests/TeamInvite.dto";
import { TeamModifyDto } from "./models/requests/TeamModify.dto";

@ApiBearerAuth("access-token")
@ApiTags("teams")
@Controller("teams")
export class TeamsController {
	constructor(private readonly teamsService: TeamsService) {}

	@ApiOperation({ summary: "Create a new team" })
	@ApiCreatedResponse({ description: "Team created", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Already on team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team" })
	@Post("create")
	async create(@Body() teamDTO: TeamCreateDto): Promise<Team> {
		return this.teamsService.create(teamDTO);
	}

	@ApiOperation({ summary: "Update a team" })
	@ApiCreatedResponse({ description: "Team updated", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Not owner of team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team" })
	@Post("update")
	async update(@Body() teamDTO: TeamModifyDto): Promise<Team> {
		return this.teamsService.update(teamDTO);
	}

	@ApiOperation({ summary: "Get all teams" })
	@ApiOkResponse({ description: "Teams found", type: [Team] })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@Get("all")
	async getAll(): Promise<Team[]> {
		return this.teamsService.getAll();
	}

	@ApiOperation({ summary: "Get a team by id" })
	@ApiQuery({ name: "id", required: true })
	@ApiOkResponse({ description: "Team found", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Get("")
	async get(@Query("id") id: string): Promise<Team> {
		return this.teamsService.get(id);
	}

	@ApiOperation({ summary: "Get a team by user id" })
	@ApiQuery({ name: "id", required: true })
	@ApiOkResponse({ description: "Team found", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Get("/members/")
	async getWithUserId(@Query("id") id: string): Promise<Team> {
		return this.teamsService.getWithUserId(id);
	}

	@ApiOperation({ summary: "Add a member to a team" })
	@ApiCreatedResponse({ description: "Member added", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "User already on team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("members/add")
	async addMember(@Body() teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		return this.teamsService.addMember(teamModifyDto);
	}

	@ApiOperation({ summary: "Remove a member from a team" })
	@ApiCreatedResponse({ description: "Member removed", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "User cannot be removed" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("members/remove")
	async removeMember(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.removeMember(teamModifyDto);
	}

	@ApiOperation({ summary: "Delete a team" })
	@ApiQuery({ name: "id", required: false })
	@ApiOkResponse({ description: "Team deleted", type: Boolean })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiForbiddenResponse({ description: "Not owner of team" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Delete()
	async delete(@Query("id") id?: string): Promise<boolean> {
		return this.teamsService.delete(id);
	}

	@ApiOperation({ summary: "Invite a member to a team" })
	@ApiCreatedResponse({ description: "Member invited", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("invites")
	async inviteMember(@Body() teamInviteDto: TeamInviteDto): Promise<Team> {
		return this.teamsService.inviteMember(teamInviteDto);
	}

	@ApiOperation({ summary: "Accept an invitation to a team" })
	@ApiCreatedResponse({ description: "Invitation accepted", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("invites/accept")
	async acceptInvitation(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.acceptInvite(teamModifyDto);
	}

	@ApiOperation({
		summary: "Reject an invitation to a team as owner or invitee"
	})
	@ApiCreatedResponse({ description: "Invitation rejected", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("invites/reject")
	async rejectInvitation(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.rejectInvite(teamModifyDto);
	}

	@ApiOperation({ summary: "Get all teams a user is invited to" })
	@ApiQuery({ name: "id", required: false })
	@ApiOkResponse({ description: "Teams found", type: [Team] })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Get("invites/member/")
	async getInvitesForUser(@Query("id") id?: string): Promise<Team[]> {
		return this.teamsService.getInvitesForUser(id);
	}

	@ApiOperation({ summary: "Deducts amount from member's team debt" })
	@ApiCreatedResponse({ description: "Debt paid", type: Team })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@ApiBadRequestResponse({ description: "Invalid team modification" })
	@Post("pay")
	async payDebt(
		@Body() teamMemberModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.payDebt(teamMemberModifyDto);
	}
}
