import { LightningElement, track, wire } from 'lwc';
import getJobs from '@salesforce/apex/ScaleGuardJobController.getJobs';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SgJobList extends LightningElement {
    @track jobs = [];
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Type', fieldName: 'JobType__c' },
        { label: 'Active', fieldName: 'IsActive__c', type: 'boolean' },
        { label: 'Actions', type: 'action', typeAttributes: { rowActions: [{ label: 'Edit', name: 'edit' }] } }
    ];
    @track selectedJob;
    @track showModal = false;
    @track isLoading = false;

    @wire(getJobs)
    wiredJobs({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.jobs = data;
        } else if (error) {
            console.error('Error loading jobs:', error);
            const toastEvent = new ShowToastEvent({
                title: 'Error loading jobs',
                message: error.body.message || 'An error occurred while loading jobs',
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        
        if (actionName === 'edit') {
            this.selectedJob = row;
            this.showModal = true;
        }
    }

    handleJobSaved() {
        // Refresh the job list after saving
        this.showModal = false;
        this.selectedJob = null;
        this.isLoading = true;
        // Re-fetch jobs to refresh the list
        // Note: In a real implementation, you'd want to update just the changed job
        // For simplicity, we'll reload the entire list
        this.template.querySelector('lightning-datatable').refresh();
    }
    
    handleCancel() {
        this.showModal = false;
        this.selectedJob = null;
    }
    
    handleClose() {
        this.showModal = false;
        this.selectedJob = null;
    }
}
