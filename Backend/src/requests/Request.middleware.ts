import { Injectable, NestMiddleware } from "@nestjs/common";
import { RequestModel } from "./request.model";

@Injectable()
export class RequestMiddleware<Request = any, Response = any>
	implements NestMiddleware<Request, Response>
{
	use(req: Request, res: Response, next: () => void) {
		RequestModel.cls.run(new RequestModel(req, res), next);
	}
}
