import { v4 as uuidv4 } from "uuid";
import * as bcrypt from "bcrypt";

export function uuid() {
	return uuidv4();
}

export async function hash(password: string) {
	return await bcrypt.hash(password, 10);
}

export async function compareHash(password: string, hash: string) {
	return await bcrypt.compare(password, hash);
}
