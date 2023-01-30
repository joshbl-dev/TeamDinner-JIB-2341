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
import { User } from "../../data/entities/User";

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

	async userHasPermission(userId: string): Promise<boolean> {
		const user: User = this.request.user as User;
		return userId === user.id;
	}
}
