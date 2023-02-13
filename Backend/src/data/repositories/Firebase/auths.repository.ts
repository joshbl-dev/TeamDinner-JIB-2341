import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Auth } from "../../entities/Auth";
import { Firebase } from "../../../utils/firebase";

@Injectable()
export class AuthsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "auths");
	}

	async createAccount(account: Auth): Promise<boolean> {
		await this.collection.doc(account.id).set(account);
		return true;
	}

	async getWithEmail(email: string): Promise<Auth> {
		const snapshot = await this.collection
			.where("email", "==", email)
			.get();
		if (snapshot.empty) {
			return null;
		}
		return snapshot.docs[0].data() as Auth;
	}

	async get(id: string): Promise<Auth> {
		const snapshot = await this.collection.doc(id).get();
		if (!snapshot.exists) {
			return null;
		}
		return snapshot.data() as Auth;
	}
}
