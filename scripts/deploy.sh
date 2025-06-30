#!/bin/bash

# Movie Studio MTA Deployment Script
# Automatically finds and deploys the latest MTA archive

set -e  # Exit on any error

# Configuration
MTA_ARCHIVES_DIR="./mta_archives"
PROJECT_NAME="movie_studio"

echo "🎬 Movie Studio Deployment Script"
echo "=================================="

# Check if mta_archives directory exists
if [ ! -d "$MTA_ARCHIVES_DIR" ]; then
    echo "❌ Error: $MTA_ARCHIVES_DIR directory not found!"
    echo "Please run 'mbt build' first to generate the MTA archive."
    exit 1
fi

# Find the latest MTA archive
echo "🔍 Looking for MTA archives in $MTA_ARCHIVES_DIR..."

# Get the most recent .mtar file
LATEST_ARCHIVE=$(find "$MTA_ARCHIVES_DIR" -name "${PROJECT_NAME}_*.mtar" -type f | sort -V | tail -n 1)

if [ -z "$LATEST_ARCHIVE" ]; then
    echo "❌ Error: No MTA archives found in $MTA_ARCHIVES_DIR!"
    echo "Please run 'mbt build' first to generate the MTA archive."
    exit 1
fi

echo "📦 Found latest archive: $(basename "$LATEST_ARCHIVE")"

# Check if cf CLI is available
if ! command -v cf &> /dev/null; then
    echo "❌ Error: Cloud Foundry CLI (cf) is not installed or not in PATH!"
    echo "Please install the cf CLI first."
    exit 1
fi

# Check if user is logged in to CF
if ! cf target &> /dev/null; then
    echo "❌ Error: Not logged in to Cloud Foundry!"
    echo "Please run 'cf login' first."
    exit 1
fi

# Show current target
echo "🎯 Current CF target:"
cf target

echo ""
echo "🚀 Deploying to Cloud Foundry..."
echo "Command: cf deploy \"$LATEST_ARCHIVE\" --delete-services"
echo ""

# Deploy the MTA archive
cf deploy "$LATEST_ARCHIVE" --delete-services

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Your application should be available at the URL shown above." 