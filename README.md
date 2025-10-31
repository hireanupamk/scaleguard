# ScaleGuard

ScaleGuard is a Salesforce application designed to provide observability and incident management capabilities.

## Deployment

### Authentication Issue Resolution

The deployment was failing due to an authentication issue with the `sfdx_orgs.json` file format. The error indicated:

```
Invalid or missing SFDX auth URL.
Ensure the file exists, and that it either a) contains only the URL, or b) is a JSON file with a top-level property named sfdxAuthUrl.
```

### Solution

1. **Fixed Authentication File Format**: 
   - The `sfdx_orgs.json` file now correctly contains the auth URL in the format:
   ```json
   {
     "sfdxAuthUrl": "force://7ab78366773d..."
   }
   ```

2. **Workflow Improvements**:
   - Enhanced the GitHub Actions workflow to properly handle authentication
   - Added better error handling and debugging output

### Deployment Process

To deploy to your Salesforce org:

1. Ensure you have the proper SFDX auth URL in your repository secrets
2. Push changes to the main branch
3. The GitHub Actions workflow will automatically deploy to your target org

### Manual Deployment

If you need to deploy manually:

```bash
# Store authentication
sfdx force:auth:sfdxurl:store -f sfdx_auth_url.txt -a targetOrg

# Deploy source code
sf project deploy start --source-dir force-app --target-org ScaleGuard --test-level RunLocalTests --wait 20
```

## Project Structure

- `force-app/` - Main Salesforce source code
- `.github/workflows/` - GitHub Actions deployment workflow
- `config/` - Configuration files
- `scripts/` - Utility scripts

## Getting Started

1. Clone this repository
2. Install Salesforce CLI tools
3. Configure your org authentication
4. Deploy using the provided workflow or manual commands
