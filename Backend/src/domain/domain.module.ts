import { Module } from "@nestjs/common";
import { TeamsModule } from "./teams/teams.module";
import { UsersModule } from "./users/users.module";
import { AuthModule } from "./auth/auth.module";
import { PollsModule } from "./polls/polls.module";

@Module({
	imports: [TeamsModule, UsersModule, AuthModule, PollsModule],
	exports: [TeamsModule, UsersModule, AuthModule, PollsModule]
})
export class DomainModule {}
