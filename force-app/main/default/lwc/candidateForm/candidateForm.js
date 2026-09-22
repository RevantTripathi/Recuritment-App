import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCandidate from '@salesforce/apex/CandidateFormController.createCandidate';
import getOpenJobRequisitions from '@salesforce/apex/CandidateFormController.getOpenJobRequisitions';

export default class CandidateForm extends LightningElement {
    @track fullName='';
    @track email='';
    @track phone='';
    @track jobReqId='';
    @track candidateId='';
    @track showFileUpload = false;
    @track jobReqOptions = []; 

    acceptedFormats = ['.pdf', '.doc', '.docx'];

    @wire(getOpenJobRequisitions) 
    wiredJobReqs({ data }) {
        if(data){
            this.jobReqOptions = data.map((req) => {
                return {label:req.Name, value:req.Id};
            });
        }
    }

    

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

    handleUploadResume(event){
        const uploadFiles = event.detail.files;
        this.dispatchEvent(new ShowToastEvent({
            title:'Success', message: uploadFiles.length + 'file(s) uploaded successfully. Resume Parsing will begin shortly.', variant: 'success' 
        }));
        this.resetForm();

    }

    resetForm(){
        this.fullName='';
        this.email='';
        this.phone='';
        this.jobReqId='';
        this.showFileUpload=false;
    }

    
}