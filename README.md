# Food Rescue Hub Demo

A Drupal 11 demonstration project for a Food Rescue Hub platform, featuring a custom theme and Docker-based development environment.

## Overview

This project is a Drupal 11-based demonstration of a Food Rescue Hub application. It includes a custom theme, Docker containerization for easy setup, and is designed to showcase food rescue and distribution workflows.

## Features

- **Drupal 11** - Latest stable version of Drupal
- **Custom Theme** - Food Rescue theme with modern, accessible styling
- **Docker Support** - Containerized development environment
- **MariaDB Database** - Pre-configured database container
- **Drush** - Drupal command-line tool included

## Requirements

- Docker and Docker Compose
- PHP 8.3+ (if running without Docker)
- Composer (if running without Docker)
- MySQL/MariaDB 10.6+ (if running without Docker)

## Quick Start

## Local Development (Docker)
This project runs locally using Docker Compose.

### Using Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd drupal-food-rescue-demo
   ```

2. **Start the containers**
   ```bash
   docker-compose up -d
   ```

3. **Access the site**
   - Open your browser and navigate to `http://localhost8080`
   - If you have an existing database dump (`drupal.sql`), you can import it:
     ```bash
     docker-compose exec db mysql -u drupal -pdrupal drupal < drupal.sql
     ```

4. **Install Drupal** (if starting fresh)
   - Visit `http://localhost/core/install.php`
   - Database settings:
     - Database name: `drupal`
     - Database username: `drupal`
     - Database password: `drupal`
     - Database host: `db`
     - Database port: `3306`

### Manual Installation

1. **Install dependencies**
   ```bash
   composer install
   ```

2. **Configure database**
   - Create a MySQL/MariaDB database
   - Update `web/sites/default/settings.php` with your database credentials

3. **Install Drupal**
   - Visit `http://localhost/web/core/install.php` or use Drush:
     ```bash
     vendor/bin/drush site:install
     ```

## Docker Services

The `docker-compose.yml` file defines two services:

- **web**: Apache web server with PHP 8.3
  - Port: `80:80`
  - Document root: `/var/www/html/web`
  - Volumes: `./web/sites/default/files` (for uploaded files)

- **db**: MariaDB 10.6 database
  - Database: `drupal`
  - Username: `drupal`
  - Password: `drupal`
  - Root password: `root`

## Project Structure

```
.
├── composer.json          # Composer dependencies
├── docker-compose.yml     # Docker services configuration
├── Dockerfile            # Web container image definition
├── drupal.sql            # Database dump (if available)
├── troubleshoot-docker.sh # Docker troubleshooting script
├── web/                  # Drupal installation
│   ├── core/            # Drupal core files
│   ├── modules/         # Custom and contributed modules
│   ├── themes/          # Themes
│   │   └── custom/
│   │       └── food_rescue/  # Custom Food Rescue theme
│   └── sites/           # Site-specific files
└── vendor/              # Composer dependencies
```

## Custom Theme

The project includes a custom theme located at `web/themes/custom/food_rescue/`:

- **Theme name**: Food Rescue
- **Base theme**: Stable9
- **Drupal version**: 11.x
- **Features**: Custom CSS styling, accessible design

- Custom Drupal theme built from scratch
- Custom CSS for layout and navigation
- Header and menu customized via Twig + CSS
- Theme structured for extensibility and accessibility

### Theme Structure

- `food_rescue.info.yml` - Theme definition
- `food_rescue.libraries.yml` - Asset libraries
- `css/style.css` - Custom stylesheet

## Troubleshooting

### Docker Issues

If you encounter issues with Docker, run the troubleshooting script:

```bash
./troubleshoot-docker.sh
```

This script will:
- Check Docker and docker-compose status
- Verify container health
- Check Apache status
- Test port bindings
- Display recent logs
- Provide common fixes

### Common Issues

1. **Port already in use**
   - Change the port mapping in `docker-compose.yml` (e.g., `"8080:80"`)

2. **Permission errors**
   - Ensure `web/sites/default/files` is writable:
     ```bash
     chmod -R 775 web/sites/default/files
     ```

3. **Database connection errors**
   - Verify the database container is running: `docker-compose ps`
   - Check database credentials match those in `docker-compose.yml`

4. **Container won't start**
   - Rebuild the containers: `docker-compose up -d --build`
   - Check logs: `docker-compose logs web`

### Viewing Logs

```bash
# Web container logs
docker-compose logs -f web

# Database container logs
docker-compose logs -f db

# All containers
docker-compose logs -f
```

## Development

### Using Drush

Drush is included in the project. To use it with Docker:

```bash
# Run Drush commands inside the web container
docker-compose exec web vendor/bin/drush <command>

# Example: Clear cache
docker-compose exec web vendor/bin/drush cache:rebuild
```

### Theme Development

1. Edit files in `web/themes/custom/food_rescue/`
2. Clear Drupal cache to see changes:
   ```bash
   docker-compose exec web vendor/bin/drush cache:rebuild
   ```

### Database Management

**Export database:**
```bash
docker-compose exec db mysqldump -u drupal -pdrupal drupal > drupal.sql
```

**Import database:**
```bash
docker-compose exec -T db mysql -u drupal -pdrupal drupal < drupal.sql
```

## Environment Variables

You can customize the Docker setup by modifying `docker-compose.yml`:

- Database credentials (MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD)
- Port mappings
- Volume mounts

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project uses the GPL-2.0-or-later license, consistent with Drupal core.

## Resources

- [Drupal Documentation](https://www.drupal.org/docs)
- [Drupal User Guide](https://www.drupal.org/docs/user_guide/en/index.html)
- [Drush Documentation](https://www.drush.org/)
- [Docker Documentation](https://docs.docker.com/)

## Support

For issues and questions:
- Check the troubleshooting script output
- Review Docker logs
- Consult Drupal community resources

---

**Note**: This is a demonstration project. For production use, ensure proper security configurations, environment variables, and database backups.