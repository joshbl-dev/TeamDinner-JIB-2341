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
		const snapshot: QuerySnapshot = await this.collection.get();
		for (let doc of snapshot.docs) {
			const team: Team = doc.data() as Team;
			if (team.members.find((member) => member.id === id)) {
				return team;
			}
		}
		return null;
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
		const doc = await this.collection.doc(teamId).get();
		const oldMem = doc.data().members.find((m) => m.id === member.id);
		await doc.ref.update({
			members: firestore.FieldValue.arrayRemove(oldMem)
		});
		await doc.ref.update({
			members: firestore.FieldValue.arrayUnion(member)
		});
		return await this.getTeam(teamId);
	}

	async isMember(id: string): Promise<boolean> {
		const snapshot: firestore.QuerySnapshot = await this.collection.get();
		return snapshot.docs.some((doc) => {
			const team: Team = doc.data() as Team;
			return team.members.some((member) => member.id === id);
		});
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
			members: firestore.FieldValue.arrayUnion({
				id: userId,
				debt: 0
			})
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
