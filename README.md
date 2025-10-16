# 🏪 Amazon Dispute Manager# 🏪 Amazon Dispute Manager



> A comprehensive Django web application for managing Amazon disputes, orders, returns, and analytics. Built with Docker, PostgreSQL, and modern web technologies.> A comprehensive Django web application for managing Amazon disputes, orders, returns, and analytics. Built with Docker, PostgreSQL, and modern web technologies.



![Python](https://img.shields.io/badge/python-3.8+-blue.svg)![Python](https://img.shields.io/badge/python-3.8+-blue.svg)

![Django](https://img.shields.io/badge/django-4.2+-green.svg)![Django](https://img.shields.io/badge/django-4.2+-green.svg)

![Docker](https://img.shields.io/badge/docker-compose-blue.svg)![Docker](https://img.shields.io/badge/docker-compose-blue.svg)

![PostgreSQL](https://img.shields.io/badge/database-postgresql-blue.svg)![PostgreSQL](https://img.shields.io/badge/database-postgresql-blue.svg)

![License](https://img.shields.io/badge/license-MIT-green.svg)![License](https://img.shields.io/badge/license-MIT-green.svg)



## 🎯 What This Project Does## 🎯 What This Project Does



The Amazon Dispute Manager is a full-featured web application that helps you:The Amazon Dispute Manager is a full-featured web application that helps you:



- **📦 Manage Orders**: Track and organize Amazon orders with detailed information- **📦 Manage Orders**: Track and organize Amazon orders with detailed information

- **🔄 Handle Returns**: Monitor return requests and their status- **🔄 Handle Returns**: Monitor return requests and their status

- **⚖️ Process Disputes**: Manage dispute cases with comprehensive tracking- **⚖️ Process Disputes**: Manage dispute cases with comprehensive tracking

- **📊 Analytics Dashboard**: Visualize data with interactive charts and insights- **📊 Analytics Dashboard**: Visualize data with interactive charts and insights

- **🗄️ Database Management**: Full PostgreSQL database with admin interface- **🗄️ Database Management**: Full PostgreSQL database with admin interface

- **🐳 Docker Deployment**: One-click setup with Docker containers- **🐳 Docker Deployment**: One-click setup with Docker containers



## 🚀 Quick Start## 🚀 Quick Start



> **New to this project?** Complete setup documentation is in [`setup-documentation/`](setup-documentation/)> **New to this project?** Complete setup documentation is in [`setup-documentation/`](setup-documentation/)



### Option 1: Automated Setup (Recommended)### Option 1: Automated Setup (Recommended)



**Windows:**

```powershell```powershell

git clone https://github.com/ks-nachiketh/amazon-dispute-manager.gitgit clone https://github.com/YOUR_USERNAME/amazon-dispute-manager.git

cd amazon-dispute-manager/amazon_dispute_managercd amazon-dispute-manager/amazon_dispute_manager

..\setup-documentation\setup.ps1..\setup-documentation\setup.ps1

``````



**macOS/Linux:****macOS/Linux:**

```bash```bash

git clone https://github.com/ks-nachiketh/amazon-dispute-manager.gitgit clone https://github.com/YOUR_USERNAME/amazon-dispute-manager.git

cd amazon-dispute-manager/amazon_dispute_managercd amazon-dispute-manager/amazon_dispute_manager

chmod +x ../setup-documentation/setup.shchmod +x ../setup-documentation/setup.sh

../setup-documentation/setup.sh../setup-documentation/setup.sh

``````



### Option 2: Manual Setup### Option 2: Manual Setup



```bash```bash

cd amazon_dispute_managercd amazon_dispute_manager

docker-compose up -d --builddocker-compose up -d --build

docker-compose exec web python manage.py migratedocker-compose exec web python manage.py migrate

docker-compose exec web python manage.py createsuperuserdocker-compose exec web python manage.py createsuperuser

``````



**Access the application**: http://localhost:9000

## 📚 Documentation



- **📖 [Complete Setup Guide](setup-documentation/SETUP_GUIDE.md)** - Step-by-step instructions for beginners- **📖 [Complete Setup Guide](setup-documentation/SETUP_GUIDE.md)** - Step-by-step instructions for beginners

- **📝 [Quick Reference](setup-documentation/QUICK_REFERENCE.md)** - Commands, URLs, and troubleshooting- **📝 [Quick Reference](setup-documentation/QUICK_REFERENCE.md)** - Commands, URLs, and troubleshooting

- **🚀 [Automated Scripts](setup-documentation/)** - One-click setup for all platforms- **🚀 [Automated Scripts](setup-documentation/)** - One-click setup for all platforms



## 🌐 Live Demo## 🌐 Live Demo



After setup, access these features:After setup, access these features:



| Feature | URL | Description |
|---------|-----|-------------|
| **Main Dashboard** | http://localhost:9000 | Homepage with navigation |
| **Admin Panel** | http://localhost:9000/admin | Database management |
| **Orders Management** | http://localhost:9000/orders/ | View and manage orders |
| **Returns Tracking** | http://localhost:9000/returns/ | Monitor return requests |
| **Dispute Resolution** | http://localhost:9000/disputes/ | Handle dispute cases |
| **Analytics** | http://localhost:9000/analytics/ | Charts and insights |

## 🛠️ Technology Stack



- **Backend**: Django 4.2+, Python 3.8+- **Backend**: Django 4.2+, Python 3.8+

- **Database**: PostgreSQL 16- **Database**: PostgreSQL 16

- **Frontend**: HTML5, CSS3, JavaScript, HTMX- **Frontend**: HTML5, CSS3, JavaScript, HTMX

- **Containerization**: Docker & Docker Compose- **Containerization**: Docker & Docker Compose

- **Styling**: Custom Amazon-themed CSS- **Styling**: Custom Amazon-themed CSS

- **Charts**: Chart.js for analytics- **Charts**: Chart.js for analytics



## 📁 Project Structure

```
amazon-dispute-manager/
├── .github/                      # GitHub templates and workflows
├── setup-documentation/          # 📚 Complete setup guides & scripts
│   ├── README.md                # Setup documentation overview
│   ├── SETUP_GUIDE.md           # Beginner-friendly instructions
│   ├── QUICK_REFERENCE.md       # Daily operations reference
│   ├── ORGANIZATION_OVERVIEW.md # Documentation organization notes
│   ├── setup.ps1                # Windows setup script
│   └── setup.sh                 # macOS/Linux setup script
├── amazon_dispute_manager/       # 🚀 Main Django application
│   ├── amazon_dispute_manager/  # Django project settings
│   ├── core/                    # Main application logic
│   │   ├── models.py            # Database models
│   │   ├── views.py             # Web views and logic
│   │   ├── templates/           # HTML templates
│   │   ├── static/              # CSS, JS, images
│   │   └── migrations/          # Database migrations
│   ├── static/                  # Static files directory
│   ├── staticfiles/             # Collected static files
│   ├── docker-compose.yml       # Container orchestration
│   ├── Dockerfile               # Web application container
│   ├── requirements.txt         # Python dependencies
│   ├── manage.py                # Django management commands
│   ├── .env                     # Environment variables
│   ├── .gitignore               # Git ignore rules
│   ├── README.md                # Project-specific documentation
│   ├── DEPLOYMENT.md            # Deployment information
│   └── db.sqlite3               # Local SQLite database (if used)
├── venv/                        # Python virtual environment
├── README.md                    # This file - main project overview
├── LICENSE                      # MIT License
├── .gitignore                   # Root-level git ignore rules
└── requirements.txt             # Root-level Python dependencies

```

## 🗄️ Database Schema

The application includes these main models:
- **Orders**: Amazon order tracking with details
- **Returns**: Return request management
- **Dispute Cases**: Comprehensive dispute handling
- **Analytics**: Data aggregation and insights

**🚀 Ready to manage your Amazon disputes like a pro? [Get started now!](setup-documentation/SETUP_GUIDE.md)**
