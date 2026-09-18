public with sharing class CandidateFormController {
    @AuraEnabled
    public static Id createCandidate(String name, String email,String phone, Id jobReqId ){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}