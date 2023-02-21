import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { UsersService } from "../users/users.service";
import { AuthService } from "../auth/auth.service";
import { PollsRepository } from "../../data/repositories/Firebase/polls.repository";
import { TeamsService } from "../teams/teams.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { User } from "../../data/entities/User";

@Injectable()
export class PollsService {
	constructor(
		private pollsRepository: PollsRepository,
		private usersService: UsersService,
		private authService: AuthService,
		private teamsService: TeamsService
	) {}

	async createPoll(pollCreateDto: PollCreateDto): Promise<Poll> {
		const user: User = await this.usersService.getWithToken();
		const team = await this.teamsService.getWithUserId(user.id);
		if (await this.teamsService.isOwner(user.id)) {
			const poll = Poll.fromDto(pollCreateDto, team.id);
			return await this.pollsRepository.createPoll(poll);
		}
		throw new HttpException(
			"You are not the owner of this team",
			HttpStatus.FORBIDDEN
		);
	}
}
