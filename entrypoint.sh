#!/bin/sh
# Docker entrypoint script.

while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

/app/bin/petal eval Petal.Release.migrate
/app/bin/petal start
