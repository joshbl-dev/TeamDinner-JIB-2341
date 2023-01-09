import { Module } from '@nestjs/common';
import { TeamsAPIModule } from './teams/teamsAPI.module';
import { UsersAPIModule } from './users/usersAPI.module';

@Module({
  imports: [TeamsAPIModule, UsersAPIModule],
})
export class ApiModule {}
