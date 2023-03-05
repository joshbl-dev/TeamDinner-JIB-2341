import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { json, urlencoded } from "express";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { INestApplication, ValidationPipe } from "@nestjs/common";
import * as fs from "fs";

async function bootstrap() {
	const version = process.env.npm_package_version;

	let app: INestApplication;
	if (fs.existsSync(process.env.HTTPS_PRIVATE_KEY)) {
		const httpsOptions = {
			key: fs.readFileSync(process.env.HTTPS_PRIVATE_KEY),
			cert: fs.readFileSync(process.env.HTTPS_CERTIFICATE)
		};
		app = await NestFactory.create(AppModule, {
			httpsOptions
		});
	} else {
		app = await NestFactory.create(AppModule);
	}
	app.use(json({ limit: "50mb" }));
	app.use(urlencoded({ extended: true, limit: "50mb" }));
	// app.useGlobalFilters();
	app.enableCors();
	app.useGlobalPipes(new ValidationPipe());

	const config = new DocumentBuilder()
		.setTitle("Team Dinner API")
		.setDescription("Team Dinner Documentation")
		.setVersion(version)
		.addBearerAuth(
			{ type: "http", scheme: "bearer", bearerFormat: "JWT" },
			"access-token"
		)
		.build();
	const document = SwaggerModule.createDocument(app, config);
	SwaggerModule.setup("api", app, document, {
		customSiteTitle: "Team Dinner API",
		swaggerOptions: {
			tagsSorter: "alpha",
			operationsSorter: "method"
		}
	});
	// fs.writeFileSync("./swagger-spec.json", JSON.stringify(document));

	await app.listen(process.env.PORT);
	console.log(
		"Running server at: http://" +
			process.env.ADDRESS +
			":" +
			process.env.PORT +
			"/api"
	);
}

bootstrap();
