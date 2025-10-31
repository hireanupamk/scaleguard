/**
 * @description Sample queueable class for ScaleGuard demo that implements the IScaleGuardJob interface
 * @author ScaleGuard Team
 */
public with sharing class DemoQueueable implements Queueable, IScaleGuardJob {
    
    /**
     * @description Constructor for the queueable job
     */
    public DemoQueueable() {
        System.debug('DemoQueueable: constructor called');
    }
    
    /**
     * @description Execute method for the queueable job
     * @param context The queueable context
     */
    public void execute(QueueableContext context) {
        System.debug('DemoQueueable: execute method called');
        
        // Log the start of queueable job execution
        String correlationId = ScaleGuard_Correlation.getCorrelationId();
        ScaleGuard_Observability.logInfo(
            'DemoQueueable execute method called', 
            correlationId, 
            'DemoQueueable'
        );
        
        try {
            // Log the execution
            Map<String, Object> logData = new Map<String, Object>();
            logData.put('queueableContext', context.toString());
            ScaleGuard_Logger.logInfo(
                'DemoQueueable', 
                'Executed queueable job', 
                correlationId, 
                logData
            );
            
            // Simulate some work
            System.sleep(500);
            
            // Process some demo data
            List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
            System.debug('Processing ' + accounts.size() + ' accounts');
            
            // Log completion
            ScaleGuard_Observability.logInfo(
                'DemoQueueable completed processing ' + accounts.size() + ' accounts', 
                correlationId, 
                'DemoQueueable'
            );
        } catch(Exception ex) {
            ScaleGuard_Observability.logError(
                'DemoQueueable execute method failed', 
                correlationId, 
                'DemoQueueable', 
                ex.getStackTraceString()
            );
            throw ex;
        }
    }
    
    /**
     * @description Execute method for the ScaleGuard job interface
     * @param parameters Parameters for the job execution
     * @return The result of the execution
     */
    public String executeJob(Map<String, Object> parameters) {
        System.debug('DemoQueueable: executeJob method called');
        
        // For demo purposes, just return a simple message
        return 'DemoQueueable executed successfully';
    }
}
