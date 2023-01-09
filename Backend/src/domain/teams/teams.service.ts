import { Injectable } from '@nestjs/common';
import { TeamsRepository } from '../../data/repositories/MariaDB/teams.repository';
import { Team } from '../../data/entities/Team';
import { TeamQueryDTO } from '../../api/teams/models/requests/teamQuery.dto';
import { uuid } from '../../utils/util';

@Injectable()
export class TeamsService {
  constructor(private teamsRepository: TeamsRepository) {}

  async create(teamDTO: TeamQueryDTO): Promise<Team> {
    const users = [];
    for (const id of teamDTO.user_ids) {
      users.push({ id: id });
    }
    return await this.teamsRepository.createTeam(
      {
        id: uuid(),
        teamName: teamDTO.teamName,
      },
      users,
    );
  }
}
