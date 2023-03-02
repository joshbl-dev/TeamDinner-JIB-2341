import { Module } from "@nestjs/common";
import { PollsController } from "./polls.controller";
import { DomainModule } from "../../domain/domain.module";

@Module({
	imports: [DomainModule],
	controllers: [PollsController]
})
export class PollsAPIModule {}
