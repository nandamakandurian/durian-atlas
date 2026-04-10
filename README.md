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
