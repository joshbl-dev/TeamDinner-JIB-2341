import { Injectable } from '@nestjs/common';
import { MariaDBRepository } from './mariaDB.repository';
import { Team } from '../../entities/Team';
import { UsersRepository } from './users.repository';
import { User } from '../../entities/User';

@Injectable()
export class TeamsRepository extends MariaDBRepository {
  constructor(private usersRepository: UsersRepository) {
    super('teams');
  }

  async getTeam(teamID: string): Promise<Team> {
    this.resetQueryBuilder();
    return this.queryBuilder.select('*').where({ id: teamID }).first();
  }

  async createTeam(team: Team, users: User[]): Promise<Team> {
    this.resetQueryBuilder();
    await this.queryBuilder.insert(team);
    for (const user of users) {
      await this.usersRepository.addUserToTeam(team.id, user.id);
    }

    return this.getTeam(team.id);
  }

  async deleteTeam(teamID: string): Promise<void> {
    await this.queryBuilder
      .where({
        id: teamID,
      })
      .del();
  }
}
