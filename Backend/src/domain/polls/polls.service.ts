import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { UsersService } from "../users/users.service";
import { AuthService } from "../auth/auth.service";
import { PollsRepository } from "../../data/repositories/Firebase/polls.repository";
import { TeamsService } from "../teams/teams.service";
import { Poll } from "../../data/entities/Poll";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { User } from "../../data/entities/User";
import { PollStageDto } from "../../api/polls/models/requests/PollStage.dto";

@Injectable()
export class PollsService {
	constructor(
		private pollsRepository: PollsRepository,
		private usersService: UsersService,
		private authService: AuthService,
		private teamsService: TeamsService
	) {}

	async createPoll(pollCreateDto: PollCreateDto): Promise<Poll> {
		const team = await this.teamsService.get();
		if (await this.isOwner()) {
			const poll = Poll.fromDto(pollCreateDto, team.id);
			return await this.pollsRepository.createPoll(poll);
		}
		throw new HttpException(
			"You are not the owner of this team",
			HttpStatus.FORBIDDEN
		);
	}

	async get(id?: string): Promise<Poll> {
		if (!id) {
			id = (await this.teamsService.get(id)).id;
		}
		const poll = await this.pollsRepository.get(id);
		if (poll) {
			return poll;
		}
		throw new HttpException("Poll not found", HttpStatus.NOT_FOUND);
	}

	async setStage(pollStageDto: PollStageDto): Promise<Poll> {
		const poll = await this.get(pollStageDto.pollId);
		if (await this.isOwner()) {
			return await this.pollsRepository.setStage(
				poll.id,
				pollStageDto.stage
			);
		}
		throw new HttpException(
			"Only the owner of the team can set the stage",
			HttpStatus.FORBIDDEN
		);
	}

	async isOwner(): Promise<boolean> {
		const user: User = await this.usersService.getWithToken();
		return await this.teamsService.isOwner(user.id);
	}
}
