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
}
