import { Injectable } from "@nestjs/common";
import { FirebaseAdmin, InjectFirebaseAdmin } from "nestjs-firebase";
import { firestore } from "firebase-admin";
import Firestore = firestore.Firestore;

@Injectable()
export class FirebaseRepository {
  db: Firestore;
  table: string;
  exists: boolean;

  constructor(@InjectFirebaseAdmin() private fb: FirebaseAdmin, table: string) {
    this.db = fb.db;
    this.table = table;

    this.db
      .collection(table)
      .get()
      .then((snapshot) => {
        if (snapshot.empty) {
          console.log("No matching document " + table + " found.");
          this.exists = false;
        } else {
          this.exists = true;
        }
      });
  }
}
