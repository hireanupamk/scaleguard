import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/messageService';
import SG_LogEvent__e from '@salesforce/messageChannel/SG_LogEvent__e';
import getLogsByCorrelationId from '@salesforce/apex/ScaleGuardLogViewerController.getLogsByCorrelationId';

export default class SgTraceability extends LightningElement {
    @track correlationId = '';
    @track logs = [];
    @track isLoading = false;
    @track error = null;
    
    @track columns = [
        { label: 'Timestamp', fieldName: 'Timestamp__c', type: 'date', sortable: true },
        { label: 'Message', fieldName: 'Message__c', type: 'text' },
        { label: 'Severity', fieldName: 'Severity__c', type: 'text' },
        { label: 'Component', fieldName: 'Component__c', type: 'text' }
    ];
    
    subscription = null;
    sortedBy = 'Timestamp__c';
    sortedDirection = 'desc';

    connectedCallback() {
        this.subscribeToLogEvents();
    }

    disconnectedCallback() {
        this.unsubscribeToLogEvents();
    }

    subscribeToLogEvents() {
        this.subscription = subscribe(
            this,
            SG_LogEvent__e,
            (message) => this.handleLogEvent(message),
            { replayId: -1 }
        );
    }

    unsubscribeToLogEvents() {
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
        }
    }

    handleLogEvent(message) {
        // If we're searching for a specific correlation ID, we might want to highlight
        // logs that match that ID
        if (this.correlationId && message.CorrelationId__c === this.correlationId) {
            // This could be used to highlight matching logs in a larger view
        }
    }
    
    handleCorrelationIdChange(event) {
        this.correlationId = event.target.value;
    }
    
    async handleSearch() {
        if (!this.correlationId.trim()) {
            this.error = 'Please enter a correlation ID';
            return;
        }
        
        this.isLoading = true;
        this.error = null;
        
        try {
            const logs = await getLogsByCorrelationId({ correlationId: this.correlationId });
            this.logs = logs;
        } catch (error) {
            this.error = 'Failed to search logs: ' + error.body.message;
            console.error('Error searching logs:', error);
        } finally {
            this.isLoading = false;
        }
    }
    
    handleSort(event) {
        const fieldName = event.detail.fieldName;
        const sortDirection = event.detail.sortDirection;
        
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        
        // Sort the data
        this.logs.sort((a, b) => {
            let aValue = a[fieldName];
            let bValue = b[fieldName];
            
            // Handle null values
            if (aValue === null) return sortDirection === 'asc' ? 1 : -1;
            if (bValue === null) return sortDirection === 'asc' ? -1 : 1;
            
            // Compare values
            if (sortDirection === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });
    }
    
    handleClear() {
        this.correlationId = '';
        this.logs = [];
        this.error = null;
    }
}
