/**
 * @description Orchestrator class for managing metadata-driven trigger execution
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_TriggerOrchestrator {
    
    /**
     * @description Executes trigger handlers based on metadata configuration
     * @param triggerContext The trigger context
     * @param objectType The object type being triggered
     * @param triggerEvent The trigger event type
     */
    public static void executeTrigger(Trigger.Context triggerContext, String objectType, String triggerEvent) {
        String correlationId = ScaleGuard_Correlation.generateCorrelationId();
        
        // Log the start of trigger execution
        ScaleGuard_Logger.logInfo('ScaleGuard_TriggerOrchestrator', 'Executing trigger for ' + objectType + ' - ' + triggerEvent, correlationId);
        
        // Get all active trigger configurations for this object and event
        List<ScaleGuard_TriggerConfig__mdt> triggerConfigs = [
            SELECT Id, Handler_Class__c, Execution_Order__c, Is_Active__c, Can_Bypass__c
            FROM ScaleGuard_TriggerConfig__mdt
            WHERE Object_API_Name__c = :objectType 
            AND Trigger_Event__c = :triggerEvent
            AND Is_Active__c = true
            ORDER BY Execution_Order__c ASC
        ];
        
        // Sort handlers by execution order
        triggerConfigs.sort();
        
        // Execute each handler in order
        for(ScaleGuard_TriggerConfig__mdt config : triggerConfigs) {
            try {
                // Check if this handler can be bypassed
                if(config.Can_Bypass__c && isBypassed(config.Handler_Class__c)) {
                    ScaleGuard_Logger.logInfo('ScaleGuard_TriggerOrchestrator', 'Bypassing handler: ' + config.Handler_Class__c, correlationId);
                    continue;
                }
                
                // Instantiate and execute the handler
                IScaleGuardTriggerHandler handler = (IScaleGuardTriggerHandler) Type.forName(config.Handler_Class__c).newInstance();
                
                if(handler != null) {
                    // Check if handler should execute
                    if(handler.shouldExecute(triggerContext)) {
                        ScaleGuard_Logger.logInfo('ScaleGuard_TriggerOrchestrator', 'Executing handler: ' + config.Handler_Class__c, correlationId);
                        handler.execute(triggerContext, correlationId);
                    } else {
                        ScaleGuard_Logger.logInfo('ScaleGuard_TriggerOrchestrator', 'Handler skipped (shouldExecute returned false): ' + config.Handler_Class__c, correlationId);
                    }
                } else {
                    ScaleGuard_Logger.logError('ScaleGuard_TriggerOrchestrator', 'Failed to instantiate handler: ' + config.Handler_Class__c, correlationId);
                }
            } catch(Exception ex) {
                ScaleGuard_Logger.logError('ScaleGuard_TriggerOrchestrator', 'Error executing handler ' + config.Handler_Class__c + ': ' + ex.getMessage(), correlationId);
                // Re-throw to ensure the trigger fails appropriately
                throw ex;
            }
        }
    }
    
    /**
     * @description Checks if a trigger handler should be bypassed
     * @param handlerClassName The name of the handler class to check
     * @return True if the handler should be bypassed, false otherwise
     */
    private static Boolean isBypassed(String handlerClassName) {
        // This is a simple implementation - in a real scenario, this could check
        // a bypass configuration, user permissions, or other conditions
        ScaleGuard_Logger.logDebug('ScaleGuard_TriggerOrchestrator', 'Checking if handler ' + handlerClassName + ' should be bypassed', null);
        return false; // Default to not bypassed for now
    }
}
