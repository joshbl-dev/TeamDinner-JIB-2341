import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { ApiModule } from "./api/api.module";
import { DomainModule } from "./domain/domain.module";
import { ServeStaticModule } from "@nestjs/serve-static";
import { UtilsModule } from "./utils/utils.module";
import { join } from "path";

@Module({
	imports: [
		ConfigModule.forRoot({
			envFilePath: `${process.env.NODE_ENV}.env`,
			isGlobal: true
		}),
		ServeStaticModule.forRoot({
			rootPath: join(__dirname, "..", "swagger-static"),
			serveRoot: process.env.NODE_ENV === "dev" ? "/" : "/api"
		}),
		UtilsModule,
		ApiModule,
		DomainModule
	]
})
export class AppModule {}
