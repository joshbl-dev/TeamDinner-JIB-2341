import { Injectable, Scope, UnauthorizedException } from "@nestjs/common";
import { LoginDto } from "../../api/users/models/requests/login.dto";
import { AccountsRepository } from "../../data/repositories/Firebase/accounts.repository";
import { compareHash } from "../../utils/util";
import { Account } from "../../data/entities/Account";
import { JwtService } from "@nestjs/jwt";
import { JwtDto } from "../../api/users/models/responses/jwt.dto";

@Injectable({ scope: Scope.REQUEST })
export class AuthService {
	constructor(
		// @Inject(REQUEST) private request: Request,
		private accountsRepository: AccountsRepository,
		private jwtService: JwtService
	) {}

	async validateAccount(email: string, password: string): Promise<Account> {
		const account: Account = await this.accountsRepository.getWithEmail(
			email
		);
		const isPasswordValid = await compareHash(password, account.password);
		if (account && isPasswordValid) {
			return account;
		}
		return null;
	}

	async login(loginDto: LoginDto): Promise<JwtDto> {
		const account: Account = await this.validateAccount(
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
}
