import { Module } from "@nestjs/common";
import { TeamsModule } from "./teams/teams.module";
import { UsersModule } from "./users/users.module";
import { AuthModule } from "./auth/auth.module";

@Module({
	imports: [TeamsModule, UsersModule, AuthModule],
	exports: [TeamsModule, UsersModule, AuthModule]
})
export class DomainModule {}
