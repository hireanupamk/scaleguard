import { LightningElement, track, wire } from 'lwc';
import getIncidents from '@salesforce/apex/ScaleGuardIncidentController.getIncidents';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SgIncidentBoard extends LightningElement {
    @track incidents = [];
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Severity', fieldName: 'Severity__c' },
        { label: 'State', fieldName: 'State__c' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
        { label: 'Description', fieldName: 'Description__c' }
    ];

    @wire(getIncidents)
    wiredIncidents({ error, data }) {
        if (data) {
            this.incidents = data;
        } else if (error) {
            console.error('Error loading incidents:', error);
            const toastEvent = new ShowToastEvent({
                title: 'Error loading incidents',
                message: error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }
}
