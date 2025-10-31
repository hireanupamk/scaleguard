/**
 * Executor class for running ScaleGuard jobs
 * Responsible for executing different types of jobs based on metadata configuration
 */
public with sharing class ScaleGuard_Executor {
    
    /**
     * Execute a job based on its type and metadata configuration
     * This is the main entry point for job execution
     */
    public static void executeJob(ScaleGuard_Job__mdt jobConfig, Map<String, Object> parameters) {
        String correlationId = ScaleGuard_Correlation.generateCorrelationId();
        try {
            // Log job start
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Starting job execution', 
                'JobName=' + jobConfig.Name + ', CorrelationId=' + correlationId);
            
            // Create execution record
            SG_Execution__c execution = new SG_Execution__c(
                Job__c = jobConfig.Name,
                Status__c = 'Running',
                CorrelationId__c = correlationId
            );
            insert execution;
            
            // Execute based on job type
            if('Batch'.equalsIgnoreCase(jobConfig.JobType__c)) {
                executeBatchJob(jobConfig, execution.Id, parameters);
            } else if('Queueable'.equalsIgnoreCase(jobConfig.JobType__c)) {
                executeQueueableJob(jobConfig, execution.Id, parameters);
            } else if('Flow'.equalsIgnoreCase(jobConfig.JobType__c)) {
                executeFlowJob(jobConfig, execution.Id, parameters);
            } else if('TriggerProxy'.equalsIgnoreCase(jobConfig.JobType__c)) {
                executeTriggerProxyJob(jobConfig, execution.Id, parameters);
            } else if('Trigger'.equalsIgnoreCase(jobConfig.JobType__c)) {
                executeTriggerJob(jobConfig, execution.Id, parameters);
            }
            
            // Update execution record
            execution.Status__c = 'Completed';
            execution.EndDateTime__c = DateTime.now();
            update execution;
            
            // Log completion
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Job completed successfully', 
                'JobName=' + jobConfig.Name + ', CorrelationId=' + correlationId);
                
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage() + ', CorrelationId=' + correlationId);
            
            // Handle failure - would implement retry logic here
            // For now, just log and continue
        }
    }
    
    /**
     * Execute a batch job
     */
    private static void executeBatchJob(ScaleGuard_Job__mdt jobConfig, ID executionId, Map<String, Object> parameters) {
        try {
            // Validate that the class exists and implements the correct interface
            Type batchClass = Type.forName(jobConfig.ApexClass__c);
            if(batchClass == null) {
                throw new Exception('Batch class not found: ' + jobConfig.ApexClass__c);
            }
            
            // Create instance and execute
            Database.Batchable<SObject> batchInstance = (Database.Batchable<SObject>)batchClass.newInstance();
            Integer batchSize = parameters.get('batchSize') != null ? (Integer)parameters.get('batchSize') : 200;
            
            // Log execution
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Executing batch job', 
                'JobName=' + jobConfig.Name + ', Class=' + jobConfig.ApexClass__c + ', BatchSize=' + batchSize + ', ExecutionId=' + executionId);
            
            // Execute batch job
            Database.executeBatch(batchInstance, batchSize);
            
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Batch job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * Execute a queueable job
     */
    private static void executeQueueableJob(ScaleGuard_Job__mdt jobConfig, ID executionId, Map<String, Object> parameters) {
        try {
            // Validate that the class exists and implements the correct interface
            Type queueableClass = Type.forName(jobConfig.ApexClass__c);
            if(queueableClass == null) {
                throw new Exception('Queueable class not found: ' + jobConfig.ApexClass__c);
            }
            
            // Create instance and execute
            Queueable queueableInstance = (Queueable)queueableClass.newInstance();
            
            // Log execution
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Executing queueable job', 
                'JobName=' + jobConfig.Name + ', Class=' + jobConfig.ApexClass__c + ', ExecutionId=' + executionId);
            
            // Execute queueable job
            System.enqueueJob(queueableInstance);
            
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Queueable job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * Execute a flow job
     */
    private static void executeFlowJob(ScaleGuard_Job__mdt jobConfig, ID executionId, Map<String, Object> parameters) {
        try {
            // Validate that the flow exists
            // In a real implementation, we would check if the flow exists
            
            // Log execution
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Executing flow job', 
                'JobName=' + jobConfig.Name + ', FlowName=' + jobConfig.ApexClass__c + ', ExecutionId=' + executionId);
            
            // In production, this would be something like:
            // Flow.Interview interview = new Flow.Interview(jobConfig.ApexClass__c, parameters);
            // interview.start();
            
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Flow job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * Execute a trigger proxy job
     */
    private static void executeTriggerProxyJob(ScaleGuard_Job__mdt jobConfig, ID executionId, Map<String, Object> parameters) {
        try {
            // Log execution
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Executing trigger proxy job', 
                'JobName=' + jobConfig.Name + ', Class=' + jobConfig.ApexClass__c + ', ExecutionId=' + executionId);
            
            // In production, this would route to trigger handlers
            // For demo purposes, we'll just log the action
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Trigger proxy job executed', 
                'JobName=' + jobConfig.Name + ', Class=' + jobConfig.ApexClass__c + ', ExecutionId=' + executionId);
            
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Trigger proxy job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * Execute a trigger job
     */
    private static void executeTriggerJob(ScaleGuard_Job__mdt jobConfig, ID executionId, Map<String, Object> parameters) {
        try {
            // Log execution
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Executing trigger job', 
                'JobName=' + jobConfig.Name + ', Object=' + jobConfig.ApexClass__c + ', ExecutionId=' + executionId);
            
            // For demo purposes, we'll call the trigger handler directly
            // In production, this would use the orchestrator to delegate to the appropriate handler
            String correlationId = ScaleGuard_Correlation.getCorrelationId();
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Trigger job delegated to handler', 
                'JobName=' + jobConfig.Name + ', HandlerClass=' + jobConfig.ApexClass__c + ', CorrelationId=' + correlationId);
            
        } catch(Exception ex) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Trigger job execution failed', 
                'JobName=' + jobConfig.Name + ', Error=' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * Execute a job with retry logic
     */
    public static void executeJobWithRetry(ScaleGuard_Job__mdt jobConfig, Map<String, Object> parameters, Integer maxRetries) {
        Integer retryCount = 0;
        Boolean success = false;
        
        while(!success && retryCount <= maxRetries) {
            try {
                executeJob(jobConfig, parameters);
                success = true;
            } catch(Exception ex) {
                retryCount++;
                if(retryCount <= maxRetries) {
                    // Wait before retry (exponential backoff)
                    Integer delay = 1000 * retryCount; // 1s, 2s, 3s, etc.
                    System.sleep(delay);
                    
                    ScaleGuard_Observability.logWarning('ScaleGuard_Executor', 'Job execution retry', 
                        'JobName=' + jobConfig.Name + ', Attempt=' + retryCount + ', Error=' + ex.getMessage());
                } else {
                    // Final failure - create incident
                    createIncidentForFailedJob(jobConfig, ex);
                    throw ex;
                }
            }
        }
    }
    
    /**
     * Check for circular dependencies in job dependencies
     * @param job The job to check dependencies for
     * @param visitedJobs Jobs already visited in the dependency chain (to detect cycles)
     * @return True if no circular dependencies detected, false otherwise
     */
    public static Boolean hasCircularDependencies(ScaleGuard_Job__mdt job, Set<String> visitedJobs) {
        // If job is already in the visited set, we have a circular dependency
        if(visitedJobs.contains(job.Name)) {
            return false; // Circular dependency detected
        }
        
        // Add job to visited set
        visitedJobs.add(job.Name);
        
        // Get all dependencies for this job
        List<ScaleGuard_Dependencies__mdt> dependencies = [SELECT Id, ParentJob__c FROM ScaleGuard_Dependencies__mdt WHERE ChildJob__c = :job.Name AND IsActive__c = true];
        
        // Check each dependency recursively
        for(ScaleGuard_Dependencies__mdt dependency : dependencies) {
            // Get the parent job
            ScaleGuard_Job__mdt parentJob = [SELECT Id, Name FROM ScaleGuard_Job__mdt WHERE Name = :dependency.ParentJob__c LIMIT 1];
            
            if(parentJob != null) {
                // Recursively check for circular dependencies
                if(!hasCircularDependencies(parentJob, visitedJobs)) {
                    return false; // Circular dependency detected in child chain
                }
            } else {
                // Parent job not found - log warning but don't fail
                ScaleGuard_Observability.logWarning('Parent job not found in dependency check', 'DependencyCheck', 'ScaleGuard_Executor'); 
            }
        }
        
        // Remove job from visited set (backtracking)
        visitedJobs.remove(job.Name);
        return true; // No circular dependencies found
    }
    /**
     * Create an incident for a failed job
     */
    private static void createIncidentForFailedJob(ScaleGuard_Job__mdt jobConfig, Exception ex) {
        try {
            SG_Incident__c incident = new SG_Incident__c(
                Name = 'Job Failure: ' + jobConfig.Name,
                Severity__c = 'High',
                State__c = 'Open',
                Description__c = 'Job execution failed: ' + ex.getMessage(),
                CreatedByJob__c = jobConfig.Name
            );
            insert incident;
            
            ScaleGuard_Observability.logInfo('ScaleGuard_Executor', 'Created incident for failed job', 
                'IncidentId=' + incident.Id + ', JobName=' + jobConfig.Name);
                
        } catch(Exception incidentEx) {
            ScaleGuard_Observability.logError('ScaleGuard_Executor', 'Failed to create incident', 
                'Error=' + incidentEx.getMessage());
        }
    }
}
