import { HttpException, Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";
import { hash, uuid } from "../../utils/util";
import { SignupDto } from "../../api/users/models/requests/signup.dto";

@Injectable()
export class UsersService {
	constructor(private usersRepository: UsersRepository) {}

	async get(id: string): Promise<User> {
		const user = await this.usersRepository.getUser(id);
		if (user) {
			return user;
		} else {
			throw new HttpException("User not found", 404);
		}
	}

	async getAll(): Promise<User[]> {
		return await this.usersRepository.getUsers();
	}

	async signup(userQueryDTO: SignupDto): Promise<User> {
		const hashedPassword = await hash(userQueryDTO.password);
		return await this.usersRepository.createUser({
			id: uuid(),
			...userQueryDTO,
			password: hashedPassword
		});
	}

	async exists(id: string): Promise<boolean> {
		return (await this.get(id)) !== undefined;
	}
}
