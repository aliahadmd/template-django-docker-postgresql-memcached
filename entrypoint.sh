#!/bin/sh

# Wait for PostgreSQL
while ! nc -z db 5432; do
    echo "Waiting for PostgreSQL..."
    sleep 1
done

echo "PostgreSQL started"

# Apply database migrations
python manage.py migrate

# Start Gunicorn
exec "$@"
