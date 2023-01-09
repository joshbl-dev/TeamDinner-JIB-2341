import { Global, Module } from '@nestjs/common';
import { Config } from './Config';

@Global()
@Module({
  exports: [Config],
  providers: [Config],
})
export class UtilsModule {}
