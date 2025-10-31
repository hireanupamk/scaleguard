import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveJob from '@salesforce/apex/ScaleGuardJobController.saveJob';

export default class SgJobDetail extends LightningElement {
    @api job;
    @track jobForm = {
        name: '',
        jobType: 'Batch',
        apexClass: '',
        isActive: true,
        dependencies: ''
    };
    @track isLoading = false;
    
    // Job types for the combobox
    jobTypes = [
        { label: 'Batch', value: 'Batch' },
        { label: 'Queueable', value: 'Queueable' },
        { label: 'Flow', value: 'Flow' },
        { label: 'Trigger Proxy', value: 'TriggerProxy' },
        { label: 'Trigger', value: 'Trigger' }
    ];

    connectedCallback() {
        if (this.job) {
            this.jobForm = {
                name: this.job.Name || '',
                jobType: this.job.JobType__c || 'Batch',
                apexClass: this.job.ApexClass__c || '',
                isActive: this.job.IsActive__c || true,
                dependencies: this.job.Dependencies__c || ''
            };
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this.jobForm[field] = event.target.value;
    }

    handleSave() {
        // Comprehensive validation
        if (!this.jobForm.name.trim()) {
            this.showToast('Validation Error', 'Job name is required', 'error');
            return;
        }
        
        if (!this.jobForm.apexClass.trim()) {
            this.showToast('Validation Error', 'Apex class is required', 'error');
            return;
        }
        
        // Set loading state
        this.isLoading = true;
        
        // Call Apex method to save the job (in a real implementation)
        saveJob({ job: this.jobForm })
            .then(result => {
                this.isLoading = false;
                this.showToast('Success', 'Job saved successfully', 'success');
                // Dispatch event to notify parent that job was saved
                const savedEvent = new CustomEvent('jobsaved');
                this.dispatchEvent(savedEvent);
            })
            .catch(error => {
                this.isLoading = false;
                console.error('Error saving job:', error);
                this.showToast('Error', error.body.message || 'An error occurred while saving the job', 'error');
            });
    }

    handleCancel() {
        // Reset form to original values
        if (this.job) {
            this.jobForm = {
                name: this.job.Name || '',
                jobType: this.job.JobType__c || 'Batch',
                apexClass: this.job.ApexClass__c || '',
                isActive: this.job.IsActive__c || true,
                dependencies: this.job.Dependencies__c || ''
            };
        }
    }
    
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}
