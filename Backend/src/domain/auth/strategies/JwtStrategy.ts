import { Injectable } from "@nestjs/common";
import { ExtractJwt, Strategy } from "passport-jwt";
import { PassportStrategy } from "@nestjs/passport";
import { Config } from "../../../utils/Config";
import { AuthService } from "../auth.service";
import { Auth } from "../../../data/entities/Auth";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
	constructor(private config: Config, private authService: AuthService) {
		super({
			jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
			ignoreExpiration: true,
			secretOrKey: config.jwtSecret
		});
	}

	async validate(payload: any): Promise<Auth> {
		return await this.authService.get(payload.sub);
	}
}
