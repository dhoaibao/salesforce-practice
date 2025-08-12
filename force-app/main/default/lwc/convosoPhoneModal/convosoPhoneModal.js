import { LightningElement, track, api } from 'lwc';
import convosoLogo from '@salesforce/resourceUrl/convosoLogo';
import createSession from '@salesforce/apex/AuthenticationService.createSession';   

export default class ConvosoPhoneModal extends LightningElement {

    @track showWelcomeScreen = false;
    @track selectedCampaign = '';
    @track selectedStatus = '';
    @track loggedInUser = '';
    @track campaignOptions = [];
    @track statusOptions = [];

    get convosoLogoUrl() {
        return convosoLogo;
    }

    get showInitialScreen() {
        return !this.showWelcomeScreen;
    }

    async handleLogin() {
        try {
            const sessionResponse = await createSession();
            
            if (sessionResponse) {
                const response = JSON.parse(sessionResponse);
                this.loggedInUser = response.user_firstname + ' ' + response.user_lastname;
                
                // Transform {name, value} to {label, value} for lightning-combobox
                this.campaignOptions = this.transformToSelectOptions(response.available_campaigns);
                this.statusOptions = this.transformToSelectOptions(response.availabilities);

                this.showWelcomeScreen = true;
                console.log('Login successful, session created:', response);
            } else {
                console.error('Failed to create session');
            }
        } catch (error) {
            console.error('Login error:', error);
        }
    }

    handleCampaignChange(event) {
        this.selectedCampaign = event.detail.value;
    }

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
    }

    // Transform data from API format {name, value} to Lightning format {label, value}
    transformToSelectOptions(apiData) {
        if (!Array.isArray(apiData)) {
            console.warn('API data is not an array:', apiData);
            return [];
        }
        
        return apiData.map(item => ({
            label: item.name || item.label || 'Unknown',
            value: item.value || item.id || item.code || ''
        }));
    }

    handleNext() {
        if (!this.selectedCampaign || !this.selectedStatus) {
            console.log('Please select both campaign and status');
            return;
        }

        console.log('Selected Campaign:', this.selectedCampaign);
        console.log('Selected Status:', this.selectedStatus);
        
        console.log('Proceeding to next step...');
    }
}