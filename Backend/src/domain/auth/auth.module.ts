import { RepositoryModule } from "../../data/repositories/repository.module";
import { PassportModule } from "@nestjs/passport";
import { JwtModule } from "@nestjs/jwt";
import { Module } from "@nestjs/common";
import { JwtStrategy } from "./strategies/JwtStrategy";
import { AuthService } from "./auth.service";
import { UsersModule } from "../users/users.module";

@Module({
	imports: [
		UsersModule,
		RepositoryModule,
		PassportModule,
		JwtModule.register({
			secret: process.env.JWT_SECRET
		})
	],
	exports: [AuthService],
	providers: [AuthService, JwtStrategy]
})
export class AuthModule {}
