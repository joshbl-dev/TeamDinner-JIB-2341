import { Injectable } from '@nestjs/common';

@Injectable()
export class Config {
  nodeEnv: string;
  mariaDBHostname: string;
  mariaDB: string;
  mariaDBPort: string;
  mariaDBUsername: string;
  mariaDBPassword: string;

  constructor() {
    this.nodeEnv = process.env.NODE_ENV;
    this.mariaDBHostname = process.env.MARIADB_HOSTNAME;
    this.mariaDB = process.env.MARIADB;
    this.mariaDBPort = process.env.MARIADB_PORT;
    this.mariaDBUsername = process.env.MARIADB_USERNAME;
    this.mariaDBPassword = process.env.MARIADB_PASSWORD;
  }
}
