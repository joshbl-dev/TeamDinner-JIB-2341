import * as admin from "firebase-admin";
import { app } from "firebase-admin";
import { Injectable } from "@nestjs/common";
import { Config } from "./Config";
import App = app.App;

@Injectable()
export class Firebase {
	app: App;

	constructor(private config: Config) {
		if (config.nodeEnv == "dev") {
			this.app = admin.initializeApp({
				credential: admin.credential.applicationDefault()
			});
		} else {
			this.app = admin.initializeApp({
				credential: admin.credential.cert({
					projectId: config.firebase_project_id,
					clientEmail: config.firebase_client_email,
					privateKey: config.firebase_private_key
				})
			});
		}
	}

	getApp(): App {
		return this.app;
	}
}
