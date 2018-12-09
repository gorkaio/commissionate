#!/bin/sh
set -e

until psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "select 1" > /dev/null 2>&1; do
  echo "Waiting for postgres server..."
  sleep 2
done

mix do deps.get, deps.compile
mix db.setup
mix phx.server