# 🚀 Complete Setup Guide for Amazon Dispute Manager

> **For Beginners**: This guide will help you set up the Amazon Dispute Manager project from scratch on a new laptop/machine. No prior experience required!

## 📋 Table of Contents

1. [What You'll Get](#what-youll-get)
2. [Prerequisites](#prerequisites)
3. [Step-by-Step Setup](#step-by-step-setup)
4. [Accessing the Application](#accessing-the-application)
5. [Database Access & Management](#database-access--management)
6. [Hosting Options](#hosting-options)
7. [Troubleshooting](#troubleshooting)
8. [Next Steps](#next-steps)

## 🎯 What You'll Get

After completing this setup, you'll have:
- ✅ A fully functional Amazon Dispute Management web application
- ✅ PostgreSQL database running in Docker
- ✅ Admin dashboard to manage disputes, orders, and returns
- ✅ Analytics dashboard with charts and insights
- ✅ Database access through pgAdmin or command line
- ✅ Everything running locally on your machine

## 📋 Prerequisites

### Required Software (We'll install these together)

1. **Git** - To download the project
2. **Docker Desktop** - To run the application and database
3. **A Code Editor** (Optional but recommended)
   - Visual Studio Code (free)
   - Or any text editor

### System Requirements
- **Operating System**: Windows 10/11, macOS, or Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Storage**: 2GB free space
- **Internet**: Required for initial setup

## 🔧 Step-by-Step Setup

### Step 1: Install Git

#### Windows:
1. Go to https://git-scm.com/download/win
2. Download and run the installer
3. Use default settings during installation
4. Open **Command Prompt** or **PowerShell** and verify: `git --version`



### Step 2: Install Docker Desktop

#### Windows:
1. Go to https://www.docker.com/products/docker-desktop/
2. Download **Docker Desktop for Windows**
3. Run the installer and follow the setup wizard
4. **Important**: Enable WSL 2 if prompted
5. Restart your computer when installation completes
6. Start **Docker Desktop** from the Start menu
7. Wait for the green "Docker Desktop is running" indicator


# Remove old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart your session or reboot
```

### Step 3: Download the Project

1. **Open Terminal/Command Prompt/PowerShell**
2. **Navigate to where you want the project** (e.g., Desktop):
   ```bash
   # Windows (PowerShell)
   cd C:\Users\YourUsername\Desktop
   
   # macOS/Linux
   cd ~/Desktop
   ```

3. **Clone the project**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/amazon-dispute-manager.git
   ```
   > Replace `YOUR_USERNAME` with the actual GitHub username

4. **Enter the project directory**:
   ```bash
   cd amazon-dispute-manager/amazon_dispute_manager
   ```

### Step 4: Start Docker Desktop

1. **Windows**: Click the Docker Desktop icon in the system tray
2. **macOS**: Click the Docker icon in the menu bar
3. **Linux**: Docker should be running as a service

**Verify Docker is running**:
```bash
docker --version
docker-compose --version
```

You should see version numbers if everything is working.

### Step 5: Build and Start the Application

**Copy and paste these commands one by one:**

1. **Build the Docker containers**:
   ```bash
   docker-compose build --no-cache
   ```
   *This might take 5-10 minutes the first time*

2. **Start the services**:
   ```bash
   docker-compose up -d
   ```
   *The `-d` flag runs containers in the background*

3. **Setup the database**:
   ```bash
   docker-compose exec web python manage.py migrate
   ```

4. **Create an admin user**:
   ```bash
   docker-compose exec web python manage.py createsuperuser
   ```
   
   **You'll be prompted to enter**:
   - Username (e.g., `admin`)
   - Email (can be fake, e.g., `admin@example.com`)
   - Password (remember this!)

5. **Load sample data** (optional but recommended):
   ```bash
   docker-compose exec web python manage.py populate_dummy_data
   ```

### Step 6: Verify Everything is Running

**Check container status**:
```bash
docker-compose ps
```

You should see something like:
```
NAME                    COMMAND                  SERVICE             STATUS
amazon_dispute_manager-db-1    "docker-entrypoint.s…"   db              running
amazon_dispute_manager-web-1   "sh -c 'python manag…"   web             running
```

## 🌐 Accessing the Application

### Main Application
- **URL**: http://localhost:9000
- **What you'll see**: Homepage with navigation to different dashboards

### Admin Panel
- **URL**: http://localhost:9000/admin
- **Login**: Use the superuser credentials you created in Step 5
- **What you can do**: 
  - Manage disputes, orders, returns
  - View all data in tables
  - Add/edit/delete records

### Available Dashboards
- **Orders**: http://localhost:9000/orders/ - Manage Amazon orders
- **Returns**: http://localhost:9000/returns/ - Track return requests
- **Disputes**: http://localhost:9000/disputes/ - Handle dispute cases
- **Analytics**: http://localhost:9000/analytics/ - View charts and insights

## 🗄️ Database Access & Management

### Option 1: Using pgAdmin (Graphical Interface)

1. **Download pgAdmin**: https://www.pgadmin.org/download/
2. **Install and open pgAdmin**
3. **Create a new server connection**:
   - **Host**: `localhost` (or try `127.0.0.1` if localhost doesn't work)
   - **Port**: `5432`
   - **Database**: `disputes_db`
   - **Username**: `postgres`
   - **Password**: `Nachi 12` *(note the space)*

4. **Navigate the database**:
   - Expand: Servers → Your Server → Databases → disputes_db → Schemas → public → Tables
   - You'll see tables like: `core_order`, `core_return`, `core_disputecase`

### Option 2: Command Line Access

**Connect to database directly**:
```bash
docker-compose exec db psql -U postgres -d disputes_db
```

**Useful SQL commands**:
```sql
-- List all tables
\dt

-- View orders
SELECT * FROM core_order LIMIT 5;

-- Count total orders
SELECT COUNT(*) FROM core_order;

-- Exit
\q
```

### Option 3: Through Django Admin

**Best for beginners**: Use the Django admin panel at http://localhost:9000/admin

## 🌍 Hosting Options (Deploy to Internet)

### Option 1: Railway (Easiest - Free Tier Available)

1. **Sign up**: https://railway.app (use GitHub to sign up)
2. **Create new project** → **Deploy from GitHub repo**
3. **Connect your repository**
4. **Add PostgreSQL service**:
   - Click "+" → Database → PostgreSQL
5. **Railway will automatically**:
   - Build your Docker container
   - Set up database connections
   - Provide a public URL
6. **Access your live app**: Railway will give you a URL like `https://your-app-name.up.railway.app`

### Option 2: DigitalOcean App Platform

1. **Sign up**: https://www.digitalocean.com/products/app-platform/
2. **Create App** → **GitHub**
3. **Select repository** and branch
4. **Choose plan** (Basic $5/month)
5. **Add database**: PostgreSQL managed database
6. **Deploy**: DigitalOcean handles the rest

### Option 3: Heroku (Classic Option)

1. **Install Heroku CLI**: https://devcenter.heroku.com/articles/heroku-cli
2. **Create Procfile** in project root:
   ```
   web: gunicorn amazon_dispute_manager.wsgi:application
   ```
3. **Deploy**:
   ```bash
   heroku create your-app-name
   heroku addons:create heroku-postgresql:hobby-dev
   git push heroku main
   heroku run python manage.py migrate
   heroku run python manage.py createsuperuser
   ```

### Option 4: VPS (Advanced Users)

For DigitalOcean Droplet, AWS EC2, etc:
1. **Create Ubuntu 20.04+ server**
2. **Install Docker**:
   ```bash
   curl -fsSL https://get.docker.com | sh
   sudo usermod -aG docker $USER
   ```
3. **Clone repository** and **run containers**
4. **Configure reverse proxy** (nginx) for custom domain

## 🔧 Troubleshooting

### Problem: "Port 9000 is already in use"

**Solution**: Change the port in `docker-compose.yml`
```yaml
ports:
  - "9001:8000"  # Change 9000 to 9001 or any available port
```
Then access via: http://localhost:9001

### Problem: "Docker daemon not running"

**Solution**: 
1. **Windows/macOS**: Start Docker Desktop
2. **Linux**: `sudo systemctl start docker`

### Problem: "Cannot connect to database"

**Solutions**:
1. **Restart database container**:
   ```bash
   docker-compose restart db
   ```

2. **Rebuild everything**:
   ```bash
   docker-compose down -v
   docker-compose up -d --build
   ```

3. **Check container logs**:
   ```bash
   docker-compose logs db
   docker-compose logs web
   ```

### Problem: "PowerShell execution policy" (Windows)

**Solution**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problem: "Permission denied" (Linux/macOS)

**Solution**:
```bash
sudo chown -R $USER:$USER .
```

### Problem: pgAdmin won't connect

**Try these hosts in order**:
1. `localhost`
2. `127.0.0.1`
3. `host.docker.internal` (macOS/Windows)
4. Your computer's IP address

### Problem: "No module named 'django'"

**Solution**: Rebuild the web container
```bash
docker-compose build web --no-cache
docker-compose up -d
```

## 📚 Next Steps

### 1. Explore the Application
- Add some sample orders manually
- Create dispute cases
- Check out the analytics dashboard

### 2. Customize for Your Needs
- Modify the Django models in `core/models.py`
- Update templates in `core/templates/`
- Add new features

### 3. Learn More
- **Django Documentation**: https://docs.djangoproject.com/
- **Docker Tutorial**: https://docs.docker.com/get-started/
- **PostgreSQL Guide**: https://www.postgresql.org/docs/

### 4. Backup Your Data
```bash
# Export database
docker-compose exec db pg_dump -U postgres disputes_db > backup.sql

# Import database (if needed)
docker-compose exec -T db psql -U postgres -d disputes_db < backup.sql
```

## 🆘 Getting Help

### Common Commands Reference

```bash
# Check what's running
docker-compose ps

# View live logs
docker-compose logs -f

# Stop everything
docker-compose down

# Start everything
docker-compose up -d

# Restart a specific service
docker-compose restart web
docker-compose restart db

# Update the project
git pull origin main
docker-compose build --no-cache
docker-compose up -d
```

### If You Get Stuck

1. **Check the logs**: `docker-compose logs -f`
2. **Restart everything**: `docker-compose down && docker-compose up -d`
3. **Search online**: Copy the error message and search Google/Stack Overflow
4. **Ask for help**: Create an issue on the GitHub repository with:
   - Your operating system
   - The exact error message
   - What you were trying to do
   - Output of `docker-compose ps` and `docker-compose logs`

## 🎉 Congratulations!

You now have a fully functional Amazon Dispute Manager running locally! The application includes:

- **Web interface** for managing disputes, orders, and returns
- **PostgreSQL database** with sample data
- **Admin panel** for data management
- **Analytics dashboard** with insights
- **Docker containerization** for easy deployment

**Ready to deploy to the internet?** Check out the [Hosting Options](#hosting-options) section above!

---

> **💡 Tip**: Bookmark this guide and the application URLs for quick access. Happy disputing! 🚀