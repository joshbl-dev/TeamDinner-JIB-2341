import { Module } from "@nestjs/common";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { UsersModule } from "../users/users.module";
import { AuthModule } from "../auth/auth.module";
import { PollsService } from "./polls.service";
import { TeamsModule } from "../teams/teams.module";

@Module({
	imports: [RepositoryModule, UsersModule, AuthModule, TeamsModule],
	exports: [PollsService],
	providers: [PollsService]
})
export class PollsModule {}
