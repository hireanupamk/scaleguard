import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/messageService';
import SG_LogEvent__e from '@salesforce/messageChannel/SG_LogEvent__e';

export default class SgLogStream extends LightningElement {
    @track logs = [];
    @track columns = [
        { label: 'Timestamp', fieldName: 'Timestamp__c', type: 'date' },
        { label: 'Message', fieldName: 'Message__c' },
        { label: 'Severity', fieldName: 'Severity__c' },
        { label: 'Component', fieldName: 'Component__c' },
        { label: 'Correlation ID', fieldName: 'CorrelationId__c' }
    ];
    
    subscription = null;

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
        // Add new log to the beginning of the array
        this.logs.unshift(message);
        
        // Keep only the last 100 logs to prevent memory issues
        if (this.logs.length > 100) {
            this.logs.pop();
        }
    }
}
