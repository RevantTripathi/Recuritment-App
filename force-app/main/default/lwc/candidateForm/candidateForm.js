import { LightningElement, track } from 'lwc';
import createCandidate from '@salesforce/apex/CandidateFormController.createCandidate';


export default class CandidateForm extends LightningElement {
    @track fullName='';
    @track email='';
    @track phone='';
    @track jobReqId='';
    @track candidateId='';
    @track showFileUpload = false;

    acceptedFormats = ['.pdf', '.doc', '.docx'];

    handleFullNameChange(event) { 
        this.fullName = event.target.value; 
    }
    handleEmailChange(event) { 
        this.email = event.target.value; 
    }
    handlePhoneChange(event) { 
        this.phone = event.target.value; 
    }
    handleJobReqIdChange(event) { 
        this.jobReqId = event.target.value; 
    }

    async handleSaveCandidate(){
        try{
            const newId= await createCandidate({ name: this.fullName, email: this.email, phone: this.phone, jobReqId: this.jobReqId })  // we are passing a object with key and values, keys are matching with the parameter of apex class, this is a way of calling apex class Imperatively
            this.candidateId= newId;
            this.showFileUpload = true;
        }
        catch (error) { 
            console.error('Error creating candidate:', error); 
        }
    }
}