public with sharing class CandidatePipelineController {

    @AuraEnabled(cacheable=true)
    public static List<Candidate__c> getCandidatesForPipeline() {
        return CandidateService.getAllCandidatesForPipeline();
    }

    
}