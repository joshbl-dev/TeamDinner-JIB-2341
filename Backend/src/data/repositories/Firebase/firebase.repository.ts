import { Injectable } from "@nestjs/common";
import { firestore } from "firebase-admin";
import { Firebase } from "../../../utils/firebase";
import CollectionReference = firestore.CollectionReference;

@Injectable()
export class FirebaseRepository {
	collection: CollectionReference;

	constructor(private firebase: Firebase, name: string) {
		this.collection = this.firebase.app.firestore().collection(name);
	}
}
