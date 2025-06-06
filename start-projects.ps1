# Function to check if a directory is a React/Next.js project
function IsReactProject {
    param (
        [string]$dir
    )
    return (Test-Path "$dir/package.json") -and 
           ((Get-Content "$dir/package.json" -Raw) -match '"react"|"next"|"vite"')
}

# Function to start a React/Next.js project
function StartReactProject {
    param (
        [string]$dir,
        [int]$port
    )
    Write-Host "Setting up $dir on port $port..."
    Set-Location $dir
    npm install
    if (Test-Path "package.json") {
        $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
        if ($packageJson.scripts.dev) {
            $env:PORT = $port
            Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm run dev"
        }
    }
    Set-Location $PSScriptRoot
}

# Start Python server for static files
Start-Process powershell -ArgumentList "-NoExit", "-Command", "python -m http.server 8000"

# Get all project directories
$projects = Get-ChildItem -Path "CommercialBundle2025zips" -Directory

# Counter for React project ports
$reactPort = 3000

# Process each project
foreach ($project in $projects) {
    $projectPath = $project.FullName
    if (IsReactProject $projectPath) {
        StartReactProject $projectPath $reactPort
        $reactPort++
    }
}

Write-Host "All projects are starting up..."
Write-Host "Static projects are available at http://localhost:8000"
Write-Host "React/Next.js projects are starting on ports 3000 and up..." 