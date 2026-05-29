# Network Connection Test Script for DDI Predictor Backend
# This script helps diagnose network connectivity issues

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🧪 Testing Network Connection" -ForegroundColor Cyan
Write-Host "   DDI Backend Connectivity Test" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Get current IP addresses
Write-Host "📡 Network Configuration:" -ForegroundColor Yellow
Write-Host ""

$wifiAdapter = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" } | Select-Object -First 1

if ($wifiAdapter) {
    $localIP = $wifiAdapter.IPAddress
    Write-Host "✅ Wi-Fi IPv4 Address: $localIP" -ForegroundColor Green
} else {
    Write-Host "⚠️  Could not detect Wi-Fi IP address" -ForegroundColor Yellow
    Write-Host "Available IPv4 addresses:" -ForegroundColor Yellow
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | ForEach-Object {
        Write-Host "  - $($_.IPAddress)" -ForegroundColor Gray
    }
    $localIP = Read-Host "Enter your PC's IP address"
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🔍 Testing Backend Server" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Check if port 5000 is listening
Write-Host "Test 1: Checking if port 5000 is listening..." -ForegroundColor Yellow
$port5000 = Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue
if ($port5000) {
    Write-Host "✅ Port 5000 is listening" -ForegroundColor Green
    $process = Get-Process -Id $port5000.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "   Process: $($process.ProcessName) (PID: $($process.Id))" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Port 5000 is NOT listening" -ForegroundColor Red
    Write-Host "   → Backend server is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Start the backend server:" -ForegroundColor Yellow
    Write-Host "   cd C:\DDI-Project\DDI-Prediction\Backend\api" -ForegroundColor Gray
    Write-Host "   python main_with_firebase.py" -ForegroundColor Gray
    Write-Host ""
}

Write-Host ""

# Test 2: Test localhost connection
Write-Host "Test 2: Testing localhost connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend is responding on localhost:5000" -ForegroundColor Green
        $healthData = $response.Content | ConvertFrom-Json
        Write-Host "   Status: $($healthData.status)" -ForegroundColor Gray
        Write-Host "   Model Loaded: $($healthData.model_loaded)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Cannot connect to localhost:5000" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Test network IP connection
Write-Host "Test 3: Testing network IP connection ($localIP:5000)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://$localIP:5000/health" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend is accessible from network IP" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Cannot connect to $localIP:5000" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "   This usually means:" -ForegroundColor Yellow
    Write-Host "   1. Windows Firewall is blocking the connection" -ForegroundColor Yellow
    Write-Host "   2. Backend is only listening on localhost (not 0.0.0.0)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Solution: Run allow_firewall_port.ps1 as Administrator" -ForegroundColor Yellow
}

Write-Host ""

# Test 4: Check firewall rules
Write-Host "Test 4: Checking firewall rules..." -ForegroundColor Yellow
$firewallRule = Get-NetFirewallRule -DisplayName "DDI Backend Port 5000" -ErrorAction SilentlyContinue
if ($firewallRule) {
    $ruleEnabled = ($firewallRule | Where-Object { $_.Enabled -eq $true })
    if ($ruleEnabled) {
        Write-Host "✅ Firewall rule exists and is enabled" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Firewall rule exists but is disabled" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ No firewall rule found for port 5000" -ForegroundColor Red
    Write-Host "   → Run allow_firewall_port.ps1 as Administrator" -ForegroundColor Yellow
}

Write-Host ""

# Test 5: Check if backend is listening on 0.0.0.0
Write-Host "Test 5: Checking server binding..." -ForegroundColor Yellow
$allInterfaces = Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalAddress -eq "0.0.0.0" }
if ($allInterfaces) {
    Write-Host "✅ Server is listening on 0.0.0.0 (all interfaces)" -ForegroundColor Green
} else {
    $localhostOnly = Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalAddress -eq "127.0.0.1" }
    if ($localhostOnly) {
        Write-Host "⚠️  Server is only listening on localhost (127.0.0.1)" -ForegroundColor Yellow
        Write-Host "   → This prevents network access!" -ForegroundColor Yellow
        Write-Host "   → Check main_with_firebase.py uses host='0.0.0.0'" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "📋 Summary & Recommendations" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Your PC's IP Address: $localIP" -ForegroundColor Cyan
Write-Host "Backend URL: http://$localIP:5000" -ForegroundColor Cyan
Write-Host ""

Write-Host "For Flutter app (constants.dart):" -ForegroundColor Yellow
Write-Host "  static const String _physicalDeviceUrl = 'http://$localIP:5000';" -ForegroundColor Gray
Write-Host ""

Write-Host "Test from your phone's browser:" -ForegroundColor Yellow
Write-Host "  http://$localIP:5000/health" -ForegroundColor Gray
Write-Host ""

Write-Host "If all tests pass, your APK should be able to connect!" -ForegroundColor Green
Write-Host ""












