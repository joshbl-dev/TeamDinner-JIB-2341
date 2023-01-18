import {
	ApiBearerAuth,
	ApiOkResponse,
	ApiQuery,
	ApiTags
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { UsersService } from "../../domain/users/users.service";
import { User } from "../../data/entities/User";
import { UserCreateDto } from "./models/requests/userCreate.dto";
import { AuthService } from "../../domain/auth/auth.service";
import { LoginDto } from "./models/requests/login.dto";
import { JwtDto } from "./models/responses/jwt.dto";

@ApiBearerAuth("access-token")
@ApiTags("users")
@Controller("users")
export class UsersController {
	constructor(
		private readonly usersService: UsersService,
		private readonly authService: AuthService
	) {}

	@Get("all")
	async getAll(): Promise<User[]> {
		return await this.usersService.getAll();
	}

	@Post("create")
	async create(@Body() userQueryDto: UserCreateDto): Promise<User> {
		return await this.usersService.create(userQueryDto);
	}

	@ApiQuery({ name: "id", required: true })
	@Get()
	async get(@Query("id") id: string): Promise<User> {
		return await this.usersService.get(id);
	}

	@Post("login")
	@ApiOkResponse({
		description: "Successful Login",
		type: JwtDto
	})
	async login(@Body() loginDto: LoginDto): Promise<JwtDto> {
		return await this.authService.login(loginDto);
	}
}
