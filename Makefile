.PHONY: infra migrate settlement-svc settlement-jobs db-dump db-restore clean

infra:
	docker compose -p mini-universe -f scenarios/infra.yml up -d --wait

migrate: infra
	@echo "Checking if databases are already migrated..."
	@if docker exec mini-universe-postgres-1 psql -U dpay -d settlement -c "SELECT 1 FROM schema_migrations;" >/dev/null 2>&1; then \
		echo "Database already migrated. Skipping patches and migrations."; \
	else \
		echo "Database empty. Applying patches..."; \
		./scripts/apply-runtime-migration-patch.sh; \
		echo "Running migrations..."; \
		docker compose -p mini-universe -f scenarios/migrations.yml up --build; \
		echo "Reverting patches..."; \
		./scripts/revert-runtime-migration-patch.sh; \
	fi

settlement-svc: migrate
	docker compose -p mini-universe -f scenarios/settlement.yml up --build -d
	docker compose -p mini-universe -f scenarios/settlement.yml logs -f settlement-service-api settlement-service-consumer

settlement-jobs: settlement-svc
	docker compose -p mini-universe -f scenarios/settlement-jobs.yml up --build -d
	docker compose -p mini-universe -f scenarios/settlement-jobs.yml logs -f settlement-scheduler settlement-email-reader

db-dump:
	@echo "Dumping clean migrated databases..."
	mkdir -p dumps
	docker exec mini-universe-postgres-1 pg_dump -U dpay -d settlement > dumps/settlement.sql
	docker exec mini-universe-postgres-1 pg_dump -U dpay -d corebanking > dumps/corebanking.sql
	docker exec mini-universe-postgres-1 pg_dump -U dpay -d reconciliation > dumps/reconciliation.sql
	@echo "Dumps saved to dumps/"

db-restore: infra
	@echo "Restoring databases from dumps..."
	docker exec -i mini-universe-postgres-1 psql -U dpay -d postgres -c "DROP DATABASE IF EXISTS settlement; CREATE DATABASE settlement;"
	docker exec -i mini-universe-postgres-1 psql -U dpay -d postgres -c "DROP DATABASE IF EXISTS corebanking; CREATE DATABASE corebanking;"
	docker exec -i mini-universe-postgres-1 psql -U dpay -d postgres -c "DROP DATABASE IF EXISTS reconciliation; CREATE DATABASE reconciliation;"
	docker exec -i mini-universe-postgres-1 psql -U dpay -d settlement < dumps/settlement.sql
	docker exec -i mini-universe-postgres-1 psql -U dpay -d corebanking < dumps/corebanking.sql
	docker exec -i mini-universe-postgres-1 psql -U dpay -d reconciliation < dumps/reconciliation.sql
	@echo "Restore complete!"

clean:
	docker compose -p mini-universe -f scenarios/settlement-jobs.yml down -v || true
	docker compose -p mini-universe -f scenarios/settlement.yml down -v || true
	docker compose -p mini-universe -f scenarios/migrations.yml down -v || true
	docker compose -p mini-universe -f scenarios/infra.yml down -v || true
