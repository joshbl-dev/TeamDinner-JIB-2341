import { Module } from "@nestjs/common";
import { TeamsAPIModule } from "./teams/teamsAPI.module";
import { UsersAPIModule } from "./users/usersAPI.module";
import { PollsAPIModule } from "./polls/pollsAPI.module";

@Module({
	imports: [TeamsAPIModule, UsersAPIModule, PollsAPIModule]
})
export class ApiModule {}
