# Windows Firewall Configuration Script for DDI Predictor Backend
# This script allows port 5000 through Windows Firewall for network access

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Configuring Windows Firewall" -ForegroundColor Cyan
Write-Host "   Allowing port 5000 for DDI Backend" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please run PowerShell as Administrator:" -ForegroundColor Yellow
    Write-Host "1. Right-click PowerShell" -ForegroundColor Yellow
    Write-Host "2. Select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host "3. Run this script again" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or run this command manually:" -ForegroundColor Yellow
    Write-Host 'New-NetFirewallRule -DisplayName "DDI Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow' -ForegroundColor Gray
    exit 1
}

# Remove existing rule if it exists (to avoid duplicates)
Write-Host "Checking for existing firewall rules..." -ForegroundColor Yellow
$existingRule = Get-NetFirewallRule -DisplayName "DDI Backend Port 5000" -ErrorAction SilentlyContinue
if ($existingRule) {
    Write-Host "Found existing rule, removing it..." -ForegroundColor Yellow
    Remove-NetFirewallRule -DisplayName "DDI Backend Port 5000" -ErrorAction SilentlyContinue
}

# Create new firewall rule
Write-Host "Creating firewall rule for port 5000..." -ForegroundColor Yellow
try {
    New-NetFirewallRule -DisplayName "DDI Backend Port 5000" `
        -Direction Inbound `
        -LocalPort 5000 `
        -Protocol TCP `
        -Action Allow `
        -Profile Domain,Private,Public `
        -Description "Allows incoming connections to DDI Predictor Backend API on port 5000"
    
    Write-Host ""
    Write-Host "Firewall rule created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Port 5000 is now accessible from other devices on your network." -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "Error creating firewall rule:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "You can try creating it manually:" -ForegroundColor Yellow
    Write-Host 'New-NetFirewallRule -DisplayName "DDI Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow' -ForegroundColor Gray
    exit 1
}

# Verify the rule was created
Write-Host "Verifying firewall rule..." -ForegroundColor Yellow
$rule = Get-NetFirewallRule -DisplayName "DDI Backend Port 5000" -ErrorAction SilentlyContinue
if ($rule) {
    Write-Host "Rule verified successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Rule Details:" -ForegroundColor Cyan
    Get-NetFirewallRule -DisplayName "DDI Backend Port 5000" | Format-Table DisplayName, Enabled, Direction, Action -AutoSize
} else {
    Write-Host "Warning: Could not verify rule creation" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Firewall Configuration Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Make sure your backend server is running" -ForegroundColor White
Write-Host "2. Verify your PC's IP address (run: ipconfig)" -ForegroundColor White
Write-Host "3. Update Flutter app with your PC's IP" -ForegroundColor White
Write-Host "4. Test connection from your phone's browser" -ForegroundColor White
Write-Host ""
