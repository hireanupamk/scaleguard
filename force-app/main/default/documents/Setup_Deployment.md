# ScaleGuard - Setup & Deployment

## Installation Guide

### Prerequisites
- Salesforce Org (Developer, Sandbox, or Production)
- Salesforce DX CLI installed
- Admin permissions in the target org
- Internet access for package installation

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/hireanupamk/ScaleGuar.git
   cd ScaleGuard
   ```

2. **Authorize Your Org**
   ```bash
   sf org login web -d -a ScaleGuardDev
   ```

3. **Deploy Metadata**
   ```bash
   sf deploy metadata -p force-app
   ```

4. **Deploy Demo Data**
   ```bash
   sf apex run -c "ScaleGuard_DemoDataLoader.run()"
   ```

5. **Verify Installation**
   - Check that all custom objects, classes, and components are deployed
   - Verify that demo data has been loaded
   - Confirm that all permission sets are assigned

### Salesforce DX Project Structure

```
ScaleGuard/
├── force-app/
│   ├── main/
│   │   ├── default/
│   │   │   ├── classes/           # Apex classes
│   │   │   ├── lwc/               # Lightning Web Components
│   │   │   ├── objects/           # Custom objects
│   │   │   ├── triggers/          # Triggers
│   │   │   ├── customMetadata/    # Custom metadata types
│   │   │   ├── permissionsets/    # Permission sets
│   │   │   └── documents/         # Documentation files
│   │   └── package.xml            # Package manifest
│   └── unpackaged/                # Unmanaged metadata
├── config/
│   └── project-scratch-def.json   # Scratch org definition
├── package.json                   # Node.js dependencies
└── README.md                      # Project overview
```

## Environment Setup

### Development Environment
1. Create a scratch org:
   ```bash
   sf org create scratch -f config/project-scratch-def.json -a ScaleGuardDev
   ```

2. Deploy to scratch org:
   ```bash
   sf deploy metadata -p force-app -o ScaleGuardDev
   ```

3. Open the org:
   ```bash
   sf org open -o ScaleGuardDev
   ```

### UAT Environment
1. Create a sandbox org
2. Deploy using the same process as development
3. Configure appropriate settings for UAT

### Production Environment
1. Create a production org
2. Deploy using the same process
3. Configure security settings and permissions
4. Set up appropriate monitoring and alerting

## Deployment Procedures

### Standard Deployment Process
1. **Pre-deployment Checks**
   - Run all unit tests
   - Verify code coverage meets requirements
   - Check for any compilation errors

2. **Deployment Steps**
   ```bash
   # Build and test
   sf test run -t "ScaleGuard_*"
   
   # Deploy to target org
   sf deploy metadata -p force-app -o TargetOrg
   
   # Verify deployment
   sf apex run -c "ScaleGuard_DemoDataLoader.run()" -o TargetOrg
   ```

3. **Post-deployment Verification**
   - Verify all components are functioning
   - Check that demo data is loaded
   - Confirm permission sets are properly assigned

### Rollback Procedures
1. **Revert Metadata Changes**
   ```bash
   sf deploy metadata -p force-app -o TargetOrg --revert
   ```

2. **Restore Demo Data**
   ```bash
   sf apex run -c "ScaleGuard_DemoDataLoader.run()" -o TargetOrg
   ```

3. **Rollback Permissions**
   - Revert permission set assignments
   - Restore previous security settings

## Configuration Management

### Metadata Configuration
ScaleGuard uses custom metadata types for flexible configuration:

1. **ScaleGuard_Job__mdt** - Job configurations
2. **ScaleGuard_TriggerConfig__mdt** - Trigger configurations  
3. **ScaleGuard_Schedule__mdt** - Scheduling configurations

### Permission Sets
All features are controlled through permission sets:
- `ScaleGuard_Admin` - Full administrative access
- `ScaleGuard_User` - Standard user access
- `ScaleGuard_Observability` - Logging and observability access

### Custom Settings
- `ScaleGuard_Settings__c` - Global configuration settings
- `ScaleGuard_Logging__c` - Logging configuration
