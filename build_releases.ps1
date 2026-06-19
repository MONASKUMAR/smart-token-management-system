# Smart Token Management System - ESP32 Build & Release Helper
# Compiles firmware and publishes updates to GitHub for HTTP Auto-Updates.

$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Starting ESP32 Firmware Release Build Pipeline  " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Ensure bin directory exists
if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
}

# Define version paths
$masterVersionPath = "bin/master_version.txt"
$slaveVersionPath = "bin/slave_version.txt"

# 1. Read & Increment Master Version
if (Test-Path $masterVersionPath) {
    $masterVersion = [int](Get-Content $masterVersionPath).Trim()
    $masterVersion++
} else {
    $masterVersion = 1
}
Set-Content -Path $masterVersionPath -Value $masterVersion.ToString()
Write-Host "[Master] Incremented version to: $masterVersion" -ForegroundColor Yellow

# 2. Read & Increment Slave Version
if (Test-Path $slaveVersionPath) {
    $slaveVersion = [int](Get-Content $slaveVersionPath).Trim()
    $slaveVersion++
} else {
    $slaveVersion = 1
}
Set-Content -Path $slaveVersionPath -Value $slaveVersion.ToString()
Write-Host "[Slave] Incremented version to: $slaveVersion" -ForegroundColor Yellow

Write-Host "--------------------------------------------------" -ForegroundColor DarkGray

# 3. Compile Master sketch
Write-Host "[Master] Compiling esp32_master sketch..." -ForegroundColor Green
if (Test-Path "build/master") { Remove-Item -Recurse -Force "build/master" }
New-Item -ItemType Directory -Path "build/master" | Out-Null

$masterCompileCmd = "arduino-cli compile --fqbn esp32:esp32:esp32:PartitionScheme=min_spiffs iot/esp32_master --output-dir build/master"
Invoke-Expression $masterCompileCmd

# Copy binary to release path
Copy-Item "build/master/esp32_master.ino.bin" "bin/esp32_master.bin" -Force
Write-Host "[Master] Binary copied to bin/esp32_master.bin" -ForegroundColor Cyan

# 4. Compile Slave sketch
Write-Host "[Slave] Compiling esp32_slave sketch..." -ForegroundColor Green
if (Test-Path "build/slave") { Remove-Item -Recurse -Force "build/slave" }
New-Item -ItemType Directory -Path "build/slave" | Out-Null

$slaveCompileCmd = "arduino-cli compile --fqbn esp32:esp32:esp32:PartitionScheme=min_spiffs iot/esp32_slave --output-dir build/slave"
Invoke-Expression $slaveCompileCmd

# Copy binary to release path
Copy-Item "build/slave/esp32_slave.ino.bin" "bin/esp32_slave.bin" -Force
Write-Host "[Slave] Binary copied to bin/esp32_slave.bin" -ForegroundColor Cyan

Write-Host "--------------------------------------------------" -ForegroundColor DarkGray

# 5. Commit and Push binaries to GitHub
Write-Host "[Git] Staging release binaries..." -ForegroundColor Green
git add bin/master_version.txt bin/slave_version.txt bin/esp32_master.bin bin/esp32_slave.bin

$commitMessage = "chore(release): publish firmware master v$masterVersion, slave v$slaveVersion"
Write-Host "[Git] Committing releases..." -ForegroundColor Green
git commit -m $commitMessage

Write-Host "[Git] Pushing releases to GitHub repository..." -ForegroundColor Green
git push

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    Firmware successfully published to GitHub!     " -ForegroundColor Cyan
Write-Host "   ESP32 boards will update on their next check.   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
