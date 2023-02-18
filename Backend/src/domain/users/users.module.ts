import { Module } from "@nestjs/common";
import { UsersService } from "./users.service";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { AuthModule } from "../auth/auth.module";

@Module({
	imports: [RepositoryModule, AuthModule],
	exports: [UsersService],
	providers: [UsersService]
})
export class UsersModule {}
