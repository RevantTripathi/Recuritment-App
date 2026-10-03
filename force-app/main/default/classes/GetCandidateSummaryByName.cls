/**
 * GetCandidateSummaryByName
 *
 * Invocable Apex action used by the Agentforce "Recruitment Assistant" agent
 * to resolve a Candidate's auto-number Name (e.g. 'CAND0001') directly to
 * their full profile summary — in a single call, with no prior list-fetch
 * or Id-resolution step required.
 *
 * Design notes:
 * - Complements CandidateSummaryAction (Id-based): this one serves the
 *   "user already knows the exact candidate code" conversational path,
 *   while CandidateSummaryAction serves the Job-Req-list drill-down path.
 *   Both return the same shape of summary data, just via different inputs.
 * - Bulk-safe (List in, List out), manual Map<String, SObject> build
 *   (Name is the key, not Id, so the shortcut Map constructor doesn't apply).
 * - Returns a blank Output (not a skipped record) when a name has no match,
 *   to preserve positional alignment between Input and Output lists.
 */

public with sharing class GetCandidateSummaryByName {
    
    
    public class Input{
        @InvocableVariable(label='Candidate Name' description='The auto-number Name of the Candidates eg CAND0001' required=true)
        public String candName;
    }
    
    
    public class Output{
        @InvocableVariable(label='Candidate Id')
        public Id candId;
        
        @InvocableVariable(label='Full Name')
        public String fullName;
        
        @InvocableVariable(label='Stage')
        public String stage;
        
        @InvocableVariable(label='Skills')
        public String skills;
        
        @InvocableVariable(label='Year of Experience')
        public Integer yearOfExperience;
    }
    
    @InvocableMethod(label='Get Candidate Summary by Name' description= 'When user provides the Name of a Candidate (e.g. CAND0001), return their full profile summary — stage, skills, and years of experience')
    public static List<Output> getCandidateSummaryByName(List<Input> inputs){
        
        Set<String> allCandidateNames = new Set<String>();
        for(Input inp: inputs){
            allCandidateNames.add(inp.candName);
        }
        
        List<Candidate__c> allCandidates = [Select Id,Name,Full_Name__c,Stage__c,Parsed_Skills__c,Year_of_Experience__c from Candidate__c where Name in :allCandidateNames];
        
        Map<String,Candidate__c> candidateMap = new Map<String, Candidate__c>();
        for(Candidate__c cand: allCandidates){
            candidateMap.put(cand.Name,cand);
        }
        
        List<Output> result = new List<Output>();
        for(Input inp: inputs){
            Candidate__c matchedCandidate = candidateMap.get(inp.candName);
            Output out = new Output();
            if(matchedCandidate != null){
                out.candId = matchedCandidate.Id;
                out.fullName = matchedCandidate.Full_Name__c;
                out.stage = matchedCandidate.Stage__c;
                out.skills = matchedCandidate.Parsed_Skills__c;
                if (matchedCandidate.Year_of_Experience__c != null) {
                    out.yearOfExperience = matchedCandidate.Year_of_Experience__c.intValue();
                }
            }
            
            result.add(out);
            
        }
        
        return result;
    }
}