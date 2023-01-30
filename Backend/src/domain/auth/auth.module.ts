import { RepositoryModule } from "../../data/repositories/repository.module";
import { PassportModule } from "@nestjs/passport";
import { JwtModule } from "@nestjs/jwt";
import { Module } from "@nestjs/common";
import { JwtStrategy } from "./strategies/JwtStrategy";
import { AuthService } from "./auth.service";
import { UsersModule } from "../users/users.module";
import { UtilsModule } from "../../utils/utils.module";
import { Config } from "../../utils/Config";

@Module({
	imports: [
		UsersModule,
		RepositoryModule,
		PassportModule,
		JwtModule.registerAsync({
			imports: [UtilsModule],
			useFactory: async (config: Config) => ({
				secret: config.jwtSecret
			}),
			inject: [Config]
		})
	],
	exports: [AuthService],
	providers: [AuthService, JwtStrategy]
})
export class AuthModule {}
