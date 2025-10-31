# ScaleGuard API Documentation

This document provides comprehensive API documentation for the ScaleGuard platform, detailing the key Apex classes and their methods that form the core of the platform's functionality.

## Overview

ScaleGuard exposes several key Apex classes that serve as the foundation for its automation and observability capabilities. These APIs are designed to be modular, well-documented, and follow Salesforce best practices for security and performance.

## Core APIs

### 1. ScaleGuard_TriggerOrchestrator

The `ScaleGuard_TriggerOrchestrator` class is responsible for orchestrating trigger execution based on metadata configurations.

#### Methods

##### executeTrigger(Trigger.Context triggerContext, String objectType, String triggerEvent)
- **Description**: Executes trigger handlers based on metadata configuration
- **Parameters**:
  - `triggerContext`: The Salesforce trigger context
  - `objectType`: The object type being triggered (e.g., "Account")
  - `triggerEvent`: The trigger event type (e.g., "Before Insert")
- **Returns**: None
- **Usage**: Called by triggers to delegate execution to configured handlers

### 2. IScaleGuardTriggerHandler

The `IScaleGuardTriggerHandler` interface defines the contract that all trigger handlers must implement.

#### Methods

##### execute(Trigger.Context triggerContext, String correlationId)
- **Description**: Main execution logic for the trigger handler
- **Parameters**:
  - `triggerContext`: The Salesforce trigger context
  - `correlationId`: Unique identifier for tracking the execution
- **Returns**: None

##### shouldExecute(Trigger.Context triggerContext)
- **Description**: Determines if this handler should run
- **Parameters**:
  - `triggerContext`: The Salesforce trigger context
- **Returns**: Boolean indicating whether the handler should execute

##### getExecutionOrder()
- **Description**: Returns the execution priority for this handler
- **Returns**: Integer representing execution order (lower numbers execute first)

##### canBeBypassed()
- **Description**: Indicates if this handler can be bypassed under certain conditions
- **Returns**: Boolean indicating if bypass is allowed

### 3. ScaleGuard_Observability

The `ScaleGuard_Observability` class provides core observability utilities for monitoring and logging.

#### Methods

##### logMessage(String message, String severity, String correlationId, String component)
- **Description**: Logs a message to the platform event for observability
- **Parameters**:
  - `message`: The message to log
  - `severity`: The severity level (INFO, WARN, ERROR)
  - `correlationId`: The correlation ID for tracking
  - `component`: The component that generated the log
- **Returns**: None

##### logExecution(String jobId, String status, String correlationId, String errorMessage)
- **Description**: Logs an execution event for tracking job execution
- **Parameters**:
  - `jobId`: The ID of the job being executed
  - `status`: The execution status
  - `correlationId`: The correlation ID for tracking
  - `errorMessage`: Any error message if execution failed
- **Returns**: None

##### getHealthMetrics()
- **Description**: Gets health metrics for the dashboard
- **Returns**: A map containing health metrics including job counts, execution times, and recent errors

##### getLogsByCorrelationId(String correlationId)
- **Description**: Gets logs by correlation ID for traceability
- **Parameters**:
  - `correlationId`: The correlation ID to search for
- **Returns**: A list of logs matching the correlation ID

##### createDemoFailure()
- **Description**: Creates a demo failure for testing observability features
- **Returns**: None

### 4. ScaleGuard_Logger

The `ScaleGuard_Logger` class provides structured logging capabilities.

#### Methods

##### logInfo(String component, String message, String correlationId, Map<String, Object> data)
- **Description**: Log an informational message with structured data
- **Parameters**:
  - `component`: The component that generated the log
  - `message`: The message to log
  - `correlationId`: The correlation ID for tracking
  - `data`: Additional structured data to log (optional)
- **Returns**: None

##### logWarning(String component, String message, String correlationId, Map<String, Object> data)
- **Description**: Log a warning message with structured data
- **Parameters**:
  - `component`: The component that generated the log
  - `message`: The message to log
  - `correlationId`: The correlation ID for tracking
  - `data`: Additional structured data to log (optional)
- **Returns**: None

##### logError(String component, String message, String correlationId, String stackTrace, Map<String, Object> data)
- **Description**: Log an error message with structured data and stack trace
- **Parameters**:
  - `component`: The component that generated the log
  - `message`: The message to log
  - `correlationId`: The correlation ID for tracking
  - `stackTrace`: The stack trace for debugging (optional)
  - `data`: Additional structured data to log (optional)
- **Returns**: None

##### logExecution(String jobId, String status, String correlationId, String errorMessage, Map<String, Object> data)
- **Description**: Log an execution event with structured data
- **Parameters**:
  - `jobId`: The ID of the job being executed
  - `status`: The execution status
  - `correlationId`: The correlation ID for tracking
  - `errorMessage`: Any error message if execution failed
  - `data`: Additional structured data to log (optional)
- **Returns**: None

### 5. ScaleGuard_Correlation

The `ScaleGuard_Correlation` class handles correlation ID generation and management.

#### Methods

##### generateCorrelationId()
- **Description**: Generates a new correlation ID
- **Returns**: A unique correlation ID string

##### getCorrelationId()
- **Description**: Gets the current correlation ID from the context
- **Returns**: The current correlation ID or a new one if none exists

### 6. ScaleGuard_AI_Triage

The `ScaleGuard_AI_Triage` class provides mocked AI/ML logic for incident analysis.

#### Methods

##### analyzeErrorLogs(List<SG_LogEvent__e> errorLogs)
- **Description**: Analyzes error logs and assigns priority
- **Parameters**:
  - `errorLogs`: List of error logs to analyze
- **Returns**: Priority level (Critical, High, Medium, Low)

##### categorizeIncident(List<SG_LogEvent__e> errorLogs)
- **Description**: Categorizes incidents based on error logs
- **Parameters**:
  - `errorLogs`: List of error logs to categorize
- **Returns**: Incident category (Data, Integration, Process, Security, Performance)

##### predictResolutionTime(String priority, String category)
- **Description**: Predicts resolution time based on priority and category
- **Parameters**:
  - `priority`: The priority level of the incident
  - `category`: The category of the incident
- **Returns**: Predicted resolution time in hours

### 7. ScaleGuard_IncidentManager

The `ScaleGuard_IncidentManager` class coordinates incident management workflows.

#### Methods

##### processIncident(String correlationId)
- **Description**: Process an incident by analyzing logs, assigning priority, and creating a ticket
- **Parameters**:
  - `correlationId`: The correlation ID to process
- **Returns**: The incident ID if successful, null if failed

## Data Models

### SG_Job__c (Custom Object)
- Stores information about job executions
- Fields: Name, Status__c, JobType__c, ExecutionTime__c, StartedAt__c, CompletedAt__c

### SG_LogEvent__e (Platform Event)
- Platform event for structured logging
- Fields: Message__c, Severity__c, CorrelationId__c, Component__c, Timestamp__c

### SG_ExecutionEvent__e (Platform Event)
- Platform event for execution tracking
- Fields: JobId__c, Status__c, CorrelationId__c, ErrorMessage__c, Timestamp__c

### ScaleGuard_TriggerConfig__mdt (Custom Metadata Type)
- Stores configuration for trigger handlers
- Fields: Object_API_Name__c, Trigger_Event__c, Handler_Class__c, Execution_Order__c, Is_Active__c, Can_Bypass__c

## Usage Examples

### Trigger Handler Implementation
```apex
public with sharing class MyTriggerHandler implements IScaleGuardTriggerHandler {
    public void execute(Trigger.Context triggerContext, String correlationId) {
        // Custom trigger logic here
        ScaleGuard_Logger.logInfo('MyTriggerHandler', 'Executing custom logic', correlationId);
    }
    
    public Boolean shouldExecute(Trigger.Context triggerContext) {
        return true;
    }
    
    public Integer getExecutionOrder() {
        return 1;
    }
    
    public Boolean canBeBypassed() {
        return false;
    }
}
```

### Logging Usage
```apex
// Log an informational message
ScaleGuard_Logger.logInfo('MyComponent', 'Processing account', correlationId);

// Log an error with structured data
Map<String, Object> data = new Map<String, Object>{'accountId' => accountId};
ScaleGuard_Logger.logError('MyComponent', 'Failed to process account', correlationId, null, data);
```

### Observability Usage
```apex
// Get health metrics for dashboard
Map<String, Object> metrics = ScaleGuard_Observability.getHealthMetrics();

// Get logs by correlation ID for traceability
List<SG_LogEvent__e> logs = ScaleGuard_Observability.getLogsByCorrelationId(correlationId);
```

## Security Considerations

- All logging respects field-level security
- No sensitive data is stored in logs
- Proper RBAC through component permissions
- Secure correlation ID handling
- All APIs follow Salesforce security best practices

## Performance Considerations

- All methods are designed to be bulk-safe
- Efficient SOQL queries are used where appropriate
- Platform events are used for scalable messaging
- Proper exception handling prevents cascading failures
