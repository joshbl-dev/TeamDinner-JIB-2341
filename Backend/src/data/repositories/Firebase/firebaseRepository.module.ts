import { Module } from "@nestjs/common";
import { TeamsRepository } from "./teams.repository";
import { UsersRepository } from "./users.repository";
import { AccountsRepository } from "./accounts.repository";
import { UtilsModule } from "../../../utils/utils.module";

@Module({
	exports: [TeamsRepository, UsersRepository, AccountsRepository],
	providers: [TeamsRepository, UsersRepository, AccountsRepository],
	imports: [UtilsModule]
})
export class FirebaseRepositoryModule {}
