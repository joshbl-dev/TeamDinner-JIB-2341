import {
	ApiBadRequestResponse,
	ApiBearerAuth,
	ApiCreatedResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
	ApiOperation,
	ApiQuery,
	ApiTags,
	ApiUnauthorizedResponse
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { UsersService } from "../../domain/users/users.service";
import { User } from "../../data/entities/User";
import { SignupDto } from "./models/requests/signup.dto";
import { AuthService } from "../../domain/auth/auth.service";
import { LoginDto } from "./models/requests/login.dto";
import { JwtDto } from "./models/responses/jwt.dto";
import { SkipAuth } from "../../utils/decorators";
import { ModifyDto } from "./models/requests/modify.dto";

@ApiBearerAuth("access-token")
@ApiTags("users")
@Controller("users")
export class UsersController {
	constructor(
		private readonly usersService: UsersService,
		private readonly authService: AuthService
	) {}

	@ApiOperation({ summary: "Get all users" })
	@ApiOkResponse({ description: "Users found", type: [User] })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@Get("all")
	async getAll(): Promise<User[]> {
		return await this.usersService.getAll();
	}

	@ApiOperation({ summary: "Get a user by id" })
	@ApiQuery({ name: "id", required: false })
	@ApiOkResponse({ description: "User found", type: User })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Get()
	async get(@Query("id") id: string): Promise<User> {
		if (!id) {
			return await this.usersService.getWithToken();
		}
		return await this.usersService.get(id);
	}

	@ApiOperation({ summary: "Sign up a new user" })
	@ApiCreatedResponse({ description: "User created", type: User })
	@ApiBadRequestResponse({ description: "Invalid user" })
	@SkipAuth()
	@Post("signup")
	async signup(@Body() signupDto: SignupDto): Promise<User> {
		return await this.usersService.signup(signupDto);
	}

	@ApiOperation({ summary: "Login a user" })
	@ApiCreatedResponse({ description: "Successful Login", type: JwtDto })
	@ApiUnauthorizedResponse({ description: "Invalid login credentials" })
	@SkipAuth()
	@Post("login")
	async login(@Body() loginDto: LoginDto): Promise<JwtDto> {
		return await this.authService.login(loginDto);
	}

	@ApiOperation({ summary: "Modify a user" })
	@ApiCreatedResponse({ description: "User modified", type: User })
	@ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
	@ApiNotFoundResponse({ description: "Entity not found" })
	@Post("modify")
	async modify(@Body() modifyDto: ModifyDto): Promise<User> {
		return await this.usersService.modify(modifyDto);
	}
}
