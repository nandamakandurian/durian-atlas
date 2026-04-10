# Durian Atlas

![Atlas carrying the world](doc/atlas-pic.jpg)

Durian Atlas is the small universe that carries a settlement stack on its shoulders.
It brings up the supporting infrastructure, runs migrations, launches settlement services and jobs, and gives you a clean way to dump or restore the world when you need to start again.

## What Atlas Carries

- `make infra` boots the base infrastructure.
- `make migrate` applies runtime patches and runs migrations when the databases are still empty.
- `make settlement` starts the settlement services.
- `make jobs` starts the settlement jobs on top of the running stack.
- `make db-dump` and `make db-restore` snapshot and restore the databases.
- `make clean` tears the stack down.

## Quick Start

```sh
make infra
make migrate
make settlement
make jobs
```
