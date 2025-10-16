# Amazon Dispute Manager

Django application for managing Amazon disputes, containerized with Docker and PostgreSQL.

## 📚 Documentation

- **🚀 [../setup-documentation/](../setup-documentation/)** - Complete setup documentation for new users
  - **[SETUP_GUIDE.md](../setup-documentation/SETUP_GUIDE.md)** - Complete beginner-friendly setup instructions
  - **[QUICK_REFERENCE.md](../setup-documentation/QUICK_REFERENCE.md)** - Essential commands and URLs reference
  - **[Automated Setup Scripts](../setup-documentation/)** - One-click setup for Windows/macOS/Linux
- **🚢 [DEPLOYMENT.md](DEPLOYMENT.md)** - Current deployment status and advanced configuration

> **New to this project?** Start with [../setup-documentation/SETUP_GUIDE.md](../setup-documentation/SETUP_GUIDE.md) for step-by-step instructions!

## Prerequisites

- Docker Desktop (running)
- PowerShell/Terminal access

## Quick Start

### Option 1: Automated Setup (Recommended for Beginners)

**Windows (PowerShell):**
```powershell
cd "your-project-folder\amazon_dispute_manager"
..\setup-documentation\setup.ps1
```

**macOS/Linux:**
```bash
cd "your-project-folder/amazon_dispute_manager"
chmod +x ../setup-documentation/setup.sh
../setup-documentation/setup.sh
```

### Option 2: Manual Setup

```powershell
cd "your-project-folder\amazon_dispute_manager"
docker-compose up -d --build
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
```

**Access Links:**
- Main App: http://localhost:9000
- Admin Panel: http://localhost:9000/admin (admin/admin123)

## Step-by-Step Container Setup

### 1. Start Docker Desktop
Ensure Docker Desktop is running (green icon in system tray)

### 2. Navigate to Project
```powershell
cd "your-project-folder\amazon_dispute_manager"

```

### 3. Build Containers
```powershell
docker-compose build --no-cache
```

### 4. Start Services
```powershell
docker-compose up -d
```

### 5. Setup Database
```powershell
docker-compose exec web python manage.py migrate
```

### 6. Create Admin User
```powershell
docker-compose exec web python manage.py createsuperuser
```

### 7. Access Application
- **Web App**: http://localhost:9000
- **Admin Panel**: http://localhost:9000/admin

### 8. Admin Login Details
After creating superuser, use these credentials:
- **Username**: admin
- **Password**: (the password you set during superuser creation)

**Or use the pre-configured admin account**:
- **Username**: admin
- **Password**: admin123

## Container Management

### Basic Commands
```powershell
# Start containers
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Restart containers
docker-compose restart
```

### Using Management Script
```powershell
.\manage-container.ps1 start
.\manage-container.ps1 stop
.\manage-container.ps1 logs
.\manage-container.ps1 status
```

## Hosting Options

### Railway (Easiest)
1. Sign up at https://railway.app
2. Connect GitHub repository
3. Add PostgreSQL service
4. Deploy automatically

### DigitalOcean App Platform
1. Sign up at https://www.digitalocean.com/products/app-platform/
2. Connect GitHub repository
3. Select Docker deployment
4. Add managed PostgreSQL database

### Heroku
1. Install Heroku CLI
2. Create Procfile: `web: gunicorn amazon_dispute_manager.wsgi:application`
3. Deploy:
   ```bash
   heroku create your-app-name
   heroku addons:create heroku-postgresql:hobby-dev
   git push heroku main
   ```

### VPS (Advanced)
1. Create Ubuntu server
2. Install Docker: `curl -fsSL https://get.docker.com | sh`
3. Clone repository and run: `docker-compose up -d`

## Admin Access

### Django Admin Panel
- **URL**: http://localhost:9000/admin
- **Username**: admin
- **Password**: admin123

### Database Access (pgAdmin/PostgreSQL clients)
- **Host**: localhost (or try 127.0.0.1)
- **Port**: 5432
- **Database**: disputes_db
- **Username**: postgres  
- **Password**: Nachi 12 *(with space)*

**pgAdmin Troubleshooting:**
1. Create new server connection with above details
2. If connection fails, try Host: `127.0.0.1` instead of `localhost`
3. Make sure Docker containers are running: `docker-compose ps`
4. Refresh pgAdmin after connecting: Right-click server → Refresh
5. Navigate to: Databases → disputes_db → Schemas → public → Tables

**Real-Time Data Updates:**
- Data added via web interface appears instantly in database
- pgAdmin requires manual refresh to see new data:
  - Right-click table → Refresh (or press F5)
  - Re-run queries to see latest data
  - For real-time monitoring, use command line queries

### Direct Database Access (Command Line)
```powershell
docker-compose exec db psql -U postgres -d disputes_db
```

### Verify Data Exists
```powershell
docker-compose exec db psql -U postgres -d disputes_db -c "SELECT COUNT(*) FROM core_order;"
```

## Common Issues

### Port Already in Use
Change port in docker-compose.yml:
```yaml
ports:
  - "9001:8000"  # Use different port
```

### Docker Not Running
Start Docker Desktop from system tray

### Database Connection Issues
```powershell
docker-compose restart db
# Or rebuild: docker-compose down -v && docker-compose up -d
```

### PowerShell Script Permissions
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```