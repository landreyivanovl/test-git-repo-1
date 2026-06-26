import { LightningElement, api } from 'lwc';

export default class ScCommunityNewOpportunityDescription extends LightningElement {
    newOppMetaData = {
        title: 'Create New Opportunity' 
    }
    @api sectionTitle
    @api sectionDescription
}