# 📝 Quick Reference Card

> **Print or bookmark this page for quick access to essential commands and URLs**

## 🔗 Application URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Main App** | http://localhost:9000 | Homepage & Dashboards |
| **Admin Panel** | http://localhost:9000/admin | Database Management |
| **Orders** | http://localhost:9000/orders/ | Manage Amazon Orders |
| **Returns** | http://localhost:9000/returns/ | Track Returns |
| **Disputes** | http://localhost:9000/disputes/ | Handle Disputes |
| **Analytics** | http://localhost:9000/analytics/ | View Charts & Insights |

## 🗄️ Database Connection Details

| Setting | Value |
|---------|--------|
| **Host** | `localhost` (or `127.0.0.1`) |
| **Port** | `5432` |
| **Database** | `disputes_db` |
| **Username** | `postgres` |
| **Password** | `Nachi 12` *(note the space)* |

## ⚡ Essential Commands

### Start/Stop Application
```bash
# Start everything
docker-compose up -d

# Stop everything  
docker-compose down

# Restart everything
docker-compose restart

# Check status
docker-compose ps
```

### Database Operations
```bash
# Connect to database
docker-compose exec db psql -U postgres -d disputes_db

# Run Django migrations
docker-compose exec web python manage.py migrate

# Create admin user
docker-compose exec web python manage.py createsuperuser

# Load sample data
docker-compose exec web python manage.py populate_dummy_data
```

### Troubleshooting
```bash
# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f db

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d

# Nuclear option (fresh start)
docker-compose down -v
docker-compose up -d --build
```

### Backup & Restore
```bash
# Backup database
docker-compose exec db pg_dump -U postgres disputes_db > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore database
docker-compose exec -T db psql -U postgres -d disputes_db < backup.sql
```

## 🚨 Quick Fixes

### Port Already in Use
Edit `docker-compose.yml` and change:
```yaml
ports:
  - "9001:8000"  # Change 9000 to 9001
```

### Docker Not Running
- **Windows/Mac**: Start Docker Desktop
- **Linux**: `sudo systemctl start docker`

### Permission Issues (Windows PowerShell)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Can't Connect to pgAdmin
Try these hosts in pgAdmin:
1. `localhost`
2. `127.0.0.1` 
3. `host.docker.internal`

## 📁 Project Structure

```
amazon-dispute-manager/
├── .github/                      # GitHub templates
├── setup-documentation/          # Setup guides and scripts (outside project)
│   ├── README.md                # Setup documentation overview
│   ├── SETUP_GUIDE.md           # Complete setup guide
│   ├── QUICK_REFERENCE.md       # This file
│   ├── setup.ps1                # Windows setup script
│   └── setup.sh                 # macOS/Linux setup script
├── amazon_dispute_manager/       # Main Django project directory
│   ├── amazon_dispute_manager/  # Django settings
│   ├── core/                    # Main application
│   │   ├── models.py            # Database models
│   │   ├── views.py             # Web views
│   │   ├── urls.py              # URL routing
│   │   ├── templates/           # HTML templates
│   │   └── static/              # CSS, JS, images
│   ├── static/                  # Static files directory
│   ├── staticfiles/             # Collected static files
│   ├── docker-compose.yml       # Container configuration
│   ├── Dockerfile               # Web app container setup
│   ├── requirements.txt         # Python dependencies
│   ├── .env                     # Environment variables
│   ├── manage.py                # Django management
│   └── db.sqlite3               # Local database
├── venv/                        # Virtual environment
├── README.md                    # Main project README
├── LICENSE                      # MIT License
└── .gitignore                   # Git ignore rules
```

## 🌐 Default Login Credentials

### Django Admin
- **Username**: admin *(or what you created)*
- **Password**: *(what you set during superuser creation)*

### Database
- **Username**: postgres
- **Password**: Nachi 12

## 📧 Support

If you encounter issues:
1. Check the logs: `docker-compose logs -f`
2. Restart services: `docker-compose restart`
3. Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed troubleshooting
4. Create a GitHub issue with error details

---
**🎯 Keep this reference handy for daily operations!**