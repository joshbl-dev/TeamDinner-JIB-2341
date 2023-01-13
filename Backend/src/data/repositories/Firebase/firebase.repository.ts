import { Injectable } from "@nestjs/common";
import * as admin from "firebase-admin";
import { firestore } from "firebase-admin";
import CollectionReference = firestore.CollectionReference;

@Injectable()
export class FirebaseRepository {
	collection: CollectionReference;

	constructor(name: string) {
		const fb = admin.initializeApp({
			credential: admin.credential.applicationDefault()
		});
		this.collection = fb.firestore().collection(name);
	}
}
