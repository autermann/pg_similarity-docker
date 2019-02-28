#!/bin/sh

set -e

for DB in "$POSTGRES_DB"; do
	echo "Loading pg_similarity extensions into ${DB}"
	"${psql[@]}" --username="${POSTGRES_USER}" --dbname="${DB}" \
		-c 'CREATE EXTENSION IF NOT EXISTS pg_similarity;'
done
