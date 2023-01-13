import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { Controller } from "@nestjs/common";
import { TeamsService } from "../../domain/teams/teams.service";

@ApiBearerAuth("access-token")
@ApiTags("teams")
@Controller("teams")
export class TeamsController {
  constructor(private readonly teamsService: TeamsService) {}

  // @Post('/create')
  // async create(@Body() teamDTO: TeamQueryDTO): Promise<Team> {
  //   return this.teamsService.create(teamDTO);
  // }
}
