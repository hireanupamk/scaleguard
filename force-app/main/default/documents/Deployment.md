# ScaleGuard Deployment Guide

This document provides comprehensive instructions for deploying and setting up the ScaleGuard platform in a Salesforce org.

## Overview

ScaleGuard is a next-generation Salesforce automation and observability platform designed for enterprise organizations. This guide covers the complete deployment process, prerequisites, and setup instructions.

## Prerequisites

### Salesforce Org Requirements
- Salesforce DX enabled org
- Developer Edition or higher org
- Permission to create custom objects, metadata, and platform events
- Admin rights for deployment and configuration

### Development Tools
- Salesforce CLI (sf) installed and configured
- Visual Studio Code with Salesforce Extensions
- Git for source control

## Deployment Steps

### 1. Clone the Repository
```bash
git clone https://github.com/hireanupamk/ScaleGuar.git
cd ScaleGuar
```

### 2. Create Scratch Org
```bash
sf org create scratch -f config/project-scratch-def.json -a ScaleGuardScratchOrg
```

### 3. Push Source to Org
```bash
sf project deploy start
```

### 4. Load Sample Data
```bash
sf apex run -l ScaleGuard_DemoDataLoader.loadAllDemoData
```

### 5. Configure Custom Metadata
The trigger orchestration requires configuration in custom metadata. The default configuration is included in the deployment, but you may need to adjust based on your specific requirements.

## Configuration

### Trigger Orchestration Configuration
The trigger orchestration system uses custom metadata to configure handler execution. The default configuration includes:

1. **ScaleGuard_TriggerConfig__mdt** - Contains configuration for trigger handlers
2. **Object_API_Name__c** - The Salesforce object this configuration applies to
3. **Trigger_Event__c** - The trigger event (Before Insert, After Update, etc.)
4. **Handler_Class__c** - The class name of the trigger handler
5. **Execution_Order__c** - Priority order for execution (ascending)
6. **Is_Active__c** - Whether this configuration is active
7. **Can_Bypass__c** - Whether this handler can be bypassed

### Permission Sets
The following permission sets are created during deployment:

- **SG_TriggerOrchestration_Read** - Read access to trigger orchestration
- **SG_TriggerOrchestration_Write** - Write access to trigger orchestration
- **SG_Observability_Read** - Read access to observability components
- **SG_Observability_Full** - Full access to observability components
- **SG_IncidentManagement_Read** - Read access to incident management
- **SG_IncidentManagement_Execute** - Execute access to incident management
- **SG_AutomationStudio_Read** - Read access to Automation Studio
- **SG_AutomationStudio_Write** - Write access to Automation Studio
- **SG_DemoData_Read** - Read access to demo data
- **SG_DemoData_Execute** - Execute access to demo data

## Platform Events Setup

ScaleGuard uses two platform events for observability:

1. **SG_LogEvent__e** - For structured logging
2. **SG_ExecutionEvent__e** - For execution tracking

These events are automatically created during deployment. Ensure that platform event subscriptions are properly configured if using external integrations.

## Custom Objects

### SG_Job__c
Stores information about job executions:
- Name (Text)
- Status__c (Picklist: Success, Failed, Running)
- JobType__c (Picklist: Batch, Queueable, Trigger)
- ExecutionTime__c (Number)
- StartedAt__c (DateTime)
- CompletedAt__c (DateTime)

### SG_Incident__c (Conceptual)
Custom object for incident tracking (not implemented in current version):
- CorrelationId__c (Text)
- Priority__c (Picklist)
- Category__c (Picklist)
- Status__c (Picklist)
- TicketId__c (Text)

## Testing

### Running Tests
```bash
sf apex test run -w 10
```

### Test Coverage
All Apex classes have test coverage of at least 75%. Run the following to verify:
```bash
sf apex test run -w 10 --code-coverage
```

### Manual Testing
1. Verify that trigger orchestration works correctly
2. Test observability dashboard functionality
3. Validate incident management workflows
4. Check that demo data loads properly
5. Confirm all permission sets are correctly assigned

## Security Considerations

### Field-Level Security
All logging respects field-level security. Ensure appropriate field-level security is configured on:
- SG_Job__c fields
- SG_LogEvent__e fields
- SG_ExecutionEvent__e fields

### Permission Sets
- Assign appropriate permission sets based on user roles
- Do not grant "View All Data" or "Modify All Data" permissions
- Regular review of permission set assignments is recommended

### Data Privacy
- No sensitive data is stored in logs
- Correlation IDs are securely generated
- All logging follows data privacy regulations

## Troubleshooting

### Common Issues

#### 1. Deployment Errors
If you encounter deployment errors, check:
- That all required dependencies are deployed
- That custom metadata configurations are correct
- That platform events are properly defined

#### 2. Trigger Not Firing
Verify:
- That the trigger is enabled on the object
- That the custom metadata configuration is active
- That appropriate permissions are granted

#### 3. Dashboard Not Showing Data
Check:
- That platform events are firing correctly
- That components are subscribed to the correct events
- That appropriate permissions are granted

#### 4. Demo Data Loading Issues
Ensure:
- That the demo data loader class has execute permissions
- That the org has sufficient governor limits for bulk operations

### Debugging Tips

1. Use the Salesforce Developer Console to inspect logs
2. Check platform event subscriptions in Setup
3. Verify custom metadata configurations in the org
4. Review component console logs in the browser developer tools

## Maintenance

### Regular Updates
- Review and update custom metadata configurations as needed
- Monitor test coverage and add new tests for new features
- Update documentation with any changes to the system

### Performance Monitoring
- Monitor governor limits during heavy usage
- Review dashboard performance regularly
- Optimize queries if performance degrades

### Backup Strategy
- Regular backups of custom metadata configurations
- Maintain source code in version control
- Document any customizations for future upgrades

## Upgrade Path

### Version Compatibility
ScaleGuard follows Salesforce DX best practices for version compatibility. When upgrading:
1. Review release notes for breaking changes
2. Test thoroughly in a sandbox environment
3. Update custom metadata configurations if needed
4. Run all tests to ensure compatibility

### Migration Steps
1. Backup current configuration and data
2. Deploy new version to sandbox
3. Test thoroughly in sandbox
4. Deploy to production
5. Validate all functionality

## Support

### Contact Information
For support with ScaleGuard, contact:
- **Lead Developer**: [Name] - [Email]
- **QA Engineer**: [Name] - [Email]
- **Technical Writer**: [Name] - [Email]

### Resources
- Documentation: [URL to documentation]
- GitHub Repository: [URL to repository]
- Community Forum: [URL to forum]

## Appendix: Useful Commands

### Salesforce CLI Commands
```bash
# Create scratch org
sf org create scratch -f config/project-scratch-def.json -a ScaleGuardScratchOrg

# Deploy source
sf project deploy start

# Run tests
sf apex test run -w 10

# Open org
sf org open

# Run demo data loader
sf apex run -l ScaleGuard_DemoDataLoader.loadAllDemoData

# Check code coverage
sf apex test run -w 10 --code-coverage
```

### Apex Class Commands
```bash
# Run specific class
sf apex run -l ScaleGuard_DemoDataLoader.loadAllDemoData

# Execute anonymous apex
sf apex run -f path/to/script.apex
```

### Metadata Commands
```bash
# Retrieve metadata
sf project retrieve start -m CustomObject -m CustomMetadata -m PlatformEvent

# Deploy metadata
sf project deploy start -m CustomObject -m CustomMetadata -m PlatformEvent
