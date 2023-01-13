import { Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";

@Injectable()
export class UsersService {
  constructor(private usersRepository: UsersRepository) {}

  async get(id: string): Promise<User> {
    return await this.usersRepository.getUser(id);
  }

  // async getAll(): Promise<User[]> {
  //   return await this.usersRepository.getUsers();
  // }
  //
  // async create(userQueryDTO: UserQueryDTO): Promise<User> {
  //   return await this.usersRepository.createUser({
  //     id: uuid(),
  //     ...userQueryDTO,
  //   });
  // }
}
