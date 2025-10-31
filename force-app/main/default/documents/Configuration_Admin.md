# ScaleGuard - Configuration & Admin Guide

## Metadata Configuration

### Job Configuration (ScaleGuard_Job__mdt)
Configure automation jobs through the custom metadata type:

1. **Job Name**: Unique identifier for the job
2. **Job Type**: Select from available job types (Batch, Queueable, Trigger, Flow)
3. **Active Status**: Enable/disable job execution
4. **Schedule**: Define cron expressions for scheduled execution
5. **Dependencies**: Specify job dependencies for sequential execution
6. **Error Handling**: Configure retry logic and error notifications

### Trigger Configuration (ScaleGuard_TriggerConfig__mdt)
Define trigger behavior through metadata:

1. **Object**: Target object for the trigger
2. **Trigger Events**: Select before/after insert/update/delete
3. **Handler Class**: Specify the handler class to execute
4. **Order**: Execution order in the trigger chain
5. **Active Status**: Enable/disable trigger execution

### Schedule Configuration (ScaleGuard_Schedule__mdt)
Manage scheduling through metadata:

1. **Schedule Name**: Unique schedule identifier
2. **Cron Expression**: Standard cron syntax for scheduling
3. **Start Date/Time**: When the schedule begins
4. **End Date/Time**: When the schedule ends (optional)
5. **Active Status**: Enable/disable schedule

## Permission Sets

### ScaleGuard_Admin
- Full access to all ScaleGuard features
- Administrative controls for jobs, triggers, and configurations
- View and modify all custom objects
- Access to all LWC components

### ScaleGuard_User
- Standard access to ScaleGuard features
- View and use automation studio
- Access to observability dashboards
- Limited configuration capabilities

### ScaleGuard_Observability
- Access to logging and observability features
- View logs and traces
- Access to health dashboards
- No administrative privileges

### Permission Set Assignment
1. Navigate to Setup → Permission Sets
2. Select the appropriate permission set
3. Click "Manage Assignments"
4. Assign to users who need access

## User Role Matrix

| Role | ScaleGuard_Admin | ScaleGuard_User | ScaleGuard_Observability |
|------|------------------|-----------------|--------------------------|
| System Administrator | ✓ | ✗ | ✗ |
| Operations Manager | ✓ | ✓ | ✓ |
| Developer | ✓ | ✓ | ✓ |
| Analyst | ✗ | ✓ | ✓ |
| Support Agent | ✗ | ✓ | ✓ |

## Admin Onboarding Wizard

### Step 1: Initial Setup
1. Install the ScaleGuard package
2. Assign appropriate permission sets to administrators
3. Configure basic settings in ScaleGuard_Settings__c

### Step 2: Configuration
1. Define job configurations using ScaleGuard_Job__mdt
2. Configure trigger behaviors in ScaleGuard_TriggerConfig__mdt
3. Set up scheduling in ScaleGuard_Schedule__mdt

### Step 3: Validation
1. Run test jobs to verify configuration
2. Check log generation and observability
3. Verify incident management workflows

### Step 4: Training
1. Provide training to end users
2. Document customizations
3. Set up monitoring and alerts

## Custom Settings

### ScaleGuard_Settings__c
Global configuration settings:

1. **Logging Level**: Set default log level (DEBUG, INFO, WARN, ERROR)
2. **Observability Enabled**: Toggle observability features
3. **Incident Threshold**: Define incident detection thresholds
4. **Demo Data Enabled**: Control demo data loading

### ScaleGuard_Logging__c
Logging-specific settings:

1. **Log Retention Days**: Number of days to retain logs
2. **Max Log Size**: Maximum size of log entries
3. **Correlation ID Length**: Length of generated correlation IDs
4. **Structured Logging**: Enable/disable structured logging format

## Best Practices

### Configuration Management
- Use custom metadata for flexible configuration
- Document all configuration changes
- Implement version control for metadata
- Test configurations in sandbox before production

### Security Considerations
- Assign minimum required permissions
- Regular review of permission set assignments
- Monitor access logs for unauthorized changes
- Implement proper field-level security

### Performance Optimization
- Optimize cron expressions for efficient scheduling
- Monitor job execution times
- Review and tune logging levels
- Implement proper error handling in jobs
