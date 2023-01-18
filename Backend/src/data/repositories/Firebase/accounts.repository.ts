import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Account } from "../../entities/Account";
import { Firebase } from "../../../utils/firebase";

@Injectable()
export class AccountsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "accounts");
	}

	async createAccount(account: Account): Promise<boolean> {
		await this.collection.doc(account.id).set(account);
		return true;
	}

	async getWithEmail(email: string): Promise<Account> {
		const snapshot = await this.collection
			.where("email", "==", email)
			.get();
		if (snapshot.empty) {
			return null;
		}
		return snapshot.docs[0].data() as Account;
	}
}
