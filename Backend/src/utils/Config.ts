import { Injectable } from "@nestjs/common";

@Injectable()
export class Config {
	nodeEnv: string;
	firebase_creds: string;
	jwtSecret: string;

	constructor() {
		this.nodeEnv = process.env.NODE_ENV;
		this.firebase_creds = process.env.FIREBASE_CREDS;
		this.jwtSecret = process.env.JWT_SECRET;
	}
}
