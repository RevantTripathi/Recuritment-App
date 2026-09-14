import { LightningElement, wire } from 'lwc';
import getCandidatesForPipeline from '@salesforce/apex/CandidatePipelineController.getCandidatesForPipeline';



export default class CandidatePipeline extends LightningElement {
    @wire(getCandidatesForPipeline) candidates;
}