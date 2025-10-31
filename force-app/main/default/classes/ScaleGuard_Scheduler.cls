/**
 * @description Schedulable class for ScaleGuard job scheduling
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_Scheduler implements Schedulable {
    
    /**
     * @description Main schedule method that executes scheduled jobs
     * @param sc The schedulable context
     */
    public void execute(SchedulableContext sc) {
        System.debug('ScaleGuard_Scheduler: execute method called');
        
        // Log the scheduler execution
        String correlationId = ScaleGuard_Correlation.getCorrelationId();
        Map<String, Object> logData = new Map<String, Object>();
        logData.put('schedulableContext', sc.toString());
        ScaleGuard_Logger.logInfo(
            'ScaleGuard_Scheduler', 
            'Scheduler executed', 
            correlationId, 
            logData
        );
        
        try {
            // Get all scheduled jobs from custom metadata
            List<ScaleGuard_Schedule__mdt> schedules = [
                SELECT Id, Name, Job__c, Schedule__c, IsActive__c 
                FROM ScaleGuard_Schedule__mdt 
                WHERE IsActive__c = true
            ];
            
            // Log the number of active schedules found
            ScaleGuard_Observability.logInfo(
                'Found ' + schedules.size() + ' active schedules', 
                correlationId, 
                'ScaleGuard_Scheduler'
            );
            
            // Process each schedule
            for (ScaleGuard_Schedule__mdt schedule : schedules) {
                // Check if schedule is due to run
                if (isScheduleDue(schedule.Schedule__c)) {
                    // Execute the associated job
                    executeScheduledJob(schedule.Job__c, correlationId);
                }
            }
            
            ScaleGuard_Observability.logInfo(
                'ScaleGuard_Scheduler completed successfully', 
                correlationId, 
                'ScaleGuard_Scheduler'
            );
            
        } catch (Exception e) {
            ScaleGuard_Observability.logError(
                'ScaleGuard_Scheduler failed: ' + e.getMessage(), 
                correlationId, 
                'ScaleGuard_Scheduler', 
                e.getStackTraceString()
            );
            throw e;
        }
    }
    
    /**
     * @description Checks if a schedule is due to run
     * @param scheduleCronExpression The cron expression for the schedule
     * @return True if the schedule is due, false otherwise
     */
    private Boolean isScheduleDue(String scheduleCronExpression) {
        // Parse the cron expression and check if it's time to run
        // For simplicity, we'll implement a basic parser for common cron formats
        if (String.isBlank(scheduleCronExpression)) {
            return false;
        }
        
        // Split the cron expression into parts (minute hour day month weekday)
        String[] cronParts = scheduleCronExpression.split('\\s+');
        if (cronParts.length < 5) {
            return false; // Invalid cron expression
        }
        
        // For this demo, we'll just return true to simulate execution
        // In a production implementation, we would parse each part and check against current time
        return true;
    }
    
    /**
     * @description Executes a scheduled job
     * @param jobName The name of the job to execute
     * @param correlationId The correlation ID for tracking
     */
    private void executeScheduledJob(String jobName, String correlationId) {
        try {
            // Find the job definition
            ScaleGuard_Job__mdt job = [
                SELECT Id, Name, JobType__c, ApexClass__c 
                FROM ScaleGuard_Job__mdt 
                WHERE Name = :jobName 
                LIMIT 1
            ];
            
            if (job != null) {
                // Log job execution
                ScaleGuard_Observability.logInfo(
                    'Executing scheduled job: ' + job.Name, 
                    correlationId, 
                    'ScaleGuard_Scheduler'
                );
                
                // Execute the job using the orchestrator
                ScaleGuard_Orchestrator.executeJob(job, new Map<String, Object>());
                
                ScaleGuard_Observability.logInfo(
                    'Scheduled job executed successfully: ' + job.Name, 
                    correlationId, 
                    'ScaleGuard_Scheduler'
                );
            } else {
                ScaleGuard_Observability.logWarning(
                    'Scheduled job not found: ' + jobName, 
                    correlationId, 
                    'ScaleGuard_Scheduler'
                );
            }
            
        } catch (Exception e) {
            ScaleGuard_Observability.logError(
                'Failed to execute scheduled job ' + jobName + ': ' + e.getMessage(), 
                correlationId, 
                'ScaleGuard_Scheduler', 
                e.getStackTraceString()
            );
            throw e;
        }
    }
}
