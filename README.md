# Django Project with Docker

This project is a Django application configured with Docker for both development and production environments. It includes PostgreSQL for the database, Memcached for caching, and Nginx as a reverse proxy in production.

## Project Structure

```
.
├── core/                   # Django project core
│   ├── settings-dev.py    # Development settings
│   ├── settings-prod.py   # Production settings
│   └── urls.py            # URL configurations
├── nginx/                 # Nginx configuration
│   ├── Dockerfile        # Nginx Dockerfile
│   └── nginx.conf        # Nginx server configuration
├── templates/            # HTML templates
│   └── home.html        # Homepage template
├── user/                 # Django app
├── docker-compose.dev.yml   # Docker Compose for development
├── docker-compose.prod.yml  # Docker Compose for production
├── Dockerfile.dev          # Development Dockerfile
├── Dockerfile.prod         # Production Dockerfile
├── manage.py              # Django management script
└── requirements.txt       # Python dependencies
```

## Development Environment

### Prerequisites
- Docker
- Docker Compose

### Setup and Running

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Start the development environment:
   ```bash
   docker compose -f docker-compose.dev.yml up --build
   ```

3. Access the development server:
   - Application: http://localhost:8000
   - Admin interface: http://localhost:8000/admin

### Development Features
- Hot-reload enabled (code changes reflect immediately)
- Debug mode enabled
- PostgreSQL database (not exposed to host)
- Memcached for caching
- All logs visible in console

### Development Ports
- Django: 8000 (exposed)
- PostgreSQL: 5432 (internal only)
- Memcached: 11211 (internal only)

## Production Environment

### Prerequisites
- Docker
- Docker Compose
- Ubuntu Server

### Setup and Running

1. Clone the repository on your production server:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Configure environment variables:
   Create a `.env` file in the project root with the following variables:
   ```env
   DJANGO_SECRET_KEY=your-secret-key-here
   POSTGRES_DB=django_db_prod
   POSTGRES_USER=django_user_prod
   POSTGRES_PASSWORD=your-secure-password
   EMAIL_HOST_USER=your-email@example.com
   EMAIL_HOST_PASSWORD=your-email-password
   ```

3. Start the production environment:
   ```bash
   docker compose -f docker-compose.prod.yml up --build -d
   ```

4. Access the production server:
   - Application: http://localhost
   - Admin interface: http://localhost/admin

### Production Features
- Nginx as reverse proxy
- Gunicorn as WSGI server
- PostgreSQL database (not exposed)
- Memcached for caching
- Static/Media files served through Nginx
- SMTP email configuration
- Debug mode disabled
- Optimized for performance

### Production Ports
- Nginx: 80 (exposed)
- Gunicorn: 8000 (internal only)
- PostgreSQL: 5432 (internal only)
- Memcached: 11211 (internal only)

## Database Management

### Creating Migrations
```bash
# Development
docker compose -f docker-compose.dev.yml exec web python manage.py makemigrations

# Production
docker compose -f docker-compose.prod.yml exec web python manage.py makemigrations
```

### Applying Migrations
```bash
# Development
docker compose -f docker-compose.dev.yml exec web python manage.py migrate

# Production
docker compose -f docker-compose.prod.yml exec web python manage.py migrate
```

### Creating Superuser
```bash
# Development
docker compose -f docker-compose.dev.yml exec web python manage.py createsuperuser

# Production
docker compose -f docker-compose.prod.yml exec web python manage.py createsuperuser
```

## Static and Media Files

### Development
- Static files are automatically served by Django's development server
- Media files are stored in the `media` directory

### Production
- Static files are collected to the `static` directory and served by Nginx
- Media files are stored in the `media` directory and served by Nginx
- Run collectstatic manually if needed:
  ```bash
  docker compose -f docker-compose.prod.yml exec web python manage.py collectstatic --noinput
  ```

## Maintenance

### Viewing Logs
```bash
# All services
docker compose -f docker-compose.prod.yml logs

# Specific service (e.g., web, nginx, db)
docker compose -f docker-compose.prod.yml logs web
```

### Backup Database
```bash
docker compose -f docker-compose.prod.yml exec db pg_dump -U django_user_prod django_db_prod > backup.sql
```

### Restore Database
```bash
cat backup.sql | docker compose -f docker-compose.prod.yml exec -T db psql -U django_user_prod -d django_db_prod
```

## Security Notes

1. In production:
   - Database port is not exposed outside Docker network
   - All services communicate through Docker's internal network
   - Debug mode is disabled
   - Secure passwords are used for database and email

2. Environment Variables:
   - Never commit `.env` files
   - Use strong, unique passwords
   - Regularly rotate secrets

## Troubleshooting

1. If static files are not serving:
   ```bash
   docker compose -f docker-compose.prod.yml exec web python manage.py collectstatic --noinput
   ```

2. If database connections fail:
   - Check if PostgreSQL container is running
   - Verify database credentials in settings
   - Ensure migrations are applied

3. If Nginx returns 502 Bad Gateway:
   - Check if Gunicorn is running
   - Verify Nginx configuration
   - Check logs for both services

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Test in development environment
4. Submit a pull request

## License

[Your License Here]
