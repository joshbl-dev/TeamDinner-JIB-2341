import { Global, Module } from "@nestjs/common";
import { Config } from "./Config";
import { Firebase } from "./firebase";

@Global()
@Module({
	exports: [Config, Firebase],
	providers: [Config, Firebase]
})
export class UtilsModule {}
