import { Module } from '@nestjs/common';
import { TeamsModule } from './teams/teams.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [TeamsModule, UsersModule],
  exports: [TeamsModule, UsersModule],
})
export class DomainModule {}
