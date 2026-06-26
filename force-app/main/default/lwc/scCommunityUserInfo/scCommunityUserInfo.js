import { LightningElement, api, track } from 'lwc';
import getUserData from '@salesforce/apex/ScUserInfoController.getUserData';
import Toast from 'lightning/toast';

export default class ScCommunityUserInfo extends LightningElement {

    userInfoMetaData = {
      cardFields: {
        firstName: 'First Name',
        lastName: 'Last Name',
        mobile: 'Mobile',
        phone: 'Phone',
        email: 'Email',
        address: 'Address'
      },
      spinner: {
        size: 'medium',
        variant: 'brand'
      },
      logo: {
        alt:'user-logo'
      }, 
      unknownMessage: 'Something went wrong. Internal server error',
    }

    @api sectionTitle
    @api sectionDescription
    
    @track userData = {
        imageUrl: '',
        firstName: '',
        lastName: '',
        mobileNumber: '',
        phoneNumber: '',
        email: '',
        address: {
            street: '',
            city: '',
            state: '',
            postalCode: '',
            country: ''
        }
    };
    isLoading=true;

    async getUserInfo(){
        try{
            const {status, userData, errorMessage} = await getUserData();
            if(status=='success'){
                this.isLoading = false;
                this.userData = this.formatUserData(userData);
            }else{
                Toast.show({label: 'Error', message: errorMessage,  variant: 'error'})
            }
        }catch(serverError){
            Toast.show({label: 'Error', message: this.userInfoMetaData.unknownMessage,  variant: 'error',
                mode: 'sticky' 
            }, this);
        }   
    }


    connectedCallback(){
        this.getUserInfo();
    }

    formatUserData(userData){
        userData.firstName = userData.firstName ?? '-';
        userData.lastName = userData.lastName ?? '-';
        userData.mobileNumber = userData.mobileNumber ?? '-';
        userData.phoneNumber = userData.phoneNumber ?? '-';
        userData.email = userData.email ?? '-';

        userData.address.street = userData.address.street ?? '';
        userData.address.city = userData.address.city ?? '';
        userData.address.state = userData.address.state ?? '';
        userData.address.postalCode = userData.address.postalCode ?? '';
        userData.address.country = userData.address.country ?? '';

        return userData;
    }

    get address(){
        
        const {street, city, state, postalCode, country} = this.userData.address
        let parts = []

        if(street){
            parts.push(street)
        }

        if(city){
            parts.push(city)
        }

        if(state){
            parts.push(state)
        }
        
        if(postalCode){
            parts.push(postalCode)
        }

        if(country){
            parts.push(country)
        }
        
        return parts.join(' ');
    }


}