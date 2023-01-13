import { Injectable } from "@nestjs/common";
import { User } from "../../entities/User";
import { FirebaseRepository } from "./firebase.repository";
import { FirebaseAdmin, InjectFirebaseAdmin } from "nestjs-firebase";

@Injectable()
export class UsersRepository extends FirebaseRepository {
  constructor(@InjectFirebaseAdmin() fb: FirebaseAdmin) {
    super(fb, "users");
  }

  async getUser(userID: string): Promise<User> {
    return this.db.collection("users").doc(userID);
  }

  // async getUsers(): Promise<User[]> {
  //   return this.fb.db.collection('users').get();
  // }
  //
  // async createUser(user: User): Promise<User> {
  //   await this.queryBuilder.insert(user);
  //   return this.getUser(user.id);
  // }
  //
  // async addUserToTeam(teamID: string, userID: string) {
  //   await this.queryBuilder.where({ id: userID }).update({ team_id: teamID });
  // }
}
