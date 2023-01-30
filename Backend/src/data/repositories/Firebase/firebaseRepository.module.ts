import { Module } from "@nestjs/common";
import { TeamsRepository } from "./teams.repository";
import { UsersRepository } from "./users.repository";
import { AuthsRepository } from "./auths.repository";
import { UtilsModule } from "../../../utils/utils.module";

@Module({
	exports: [TeamsRepository, UsersRepository, AuthsRepository],
	providers: [TeamsRepository, UsersRepository, AuthsRepository],
	imports: [UtilsModule]
})
export class FirebaseRepositoryModule {}
