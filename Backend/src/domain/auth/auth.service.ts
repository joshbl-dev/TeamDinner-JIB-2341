import {
	Inject,
	Injectable,
	Scope,
	UnauthorizedException
} from "@nestjs/common";
import { LoginDto } from "../../api/users/models/requests/login.dto";
import { AuthsRepository } from "../../data/repositories/Firebase/auths.repository";
import { compareHash } from "../../utils/util";
import { Auth } from "../../data/entities/Auth";
import { JwtService } from "@nestjs/jwt";
import { JwtDto } from "../../api/users/models/responses/jwt.dto";
import { REQUEST } from "@nestjs/core";
import { Request } from "express";

@Injectable({ scope: Scope.REQUEST })
export class AuthService {
	constructor(
		@Inject(REQUEST) private request: Request,
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
		const auth: Auth = this.request.user as Auth;
		return userId === auth.id;
	}

	async userIsAdmin(): Promise<boolean> {
		const auth: Auth = this.request.user as Auth;
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
}
