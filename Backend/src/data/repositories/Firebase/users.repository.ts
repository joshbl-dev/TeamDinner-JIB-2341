import { Injectable } from "@nestjs/common";
import { User } from "../../entities/User";
import { FirebaseRepository } from "./firebase.repository";
import { firestore } from "firebase-admin";
import DocumentSnapshot = firestore.DocumentSnapshot;
import QuerySnapshot = firestore.QuerySnapshot;
import DocumentReference = firestore.DocumentReference;

@Injectable()
export class UsersRepository extends FirebaseRepository {
	constructor() {
		super("users");
	}

	async getUser(userID: string): Promise<User> {
		const snapshot: DocumentSnapshot = await this.collection
			.doc(userID)
			.get();
		return snapshot.data() as User;
	}

	async getUsers(): Promise<User[]> {
		const snapshot: QuerySnapshot = await this.collection.get();
		return snapshot.docs.map((doc) => doc.data()) as User[];
	}

	async createUser(user: User): Promise<User> {
		const doc: DocumentReference = await this.collection.doc(user.id);
		await doc.set(user);
		return this.getUser(user.id);
	}

	// async addUserToTeam(teamID: string, userID: string) {
	// 	await this.queryBuilder
	// 		.where({ id: userID })
	// 		.update({ team_id: teamID });
	// }
}
