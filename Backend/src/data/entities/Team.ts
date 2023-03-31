import { Member } from "./Member";

export class Team {
	id: string;
	name: string;
	description: string;
	owner: string;
	members: Member[];
	invitations: string[];
}
