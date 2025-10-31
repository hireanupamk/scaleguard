/**
 * @description Utility class for correlation ID generation and management
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_Correlation {
    
    /**
     * @description Generates a new correlation ID
     * @return A unique correlation ID string
     */
    public static String generateCorrelationId() {
        return 'SG-' + String.valueOf(System.currentTimeMillis()) + '-' + String.valueOf(Math.abs(System.rand()));
    }
    
    /**
     * @description Gets the current correlation ID from the context
     * @return The current correlation ID or a new one if none exists
     */
    public static String getCorrelationId() {
        // In a real implementation, this would retrieve the correlation ID from context
        // For now, we'll generate a new one for each call to simplify the demo
        return generateCorrelationId();
    }
}
