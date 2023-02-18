import {
	ApiBearerAuth,
	ApiOperation,
	ApiQuery,
	ApiTags
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
	@Post("create")
	async create(@Body() teamDTO: TeamCreateDto): Promise<Team> {
		return this.teamsService.create(teamDTO);
	}

	@ApiOperation({ summary: "Update a team" })
	@Post("update")
	async update(@Body() teamDTO: TeamModifyDto): Promise<Team> {
		return this.teamsService.update(teamDTO);
	}

	@ApiOperation({ summary: "Get all teams" })
	@Get("all")
	async getAll(): Promise<Team[]> {
		return this.teamsService.getAll();
	}

	@ApiOperation({ summary: "Get a team by id" })
	@ApiQuery({ name: "id", required: true })
	@Get("")
	async get(@Query("id") id: string): Promise<Team> {
		return this.teamsService.get(id);
	}

	@ApiOperation({ summary: "Get a team by user id" })
	@ApiQuery({ name: "id", required: true })
	@Get("/members/")
	async getWithUserId(@Query("id") id: string): Promise<Team> {
		return this.teamsService.getWithUserId(id);
	}

	@ApiOperation({ summary: "Add a member to a team" })
	@Post("members/add")
	async addMember(@Body() teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		return this.teamsService.addMember(teamModifyDto);
	}

	@ApiOperation({ summary: "Remove a member from a team" })
	@Post("members/remove")
	async removeMember(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.removeMember(teamModifyDto);
	}

	@ApiOperation({ summary: "Delete a team" })
	@ApiQuery({ name: "id", required: false })
	@Delete()
	async delete(@Query("id") id?: string): Promise<boolean> {
		return this.teamsService.delete(id);
	}

	@ApiOperation({ summary: "Invite a member to a team" })
	@Post("invites")
	async inviteMember(@Body() teamInviteDto: TeamInviteDto): Promise<Team> {
		return this.teamsService.inviteMember(teamInviteDto);
	}

	@ApiOperation({ summary: "Accept an invitation to a team" })
	@Post("invites/accept")
	async acceptInvitation(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.acceptInvite(teamModifyDto);
	}

	@ApiOperation({
		summary: "Reject an invitation to a team as owner or invitee"
	})
	@Post("invites/reject")
	async rejectInvitation(
		@Body() teamModifyDto: TeamMemberModifyDto
	): Promise<Team> {
		return this.teamsService.rejectInvite(teamModifyDto);
	}

	@ApiOperation({ summary: "Get all teams a user is invited to" })
	@ApiQuery({ name: "id", required: true })
	@Get("invites/member/")
	async getInvitesForUser(@Query("id") id: string): Promise<Team[]> {
		return this.teamsService.getInvitesForUser(id);
	}
}
