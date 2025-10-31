/**
 * @description Sample batch class for ScaleGuard demo that implements the IScaleGuardJob interface
 * @author ScaleGuard Team
 */
public with sharing class DemoBatch implements Database.Batchable<sObject>, IScaleGuardJob {
    
    /**
     * @description Start method for the batch job
     * @param scope The scope of records to process
     * @return The iterable of records to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('DemoBatch: start method called');
        
        // Log the start of batch job execution
        String correlationId = ScaleGuard_Correlation.getCorrelationId();
        ScaleGuard_Observability.logInfo(
            'DemoBatch start method called', 
            correlationId, 
            'DemoBatch'
        );
        
        try {
            // For demo purposes, we'll query all accounts
            Database.QueryLocator locator = Database.getQueryLocator([SELECT Id, Name FROM Account LIMIT 100]);
            ScaleGuard_Observability.logInfo(
                'DemoBatch query completed successfully', 
                correlationId, 
                'DemoBatch'
            );
            return locator;
        } catch(Exception ex) {
            ScaleGuard_Observability.logError(
                'DemoBatch start method failed', 
                correlationId, 
                'DemoBatch', 
                ex.getStackTraceString()
            );
            throw ex;
        }
    }
    
    /**
     * @description Execute method for the batch job
     * @param bc The batch context
     * @param records The records to process
     */
    public void execute(Database.BatchableContext bc, List<sObject> records) {
        System.debug('DemoBatch: execute method called with ' + records.size() + ' records');
        
        // Log the execution
        String correlationId = ScaleGuard_Correlation.getCorrelationId();
        Map<String, Object> logData = new Map<String, Object>();
        logData.put('recordsProcessed', records.size());
        ScaleGuard_Logger.logInfo(
            'DemoBatch', 
            'Executed batch job', 
            correlationId, 
            logData
        );
        
        try {
            // Process the records (demo: just log them)
            for (SObject record : records) {
                Account acc = (Account) record;
                System.debug('Processing account: ' + acc.Name);
            }
            
            // Simulate some work
            System.sleep(100);
            
            ScaleGuard_Observability.logInfo(
                'DemoBatch completed processing ' + records.size() + ' records', 
                correlationId, 
                'DemoBatch'
            );
        } catch(Exception ex) {
            ScaleGuard_Observability.logError(
                'DemoBatch execute method failed', 
                correlationId, 
                'DemoBatch', 
                ex.getStackTraceString()
            );
            throw ex;
        }
    }
    
    /**
     * @description Finish method for the batch job
     * @param bc The batch context
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('DemoBatch: finish method called');
        
        // Log the completion
        String correlationId = ScaleGuard_Correlation.getCorrelationId();
        try {
            ScaleGuard_Observability.logInfo(
                'DemoBatch finished processing', 
                correlationId, 
                'DemoBatch'
            );
        } catch(Exception ex) {
            ScaleGuard_Observability.logError(
                'DemoBatch finish method failed', 
                correlationId, 
                'DemoBatch', 
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
        System.debug('DemoBatch: executeJob method called');
        
        // For demo purposes, just return a simple message
        return 'DemoBatch executed successfully';
    }
}
