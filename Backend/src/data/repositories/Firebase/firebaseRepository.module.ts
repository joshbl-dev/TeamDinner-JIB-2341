import { Module } from "@nestjs/common";
import { TeamsRepository } from "./teams.repository";
import { UsersRepository } from "./users.repository";

@Module({
  exports: [TeamsRepository, UsersRepository],
  providers: [TeamsRepository, UsersRepository],
})
export class FirebaseRepositoryModule {}
