/**
 * @description Utility class to load demo data for ScaleGuard platform
 * @author ScaleGuard Team
 */
public with sharing class ScaleGuard_DemoDataLoader {
    
    /**
     * @description Loads sample accounts for trigger testing
     */
    public static void loadSampleAccounts() {
        List<Account> accountsToInsert = new List<Account>();
        
        // Create 50 sample accounts with various attributes
        String[] accountNames = new String[] {
            'Acme Corporation', 'Globex Industries', 'Wayne Enterprises', 
            'Stark Industries', 'Oscorp', 'Umbrella Corp', 'Cyberdyne Systems',
            'Initech', 'Weyland-Yutani', 'Virtucon', 'Soylent Corp', 'LexCorp',
            'Preston & Sons', 'Bluth Company', 'Hooli', 'Bazooka Corp', 'Pied Piper',
            'Cloud Corp', 'Tech Solutions', 'Global Innovations', 'Prime Systems',
            'Data Dynamics', 'Network Masters', 'Software Experts', 'Digital Services',
            'Cloud Computing Inc', 'IT Solutions Ltd', 'Enterprise Systems', 'Business Tech',
            'Advanced Technologies', 'Innovation Labs', 'Future Systems', 'NextGen Solutions',
            'Smart Solutions', 'Digital Innovations', 'Tech Forward', 'Modern Systems',
            'Cloud Services', 'Data Systems', 'Network Solutions', 'Software Systems',
            'Enterprise Software', 'Business Solutions', 'Technology Partners', 'Digital Partners',
            'Innovative Tech', 'Advanced Solutions', 'Creative Systems', 'Strategic Tech',
            'Global Solutions', 'Enterprise Tech', 'Digital Systems', 'Tech Innovations',
            'Business Systems', 'Software Partners', 'Cloud Solutions', 'Data Innovations'
        };
        
        String[] accountTypes = new String[] {'Prospect', 'Customer', 'Partner'};
        String[] industries = new String[] {'Technology', 'Finance', 'Healthcare', 'Manufacturing', 'Retail', 'Energy', 'Transportation'};
        
        for(Integer i = 0; i < 50; i++) {
            Account acc = new Account(
                Name = accountNames[i] + ' - ' + i,
                Type = accountTypes[i % accountTypes.length],
                Industry = industries[i % industries.length],
                AnnualRevenue = 1000000 + (i * 50000),
                NumberOfEmployees = 10 + i,
                Website = 'www.' + accountNames[i].toLowerCase().replace(' ', '') + '.com'
            );
            accountsToInsert.add(acc);
        }
        
        if(!accountsToInsert.isEmpty()) {
            insert accountsToInsert;
        }
    }
    
    /**
     * @description Loads sample jobs for observability testing
     */
    public static void loadSampleJobs() {
        List<SG_Job__c> jobsToInsert = new List<SG_Job__c>();
        
        // Create 10 sample jobs with different statuses
        String[] jobNames = new String[] {
            'Daily Data Sync', 'Weekly Report Generation', 'Monthly Financial Close',
            'Customer Data Cleanup', 'Inventory Reconciliation', 'Sales Forecasting',
            'Marketing Campaign Analysis', 'Lead Scoring Process', 'Customer Segmentation',
            'Data Migration Task'
        };
        
        String[] statuses = new String[] {'Success', 'Failed', 'Running'};
        String[] jobTypes = new String[] {'Batch', 'Queueable', 'Trigger'};
        
        for(Integer i = 0; i < 10; i++) {
            SG_Job__c job = new SG_Job__c(
                Name = jobNames[i],
                Status__c = statuses[i % statuses.size()],
                JobType__c = jobTypes[i % jobTypes.size()],
                ExecutionTime__c = 100 + (i * 50),
                StartedAt__c = System.now().addHours(-2),
                CompletedAt__c = System.now().addHours(-1)
            );
            jobsToInsert.add(job);
        }
        
        if(!jobsToInsert.isEmpty()) {
            insert jobsToInsert;
        }
    }
    
    /**
     * @description Loads sample logs for traceability testing
     */
    public static void loadSampleLogs() {
        List<SG_LogEvent__e> logsToInsert = new List<SG_LogEvent__e>();
        
        // Create 500 sample log entries with different severities
        String[] logMessages = new String[] {
            'Successfully processed account record',
            'Error occurred while validating account data',
            'Warning: Potential duplicate account detected',
            'Informational: Account created successfully',
            'Critical error in data synchronization',
            'Database connection timeout',
            'API call to external service failed',
            'Workflow rule executed successfully',
            'Validation rule prevented account update',
            'Permission denied for account access'
        };
        
        String[] severities = new String[] {'INFO', 'WARN', 'ERROR'};
        String[] components = new String[] {'AccountTrigger', 'DataSyncBatch', 'ReportGenerator', 'WorkflowRule', 'ValidationRule'};
        
        for(Integer i = 0; i < 500; i++) {
            // Generate correlation ID
            String correlationId = 'SG-' + String.valueOf(System.currentTimeMillis() + i) + '-' + String.valueOf(i);
            
            SG_LogEvent__e log = new SG_LogEvent__e(
                Message__c = logMessages[i % logMessages.size()] + ' - Record ID: ' + i,
                Severity__c = severities[i % severities.size()],
                Component__c = components[i % components.size()],
                CorrelationId__c = correlationId,
                Timestamp__c = System.now().addMinutes(-i)
            );
            logsToInsert.add(log);
        }
        
        // Fire all events at once (using bulk approach)
        if(!logsToInsert.isEmpty()) {
            for(Integer i = 0; i < logsToInsert.size(); i += 100) {
                Integer endIndex = Math.min(i + 100, logsToInsert.size());
                List<SG_LogEvent__e> batch = logsToInsert.getRange(i, endIndex);
                EventBus.publish(batch);
            }
        }
    }
    
    /**
     * @description Loads sample incidents for triage testing
     */
    public static void loadSampleIncidents() {
        // This method would typically create records in a custom object
        // For demo purposes, we'll just log that it was called
        System.debug('Sample incidents loaded for triage testing');
    }
    
    /**
     * @description Main method to load all demo data
     */
    public static void loadAllDemoData() {
        try {
            System.debug('Starting to load demo data...');
            
            // Load sample accounts
            loadSampleAccounts();
            System.debug('Sample accounts loaded successfully');
            
            // Load sample jobs
            loadSampleJobs();
            System.debug('Sample jobs loaded successfully');
            
            // Load sample logs
            loadSampleLogs();
            System.debug('Sample logs loaded successfully');
            
            // Load sample incidents
            loadSampleIncidents();
            System.debug('Sample incidents loaded successfully');
            
            System.debug('All demo data loaded successfully');
        } catch(Exception e) {
            System.debug('Error loading demo data: ' + e.getMessage());
            throw e;
        }
    }
}
