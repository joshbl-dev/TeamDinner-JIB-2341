import * as admin from "firebase-admin";
import { app } from "firebase-admin";
import { Injectable } from "@nestjs/common";
import App = app.App;

@Injectable()
export class Firebase {
	app: App;

	constructor() {
		this.app = admin.initializeApp({
			credential: admin.credential.applicationDefault()
		});
	}

	getApp(): App {
		return this.app;
	}
}
