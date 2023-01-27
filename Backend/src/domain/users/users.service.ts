import { Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";
import { hash, uuid } from "../../utils/util";
import { SignupDto } from "../../api/users/models/requests/signup.dto";
import { FriendDto } from "../../api/users/models/requests/friend.dto";

@Injectable()
export class UsersService {
	constructor(
		private usersRepository: UsersRepository
	) // private authService: AuthService
	{}

	async get(id: string): Promise<User> {
		return await this.usersRepository.getUser(id);
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

	async addFriend(friendDto: FriendDto): Promise<User> {
		// await this.authService.confirmUser(friendDto.userId);
		return await this.usersRepository.addFriend(
			friendDto.userId,
			friendDto.friendId
		);
	}

	async removeFriend(friendDto: FriendDto): Promise<User> {
		return await this.usersRepository.removeFriend(
			friendDto.userId,
			friendDto.friendId
		);
	}
}
