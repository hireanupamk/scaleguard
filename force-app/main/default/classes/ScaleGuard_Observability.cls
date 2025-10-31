/**
 * @description Utility class for structured logging and observability in ScaleGuard
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_Observability {
    
    /**
     * @description Logs a message to the platform event for observability
     * @param message The message to log
     * @param severity The severity level (INFO, WARN, ERROR)
     * @param correlationId The correlation ID for tracking
     * @param component The component that generated the log
     */
    public static void logMessage(String message, String severity, String correlationId, String component) {
        // Create the log event
        SG_LogEvent__e logEvent = new SG_LogEvent__e(
            Message__c = message,
            Severity__c = severity,
            CorrelationId__c = correlationId,
            Component__c = component,
            Timestamp__c = System.now()
        );
        
        // Fire the event
        System.debug('Firing log event: ' + message);
        EventBus.publish(logEvent);
    }
    
    /**
     * @description Logs an execution event for tracking job execution
     * @param jobId The ID of the job being executed
     * @param status The execution status
     * @param correlationId The correlation ID for tracking
     * @param errorMessage Any error message if execution failed
     */
    public static void logExecution(String jobId, String status, String correlationId, String errorMessage) {
        // Create the execution event
        SG_ExecutionEvent__e execEvent = new SG_ExecutionEvent__e(
            JobId__c = jobId,
            Status__c = status,
            CorrelationId__c = correlationId,
            ErrorMessage__c = errorMessage,
            Timestamp__c = System.now()
        );
        
        // Fire the event
        System.debug('Firing execution event for job: ' + jobId);
        EventBus.publish(execEvent);
    }
    
    /**
     * @description Logs an error with full context for debugging
     * @param message The error message
     * @param correlationId The correlation ID for tracking
     * @param component The component that generated the error
     * @param stackTrace The stack trace for debugging
     */
    public static void logError(String message, String correlationId, String component, String stackTrace) {
        logMessage(message, 'ERROR', correlationId, component);
        
        // Also log to audit log if needed
        // This is a simplified version - in a real implementation, you'd want to store
        // error details in the SG_AuditLog__c object
        System.debug('ScaleGuard Error: ' + message);
    }
    
    /**
     * @description Logs a warning message
     * @param message The warning message
     * @param correlationId The correlation ID for tracking
     * @param component The component that generated the warning
     */
    public static void logWarning(String message, String correlationId, String component) {
        logMessage(message, 'WARN', correlationId, component);
    }
    
    /**
     * @description Logs an informational message
     * @param message The info message
     * @param correlationId The correlation ID for tracking
     * @param component The component that generated the info
     */
    public static void logInfo(String message, String correlationId, String component) {
        logMessage(message, 'INFO', correlationId, component);
    }
    
    /**
     * @description Gets health metrics for the dashboard
     * @return A map containing health metrics
     */
    public static Map<String, Object> getHealthMetrics() {
        Map<String, Object> metrics = new Map<String, Object>();
        
        // Get total job count
        Integer totalJobs = [SELECT COUNT() FROM SG_Job__c];
        metrics.put('totalJobs', totalJobs);
        
        // Get successful job count
        Integer successfulJobs = [SELECT COUNT() FROM SG_Job__c WHERE Status__c = 'Success'];
        metrics.put('successfulJobs', successfulJobs);
        
        // Get failed job count
        Integer failedJobs = [SELECT COUNT() FROM SG_Job__c WHERE Status__c = 'Failed'];
        metrics.put('failedJobs', failedJobs);
        
        // Get active job count
        Integer activeJobs = [SELECT COUNT() FROM SG_Job__c WHERE Status__c = 'Running'];
        metrics.put('activeJobs', activeJobs);
        
        // Get average execution time (in milliseconds)
        Decimal avgExecutionTime = [SELECT AVG(ExecutionTime__c) FROM SG_Job__c WHERE Status__c = 'Success'];
        metrics.put('avgExecutionTime', avgExecutionTime != null ? Math.round(avgExecutionTime) : 0);
        
        // Get recent errors (last 10)
        List<SG_LogEvent__e> recentErrors = [
            SELECT Message__c, Component__c, CorrelationId__c, Timestamp__c
            FROM SG_LogEvent__e
            WHERE Severity__c = 'ERROR'
            ORDER BY Timestamp__c DESC
            LIMIT 10
        ];
        
        List<Map<String, Object>> recentErrorList = new List<Map<String, Object>>();
        for(SG_LogEvent__e error : recentErrors) {
            Map<String, Object> errorMap = new Map<String, Object>();
            errorMap.put('timestamp', error.Timestamp__c);
            errorMap.put('message', error.Message__c);
            errorMap.put('component', error.Component__c);
            errorMap.put('correlationId', error.CorrelationId__c);
            recentErrorList.add(errorMap);
        }
        metrics.put('recentErrors', recentErrorList);
        
        return metrics;
    }
    
    /**
     * @description Gets logs by correlation ID for traceability
     * @param correlationId The correlation ID to search for
     * @return A list of logs matching the correlation ID
     */
    public static List<SG_LogEvent__e> getLogsByCorrelationId(String correlationId) {
        return [
            SELECT Id, Message__c, Severity__c, Component__c, Timestamp__c, CorrelationId__c
            FROM SG_LogEvent__e
            WHERE CorrelationId__c = :correlationId
            ORDER BY Timestamp__c ASC
        ];
    }
    
    /**
     * @description Creates a demo failure for testing observability features
     */
    public static void createDemoFailure() {
        // Generate a correlation ID for this demo
        String correlationId = ScaleGuard_Correlation.generateCorrelationId();
        
        // Log a demo error with correlation ID
        ScaleGuard_Logger.logError('Simulated demo failure for testing observability', correlationId, 'DemoDataGenerator', 'This is a simulated error for testing purposes.');
    }
}
