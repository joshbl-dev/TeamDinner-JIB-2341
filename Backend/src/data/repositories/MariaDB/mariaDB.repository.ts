import { MariaDB } from './MariaDB';
import { Knex } from 'knex';
import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import QueryBuilder = Knex.QueryBuilder;

@Injectable()
export abstract class MariaDBRepository implements OnModuleInit {
  protected readonly tableName: string;
  protected queryBuilder: QueryBuilder;
  @Inject(MariaDB)
  private readonly mariaDB: MariaDB;

  protected constructor(tableName: string) {
    this.tableName = tableName;
  }

  resetQueryBuilder() {
    this.queryBuilder = this.mariaDB.knex(this.tableName);
  }

  onModuleInit(): any {
    this.queryBuilder = this.mariaDB.knex(this.tableName);
  }
}
