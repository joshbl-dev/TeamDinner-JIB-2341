import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { json, urlencoded } from "express";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { INestApplication, ValidationPipe } from "@nestjs/common";
import * as fs from "fs";
import { createWriteStream } from "fs";
import { get } from "http";

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

	await app.listen(process.env.PORT);
	console.log(
		"Running server at: http://" +
			process.env.ADDRESS +
			":" +
			process.env.PORT +
			"/api"
	);

	if (process.env.NODE_ENV === "dev") {
		const serverUrl =
			"http://" + process.env.ADDRESS + ":" + process.env.PORT;
		// write swagger ui files
		get(`${serverUrl}/swagger/swagger-ui-bundle.js`, function (response) {
			response.pipe(createWriteStream("public/swagger-ui-bundle.js"));
			console.log(
				`Swagger UI bundle file written to: '/public/swagger-ui-bundle.js'`
			);
		});

		get(`${serverUrl}/swagger/swagger-ui-init.js`, function (response) {
			response.pipe(createWriteStream("public/swagger-ui-init.js"));
			console.log(
				`Swagger UI init file written to: '/public/swagger-ui-init.js'`
			);
		});

		get(
			`${serverUrl}/swagger/swagger-ui-standalone-preset.js`,
			function (response) {
				response.pipe(
					createWriteStream("public/swagger-ui-standalone-preset.js")
				);
				console.log(
					`Swagger UI standalone preset file written to: '/public/swagger-ui-standalone-preset.js'`
				);
			}
		);

		get(`${serverUrl}/swagger/swagger-ui.css`, function (response) {
			response.pipe(createWriteStream("public/swagger-ui.css"));
			console.log(
				`Swagger UI css file written to: '/public/swagger-ui.css'`
			);
		});
	}
}

bootstrap();
