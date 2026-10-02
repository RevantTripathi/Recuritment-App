/**
 * CandidateSummaryAction
 *
 * Invocable Apex action used by the Agentforce "Recruitment Assistant" agent
 * (candidate_review topic) to fetch key profile details for a single candidate.
 *
 * Design notes:
 * - Called by the agent AFTER GetCandidatesForJobReq has already returned a list
 *   of candidates (with Ids) for a given Job Requisition. The agent resolves the
 *   user's natural-language candidate reference (e.g. a name) back to an Id from
 *   that earlier list, then invokes this action with that Id.
 * - Input/Output are bulk-safe (List in, List out) per Salesforce best practice,
 *   even though the agent currently invokes this one candidate at a time.
 * - Returns blank fields (not a skipped record) when a candidateId has no match,
 *   to preserve positional alignment between Input and Output lists.
 */





public with sharing class CandidateSummaryAction {
    
    public class Input{
        @InvocableVariable(label= 'Candidate Id' description ='Id of the candidate to summarize' required=true)
        public Id candidateId;
    }
    public class Output{
        @InvocableVariable(label='Full Name')
        public String fullName;
        
        @InvocableVariable(label='Stage')
        public String stage;
        
        @InvocableVariable(label='Skills')
        public String skills;
        
        @InvocableVariable(label='Year of Experience')
        public Integer yearOfExperience;
    }
    
    @InvocableMethod(label= 'Get candidate Summary' description='Return key profile details for a candidate, including name, stage,skills and year of experience, ')
    public static List<Output> getCandidateSummary(List<Input> inputs){
        
        //collect all the candidate id to summarize
        Set <Id> candidateIdToSummarize= new Set<Id>();
        for (Input candId: inputs){
            candidateIdToSummarize.add(candId.candidateId);
        }
        
        List<Candidate__c> candidateToSummarize = new List<Candidate__c>([Select Id,Full_Name__c,Stage__c,Parsed_Skills__c,Year_of_Experience__c from Candidate__c where Id in :candidateIdToSummarize]);
        
        
        List<Output> results = new List<Output>();
        //it directly converts your list of Sobject to Map of Sobject,(in built of Apex because query already has the Id of each record of the SObject)(Id, CandidateDetials)
        Map<Id,Candidate__c> candidateMap = new Map<Id,Candidate__c>(candidateToSummarize);
        
        for(Input candId: inputs){
            Candidate__c matchedCandidate = candidateMap.get(candId.candidateId);
            Output out = new Output();
            if(matchedCandidate!= null){
                out.fullName = matchedCandidate.Full_Name__c;
                out.stage = matchedCandidate.Stage__c;
                out.skills = matchedCandidate.Parsed_Skills__c;
                if (matchedCandidate.Year_of_Experience__c != null) {
                    out.yearOfExperience = matchedCandidate.Year_of_Experience__c.intValue();
                }
                
            }
            results.add(out);
        }
        
        return results;
    }
    
}