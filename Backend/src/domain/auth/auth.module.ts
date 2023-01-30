import { RepositoryModule } from "../../data/repositories/repository.module";
import { PassportModule } from "@nestjs/passport";
import { JwtModule } from "@nestjs/jwt";
import { Module } from "@nestjs/common";
import { JwtStrategy } from "./strategies/JwtStrategy";
import { AuthService } from "./auth.service";
import { UtilsModule } from "../../utils/utils.module";
import { Config } from "../../utils/Config";
import { APP_GUARD } from "@nestjs/core";
import { JwtAuthGuard } from "./guards/jwt.guard";

@Module({
	imports: [
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
	providers: [
		AuthService,
		JwtStrategy,
		{
			provide: APP_GUARD,
			useClass: JwtAuthGuard
		}
	]
})
export class AuthModule {}
