public class CandidateTriggerHandler extends TriggerHandler {

/**  Note: parameters are typed as generic SObject/Map<Id, SObject>
 * (not List<Candidate__c>) because this method overrides TriggerHandler.afterUpdate(), and Apex requires an override's
 * signature to match its parent's exactly. The cast to Candidate__c happens inside the method body instead.
 */

    protected override void afterUpdate(List<SObject> newList, Map<Id,SObject> newMap, Map<Id,SObject> oldMap){
        List<Candidate__c> newCandidates = (List<Candidate__c>)newList;   // Cast generic SObject types back to Candidate_c
        Map<Id, Candidate__c> newCandidateMap = (Map<Id, Candidate__c>)newMap;
        Map<Id, Candidate__c> oldCandidateMap = (Map<Id,Candidate__c>)oldMap;

        List<Interview__c> interviewsToCreate = new List<Interview__c>(); 
           // to store a new Interview Record
        for(Candidate__c cand: newCandidates){          // looping through the new Candidates

            Candidate__c oldCand = oldCandidateMap.get(cand.Id);      // its gets the previous version of each new Candidate records

            if(cand.Stage__c == 'Interview' && oldCand.Stage__c != 'Interview'){
                interviewsToCreate.add(new Interview__c(Candidate__c = cand.Id));
            }

            
        }
        if(!interviewsToCreate.isEmpty()){
                insert interviewsToCreate;
        }
    }
}