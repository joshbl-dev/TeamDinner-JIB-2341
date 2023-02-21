import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Poll } from "../../entities/Poll";

@Injectable()
export class PollsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "polls");
	}

	async createPoll(poll: Poll): Promise<Poll> {
		const doc = await this.collection.add(poll);
		return await this.get(doc.id);
	}

	async get(id: string): Promise<Poll> {
		const data = await this.collection
			.doc(id)
			.get()
			.then((doc) => doc.data());
		return data as Poll;
	}
}
