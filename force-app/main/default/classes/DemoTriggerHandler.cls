/**
 * @description Demo trigger handler that implements the IScaleGuardTriggerHandler interface
 * @author ScaleGuard Team
 */
public with sharing class DemoTriggerHandler implements IScaleGuardTriggerHandler {
    
    /**
     * @description Executes the trigger logic
     * @param triggerContext The trigger context
     * @param correlationId The correlation ID for tracking
     */
    public void execute(Trigger.Context triggerContext, String correlationId) {
        ScaleGuard_Logger.logInfo('DemoTriggerHandler', 'Executing demo trigger logic', correlationId);
        
        // Example logic for handling account inserts
        if(triggerContext.isInsert) {
            List<Account> accounts = (List<Account>) triggerContext.new;
            ScaleGuard_Logger.logInfo('DemoTriggerHandler', 'Processing ' + accounts.size() + ' account records', correlationId);
            
            // Add some sample logic - for example, setting a default value
            for(Account acc : accounts) {
                if(String.isBlank(acc.Name)) {
                    acc.Name = 'Unnamed Account';
                }
            }
        }
    }
    
    /**
     * @description Determines if this handler should execute
     * @param triggerContext The trigger context
     * @return True if this handler should execute, false otherwise
     */
    public Boolean shouldExecute(Trigger.Context triggerContext) {
        ScaleGuard_Logger.logDebug('DemoTriggerHandler', 'Checking if handler should execute', null);
        // In a real implementation, this might check conditions like user permissions,
        // org settings, or other business rules
        return true;
    }
    
    /**
     * @description Gets the execution order for this handler
     * @return The execution order number
     */
    public Integer getExecutionOrder() {
        return 1;
    }
    
    /**
     * @description Determines if this handler can be bypassed
     * @return True if this handler can be bypassed, false otherwise
     */
    public Boolean canBeBypassed() {
        return false;
    }
}
