import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { RepositoryModule } from '../../data/repositories/repository.module';

@Module({
  imports: [RepositoryModule],
  exports: [UsersService],
  providers: [UsersService],
})
export class UsersModule {}
