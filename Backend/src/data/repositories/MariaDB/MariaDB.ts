import { Injectable } from '@nestjs/common';
import { Config } from '../../../utils/Config';
import knex, { Knex } from 'knex';

@Injectable()
export class MariaDB {
  knex: Knex;

  constructor(private config: Config) {
    this.knex = knex({
      client: 'mysql',
      connection: {
        user: config.mariaDBUsername,
        password: config.mariaDBPassword,
        host: config.mariaDBHostname,
        database: config.mariaDB,
      },
      pool: {
        min: 0,
        max: 2,
      },
    });
  }
}
