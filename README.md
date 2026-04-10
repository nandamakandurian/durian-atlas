# Durian Atlas

![Atlas carrying the world](doc/atlas-pic.jpg)

Durian Atlas is the small universe that carries a settlement stack on its shoulders.
Like the Titan condemned to hold up the heavens, Atlas exists to bear the heavy load that everything else depends on: the infrastructure, the migrations, the services, the jobs, and the state of the databases themselves.
The name fits because this repository is not one service among many. It is the weight-bearer behind the scene, the thing that lets an entire local world stand up, move, fall, and be rebuilt on demand.
It brings up the supporting infrastructure, runs migrations, launches settlement services and jobs, and gives you a clean way to dump or restore the world when you need to start again.

## What Atlas Carries

- `make infra` boots the base infrastructure.
- `make migrate` applies runtime patches and runs migrations when the databases are still empty.
- `make settlement` starts the settlement services.
- `make jobs` starts the settlement jobs on top of the running stack.
- `make db-dump` and `make db-restore` snapshot and restore the databases.
- `make clean` tears the stack down.

## Makefile Commands

`make infra`

Starts the base local infrastructure from `scenarios/infra.yml` and waits until the services are healthy. This is the foundation Atlas stands on: Postgres, Redis, Kafka, Consul, and the seed containers that prepare the environment.

`make migrate`

Depends on `infra`, so it boots the base stack first if needed. Then it checks whether the settlement database already has `schema_migrations`; if it does, Atlas skips the migration flow. If the database is still empty, Atlas applies the runtime migration patch, runs the migration stack from `scenarios/migrations.yml`, and reverts the patch afterward.

`make settlement`

Depends on `migrate`, so Atlas ensures infrastructure and schema are ready first. Then it builds and starts the settlement API and consumer from `scenarios/settlement.yml`, and follows their logs so you can watch the services come up.

`make jobs`

Depends on `settlement`, so the core settlement services are already running before the jobs start. Then it builds and launches the scheduler and email reader from `scenarios/settlement-jobs.yml`, and tails their logs.

`make db-dump`

Creates the `dumps/` directory if it does not exist, then exports clean SQL dumps for the `settlement`, `corebanking`, and `reconciliation` databases from the running Postgres container.

`make db-restore`

Depends on `infra`, so Postgres is available first. Then Atlas drops and recreates the `settlement`, `corebanking`, and `reconciliation` databases and restores them from the SQL files in `dumps/`.

`make clean`

Tears down the jobs, settlement, migration, and infrastructure stacks in reverse order and removes their volumes. Use this when you want Atlas to put the whole local world back down.

## Quick Start

Set the external repository paths first. Atlas carries the stack, but it cannot assume every machine keeps the world in the same place.
One engineer may keep `settlement_service` beside this repo, another may keep it elsewhere entirely. Atlas now reads those locations from required env vars instead of hardcoding one filesystem layout.

```sh
cp .env.example .env
```

Fill `.env` with absolute paths for the sibling repositories Atlas depends on.

```sh
make infra
make migrate
make settlement
make jobs
```

If any of those paths are missing, compose now fails fast instead of silently assuming the same directory structure for every user.
