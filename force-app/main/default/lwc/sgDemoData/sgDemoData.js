import { LightningElement, track } from 'lwc';
import createDemoFailure from '@salesforce/apex/ScaleGuard_Observability.createDemoFailure';

export default class SgDemoData extends LightningElement {
    @track isLoading = false;
    @track message = '';
    @track isError = false;

    async handleCreateDemoFailure() {
        this.isLoading = true;
        this.message = '';
        this.isError = false;
        
        try {
            await createDemoFailure();
            this.message = 'Demo failure created successfully!';
        } catch (error) {
            this.isError = true;
            this.message = 'Failed to create demo failure: ' + error.body.message;
            console.error('Error creating demo failure:', error);
        } finally {
            this.isLoading = false;
        }
    }
}
