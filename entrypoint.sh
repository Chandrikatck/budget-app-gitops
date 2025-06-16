#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid
rm -f /app/tmp/pids/server.pid

# Wait for PostgreSQL to be ready
echo "Checking PostgreSQL readiness at host: postgres, port: 5432"
until pg_isready -h postgres -p 5432 -U postgres > /dev/null 2>&1; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "PostgreSQL is ready, running migrations..."

# Run migrations (ignore if already exists)
bundle exec rake db:create db:migrate || true

# Execute the main container command
exec "$@"
