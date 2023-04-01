import { Injectable } from "@nestjs/common";
import { FirebaseRepository } from "./firebase.repository";
import { Firebase } from "../../../utils/firebase";
import { Team } from "../../entities/Team";
import { firestore } from "firebase-admin";
import { Member } from "../../entities/Member";
import DocumentReference = firestore.DocumentReference;
import DocumentData = firestore.DocumentData;
import QuerySnapshot = firestore.QuerySnapshot;

@Injectable()
export class TeamsRepository extends FirebaseRepository {
	constructor(firebase: Firebase) {
		super(firebase, "teams");
	}

	async getTeam(teamID: string): Promise<Team> {
		const data: DocumentData = await this.collection
			.doc(teamID)
			.get()
			.then((doc) => doc.data());
		return data as Team;
	}

	async getTeamWithUserId(id: string): Promise<Team> {
		const snapshot: QuerySnapshot = await this.collection
			.where("members", "array-contains", (obj) =>
				obj.where("id", "==", id)
			)
			.get();

		if (snapshot.docs.length > 0) {
			return snapshot.docs[0].data() as Team;
		} else {
			return null;
		}
	}

	async getTeams(): Promise<Team[]> {
		const snapshot: firestore.QuerySnapshot = await this.collection.get();
		return snapshot.docs.map((doc) => doc.data()) as Team[];
	}

	async createTeam(team: Team): Promise<Team> {
		const teamDoc: DocumentReference = await this.collection.doc(team.id);
		await teamDoc.set(team);
		return this.getTeam(team.id);
	}

	async updateTeam(teamId: string, updates: any): Promise<Team> {
		const teamDoc: DocumentReference = await this.collection.doc(teamId);
		await teamDoc.update(updates);
		return this.getTeam(teamId);
	}

	async checkOwner(id: string): Promise<boolean> {
		const snapshot: firestore.QuerySnapshot = await this.collection
			.where("owner", "==", id)
			.get();
		console.log(snapshot.docs.length);
		return snapshot.docs.length > 0;
	}

	async addMember(teamId: string, member: Member): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			members: firestore.FieldValue.arrayUnion(member)
		});
		return await this.getTeam(teamId);
	}

	async removeMember(teamId: string, member: Member): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			members: firestore.FieldValue.arrayRemove(member)
		});
		return await this.getTeam(teamId);
	}

	async deleteTeam(teamId: string): Promise<void> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.delete();
	}

	async updateMember(teamId: string, member: Member): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			members: firestore.FieldValue.arrayRemove(member)
		});
		await docRef.update({
			members: firestore.FieldValue.arrayUnion(member)
		});
		return await this.getTeam(teamId);
	}

	async isMember(id: string): Promise<boolean> {
		const snapshot: firestore.QuerySnapshot = await this.collection
			.where("members", "array-contains", (obj) =>
				obj.where("id", "==", id)
			)
			.get();
		return snapshot.docs.length > 0;
	}

	async inviteMember(teamId: string, userId: string): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			invitations: firestore.FieldValue.arrayUnion(userId)
		});
		return await this.getTeam(teamId);
	}

	async rejectInvite(teamId: string, userId: string): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			invitations: firestore.FieldValue.arrayRemove(userId)
		});
		return await this.getTeam(teamId);
	}

	async acceptInvite(teamId: string, userId: string): Promise<Team> {
		const docRef: DocumentReference = await this.collection.doc(teamId);
		await docRef.update({
			invitations: firestore.FieldValue.arrayRemove(userId),
			members: firestore.FieldValue.arrayUnion(userId)
		});
		return await this.getTeam(teamId);
	}

	async getInvitesForUser(userId: string): Promise<Team[]> {
		const snapshot: firestore.QuerySnapshot = await this.collection
			.where("invitations", "array-contains", userId)
			.get();
		return snapshot.docs.map((doc) => doc.data()) as Team[];
	}
}
