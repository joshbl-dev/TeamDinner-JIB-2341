import { IsNotEmpty, IsString } from "class-validator";

export class FriendDto {
	@IsString()
	@IsNotEmpty()
	userId: string;

	@IsString()
	@IsNotEmpty()
	friendId: string;
}
