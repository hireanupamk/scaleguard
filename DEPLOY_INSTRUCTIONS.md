# Deployment Instructions for ScaleGuard

## Issue Resolution

The original error occurred because the authentication file (`sfdx_orgs.json`) was not in the correct format for SFDX authentication. The error message indicated:

```
Invalid or missing SFDX auth URL.
Ensure the file exists, and that it either a) contains only the URL, or b) is a JSON file with a top-level property named sfdxAuthUrl.
```

## Solution

### Step 1: Fix Authentication File Format

Create a proper authentication file with the correct format:

```bash
# Create a new auth file with the correct format
echo "force://7ab78366773d..." > sfdx_auth_url.txt
```

### Step 2: Store Authentication

```bash
# Store the auth URL with SFDX
sfdx force:auth:sfdxurl:store -f sfdx_auth_url.txt -a targetOrg
```

### Step 3: Deploy Source Code

Once authentication is properly set up, deploy using:

```bash
# Using Salesforce CLI (sf)
sf project deploy start --source-dir force-app --target-org ScaleGuard --test-level RunLocalTests --wait 20

# Or using legacy SFDX
sfdx force:source:deploy -p force-app -u ScaleGuard -w 20 -l RunLocalTests
```

## Alternative Approach (Already Working)

Since we've confirmed the org is accessible via MCP tools, you can also deploy directly using:

```bash
# Using MCP deploy tool
sf project deploy start --source-dir force-app --target-org ScaleGuard --test-level RunLocalTests --wait 20
```

## Verification

Verify the deployment was successful:
```bash
# Check deployed components
sf project deploy report --json
```

## Note

The authentication issue was resolved by ensuring the auth URL is in the correct format and stored properly. The org "ScaleGuard" is already configured and accessible.
