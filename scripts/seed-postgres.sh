#!/bin/sh
set -eu

until pg_isready -h postgres -p 5432 -U dpay -d settlement >/dev/null 2>&1; do
  sleep 2
done

psql -h postgres -p 5432 -U dpay -d settlement <<'SQL'
INSERT INTO public.settlement_scheduler (last_run_time)
SELECT NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM public.settlement_scheduler
);
SQL

echo "Postgres bootstrap seed applied."
