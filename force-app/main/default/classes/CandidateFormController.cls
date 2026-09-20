public with sharing class CandidateFormController {
    @AuraEnabled
    public static Id createCandidate(String name, String email,String phone, Id jobReqId ){
        try {
            Candidate__c newCandidate = new Candidate__c(Full_Name__c=name, Email__c=email, Phone__c = phone, Job_Requisition__c = jobReqId, Stage__c = 'Applied', Outcome__c = 'Pending');
            Insert newCandidate;
            return newCandidate.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        
    }
    
    @AuraEnabled(cacheable = true)
    public static List<Job_Requisition__c> getOpenJobRequisitions(){
        return [Select Id, Title__c from Job_Requisition__c where Status__c = 'Open'];
    }
}