import { LightningElement, wire, track } from 'lwc';
import getCandidatesForPipeline from '@salesforce/apex/CandidatePipelineController.getCandidatesForPipeline';



export default class CandidatePipeline extends LightningElement {
    @track groupCandidates = [];

    @wire(getCandidatesForPipeline)
    wireCandidates({error,data}){
        if(data){
            const grouped = [{stageName:'Applied',candidates:[]},{stageName:'Screening', candidates:[]},{stageName:'Interview', candidates:[]},{stageName:'Offer',candidates:[]}];
            data.forEach((cand) => { 
                const matchingColumn = grouped.find((col) => col.stageName ===cand.Stage__c);
                if(matchingColumn){
                    matchingColumn.candidates.push(cand);
                }
            });

            this.groupCandidates = grouped;
        }else if(error){
            console.error('Error loading Candidates',error);
        }
    };
}