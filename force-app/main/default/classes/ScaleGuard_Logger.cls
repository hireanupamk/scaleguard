/**
 * @description Nebula Logger integration for ScaleGuard structured logging
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_Logger {
    
    /**
     * @description Log an informational message with structured data
     * @param component The component that generated the log
     * @param message The message to log
     * @param correlationId The correlation ID for tracking
     * @param data Additional structured data to log (optional)
     */
    public static void logInfo(String component, String message, String correlationId, Map<String, Object> data) {
        String structuredMessage = buildStructuredMessage(message, data);
        ScaleGuard_Observability.logInfo(structuredMessage, correlationId, component);
    }
    
    /**
     * @description Log a warning message with structured data
     * @param component The component that generated the log
     * @param message The message to log
     * @param correlationId The correlation ID for tracking
     * @param data Additional structured data to log (optional)
     */
    public static void logWarning(String component, String message, String correlationId, Map<String, Object> data) {
        String structuredMessage = buildStructuredMessage(message, data);
        ScaleGuard_Observability.logWarning(structuredMessage, correlationId, component);
    }
    
    /**
     * @description Log an error message with structured data and stack trace
     * @param component The component that generated the log
     * @param message The message to log
     * @param correlationId The correlation ID for tracking
     * @param stackTrace The stack trace for debugging (optional)
     * @param data Additional structured data to log (optional)
     */
    public static void logError(String component, String message, String correlationId, String stackTrace, Map<String, Object> data) {
        String structuredMessage = buildStructuredMessage(message, data);
        ScaleGuard_Observability.logError(structuredMessage, correlationId, component, stackTrace);
    }
    
    /**
     * @description Log an execution event with structured data
     * @param jobId The ID of the job being executed
     * @param status The execution status
     * @param correlationId The correlation ID for tracking
     * @param errorMessage Any error message if execution failed
     * @param data Additional structured data to log (optional)
     */
    public static void logExecution(String jobId, String status, String correlationId, String errorMessage, Map<String, Object> data) {
        // Create a structured message for execution events
        String structuredMessage = buildStructuredMessage('Job execution: ' + status, data);
        ScaleGuard_Observability.logExecution(jobId, status, correlationId, structuredMessage);
    }
    
    /**
     * @description Builds a structured message from a base message and additional data
     * @param baseMessage The base message
     * @param data Additional structured data to include
     * @return The structured message string
     */
    private static String buildStructuredMessage(String baseMessage, Map<String, Object> data) {
        if (data == null || data.isEmpty()) {
            return baseMessage;
        }
        
        // Build structured data portion
        String structuredData = '';
        for (String key : data.keySet()) {
            if (structuredData != '') {
                structuredData += '; ';
            }
            structuredData += key + '=' + String.valueOf(data.get(key));
        }
        
        return baseMessage + ' | ' + structuredData;
    }
}
