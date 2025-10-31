import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SgIncidentPrioritization extends LightningElement {
    @api correlationId;
    @track priority = 'Low';
    @track category = 'Other';
    @track resolutionTime = 8;
    @track isLoading = false;
    @track error;

    connectedCallback() {
        if (this.correlationId) {
            this.analyzeLogs();
        }
    }

    handleCorrelationIdChange(event) {
        const newCorrelationId = event.detail.value;
        if (newCorrelationId) {
            this.correlationId = newCorrelationId; // Store in local property instead of API property
            this.analyzeLogs();
        } else {
            this.correlationId = newCorrelationId; // Clear the correlation ID
        }
    }

    async analyzeLogs() {
        this.isLoading = true;
        this.error = null;
        
        try {
            // In a real implementation, this would call an Apex method
            // For this mock implementation, we'll simulate the analysis
            
            // Simulate API delay using async/await (no setTimeout in promise)
            // Remove setTimeout completely from mock implementation
            // Just proceed immediately with mock analysis
            // Mock analysis based on correlation ID
            // In a real implementation, this would fetch logs and analyze them
            this.priority = this.determinePriority(this.correlationId);
            this.category = this.determineCategory(this.correlationId);
            this.resolutionTime = this.predictResolutionTime(this.priority, this.category);
            
        } catch (error) {
            this.error = 'Failed to analyze logs: ' + error.body.message;
            const toastEvent = new ShowToastEvent({
                title: 'Analysis Error',
                message: this.error,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        } finally {
            this.isLoading = false;
        }
    }

    determinePriority(correlationId) {
        // Mock logic to determine priority based on correlation ID
        if (correlationId.includes('critical') || correlationId.includes('fatal')) {
            return 'Critical';
        } else if (correlationId.includes('error') || correlationId.includes('fail')) {
            return 'High';
        } else if (correlationId.includes('warning')) {
            return 'Medium';
        } else {
            return 'Low';
        }
    }

    determineCategory(correlationId) {
        // Mock logic to determine category based on correlation ID
        if (correlationId.includes('db') || correlationId.includes('data')) {
            return 'Data';
        } else if (correlationId.includes('api') || correlationId.includes('integration')) {
            return 'Integration';
        } else if (correlationId.includes('process') || correlationId.includes('workflow')) {
            return 'Process';
        } else if (correlationId.includes('security') || correlationId.includes('auth')) {
            return 'Security';
        } else if (correlationId.includes('perf') || correlationId.includes('timeout')) {
            return 'Performance';
        } else {
            return 'Other';
        }
    }

    predictResolutionTime(priority, category) {
        // Mock resolution time prediction
        const resolutionTimes = {
            'Critical': {
                'Data': 2,
                'Integration': 4,
                'Process': 3,
                'Security': 1,
                'Performance': 2,
                'Other': 3
            },
            'High': {
                'Data': 4,
                'Integration': 6,
                'Process': 5,
                'Security': 3,
                'Performance': 4,
                'Other': 5
            },
            'Medium': {
                'Data': 8,
                'Integration': 12,
                'Process': 10,
                'Security': 6,
                'Performance': 8,
                'Other': 10
            },
            'Low': {
                'Data': 16,
                'Integration': 24,
                'Process': 20,
                'Security': 12,
                'Performance': 16,
                'Other': 20
            }
        };
        
        return resolutionTimes[priority][category] || 8;
    }

    get priorityOptions() {
        return [
            { label: 'Critical', value: 'Critical' },
            { label: 'High', value: 'High' },
            { label: 'Medium', value: 'Medium' },
            { label: 'Low', value: 'Low' }
        ];
    }

    get categoryOptions() {
        return [
            { label: 'Data', value: 'Data' },
            { label: 'Integration', value: 'Integration' },
            { label: 'Process', value: 'Process' },
            { label: 'Security', value: 'Security' },
            { label: 'Performance', value: 'Performance' },
            { label: 'Other', value: 'Other' }
        ];
    }

    handlePriorityChange(event) {
        this.priority = event.detail.value;
        this.resolutionTime = this.predictResolutionTime(this.priority, this.category);
    }

    handleCategoryChange(event) {
        this.category = event.detail.value;
        this.resolutionTime = this.predictResolutionTime(this.priority, this.category);
    }

    handleCreateTicket() {
        // In a real implementation, this would create a ticket in Jira/ServiceNow
        // For this mock implementation, we'll just show a toast
        const toastEvent = new ShowToastEvent({
            title: 'Ticket Creation',
            message: 'Mock ticket created for incident with correlation ID: ' + this.correlationId,
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
    }

    get priorityColor() {
        switch(this.priority) {
            case 'Critical':
                return 'slds-theme_error';
            case 'High':
                return 'slds-theme_warning';
            case 'Medium':
                return 'slds-theme_info';
            case 'Low':
                return 'slds-theme_success';
            default:
                return '';
        }
    }
}
