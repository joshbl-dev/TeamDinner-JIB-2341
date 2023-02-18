import { HttpException, Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";
import { hash, uuid } from "../../utils/util";
import { SignupDto } from "../../api/users/models/requests/signup.dto";
import { AuthsRepository } from "../../data/repositories/Firebase/auths.repository";
import { Auth } from "../../data/entities/Auth";

@Injectable()
export class UsersService {
	constructor(
		private usersRepository: UsersRepository,
		private authRepository: AuthsRepository
	) {}

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

	async getWithEmail(email: string): Promise<User> {
		const auth: Auth = await this.authRepository.getWithEmail(email);
		if (!auth) {
			throw new HttpException("User not found", 404);
		}
		return this.get(auth.id);
	}
}
