public class CandidateTriggerHandler extends TriggerHandler {
    
    /**  Note: parameters are typed as generic SObject/Map<Id, SObject>
     * (not List<Candidate__c>) because this method overrides TriggerHandler.afterUpdate(), and Apex requires an override's
     * signature to match its parent's exactly. The cast to Candidate__c happens inside the method body instead.
     */
    
    protected override void afterUpdate(List<SObject> newList, Map<Id,SObject> newMap, Map<Id,SObject> oldMap){
        List<Candidate__c> newCandidates = (List<Candidate__c>)newList;   // Cast generic SObject types back to Candidate_c
        Map<Id, Candidate__c> newCandidateMap = (Map<Id, Candidate__c>)newMap;
        Map<Id, Candidate__c> oldCandidateMap = (Map<Id,Candidate__c>)oldMap;
        
        Set<Id> candidateMovingToInterview = new Set<Id>();
        
        // to store a new Interview Record
        for(Candidate__c cand: newCandidates){          // looping through the new Candidates
            
            Candidate__c oldCand = oldCandidateMap.get(cand.Id);      // its gets the previous version of each new Candidate records
            
            if(cand.Stage__c == 'Interview' && oldCand.Stage__c != 'Interview'){
                candidateMovingToInterview.add(cand.Id);      //IMP-->collects the Ids of Candidates who is moving for interview
            }
        }
        Map<Id,Integer> existingInterviewCountforEachCand = new Map<Id,Integer>();
        for(AggregateResult ar:[Select Candidate__c candId, count(Id) total from Interview__c where Candidate__c in :candidateMovingToInterview group by Candidate__c ]){
            existingInterviewCountforEachCand.put((Id)ar.get('candId'),(Integer)ar.get('total'));
        }
        
        
        List<Interview__c> interviewsToCreate = new List<Interview__c>();
        for(Id candId:candidateMovingToInterview ){
            
            Integer existingCount;
            if(existingInterviewCountforEachCand.containsKey(candId)){
                existingCount= existingInterviewCountforEachCand.get(candId);
            }else{
                existingCount=0;
            }
            
            String Stage_name;
            if(existingCount==0){
                Stage_name='Phone';
            }else if (existingCount ==1) {
                Stage_name = 'Technical';
            } else {
                Stage_name = 'Final';
            }
            
            interviewsToCreate.add(new Interview__c(
                Candidate__c = candId,
            Interview_Stage__c = Stage_name,
            Interview_Status__c = 'Scheduled',
            Scheduled_Date__c = Date.today().addDays(7)
                ));
        }
        
        
        
        if(!interviewsToCreate.isEmpty()){
            insert interviewsToCreate;
        }
    }
    
}