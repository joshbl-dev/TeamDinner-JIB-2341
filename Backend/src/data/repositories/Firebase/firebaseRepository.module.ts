import { Module } from '@nestjs/common';
import { TeamsRepository } from './teams.repository';
import { UsersRepository } from './users.repository';
import {FirebaseModule} from "nestjs-firebase";
import * as process from "process";

@Module({
    imports: [
        FirebaseModule.forRoot({
            googleApplicationCredential: process.env.FIREBASE_CREDS,
        })
    ],
    exports: [TeamsRepository, UsersRepository],
    providers: [
        TeamsRepository,
        UsersRepository,
    ],
})
export class FirebaseRepositoryModule {}
