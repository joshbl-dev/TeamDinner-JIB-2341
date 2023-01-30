import { Injectable } from "@nestjs/common";
import { User } from "../../entities/User";
import { FirebaseRepository } from "./firebase.repository";
import { firestore } from "firebase-admin";
import { AuthsRepository } from "./auths.repository";
import { Auth } from "../../entities/Auth";
import { Firebase } from "../../../utils/firebase";
import QuerySnapshot = firestore.QuerySnapshot;
import DocumentReference = firestore.DocumentReference;
import DocumentData = firestore.DocumentData;

@Injectable()
export class UsersRepository extends FirebaseRepository {
	constructor(
		firebase: Firebase,
		private accountsRepository: AuthsRepository
	) {
		super(firebase, "users");
	}

	async getUser(userID: string): Promise<User> {
		const data: DocumentData = await this.collection
			.doc(userID)
			.get()
			.then((doc) => doc.data());
		return data as User;
	}

	async getUsers(): Promise<User[]> {
		const snapshot: QuerySnapshot = await this.collection.get();
		return snapshot.docs.map((doc) => doc.data()) as User[];
	}

	async createUser(user: User & Auth): Promise<User> {
		const userDoc: DocumentReference = await this.collection.doc(user.id);
		await userDoc.set({
			id: user.id,
			firstName: user.firstName,
			lastName: user.lastName
		});
		await this.accountsRepository.createAccount({
			id: user.id,
			email: user.email,
			password: user.password
		});
		return this.getUser(user.id);
	}

	// async addUserToTeam(teamID: string, userID: string) {
	// 	await this.queryBuilder
	// 		.where({ id: userID })
	// 		.update({ team_id: teamID });
	// }
}
