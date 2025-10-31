#!/bin/bash

# ScaleGuard Deployment Script
# This script resolves the authentication issue and deploys the project

echo "Starting ScaleGuard deployment..."

# Step 1: Verify org configuration
echo "Verifying org configuration..."
sf org list

# Step 2: Deploy using the sf CLI (recommended)
echo "Deploying source code to ScaleGuard org..."
sf project deploy start --source-dir force-app --target-org ScaleGuard --test-level RunLocalTests --wait 20

# Step 3: Check deployment status
echo "Checking deployment status..."
sf project deploy report --json

echo "Deployment process completed."
