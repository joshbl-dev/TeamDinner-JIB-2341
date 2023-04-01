import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { UsersService } from "../users/users.service";
import { AuthService } from "../auth/auth.service";
import { PollsRepository } from "../../data/repositories/Firebase/polls.repository";
import { TeamsService } from "../teams/teams.service";
import { Poll, PollStage } from "../../data/entities/Poll";
import { PollCreateDto } from "../../api/polls/models/requests/PollCreate.dto";
import { User } from "../../data/entities/User";
import { PollStageDto } from "../../api/polls/models/requests/PollStage.dto";
import { VoteDto } from "../../api/polls/models/requests/Vote.dto";
import { Vote } from "../../data/entities/Vote";
import { PollResultsDto } from "../../api/polls/models/responses/PollResults.dto";
import { TeamBillDto } from "../../api/teams/models/requests/TeamBill.dto";
import { Team } from "../../data/entities/Team";

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

	async getResults(id?: string): Promise<PollResultsDto> {
		const poll: any = await this.get(id);
		return PollResultsDto.fromPoll(poll);
	}

	async splitBill(teamBillDto: TeamBillDto): Promise<void> {
		const team: Team = await this.teamsService.get();
		const optOuts = await this.getOptOuts(team.id);
		const split = teamBillDto.amount / (team.members.length - optOuts);
		for (const member of team.members) {
			if (await this.isOptedOut(member.id)) {
				continue;
			}
			const user: User = await this.usersService.get(member.id);
			member.debt += split * (1 + user.tips ? user.tips : 0);
			await this.teamsService.updateMember(team.id, member);
		}
	}

	async getOptOuts(id?: string): Promise<number> {
		const poll = await this.get(id);
		let optOuts = 0;
		poll.votes.forEach((vote: Vote) => {
			if (vote.optionIds.includes("-1")) {
				optOuts++;
			}
		});

		return optOuts;
	}

	async isOptedOut(userId?: string): Promise<boolean> {
		const poll = await this.get();
		const vote = poll.votes.find((vote: Vote) => vote.userId == userId);
		return vote && vote.optionIds.includes("-1");
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

	async vote(voteDto: VoteDto): Promise<Poll> {
		const user: User = await this.usersService.get(voteDto.userId);
		voteDto.userId = user.id;
		const poll = await this.get(voteDto.pollId);
		if (await this.isInProgress(poll)) {
			if (this.optionsAreInPoll(poll, voteDto.optionIds)) {
				if (await this.isMember(poll.id, voteDto.userId)) {
					if (await this.hasVoted(poll, voteDto.userId)) {
						const currentVote = poll.votes.find(
							(v) => v.userId == voteDto.userId
						);
						await this.pollsRepository.removeVote(
							poll.id,
							currentVote
						);
					}
					return await this.pollsRepository.vote(
						poll.id,
						Vote.fromDto(voteDto)
					);
				}
				throw new HttpException(
					"You are not a member of this team",
					HttpStatus.FORBIDDEN
				);
			}
			throw new HttpException(
				"All options must be part of poll options",
				HttpStatus.FORBIDDEN
			);
		}
		throw new HttpException(
			"The poll is not in progress",
			HttpStatus.FORBIDDEN
		);
	}

	optionsAreInPoll(poll: Poll, optionIds: string[]): boolean {
		if (!poll.isMultichoice && optionIds.length > 1) {
			throw new HttpException(
				"Poll is not multichoice, only one option can be selected",
				HttpStatus.FORBIDDEN
			);
		}
		return optionIds.every((optionId) =>
			poll.options.some((option) => option.id == optionId)
		);
	}

	async isInProgress(poll: Poll): Promise<boolean> {
		if (new Date(poll.time).getTime() > Date.now()) {
			await this.pollsRepository.setStage(poll.id, PollStage.FINISHED);
			throw new HttpException(
				"The poll has expired",
				HttpStatus.FORBIDDEN
			);
		}
		return poll.stage == PollStage.IN_PROGRESS;
	}

	async hasVoted(poll: Poll, userId: string): Promise<boolean> {
		return poll.votes.some((vote) => vote.userId == userId);
	}

	async isOwner(): Promise<boolean> {
		const user: User = await this.usersService.getWithToken();
		return await this.teamsService.isOwner(user.id);
	}

	async isMember(id: string, userId?: string): Promise<boolean> {
		if (!userId) {
			userId = (await this.usersService.get()).id;
		}
		return await this.teamsService.userIsMemberOfTeam(id, userId);
	}
}
