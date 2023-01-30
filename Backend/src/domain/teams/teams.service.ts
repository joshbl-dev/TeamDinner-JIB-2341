import { Injectable } from "@nestjs/common";
import { TeamsRepository } from "../../data/repositories/Firebase/teams.repository";

@Injectable()
export class TeamsService {
	constructor(private teamsRepository: TeamsRepository) {}

	// async create(teamDTO: TeamCreateDto): Promise<Team> {
	//   const users = [];
	//   for (const id of teamDTO.user_ids) {
	//     users.push({ id: id });
	//   }
	//   return await this.teamsRepository.createTeam(
	//     {
	//       id: uuid(),
	//       teamName: teamDTO.teamName,
	//     },
	//     users,
	//   );
	// }
}
