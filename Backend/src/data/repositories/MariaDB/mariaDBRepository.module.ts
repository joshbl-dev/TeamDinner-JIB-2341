import { Module } from '@nestjs/common';
import { MariaDB } from './MariaDB';
import { TeamsRepository } from './teams.repository';
import { UsersRepository } from './users.repository';

@Module({
  exports: [TeamsRepository, UsersRepository],
  providers: [
    {
      provide: MariaDB,
      useClass: MariaDB,
    },
    TeamsRepository,
    UsersRepository,
  ],
})
export class MariaDBRepositoryModule {}
