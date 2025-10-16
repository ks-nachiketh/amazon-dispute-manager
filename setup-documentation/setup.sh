#!/bin/bash
# Amazon Dispute Manager - Quick Setup Script for macOS/Linux
# Run this script from the amazon_dispute_manager directory after cloning the repository and installing Docker

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Amazon Dispute Manager - Quick Setup Script${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: docker-compose.yml not found!${NC}"
    echo -e "${RED}Please run this script from the amazon_dispute_manager directory.${NC}"
    echo -e "${YELLOW}Example: cd amazon-dispute-manager/amazon_dispute_manager${NC}"
    echo -e "${YELLOW}Then run: ../setup-documentation/setup.sh${NC}"
    exit 1
fi

# Check if Docker is running
echo -e "${YELLOW}🔍 Checking Docker status...${NC}"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        echo -e "${GREEN}✅ Docker found: ${DOCKER_VERSION}${NC}"
    else
        echo -e "${RED}❌ Docker found but not running!${NC}"
        echo -e "${RED}Please start Docker and try again.${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Docker not found!${NC}"
    echo -e "${RED}Please install Docker and try again.${NC}"
    echo -e "${BLUE}Download Docker Desktop from: https://www.docker.com/products/docker-desktop/${NC}"
    exit 1
fi

# Check if docker-compose exists
echo -e "${YELLOW}🔍 Checking Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✅ Docker Compose found: ${COMPOSE_VERSION}${NC}"
else
    echo -e "${RED}❌ Docker Compose not found!${NC}"
    echo -e "${RED}Please install Docker Compose and try again.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🏗️  Building Docker containers...${NC}"
echo -e "${GRAY}   This might take 5-10 minutes on first run...${NC}"

# Build containers
if ! docker-compose build --no-cache; then
    echo -e "${RED}❌ Failed to build containers!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Containers built successfully!${NC}"
echo ""

echo -e "${YELLOW}🚀 Starting services...${NC}"
if ! docker-compose up -d; then
    echo -e "${RED}❌ Failed to start services!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Services started!${NC}"
echo ""

# Wait a moment for services to be ready
echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 10

echo -e "${YELLOW}🗄️  Setting up database...${NC}"
if ! docker-compose exec web python manage.py migrate; then
    echo -e "${RED}❌ Failed to migrate database!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Database migrated!${NC}"
echo ""

echo -e "${YELLOW}👤 Creating admin user...${NC}"
echo -e "${GRAY}   You'll be prompted to enter admin credentials:${NC}"
if ! docker-compose exec web python manage.py createsuperuser; then
    echo -e "${RED}❌ Failed to create admin user!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Admin user created!${NC}"
echo ""

echo -e "${YELLOW}📊 Loading sample data...${NC}"
if ! docker-compose exec web python manage.py populate_dummy_data; then
    echo -e "${YELLOW}⚠️  Warning: Failed to load sample data (this is optional)${NC}"
else
    echo -e "${GREEN}✅ Sample data loaded!${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo -e "${GREEN}==================${NC}"
echo ""
echo -e "${CYAN}Your Amazon Dispute Manager is now running!${NC}"
echo ""
echo -e "${WHITE}📱 Access URLs:${NC}"
echo -e "   ${BLUE}• Main App:    http://localhost:9000${NC}"
echo -e "   ${BLUE}• Admin Panel: http://localhost:9000/admin${NC}"
echo -e "   ${BLUE}• Orders:      http://localhost:9000/orders/${NC}"
echo -e "   ${BLUE}• Returns:     http://localhost:9000/returns/${NC}"
echo -e "   ${BLUE}• Disputes:    http://localhost:9000/disputes/${NC}"
echo -e "   ${BLUE}• Analytics:   http://localhost:9000/analytics/${NC}"
echo ""
echo -e "${WHITE}🗄️  Database Connection:${NC}"
echo -e "   ${GRAY}• Host:     localhost${NC}"
echo -e "   ${GRAY}• Port:     5432${NC}"
echo -e "   ${GRAY}• Database: disputes_db${NC}"
echo -e "   ${GRAY}• User:     postgres${NC}"
echo -e "   ${GRAY}• Password: Nachi 12${NC}"
echo ""
echo -e "${WHITE}📚 Documentation:${NC}"
echo -e "   ${GRAY}• Setup Guide:      ../setup-documentation/SETUP_GUIDE.md${NC}"
echo -e "   ${GRAY}• Quick Reference:  ../setup-documentation/QUICK_REFERENCE.md${NC}"
echo ""
echo -e "${WHITE}🔧 Useful Commands:${NC}"
echo -e "   ${GRAY}• Check status:     docker-compose ps${NC}"
echo -e "   ${GRAY}• View logs:        docker-compose logs -f${NC}"
echo -e "   ${GRAY}• Stop services:    docker-compose down${NC}"
echo -e "   ${GRAY}• Restart services: docker-compose restart${NC}"
echo ""

# Open the application in default browser (optional)
read -p "Would you like to open the application in your browser? (y/n): " -n 1 -r
echo    # Move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🌐 Opening application...${NC}"
    # Try different commands based on the OS
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:9000"
    elif command -v open &> /dev/null; then
        open "http://localhost:9000"
    else
        echo -e "${BLUE}Please open http://localhost:9000 in your browser${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Happy disputing! 🚀${NC}"