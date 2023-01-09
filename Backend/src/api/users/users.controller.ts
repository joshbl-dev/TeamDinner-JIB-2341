import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { UsersService } from '../../domain/users/users.service';
import { User } from '../../data/entities/User';
import { UserQueryDTO } from './models/requests/userQuery.dto';

@ApiBearerAuth('access-token')
@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('all')
  async getAll(): Promise<User[]> {
    return await this.usersService.getAll();
  }

  @Post('create')
  async create(@Body() userQueryDTO: UserQueryDTO): Promise<User> {
    return await this.usersService.create(userQueryDTO);
  }

  @ApiQuery({ name: 'id', required: true })
  @Get()
  async get(@Query('id') id: string): Promise<User> {
    return await this.usersService.get(id);
  }
}
