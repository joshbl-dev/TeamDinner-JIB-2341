import { Module } from "@nestjs/common";
import { TeamsService } from "./teams.service";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { UsersModule } from "../users/users.module";
import { AuthModule } from "../auth/auth.module";

@Module({
	imports: [RepositoryModule, UsersModule, AuthModule],
	exports: [TeamsService],
	providers: [TeamsService]
})
export class TeamsModule {}
