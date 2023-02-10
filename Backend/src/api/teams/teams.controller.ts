import { ApiBearerAuth, ApiQuery, ApiTags } from "@nestjs/swagger";
import { Body, Controller, Delete, Get, Post, Query } from "@nestjs/common";
import { TeamsService } from "../../domain/teams/teams.service";
import { Team } from "../../data/entities/Team";
import { TeamCreateDto } from "./models/requests/teamCreate.dto";
import { TeamModifyDto } from "./models/requests/TeamModify.dto";

@ApiBearerAuth("access-token")
@ApiTags("teams")
@Controller("teams")
export class TeamsController {
	constructor(private readonly teamsService: TeamsService) {}

	@Post("create")
	async create(@Body() teamDTO: TeamCreateDto): Promise<Team> {
		return this.teamsService.create(teamDTO);
	}

	@Get("all")
	async getAll(): Promise<Team[]> {
		return this.teamsService.getAll();
	}

	@ApiQuery({ name: "id", required: true })
	@Get(":id")
	async get(@Query("id") id: string): Promise<Team> {
		return this.teamsService.get(id);
	}

	@ApiQuery({ name: "userId", required: true })
	@Get("/members/:userId")
	async getWithUserId(@Query("userId") id: string): Promise<Team> {
		return this.teamsService.getWithUserId(id);
	}

	@Post("members/add")
	async addMember(@Body() teamModifyDto: TeamModifyDto): Promise<Team> {
		return this.teamsService.addMember(teamModifyDto);
	}

	@Post("members/remove")
	async removeMember(@Body() teamModifyDto: TeamModifyDto): Promise<Team> {
		return this.teamsService.removeMember(teamModifyDto);
	}

	@ApiQuery({ name: "id", required: true })
	@Delete()
	async delete(@Query("id") id: string): Promise<boolean> {
		return this.teamsService.delete(id);
	}
}
