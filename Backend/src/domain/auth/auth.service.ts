import { Injectable, UnauthorizedException } from "@nestjs/common";
import { LoginDto } from "../../api/users/models/requests/login.dto";
import { AuthsRepository } from "../../data/repositories/Firebase/auths.repository";
import { compareHash } from "../../utils/util";
import { Auth } from "../../data/entities/Auth";
import { JwtService } from "@nestjs/jwt";
import { JwtDto } from "../../api/users/models/responses/jwt.dto";
import { RequestModel } from "../../requests/request.model";

@Injectable()
export class AuthService {
	constructor(
		private authsRepository: AuthsRepository,
		private jwtService: JwtService
	) {}

	async validateAuth(email: string, password: string): Promise<Auth> {
		const auth: Auth = await this.authsRepository.getWithEmail(email);
		if (auth) {
			const isPasswordValid = await compareHash(password, auth.password);
			if (isPasswordValid) {
				return auth;
			}
		}
		return null;
	}

	async login(loginDto: LoginDto): Promise<JwtDto> {
		const auth: Auth = await this.validateAuth(
			loginDto.email,
			loginDto.password
		);
		if (!auth) {
			throw new UnauthorizedException();
		}
		const payload = { email: auth.email, sub: auth.id };
		return {
			token: this.jwtService.sign(payload)
		};
	}

	async userIsInJWT(userId: string): Promise<boolean> {
		console.log(RequestModel.currentUser);
		const auth: Auth = RequestModel.currentUser as Auth;
		return userId === auth.id || auth.isAdmin;
	}

	async getAuthFromJWT(): Promise<Auth> {
		return RequestModel.currentUser as Auth;
	}

	async userIsAdmin(): Promise<boolean> {
		const auth: Auth = RequestModel.currentUser as Auth;
		return auth.isAdmin;
	}

	async get(id: string): Promise<Auth> {
		const auth: Auth = await this.authsRepository.get(id);
		return {
			id: auth.id,
			email: auth.email,
			isAdmin: auth.isAdmin
		};
	}

	async getWithEmail(email: string): Promise<Auth> {
		const auth: Auth = await this.authsRepository.getWithEmail(email);
		return {
			id: auth.id,
			email: auth.email,
			isAdmin: auth.isAdmin
		};
	}
}
