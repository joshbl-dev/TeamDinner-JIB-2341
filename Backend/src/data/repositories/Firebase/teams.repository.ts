import { Injectable } from "@nestjs/common";

@Injectable()
export class TeamsRepository {
  // constructor() {
  //   super("teams");
  // }
  // async getTeam(teamID: string): Promise<Team> {
  //   this.resetQueryBuilder();
  //   return this.queryBuilder.select('*').where({ id: teamID }).first();
  // }
  //
  // async createTeam(team: Team, users: User[]): Promise<Team> {
  //   this.resetQueryBuilder();
  //   await this.queryBuilder.insert(team);
  //   for (const user of users) {
  //     await this.usersRepository.addUserToTeam(team.id, user.id);
  //   }
  //
  //   return this.getTeam(team.id);
  // }
  //
  // async deleteTeam(teamID: string): Promise<void> {
  //   await this.queryBuilder
  //     .where({
  //       id: teamID,
  //     })
  //     .del();
  // }
}
