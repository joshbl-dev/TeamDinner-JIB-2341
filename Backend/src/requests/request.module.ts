import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { RequestMiddleware } from "./Request.middleware";

@Module({
	providers: [RequestMiddleware],
	exports: [RequestMiddleware]
})
export class RequestModule implements NestModule {
	configure(consumer: MiddlewareConsumer): any {
		consumer.apply(RequestMiddleware).forRoutes("*");
	}
}
