import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/messageService';
import SG_LogEvent__e from '@salesforce/messageChannel/SG_LogEvent__e';

export default class SgAlerting extends LightningElement {
    @track alerts = [];
    @track isLoading = false;
    @track error = null;
    
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
        // Check for error messages that should trigger alerts
        if (message.Severity__c === 'ERROR') {
            // Create alert entry
            const alert = {
                id: Date.now(), // Simple ID generation
                timestamp: message.Timestamp__c,
                message: message.Message__c,
                component: message.Component__c,
                correlationId: message.CorrelationId__c,
                severity: message.Severity__c
            };
            
            // Add to alerts list
            this.alerts.unshift(alert);
            
            // Keep only last 20 alerts to prevent memory issues
            if (this.alerts.length > 20) {
                this.alerts.pop();
            }
        }
    }
    
    get hasAlerts() {
        return this.alerts.length > 0;
    }
    
    get alertCount() {
        return this.alerts.length;
    }
}
