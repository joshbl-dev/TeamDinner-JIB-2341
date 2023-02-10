import {
	HttpException,
	HttpStatus,
	Injectable,
	UnauthorizedException
} from "@nestjs/common";
import { TeamsRepository } from "../../data/repositories/Firebase/teams.repository";
import { Team } from "../../data/entities/Team";
import { TeamCreateDto } from "../../api/teams/models/requests/teamCreate.dto";
import { uuid } from "../../utils/util";
import { TeamModifyDto } from "../../api/teams/models/requests/TeamModify.dto";
import { UsersService } from "../users/users.service";
import { AuthService } from "../auth/auth.service";

@Injectable()
export class TeamsService {
	constructor(
		private teamsRepository: TeamsRepository,
		private usersService: UsersService,
		private authService: AuthService
	) {}

	async create(teamDTO: TeamCreateDto): Promise<Team> {
		if (await this.authService.userIsInJWT(teamDTO.owner)) {
			const isOwner = await this.checkOwner(teamDTO.owner);
			if (!isOwner) {
				return await this.teamsRepository.createTeam({
					id: uuid(),
					members: [teamDTO.owner],
					...teamDTO
				});
			}
			throw new HttpException(
				"User is already owner of a team",
				HttpStatus.BAD_REQUEST
			);
		} else {
			throw new UnauthorizedException(
				"User is not authorized to create a team for this user"
			);
		}
	}

	async getAll(): Promise<Team[]> {
		return await this.teamsRepository.getTeams();
	}

	async get(id: string): Promise<Team> {
		const team = await this.teamsRepository.getTeam(id);
		if (team) {
			return team;
		} else {
			throw new HttpException("Team not found", HttpStatus.NOT_FOUND);
		}
	}

	async getWithUserId(id: string): Promise<Team> {
		const team = await this.teamsRepository.getTeamWithUserId(id);
		if (team) {
			return team;
		} else {
			throw new HttpException("Team not found", HttpStatus.NOT_FOUND);
		}
	}

	async addMember(teamModifyDto: TeamModifyDto): Promise<Team> {
		const team: Team = await this.get(teamModifyDto.teamId);
		if (await this.authService.userIsInJWT(team.owner)) {
			if (await this.usersService.exists(teamModifyDto.userId)) {
				if (await this.userOnTeam(teamModifyDto.userId)) {
					throw new HttpException(
						"User is already on a team",
						HttpStatus.BAD_REQUEST
					);
				}
				return await this.teamsRepository.addMember(
					teamModifyDto.teamId,
					teamModifyDto.userId
				);
			}
		}
	}

	async removeMember(teamModifyDto: TeamModifyDto): Promise<Team> {
		const team: Team = await this.get(teamModifyDto.teamId);
		if (
			(await this.authService.userIsInJWT(team.owner)) ||
			(await this.authService.userIsInJWT(teamModifyDto.userId))
		) {
			if (await this.checkOwner(teamModifyDto.userId)) {
				throw new HttpException(
					"User is owner of a team",
					HttpStatus.BAD_REQUEST
				);
			}

			if (await this.userOnTeam(teamModifyDto.userId)) {
				return await this.teamsRepository.removeMember(
					teamModifyDto.teamId,
					teamModifyDto.userId
				);
			}
			throw new HttpException(
				"User is not on this team",
				HttpStatus.BAD_REQUEST
			);
		}
	}

	async delete(id: string): Promise<boolean> {
		const team: Team = await this.get(id);
		if (await this.authService.userIsInJWT(team.owner)) {
			await this.teamsRepository.deleteTeam(id);
			return true;
		}
		throw new UnauthorizedException(
			"User is not authorized to delete this team"
		);
	}

	private async checkOwner(id: string): Promise<boolean> {
		return await this.teamsRepository.checkOwner(id);
	}

	private async userOnTeam(id: string): Promise<boolean> {
		return await this.teamsRepository.userOnTeam(id);
	}

	private async exists(id: string): Promise<boolean> {
		return (await this.get(id)) !== undefined;
	}
}
