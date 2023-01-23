import { Injectable } from "@nestjs/common";

@Injectable()
export class Config {
	nodeEnv: string;
	firebase_creds: string;
	jwtSecret: string;
	firebase_project_id: string;
	firebase_client_email: string;
	firebase_private_key: string;

	constructor() {
		this.nodeEnv = process.env.NODE_ENV;
		this.firebase_creds = process.env.FIREBASE_CREDS;
		this.jwtSecret = process.env.JWT_SECRET;
		this.firebase_project_id = process.env.FIREBASE_PROJECT_ID;
		this.firebase_client_email = process.env.FIREBASE_CLIENT_EMAIL;
		this.firebase_private_key = process.env.FIREBASE_PRIVATE_KEY;
	}
}
