# ScaleGuard Permission Sets

This document describes the permission sets created for the ScaleGuard platform to manage access to various components and features.

## Overview

ScaleGuard implements a granular permission model using Salesforce permission sets to control access to its various components. Each permission set follows the naming convention `[AppPrefix]_[Component]_[AccessLevel]` where:

- **AppPrefix**: SG (ScaleGuard)
- **Component**: Descriptive component name (e.g., TriggerOrchestration, Observability, IncidentManagement)
- **AccessLevel**: Read, Write, Full, Execute, Admin

## Permission Sets

### Trigger Orchestration

#### SG_TriggerOrchestration_Read
- **Description**: Allows read access to trigger orchestration components
- **Components**: 
  - ScaleGuard_TriggerConfig__mdt (Custom Metadata Type)
  - AccountTrigger (Trigger)
- **Access Level**: Read

#### SG_TriggerOrchestration_Write
- **Description**: Allows write access to trigger orchestration configuration
- **Components**:
  - ScaleGuard_TriggerConfig__mdt (Custom Metadata Type)
- **Access Level**: Write

### Observability Engine

#### SG_Observability_Read
- **Description**: Allows read access to observability components
- **Components**:
  - SG_Job__c (Custom Object)
  - SG_LogEvent__e (Platform Event)
  - SG_ExecutionEvent__e (Platform Event)
- **Access Level**: Read

#### SG_Observability_Full
- **Description**: Full access to observability components
- **Components**:
  - SG_Job__c (Custom Object)
  - SG_LogEvent__e (Platform Event)
  - SG_ExecutionEvent__e (Platform Event)
- **Access Level**: Full

### Incident Management

#### SG_IncidentManagement_Read
- **Description**: Allows read access to incident management components
- **Components**:
  - SG_Incident__c (Custom Object)
  - SG_LogEvent__e (Platform Event)
- **Access Level**: Read

#### SG_IncidentManagement_Execute
- **Description**: Allows execution of incident management workflows
- **Components**:
  - SG_Incident__c (Custom Object)
  - ScaleGuard_IncidentManager.cls (Apex Class)
  - ScaleGuard_AI_Triage.cls (Apex Class)
- **Access Level**: Execute

### Automation Studio

#### SG_AutomationStudio_Read
- **Description**: Allows read access to Automation Studio components
- **Components**:
  - ScaleGuard_Job__c (Custom Object)
  - ScaleGuard_TriggerConfig__mdt (Custom Metadata Type)
- **Access Level**: Read

#### SG_AutomationStudio_Write
- **Description**: Allows write access to Automation Studio components
- **Components**:
  - ScaleGuard_Job__c (Custom Object)
  - ScaleGuard_TriggerConfig__mdt (Custom Metadata Type)
- **Access Level**: Write

### Demo Data Management

#### SG_DemoData_Read
- **Description**: Allows read access to demo data components
- **Components**:
  - ScaleGuard_DemoDataLoader.cls (Apex Class)
- **Access Level**: Read

#### SG_DemoData_Execute
- **Description**: Allows execution of demo data loading
- **Components**:
  - ScaleGuard_DemoDataLoader.cls (Apex Class)
- **Access Level**: Execute

## Permission Set Groups

### ScaleGuard_Administrators
- **Components**:
  - SG_TriggerOrchestration_Full
  - SG_Observability_Full
  - SG_IncidentManagement_Full
  - SG_AutomationStudio_Write
  - SG_DemoData_Execute
- **Description**: Full administrative access to all ScaleGuard components

### ScaleGuard_Observers
- **Components**:
  - SG_Observability_Read
  - SG_IncidentManagement_Read
  - SG_AutomationStudio_Read
- **Description**: Read-only access to monitoring and observability components

### ScaleGuard_Configurators
- **Components**:
  - SG_TriggerOrchestration_Write
  - SG_AutomationStudio_Write
- **Description**: Ability to configure trigger orchestration and automation workflows

## Assignment Recommendations

1. **System Administrators**: Assign the ScaleGuard_Administrators group
2. **Operations Teams**: Assign the ScaleGuard_Observers group  
3. **DevOps Engineers**: Assign the ScaleGuard_Configurators group
4. **Support Staff**: Assign the ScaleGuard_Observers group

## Security Considerations

- All permission sets follow the principle of least privilege
- No permission sets grant "View All Data" or "Modify All Data" permissions
- Field-level security is respected across all components
- Audit logging is implemented for all permission set assignments
- Regular review of permission set assignments is recommended

## Testing Validation

All permission sets have been tested to ensure:
- Correct field-level security enforcement
- Appropriate CRUD permissions for each component
- No cross-component permission leakage
- Proper assignment to user profiles and roles
