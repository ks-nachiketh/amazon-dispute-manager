# Amazon Dispute Manager - Container Management Script (PowerShell)

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    Default = "White"
}

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# Function to check if Docker is running
function Test-Docker {
    try {
        docker info | Out-Null
        Write-Success "Docker is running"
        return $true
    }
    catch {
        Write-Error "Docker is not running. Please start Docker and try again."
        return $false
    }
}

# Function to check if docker-compose is available
function Test-Compose {
    try {
        docker-compose --version | Out-Null
        Write-Success "docker-compose is available"
        return $true
    }
    catch {
        Write-Error "docker-compose is not installed. Please install it and try again."
        return $false
    }
}

# Function to build the application
function Build-App {
    Write-Status "Building the application..."
    docker-compose build --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Application built successfully"
    } else {
        Write-Error "Build failed"
        exit $LASTEXITCODE
    }
}

# Function to start the application
function Start-App {
    Write-Status "Starting the application..."
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Application started successfully"
        Write-Status "The application is running at: http://localhost:9000"
    } else {
        Write-Error "Failed to start application"
        exit $LASTEXITCODE
    }
}

# Function to stop the application
function Stop-App {
    Write-Status "Stopping the application..."
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Application stopped successfully"
    } else {
        Write-Error "Failed to stop application"
    }
}

# Function to restart the application
function Restart-App {
    Write-Status "Restarting the application..."
    docker-compose restart
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Application restarted successfully"
    } else {
        Write-Error "Failed to restart application"
    }
}

# Function to view logs
function Show-Logs {
    Write-Status "Showing application logs..."
    docker-compose logs -f
}

# Function to run database migrations
function Invoke-Migrate {
    Write-Status "Running database migrations..."
    docker-compose exec web python manage.py migrate
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Database migrations completed"
    } else {
        Write-Error "Migration failed"
    }
}

# Function to create a superuser
function New-Superuser {
    Write-Status "Creating Django superuser..."
    docker-compose exec web python manage.py createsuperuser
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Superuser created successfully"
    } else {
        Write-Error "Failed to create superuser"
    }
}

# Function to populate dummy data
function Add-DummyData {
    Write-Status "Populating dummy data..."
    docker-compose exec web python manage.py populate_dummy_data
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Dummy data populated successfully"
    } else {
        Write-Error "Failed to populate dummy data"
    }
}

# Function to show application status
function Get-Status {
    Write-Status "Application status:"
    docker-compose ps
}

# Function to clean up
function Remove-All {
    Write-Warning "This will remove all containers, volumes, and images related to this project."
    $response = Read-Host "Are you sure? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Status "Cleaning up..."
        docker-compose down -v --rmi all
        Write-Success "Cleanup completed"
    } else {
        Write-Status "Cleanup cancelled"
    }
}

# Function to show help
function Show-Help {
    Write-Host "Amazon Dispute Manager - Container Management" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "Usage: .\manage-container.ps1 [COMMAND]" -ForegroundColor $Colors.Default
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor $Colors.Default
    Write-Host "  build         Build the application containers" -ForegroundColor $Colors.Default
    Write-Host "  start         Start the application" -ForegroundColor $Colors.Default
    Write-Host "  stop          Stop the application" -ForegroundColor $Colors.Default
    Write-Host "  restart       Restart the application" -ForegroundColor $Colors.Default
    Write-Host "  logs          View application logs" -ForegroundColor $Colors.Default
    Write-Host "  status        Show application status" -ForegroundColor $Colors.Default
    Write-Host "  migrate       Run database migrations" -ForegroundColor $Colors.Default
    Write-Host "  createsuperuser Create Django admin superuser" -ForegroundColor $Colors.Default
    Write-Host "  populate      Populate dummy data" -ForegroundColor $Colors.Default
    Write-Host "  cleanup       Remove all containers, volumes, and images" -ForegroundColor $Colors.Default
    Write-Host "  help          Show this help message" -ForegroundColor $Colors.Default
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor $Colors.Yellow
    Write-Host "  .\manage-container.ps1 build; .\manage-container.ps1 start    # Build and start" -ForegroundColor $Colors.Default
    Write-Host "  .\manage-container.ps1 logs                                  # View real-time logs" -ForegroundColor $Colors.Default
    Write-Host "  .\manage-container.ps1 migrate                               # Run database migrations" -ForegroundColor $Colors.Default
}

# Main execution logic
if (-not (Test-Docker)) {
    exit 1
}

if (-not (Test-Compose)) {
    exit 1
}

switch ($Command.ToLower()) {
    "build" { Build-App }
    "start" { Start-App }
    "stop" { Stop-App }
    "restart" { Restart-App }
    "logs" { Show-Logs }
    "status" { Get-Status }
    "migrate" { Invoke-Migrate }
    "createsuperuser" { New-Superuser }
    "populate" { Add-DummyData }
    "cleanup" { Remove-All }
    default { Show-Help }
}