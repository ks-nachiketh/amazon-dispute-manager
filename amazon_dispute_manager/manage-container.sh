#!/bin/bash

# Amazon Dispute Manager - Container Management Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if docker-compose is available
check_compose() {
    if ! command -v docker-compose > /dev/null 2>&1; then
        print_error "docker-compose is not installed. Please install it and try again."
        exit 1
    fi
    print_success "docker-compose is available"
}

# Function to build the application
build() {
    print_status "Building the application..."
    docker-compose build --no-cache
    print_success "Application built successfully"
}

# Function to start the application
start() {
    print_status "Starting the application..."
    docker-compose up -d
    print_success "Application started successfully"
    print_status "The application is running at: http://localhost:8000"
}

# Function to stop the application
stop() {
    print_status "Stopping the application..."
    docker-compose down
    print_success "Application stopped successfully"
}

# Function to restart the application
restart() {
    print_status "Restarting the application..."
    docker-compose restart
    print_success "Application restarted successfully"
}

# Function to view logs
logs() {
    print_status "Showing application logs..."
    docker-compose logs -f
}

# Function to run database migrations
migrate() {
    print_status "Running database migrations..."
    docker-compose exec web python manage.py migrate
    print_success "Database migrations completed"
}

# Function to create a superuser
createsuperuser() {
    print_status "Creating Django superuser..."
    docker-compose exec web python manage.py createsuperuser
    print_success "Superuser created successfully"
}

# Function to populate dummy data
populate_data() {
    print_status "Populating dummy data..."
    docker-compose exec web python manage.py populate_dummy_data
    print_success "Dummy data populated successfully"
}

# Function to show application status
status() {
    print_status "Application status:"
    docker-compose ps
}

# Function to clean up
cleanup() {
    print_warning "This will remove all containers, volumes, and images related to this project."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleaning up..."
        docker-compose down -v --rmi all
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Function to show help
help() {
    echo "Amazon Dispute Manager - Container Management"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  build         Build the application containers"
    echo "  start         Start the application"
    echo "  stop          Stop the application"
    echo "  restart       Restart the application"
    echo "  logs          View application logs"
    echo "  status        Show application status"
    echo "  migrate       Run database migrations"
    echo "  createsuperuser Create Django admin superuser"
    echo "  populate      Populate dummy data"
    echo "  cleanup       Remove all containers, volumes, and images"
    echo "  help          Show this help message"
    echo
    echo "Examples:"
    echo "  $0 build && $0 start    # Build and start the application"
    echo "  $0 logs                 # View real-time logs"
    echo "  $0 migrate              # Run database migrations"
}

# Main execution
case "${1:-help}" in
    build)
        check_docker
        check_compose
        build
        ;;
    start)
        check_docker
        check_compose
        start
        ;;
    stop)
        check_docker
        check_compose
        stop
        ;;
    restart)
        check_docker
        check_compose
        restart
        ;;
    logs)
        check_docker
        check_compose
        logs
        ;;
    status)
        check_docker
        check_compose
        status
        ;;
    migrate)
        check_docker
        check_compose
        migrate
        ;;
    createsuperuser)
        check_docker
        check_compose
        createsuperuser
        ;;
    populate)
        check_docker
        check_compose
        populate_data
        ;;
    cleanup)
        check_docker
        check_compose
        cleanup
        ;;
    help|*)
        help
        ;;
esac