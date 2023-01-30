import { Injectable } from "@nestjs/common";
import { ExtractJwt, Strategy } from "passport-jwt";
import { PassportStrategy } from "@nestjs/passport";
import { Config } from "../../../utils/Config";
import { User } from "../../../data/entities/User";
import { UsersService } from "../../users/users.service";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
	constructor(private config: Config, private usersService: UsersService) {
		super({
			jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
			ignoreExpiration: true,
			secretOrKey: config.jwtSecret
		});
	}

	async validate(payload: any): Promise<User> {
		return await this.usersService.get(payload.sub);
	}
}
