import { Module } from '@nestjs/common';
import { TeamsService } from './teams.service';
import { RepositoryModule } from '../../data/repositories/repository.module';

@Module({
  imports: [RepositoryModule],
  exports: [TeamsService],
  providers: [TeamsService],
})
export class TeamsModule {}
