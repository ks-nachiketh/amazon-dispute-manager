# Quick Deployment Reference

> 📖 **For comprehensive instructions, see [README.md](README.md)**

## Current Configuration ✅

The application is currently configured and running with:
- **Web Application**: http://localhost:9000
- **Admin Panel**: http://localhost:9000/admin  
- **Database**: PostgreSQL on localhost:5432
- **Status**: Running in Docker containers

## Quick Commands

```powershell
# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Restart application
docker-compose restart

# Stop application
docker-compose down

# Start application
docker-compose up -d
```

## Current Environment Settings

The `.env` file is configured with:

```env
# Django Configuration  
DEBUG=1
SECRET_KEY=django-insecure-g_zf-a3%8_(r@rywnm)+8i&(9hxg20o958pe)5a)v+sj3o6rze
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
CSRF_TRUSTED_ORIGINS=http://localhost:9000,http://127.0.0.1:9000

# Database Configuration
DATABASE_NAME=disputes_db
DATABASE_USER=postgres
DATABASE_PASSWORD=Nachi12
DATABASE_HOST=db
DATABASE_PORT=5432
```

## Next Steps

1. **Access Application**: Visit http://localhost:9000
2. **Create Admin User**: `docker-compose exec web python manage.py createsuperuser`
3. **Add Sample Data**: `docker-compose exec web python manage.py populate_dummy_data`
4. **Production Deployment**: See README.md for hosting options

## 🛠️ Management Commands

### Using PowerShell Script (Recommended)

```powershell
# View all available commands
.\manage-container.ps1 help

# Build the containers
.\manage-container.ps1 build

# Start the application
.\manage-container.ps1 start

# View real-time logs
.\manage-container.ps1 logs

# Check status
.\manage-container.ps1 status

# Stop the application
.\manage-container.ps1 stop

# Restart services
.\manage-container.ps1 restart

# Run database migrations
.\manage-container.ps1 migrate

# Create Django superuser
.\manage-container.ps1 createsuperuser

# Clean up everything
.\manage-container.ps1 cleanup
```

### Using Docker Compose Directly

```powershell
# Build and start
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Execute Django commands
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py collectstatic

# Access Django shell
docker-compose exec web python manage.py shell
```

## 📦 Container Architecture

The application consists of two main services:

### 1. **Database Service (`db`)**
- **Image**: PostgreSQL 16 Alpine
- **Port**: 5432
- **Volume**: `pg_data` for persistent data
- **Health Check**: Ensures database is ready before starting web service

### 2. **Web Service (`web`)**
- **Build**: Custom Django application
- **Port**: 8000
- **Dependencies**: Waits for database health check
- **Auto-migration**: Runs migrations on startup
- **Static Files**: Collects static files automatically

## 🌐 Deployment Options

### Local Development
The current setup is perfect for local development with hot-reloading enabled.

### Production Deployment

For production deployment, consider these modifications:

1. **Environment Variables**:
   ```env
   DEBUG=0
   SECRET_KEY=your-super-secret-production-key
   DJANGO_ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
   CSRF_TRUSTED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
   ```

2. **Use a Production WSGI Server**:
   ```dockerfile
   # In Dockerfile, replace the CMD with:
   CMD ["gunicorn", "--bind", "0.0.0.0:8000", "amazon_dispute_manager.wsgi:application"]
   ```

3. **Add Gunicorn to requirements.txt**:
   ```txt
   gunicorn==21.2.0
   ```

### Cloud Hosting Options

#### 1. **DigitalOcean App Platform**
- Push your code to GitHub
- Connect repository to DigitalOcean App Platform
- Configure environment variables
- Deploy with one click

#### 2. **Heroku**
- Install Heroku CLI
- Create a `Procfile`:
   ```
   web: gunicorn amazon_dispute_manager.wsgi:application
   release: python manage.py migrate
   ```
- Deploy with `git push heroku main`

#### 3. **AWS ECS/Fargate**
- Push Docker image to ECR
- Create ECS task definition
- Set up RDS for PostgreSQL
- Deploy using ECS service

#### 4. **Google Cloud Run**
- Build and push to Google Container Registry
- Deploy to Cloud Run
- Connect to Cloud SQL for PostgreSQL

#### 5. **Railway**
- Connect GitHub repository
- Railway auto-detects Docker setup
- Add PostgreSQL service
- Deploy automatically

## 🔧 Troubleshooting

### Common Issues

#### 1. **Port Already in Use**
```powershell
# Check what's using port 9000 (host port)
netstat -ano | findstr :9000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or change port in docker-compose.yml
ports:
  - "9001:8000"  # Use host port 9001 instead (container stays on 8000)
```

#### 2. **Database Connection Issues**
```powershell
# Check database container logs
docker-compose logs db

# Restart database service
docker-compose restart db

# Rebuild if persistent
docker-compose down -v
docker-compose up -d --build
```

#### 3. **Permission Issues (Windows)**
```powershell
# Run PowerShell as Administrator
# Or change execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 4. **Static Files Not Loading**
```powershell
# Collect static files manually
docker-compose exec web python manage.py collectstatic --noinput
```

### Logs and Debugging

```powershell
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs web
docker-compose logs db

# Follow logs in real-time
docker-compose logs -f

# Access container shell
docker-compose exec web bash
docker-compose exec db psql -U postgres -d disputes_db
```

## 🔒 Security Notes

- Change the `SECRET_KEY` for production
- Use strong database passwords
- Enable HTTPS for production deployments
- Configure proper CORS settings
- Set `DEBUG=0` in production
- Use environment-specific `.env` files

## 📋 Next Steps

1. **Customize the Application**: Modify models, views, and templates as needed
2. **Add Monitoring**: Integrate logging and monitoring solutions
3. **Set Up CI/CD**: Automate testing and deployment
4. **Configure Backups**: Set up database backup strategies
5. **Add SSL/TLS**: Configure HTTPS for production

## 🆘 Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review Docker and Django logs
3. Ensure all prerequisites are installed
4. Verify network connectivity
5. Check firewall settings

For deployment-specific questions, consult the documentation of your chosen hosting platform.

---

**Happy coding! 🚀**