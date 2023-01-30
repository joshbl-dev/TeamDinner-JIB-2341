import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { ApiModule } from "./api/api.module";
import { DomainModule } from "./domain/domain.module";
import { UtilsModule } from "./utils/utils.module";

@Module({
	imports: [
		ConfigModule.forRoot({
			envFilePath: `${process.env.NODE_ENV}.env`,
			isGlobal: true
		}),
		UtilsModule,
		ApiModule,
		DomainModule
	]
})
export class AppModule {}
