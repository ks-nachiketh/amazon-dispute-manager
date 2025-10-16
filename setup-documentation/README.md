# 📚 Amazon Dispute Manager - Setup Documentation

> **Complete setup documentation for new users** - Everything you need to get the Amazon Dispute Manager running from scratch!

## 📋 What's in This Folder

This folder contains all the documentation and scripts needed to set up the Amazon Dispute Manager project on a new laptop or machine. Whether you're a complete beginner or an experienced developer, these guides will get you up and running quickly.

## 🗂️ Documentation Files

### 📖 [SETUP_GUIDE.md](SETUP_GUIDE.md) - **START HERE!**
- **Who it's for**: Complete beginners with zero experience
- **What it covers**: Step-by-step setup from installing Git and Docker to accessing the live application
- **Time needed**: 30-60 minutes (including software downloads)
- **Result**: Fully functional local deployment

### 📝 [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - **Daily Operations**
- **Who it's for**: Users who have already completed setup
- **What it covers**: Essential commands, URLs, database details, and troubleshooting
- **Use case**: Keep this bookmarked for quick access to commands and connection details

## 🚀 Automated Setup Scripts

### Windows Users: `setup.ps1`
```powershell
# Navigate to the project directory first
cd amazon-dispute-manager/amazon_dispute_manager

# Run the setup script
../setup-documentation/setup.ps1
```

### macOS/Linux Users: `setup.sh`
```bash
# Navigate to the project directory first
cd amazon-dispute-manager/amazon_dispute_manager

# Make the script executable and run it
chmod +x ../setup-documentation/setup.sh
../setup-documentation/setup.sh
```

## 🎯 Quick Start Options

### Option 1: Automated Setup (Recommended for Beginners)
1. **Clone the repository** from GitHub
2. **Install Docker Desktop** (see [SETUP_GUIDE.md](SETUP_GUIDE.md) for instructions)
3. **Run the appropriate setup script** above
4. **Access the application** at http://localhost:9000

### Option 2: Manual Setup (For Experienced Users)
1. **Follow the manual steps** in [SETUP_GUIDE.md](SETUP_GUIDE.md)
2. **Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md)** for command reference

## 🌐 What You'll Get After Setup

- ✅ **Web Application**: Full-featured dispute management interface
- ✅ **Admin Panel**: Django admin for data management
- ✅ **PostgreSQL Database**: Production-ready database running in Docker
- ✅ **Sample Data**: Pre-loaded orders, returns, and disputes for testing
- ✅ **Analytics Dashboard**: Charts and insights
- ✅ **Multiple Access Methods**: Web UI, database clients, command line

## 🔗 Application Access Points

After setup, you can access:

| Service | URL | Purpose |
|---------|-----|---------|
| **Main App** | http://localhost:9000 | Homepage & Dashboards |
| **Admin Panel** | http://localhost:9000/admin | Database Management |
| **Orders** | http://localhost:9000/orders/ | Manage Amazon Orders |
| **Returns** | http://localhost:9000/returns/ | Track Returns |
| **Disputes** | http://localhost:9000/disputes/ | Handle Disputes |
| **Analytics** | http://localhost:9000/analytics/ | View Charts & Insights |

## 🗄️ Database Connection

Connect to PostgreSQL using any database client:

- **Host**: `localhost`
- **Port**: `5432`
- **Database**: `disputes_db`
- **Username**: `postgres`
- **Password**: `Nachi 12`

## 🆘 Need Help?

### 1. Check Documentation
- **Setup issues**: See [SETUP_GUIDE.md](SETUP_GUIDE.md) troubleshooting section
- **Daily operations**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### 2. Common Issues & Solutions

**Docker not running?**
- Windows/Mac: Start Docker Desktop
- Linux: `sudo systemctl start docker`

**Port 9000 in use?**
- Edit `docker-compose.yml` and change `9000:8000` to `9001:8000`
- Access via http://localhost:9001

**Can't connect to database?**
- Try host `127.0.0.1` instead of `localhost`
- Restart containers: `docker-compose restart`

### 3. Get Support
If you're still stuck:
1. **Check container status**: `docker-compose ps`
2. **View logs**: `docker-compose logs -f`
3. **Create a GitHub issue** with:
   - Your operating system
   - Exact error message
   - Steps you followed
   - Output of the above commands

## 🌍 Deployment Options

Ready to deploy to the internet? The [SETUP_GUIDE.md](SETUP_GUIDE.md) includes detailed instructions for:

- **Railway** (Free tier available, easiest)
- **DigitalOcean App Platform** (Managed service)
- **Heroku** (Classic PaaS option)
- **VPS/Cloud Server** (Full control)

## 📁 Project Structure

```
disputes-manager/
├── setup-documentation/          # 📚 You are here!
│   ├── SETUP_GUIDE.md           # Complete beginner's guide
│   ├── QUICK_REFERENCE.md       # Commands and URLs
│   ├── setup.ps1                # Windows setup script
│   ├── setup.sh                 # macOS/Linux setup script
│   └── README.md                # This file
├── amazon_dispute_manager/       # 🚀 Main project
│   ├── docker-compose.yml       # Container configuration
│   ├── Dockerfile               # Web app container
│   ├── manage.py                # Django management
│   ├── core/                    # Application code
│   └── ...                      # Other project files
└── README.md                     # Project overview
```

## 🎉 Success Checklist

After completing setup, you should be able to:

- [ ] Access the web app at http://localhost:9000
- [ ] Log into the admin panel at http://localhost:9000/admin
- [ ] See sample orders, returns, and disputes in the dashboards
- [ ] Connect to the PostgreSQL database with a client like pgAdmin
- [ ] Run `docker-compose ps` and see both containers running
- [ ] View analytics charts and data

## 💡 Tips

- **Bookmark** the [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for daily use
- **Keep Docker Desktop running** when working with the application
- **Use the setup scripts** - they handle error checking and provide helpful output
- **Read the troubleshooting sections** - most issues have simple solutions

---

**🚀 Ready to get started? Open [SETUP_GUIDE.md](SETUP_GUIDE.md) and let's build something awesome!**