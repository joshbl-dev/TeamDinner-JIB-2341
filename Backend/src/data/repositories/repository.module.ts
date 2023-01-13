import { Module } from "@nestjs/common";
import { FirebaseRepositoryModule } from "./Firebase/firebaseRepository.module";

@Module({
  imports: [FirebaseRepositoryModule],
  exports: [FirebaseRepositoryModule],
})
export class RepositoryModule {}

