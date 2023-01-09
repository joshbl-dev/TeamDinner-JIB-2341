import { Module } from '@nestjs/common';
import { TeamsController } from './teams.controller';
import { DomainModule } from '../../domain/domain.module';

@Module({
  imports: [DomainModule],
  controllers: [TeamsController],
})
export class TeamsAPIModule {}
