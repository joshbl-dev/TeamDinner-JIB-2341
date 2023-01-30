import { Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";
import { hash, uuid } from "../../utils/util";
import { UserCreateDto } from "../../api/users/models/requests/userCreate.dto";

@Injectable()
export class UsersService {
	constructor(private usersRepository: UsersRepository) {}

	async get(id: string): Promise<User> {
		return await this.usersRepository.getUser(id);
	}

	async getAll(): Promise<User[]> {
		return await this.usersRepository.getUsers();
	}

	async create(userQueryDTO: UserCreateDto): Promise<User> {
		const hashedPassword = await hash(userQueryDTO.password);
		console.log(hashedPassword);
		return await this.usersRepository.createUser({
			id: uuid(),
			...userQueryDTO,
			password: hashedPassword
		});
	}
}
