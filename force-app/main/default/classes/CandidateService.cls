public with sharing class CandidateService {
    
    public static List<Candidate__c> getAllCandidatesForPipeline() {
        return [ SELECT Id, Name, Email__c, Stage__c, Outcome__c, Job_Requisition__c, Full_Name__c FROM Candidate__c ORDER BY Stage__c ];
    }
    
}