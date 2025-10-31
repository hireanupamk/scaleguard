import { LightningElement, track, wire } from 'lwc';
import getExecutions from '@salesforce/apex/ScaleGuardExecutionController.getExecutions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SgExecutionTable extends LightningElement {
    @track executions = [];
    @track columns = [
        { label: 'Job Name', fieldName: 'Job__c' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Start Time', fieldName: 'StartDateTime__c', type: 'date' },
        { label: 'End Time', fieldName: 'EndDateTime__c', type: 'date' },
        { label: 'Correlation ID', fieldName: 'CorrelationId__c' }
    ];

    @wire(getExecutions)
    wiredExecutions({ error, data }) {
        if (data) {
            this.executions = data;
        } else if (error) {
            console.error('Error loading executions:', error);
            const toastEvent = new ShowToastEvent({
                title: 'Error loading executions',
                message: error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }
}
