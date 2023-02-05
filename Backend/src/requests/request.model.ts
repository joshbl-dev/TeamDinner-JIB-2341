import { AsyncLocalStorage } from "async_hooks";

export class RequestModel<TRequest = any, TResponse = any> {
	static cls = new AsyncLocalStorage<RequestModel>();

	constructor(
		public readonly req: TRequest,
		public readonly res: TResponse
	) {}

	static get currentContext() {
		return this.cls.getStore();
	}

	static get currentUser() {
		return this.currentContext.req.user;
	}
}
