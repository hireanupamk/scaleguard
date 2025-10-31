import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/messageService';
import SG_LogEvent__e from '@salesforce/messageChannel/SG_LogEvent__e';
import getHealthMetrics from '@salesforce/apex/ScaleGuard_Observability.getHealthMetrics';

export default class SgHealthDashboard extends LightningElement {
    @track healthMetrics = {
        totalJobs: 0,
        successfulJobs: 0,
        failedJobs: 0,
        activeJobs: 0,
        avgExecutionTime: 0,
        recentErrors: []
    };
    
    @track isLoading = true;
    @track error = null;
    
    subscription = null;
    refreshInterval;

    connectedCallback() {
        this.subscribeToLogEvents();
        this.loadHealthMetrics();
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
        // Update metrics when new log events arrive
        if (message.Severity__c === 'ERROR') {
            // Add to recent errors if it's an error
            this.healthMetrics.recentErrors.unshift({
                timestamp: message.Timestamp__c,
                message: message.Message__c,
                component: message.Component__c,
                correlationId: message.CorrelationId__c
            });
            
            // Keep only last 10 errors
            if (this.healthMetrics.recentErrors.length > 10) {
                this.healthMetrics.recentErrors.pop();
            }
        }
        
        // Trigger re-render to show updated data
        this.healthMetrics = { ...this.healthMetrics };
    }
    
    async loadHealthMetrics() {
        this.isLoading = true;
        this.error = null;
        
        try {
            const metrics = await getHealthMetrics();
            this.healthMetrics = {
                totalJobs: metrics.totalJobs,
                successfulJobs: metrics.successfulJobs,
                failedJobs: metrics.failedJobs,
                activeJobs: metrics.activeJobs,
                avgExecutionTime: metrics.avgExecutionTime,
                recentErrors: metrics.recentErrors || []
            };
        } catch (error) {
            this.error = 'Failed to load health metrics: ' + error.body.message;
            console.error('Error loading health metrics:', error);
        } finally {
            this.isLoading = false;
        }
    }
    
    get successRate() {
        if (this.healthMetrics.totalJobs === 0) return 0;
        return Math.round((this.healthMetrics.successfulJobs / this.healthMetrics.totalJobs) * 100);
    }
    
    get errorRate() {
        if (this.healthMetrics.totalJobs === 0) return 0;
        return Math.round((this.healthMetrics.failedJobs / this.healthMetrics.totalJobs) * 100);
    }
    
    handleRefresh() {
        this.loadHealthMetrics();
    }
}
