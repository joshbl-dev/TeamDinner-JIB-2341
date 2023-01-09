import { Module } from "@nestjs/common";
import { MariaDBRepositoryModule } from "./MariaDB/mariaDBRepository.module";

@Module({
	imports: [MariaDBRepositoryModule],
	exports: [MariaDBRepositoryModule]
})
export class RepositoryModule {}
