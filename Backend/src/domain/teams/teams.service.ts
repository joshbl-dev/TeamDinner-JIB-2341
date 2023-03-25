import {
	HttpException,
	HttpStatus,
	Injectable,
	UnauthorizedException
} from "@nestjs/common";
import { TeamsRepository } from "../../data/repositories/Firebase/teams.repository";
import { Team } from "../../data/entities/Team";
import { TeamCreateDto } from "../../api/teams/models/requests/TeamCreate.dto";
import { uuid } from "../../utils/util";
import { TeamMemberModifyDto } from "../../api/teams/models/requests/TeamMemberModify.dto";
import { UsersService } from "../users/users.service";
import { AuthService } from "../auth/auth.service";
import { TeamInviteDto } from "../../api/teams/models/requests/TeamInvite.dto";
import { User } from "../../data/entities/User";
import { TeamModifyDto } from "../../api/teams/models/requests/TeamModify.dto";
import { Member } from "../../data/entities/Member";

@Injectable()
export class TeamsService {
	constructor(
		private teamsRepository: TeamsRepository,
		private usersService: UsersService,
		private authService: AuthService
	) {}

	async create(teamDTO: TeamCreateDto): Promise<Team> {
		const owner: User = await this.usersService.getWithToken();
		const isOwner = await this.isOwner(owner.id);
		if (!isOwner) {
			return await this.teamsRepository.createTeam({
				id: uuid(),
				members: [
					{
						id: owner.id,
						debt: 0
					}
				],
				owner: owner.id,
				name: teamDTO.name,
				description: teamDTO.description,
				invitations: []
			});
		}
		throw new HttpException(
			"User is already owner of a team",
			HttpStatus.BAD_REQUEST
		);
	}

	async update(teamDTO: TeamModifyDto): Promise<Team> {
		const owner: User = await this.usersService.getWithToken();
		const team: Team = await this.getWithUserId(owner.id);
		if (team.owner === owner.id) {
			for (let teamDTOKey in teamDTO) {
				if (!teamDTO[teamDTOKey]) {
					delete teamDTO[teamDTOKey];
				}
			}
			return await this.teamsRepository.updateTeam(team.id, teamDTO);
		}
		throw new HttpException(
			"User is not owner of the team",
			HttpStatus.BAD_REQUEST
		);
	}

	async getAll(): Promise<Team[]> {
		return await this.teamsRepository.getTeams();
	}

	async get(id?: string): Promise<Team> {
		if (!id) {
			return this.getWithUserId(null);
		}
		const team = await this.teamsRepository.getTeam(id);
		if (team) {
			return team;
		} else {
			throw new HttpException("Team not found", HttpStatus.NOT_FOUND);
		}
	}

	async getWithUserId(id?: string): Promise<Team> {
		if (!id) {
			const user: User = await this.usersService.getWithToken();
			id = user.id;
		}
		const team = await this.teamsRepository.getTeamWithUserId(id);
		if (team) {
			return team;
		} else {
			throw new HttpException("Team not found", HttpStatus.NOT_FOUND);
		}
	}

	async addMember(teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		const team: Team = await this.get(teamModifyDto.teamId);
		if (await this.authService.userIsInJWT(team.owner)) {
			if (await this.usersService.exists(teamModifyDto.userId)) {
				if (await this.isMember(teamModifyDto.userId)) {
					throw new HttpException(
						"User is already on a team",
						HttpStatus.BAD_REQUEST
					);
				}
				return await this.teamsRepository.addMember(
					teamModifyDto.teamId,
					{
						id: teamModifyDto.userId,
						debt: 0
					}
				);
			}
		}
	}

	async removeMember(teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		const team: Team = await this.get(teamModifyDto.teamId);
		if (!teamModifyDto.userId) {
			teamModifyDto.userId = (await this.usersService.getWithToken()).id;
		}
		if (
			(await this.authService.userIsInJWT(team.owner)) ||
			(await this.authService.userIsInJWT(teamModifyDto.userId))
		) {
			if (await this.isOwner(teamModifyDto.userId)) {
				throw new HttpException(
					"User is owner of a team",
					HttpStatus.BAD_REQUEST
				);
			}

			if (await this.isMember(teamModifyDto.userId)) {
				const member = team.members.filter(
					(member) => member.id == teamModifyDto.userId
				)[0];
				return await this.teamsRepository.removeMember(
					teamModifyDto.teamId,
					member
				);
			}
			throw new HttpException(
				"User is not on this team",
				HttpStatus.BAD_REQUEST
			);
		}
	}

	async delete(id?: string): Promise<boolean> {
		let team: Team;
		if (!id) {
			const owner: User = await this.usersService.getWithToken();
			team = await this.getWithUserId(owner.id);
		} else {
			team = await this.get(id);
		}
		if (await this.authService.userIsInJWT(team.owner)) {
			await this.teamsRepository.deleteTeam(team.id);
			return true;
		}
		throw new UnauthorizedException(
			"User is not authorized to delete this team"
		);
	}

	async inviteMember(teamInviteDto: TeamInviteDto): Promise<Team> {
		const team: Team = await this.get(teamInviteDto.teamId);
		if (await this.authService.userIsInJWT(team.owner)) {
			const user: User = await this.usersService.getWithEmail(
				teamInviteDto.email
			);

			if (await this.isMember(user.id)) {
				throw new HttpException(
					"User is already on a team",
					HttpStatus.BAD_REQUEST
				);
			}
			return await this.teamsRepository.inviteMember(
				teamInviteDto.teamId,
				user.id
			);
		}
	}

	async acceptInvite(teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		if (await this.exists(teamModifyDto.teamId)) {
			if (await this.authService.userIsInJWT(teamModifyDto.userId)) {
				if (await this.isMember(teamModifyDto.userId)) {
					throw new HttpException(
						"User is already on a team",
						HttpStatus.BAD_REQUEST
					);
				}
				return await this.teamsRepository.acceptInvite(
					teamModifyDto.teamId,
					teamModifyDto.userId
				);
			}
		}
	}

	async rejectInvite(teamModifyDto: TeamMemberModifyDto): Promise<Team> {
		const team: Team = await this.get(teamModifyDto.teamId);
		if (
			(await this.authService.userIsInJWT(teamModifyDto.userId)) ||
			(await this.authService.userIsInJWT(team.owner))
		) {
			return await this.teamsRepository.rejectInvite(
				teamModifyDto.teamId,
				teamModifyDto.userId
			);
		}
	}

	async updateMember(teamId: string, member: Member): Promise<Team> {
		return await this.teamsRepository.updateMember(teamId, member);
	}

	async payDebt(teamMemberModifyDto: TeamMemberModifyDto): Promise<Team> {
		const team: Team = await this.get();
		const member = team.members.filter(
			(member) => member.id == teamMemberModifyDto.userId
		)[0];
		member.debt -= teamMemberModifyDto.amount;
		return await this.teamsRepository.updateMember(team.id, member);
	}

	async getInvitesForUser(id?: string): Promise<Team[]> {
		if (!id) {
			const user: User = await this.usersService.getWithToken();
			id = user.id;
		}
		return await this.teamsRepository.getInvitesForUser(id);
	}

	public async isOwner(userId: string): Promise<boolean> {
		return await this.teamsRepository.checkOwner(userId);
	}

	public async userIsOwnerOfTeam(
		id: string,
		userId: string
	): Promise<boolean> {
		const team: Team = await this.get(id);
		return team.owner === userId;
	}

	public async userIsMemberOfTeam(
		id: string,
		userId: string
	): Promise<boolean> {
		const team: Team = await this.get(id);
		return team.members.map((member) => member.id).includes(userId);
	}

	private async isMember(id: string): Promise<boolean> {
		return await this.teamsRepository.isMember(id);
	}

	private async exists(id: string): Promise<boolean> {
		return (await this.get(id)) !== undefined;
	}
}
