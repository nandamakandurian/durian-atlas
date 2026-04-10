#!/bin/sh
set -eu

ROOT="/Users/nanda/Documents/projects/durianpay"
PATCH_DIR="/Users/nanda/Documents/projects/durianpay/oracle/mini-universe/patches"

rm -f "$ROOT"/dpay-common/db/migrations/*.orig "$ROOT"/dpay-common/db/migrations/*.rej
rm -f "$ROOT"/dpay-core-banking/infra/pg/migrations/*.orig "$ROOT"/dpay-core-banking/infra/pg/migrations/*.rej

for patch_file in "$PATCH_DIR"/*.diff; do
  patch --forward -p0 -d "$ROOT" < "$patch_file"
done

rm -f "$ROOT"/dpay-common/db/migrations/*.orig "$ROOT"/dpay-common/db/migrations/*.rej
rm -f "$ROOT"/dpay-core-banking/infra/pg/migrations/*.orig "$ROOT"/dpay-core-banking/infra/pg/migrations/*.rej

echo "Applied runtime settlement migration patch."
