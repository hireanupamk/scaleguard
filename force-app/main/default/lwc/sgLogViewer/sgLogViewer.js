import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/messageService';
import SG_LogEvent__e from '@salesforce/messageChannel/SG_LogEvent__e';

export default class SgLogViewer extends LightningElement {
    @track logs = [];
    @track filteredLogs = [];
    @track columns = [
        { label: 'Timestamp', fieldName: 'Timestamp__c', type: 'date', sortable: true },
        { label: 'Message', fieldName: 'Message__c', type: 'text' },
        { label: 'Severity', fieldName: 'Severity__c', type: 'text' },
        { label: 'Component', fieldName: 'Component__c', type: 'text' },
        { label: 'Correlation ID', fieldName: 'CorrelationId__c', type: 'text' }
    ];
    
    @track jobFilter = '';
    @track severityFilter = '';
    @track dateFilter = '';
    
    subscription = null;
    sortedBy = 'Timestamp__c';
    sortedDirection = 'desc';
    
    // Severity options for the combobox
    severityOptions = [
        { label: 'All', value: '' },
        { label: 'INFO', value: 'INFO' },
        { label: 'WARN', value: 'WARN' },
        { label: 'ERROR', value: 'ERROR' }
    ];

    connectedCallback() {
        this.subscribeToLogEvents();
        this.loadLogs();
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
        // Add new log to the beginning of the array
        this.logs.unshift(message);
        
        // Keep only the last 1000 logs to prevent memory issues
        if (this.logs.length > 1000) {
            this.logs.pop();
        }
        
        // Reapply filters
        this.applyFilters();
    }
    
    loadLogs() {
        // In a real implementation, this would call an Apex method to fetch historical logs
        // For demo purposes, we'll just use the real-time logs
        this.filteredLogs = [...this.logs];
    }
    
    applyFilters() {
        let filtered = [...this.logs];
        
        // Apply job filter
        if (this.jobFilter) {
            filtered = filtered.filter(log => 
                log.Component__c.toLowerCase().includes(this.jobFilter.toLowerCase())
            );
        }
        
        // Apply severity filter
        if (this.severityFilter) {
            filtered = filtered.filter(log => 
                log.Severity__c === this.severityFilter
            );
        }
        
        // Apply date filter
        if (this.dateFilter) {
            filtered = filtered.filter(log => {
                const logDate = new Date(log.Timestamp__c);
                const filterDate = new Date(this.dateFilter);
                return logDate.toDateString() === filterDate.toDateString();
            });
        }
        
        this.filteredLogs = filtered;
    }
    
    handleJobFilterChange(event) {
        this.jobFilter = event.target.value;
        this.applyFilters();
    }
    
    handleSeverityFilterChange(event) {
        this.severityFilter = event.target.value;
        this.applyFilters();
    }
    
    handleDateFilterChange(event) {
        this.dateFilter = event.target.value;
        this.applyFilters();
    }
    
    handleSort(event) {
        const fieldName = event.detail.fieldName;
        const sortDirection = event.detail.sortDirection;
        
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        
        // Sort the data
        this.filteredLogs.sort((a, b) => {
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
    
    clearFilters() {
        this.jobFilter = '';
        this.severityFilter = '';
        this.dateFilter = '';
        this.filteredLogs = [...this.logs];
    }
}
