import { Injectable } from '@nestjs/common';
import { MariaDBRepository } from './mariaDB.repository';
import { User } from '../../entities/User';

@Injectable()
export class UsersRepository extends MariaDBRepository {
  constructor() {
    super('users');
  }

  async getUser(userID: string): Promise<User> {
    this.resetQueryBuilder();
    return this.queryBuilder.select('*').where({ id: userID });
  }

  async getUsers(): Promise<User[]> {
    this.resetQueryBuilder();
    return this.queryBuilder.select('*');
  }

  async createUser(user: User): Promise<User> {
    this.resetQueryBuilder();
    await this.queryBuilder.insert(user);
    return this.getUser(user.id);
  }

  async addUserToTeam(teamID: string, userID: string) {
    this.resetQueryBuilder();
    await this.queryBuilder.where({ id: userID }).update({ team_id: teamID });
  }
}
