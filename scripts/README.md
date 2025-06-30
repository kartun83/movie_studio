# Deployment Scripts

This folder contains deployment scripts for the Movie Studio MTA application.

## Scripts Overview

### `deploy.sh` (Linux/macOS)
Bash script that automatically finds the latest MTA archive and deploys it to Cloud Foundry.

### `deploy.ps1` (Windows)
PowerShell script that automatically finds the latest MTA archive and deploys it to Cloud Foundry.

## Usage

### Using npm scripts (Recommended)

```bash
# Build and deploy in one command (Linux/macOS)
npm run build:deploy

# Build and deploy in one command (Windows)
npm run build:deploy:win

# Deploy only (Linux/macOS)
npm run deploy

# Deploy only (Windows)
npm run deploy:win
```

### Direct script execution

```bash
# Linux/macOS
./scripts/deploy.sh

# Windows PowerShell
powershell -ExecutionPolicy Bypass -File .\scripts\deploy.ps1
```

## Prerequisites

1. **Cloud Foundry CLI** must be installed and available in PATH
2. **Logged in to Cloud Foundry** (`cf login`)
3. **MTA archive exists** in `./mta_archives/` folder (run `mbt build` first)

## What the scripts do

1. **Find the latest MTA archive** in `./mta_archives/` folder
2. **Validate prerequisites** (cf CLI, login status)
3. **Show current CF target** for confirmation
4. **Deploy with `--delete-services`** flag to clean up old services
5. **Provide clear feedback** with emojis and status messages

## Features

- ✅ **Automatic version detection** - No need to specify exact version
- ✅ **Error handling** - Clear error messages for common issues
- ✅ **Prerequisites checking** - Validates cf CLI and login status
- ✅ **Cross-platform support** - Works on Linux, macOS, and Windows
- ✅ **Visual feedback** - Uses emojis and colors for better UX

## Example Output

```
🎬 Movie Studio Deployment Script
==================================
🔍 Looking for MTA archives in ./mta_archives...
📦 Found latest archive: movie_studio_1.1.0.mtar
🎯 Current CF target:
API endpoint:   https://api.cf.eu10.hana.ondemand.com
API version:    3.131.0
user:           your-email@example.com
org:            your-org
space:          your-space

🚀 Deploying to Cloud Foundry...
Command: cf deploy "./mta_archives/movie_studio_1.1.0.mtar" --delete-services

✅ Deployment completed successfully!
🌐 Your application should be available at the URL shown above.
``` 