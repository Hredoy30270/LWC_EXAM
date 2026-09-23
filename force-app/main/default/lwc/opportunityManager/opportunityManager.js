import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import calculateRevenue from '@salesforce/apex/OpportunityController.calculateRevenue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class OpportunityManager extends NavigationMixin(LightningElement) {

    @wire(getOpportunities)
    wiredOppsResult;

    get opportunityList() {
        return this.wiredOppsResult?.data || [];
    }

    async handleUpdate(event) {
        
        try {
            await calculateRevenue({id: event.dataset.id})
            ShowToastEvent({
                title: 'Success',
                message: 'Expected Revenue updated successfully',
                variant: 'success'
            });
            
        } catch (error) {
            ShowToastEvent({
                title:'Error',
                message:'Something went wrong',
                variant: 'error'
            });
        }
        }

    


}