import {
	Injectable,
	Request,
	Scope,
	UnauthorizedException
} from "@nestjs/common";
import { LoginDto } from "../../api/users/models/requests/login.dto";
import { AuthsRepository } from "../../data/repositories/Firebase/auths.repository";
import { compareHash } from "../../utils/util";
import { Auth } from "../../data/entities/Auth";
import { JwtService } from "@nestjs/jwt";
import { JwtDto } from "../../api/users/models/responses/jwt.dto";

@Injectable({ scope: Scope.REQUEST })
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
		const account: Auth = await this.validateAuth(
			loginDto.email,
			loginDto.password
		);
		if (!account) {
			throw new UnauthorizedException();
		}
		const payload = { email: account.email, sub: account.id };
		return {
			token: this.jwtService.sign(payload)
		};
	}

	async confirmUser(@Request() request): Promise<boolean> {
		console.log(request.user);
		return true;
	}
}
