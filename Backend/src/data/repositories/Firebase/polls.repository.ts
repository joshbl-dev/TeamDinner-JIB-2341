import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Poll, PollStage } from "../../entities/Poll";
import { firestore } from "firebase-admin";
import { Vote } from "../../entities/Vote";

@Injectable()
export class PollsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "polls");
	}

	async createPoll(poll: Poll): Promise<Poll> {
		const doc = await this.collection.doc(poll.id);
		await doc.set(poll);
		return await this.get(doc.id);
	}

	async get(id: string): Promise<Poll> {
		const data = await this.collection
			.doc(id)
			.get()
			.then((doc) => doc.data());
		return data as Poll;
	}

	async setStage(id: string, stage: PollStage): Promise<Poll> {
		await this.collection.doc(id).update({ stage: stage });
		return await this.get(id);
	}

	async vote(id: string, vote: Vote): Promise<Poll> {
		await this.collection
			.doc(id)
			.update({ vote: firestore.FieldValue.arrayUnion(vote) });
		return await this.get(id);
	}

	async removeVote(id: string, vote: Vote): Promise<Poll> {
		await this.collection
			.doc(id)
			.update({ vote: firestore.FieldValue.arrayRemove(vote) });
		return await this.get(id);
	}
}
