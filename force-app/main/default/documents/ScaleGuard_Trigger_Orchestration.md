# ScaleGuard Trigger Orchestration

## Overview
ScaleGuard provides metadata-driven trigger orchestration that allows administrators to configure the order of execution for trigger handlers, enable bypass logic, and manage trigger behavior through custom metadata rather than hard-coded logic.

## Key Components

### 1. IScaleGuardTriggerHandler Interface
Defines the contract that all trigger handlers must implement:
- `execute(Trigger.Context triggerContext, String correlationId)` - Main execution logic
- `shouldExecute(Trigger.Context triggerContext)` - Determines if handler should run
- `getExecutionOrder()` - Returns execution priority (lower numbers execute first)
- `canBeBypassed()` - Indicates if handler can be bypassed under certain conditions

### 2. ScaleGuard_TriggerOrchestrator Class
Manages the execution of trigger handlers based on metadata configuration:
- Retrieves active trigger configurations from custom metadata
- Executes handlers in the configured order
- Handles bypass logic
- Implements proper error handling and logging

### 3. Custom Metadata Type: ScaleGuard_TriggerConfig__mdt
Stores configuration for trigger handlers:
- **Object_API_Name__c**: The Salesforce object this configuration applies to
- **Trigger_Event__c**: The trigger event (Before Insert, After Update, etc.)
- **Handler_Class__c**: The class name of the trigger handler
- **Execution_Order__c**: Priority order for execution (ascending)
- **Is_Active__c**: Whether this configuration is active
- **Can_Bypass__c**: Whether this handler can be bypassed

### 4. Demo Trigger Handler: DemoTriggerHandler
A sample implementation demonstrating how to create trigger handlers that conform to the interface.

### 5. AccountTrigger
The main trigger that delegates to the orchestrator based on the trigger context.

## How It Works

1. When a trigger event occurs (e.g., Account before insert), the AccountTrigger fires
2. The trigger determines the event type and passes control to ScaleGuard_TriggerOrchestrator
3. The orchestrator retrieves all active configurations for that object and event from custom metadata
4. Handlers are sorted by execution order and executed sequentially
5. Each handler's `shouldExecute()` method is called to determine if it should run
6. If bypass is enabled and allowed, the handler can be skipped
7. The handler's `execute()` method is called with the trigger context and correlation ID
8. All operations are logged using the ScaleGuard_Logger for observability

## Benefits

- **Flexibility**: Change trigger execution order without code changes
- **Maintainability**: Centralized configuration in metadata
- **Control**: Enable/disable handlers and bypass logic through configuration
- **Observability**: Full logging and correlation ID tracking across all executions
- **Security**: Proper separation of concerns with interface-based design

## Implementation Notes

- All trigger handlers must implement IScaleGuardTriggerHandler
- Custom metadata configurations are used to drive execution order
- Bypass logic can be extended to check permissions, conditions, or other criteria
- Error handling ensures that failures in one handler don't prevent others from running
- Logging provides complete traceability through correlation IDs
