#!/usr/bin/env pwsh
# Amazon Dispute Manager - Quick Setup Script for Windows
# Run this script from the amazon_dispute_manager directory after cloning the repository and installing Docker Desktop

Write-Host "🚀 Amazon Dispute Manager - Quick Setup Script" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Error: docker-compose.yml not found!" -ForegroundColor Red
    Write-Host "Please run this script from the amazon_dispute_manager directory." -ForegroundColor Red
    Write-Host "Example: cd amazon-dispute-manager/amazon_dispute_manager" -ForegroundColor Yellow
    Write-Host "Then run: ../setup-documentation/setup.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
Write-Host "🔍 Checking Docker status..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker not found or not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    Write-Host "Download Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Blue
    exit 1
}

# Check if docker-compose exists
Write-Host "🔍 Checking Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "✅ Docker Compose found: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🏗️  Building Docker containers..." -ForegroundColor Yellow
Write-Host "   This might take 5-10 minutes on first run..." -ForegroundColor Gray

# Build containers
docker-compose build --no-cache

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build containers!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Containers built successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "🚀 Starting services..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start services!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Services started!" -ForegroundColor Green
Write-Host ""

# Wait a moment for services to be ready
Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "🗄️  Setting up database..." -ForegroundColor Yellow
docker-compose exec web python manage.py migrate

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to migrate database!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Database migrated!" -ForegroundColor Green
Write-Host ""

Write-Host "👤 Creating admin user..." -ForegroundColor Yellow
Write-Host "   You'll be prompted to enter admin credentials:" -ForegroundColor Gray
docker-compose exec web python manage.py createsuperuser

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create admin user!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Admin user created!" -ForegroundColor Green
Write-Host ""

Write-Host "📊 Loading sample data..." -ForegroundColor Yellow
docker-compose exec web python manage.py populate_dummy_data

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Warning: Failed to load sample data (this is optional)" -ForegroundColor Orange
} else {
    Write-Host "✅ Sample data loaded!" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host ""
Write-Host "Your Amazon Dispute Manager is now running!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Access URLs:" -ForegroundColor White
Write-Host "   • Main App:    http://localhost:9000" -ForegroundColor Blue
Write-Host "   • Admin Panel: http://localhost:9000/admin" -ForegroundColor Blue
Write-Host "   • Orders:      http://localhost:9000/orders/" -ForegroundColor Blue
Write-Host "   • Returns:     http://localhost:9000/returns/" -ForegroundColor Blue
Write-Host "   • Disputes:    http://localhost:9000/disputes/" -ForegroundColor Blue
Write-Host "   • Analytics:   http://localhost:9000/analytics/" -ForegroundColor Blue
Write-Host ""
Write-Host "🗄️  Database Connection:" -ForegroundColor White
Write-Host "   • Host:     localhost" -ForegroundColor Gray
Write-Host "   • Port:     5432" -ForegroundColor Gray
Write-Host "   • Database: disputes_db" -ForegroundColor Gray
Write-Host "   • User:     postgres" -ForegroundColor Gray
Write-Host "   • Password: Nachi 12" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor White
Write-Host "   • Setup Guide:      ../setup-documentation/SETUP_GUIDE.md" -ForegroundColor Gray
Write-Host "   • Quick Reference:  ../setup-documentation/QUICK_REFERENCE.md" -ForegroundColor Gray
Write-Host ""
Write-Host "🔧 Useful Commands:" -ForegroundColor White
Write-Host "   • Check status:     docker-compose ps" -ForegroundColor Gray
Write-Host "   • View logs:        docker-compose logs -f" -ForegroundColor Gray
Write-Host "   • Stop services:    docker-compose down" -ForegroundColor Gray
Write-Host "   • Restart services: docker-compose restart" -ForegroundColor Gray
Write-Host ""

# Open the application in default browser (optional)
$openBrowser = Read-Host "Would you like to open the application in your browser? (y/n)"
if ($openBrowser -eq "y" -or $openBrowser -eq "Y" -or $openBrowser -eq "yes") {
    Write-Host "🌐 Opening application..." -ForegroundColor Yellow
    Start-Process "http://localhost:9000"
}

Write-Host ""
Write-Host "Happy disputing! 🚀" -ForegroundColor Green