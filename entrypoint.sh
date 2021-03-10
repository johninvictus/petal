#!/bin/sh
# Docker entrypoint script.

while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

./prod/rel/petal/bin/petal eval Petal.Release.migrate

./prod/rel/petal/bin/petal start