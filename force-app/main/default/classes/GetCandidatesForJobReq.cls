public with sharing class GetCandidatesForJobReq {
    
    
    public class Input{
        @InvocableVariable(label='Job Req Id' description='Id of the Job Requisition' required=true)
        public Id jobReqId;
    }
    
    public class Output{
        @InvocableVariable(label='Candidate Id')
        public Id candidateId;
        
        @InvocableVariable(label='Candidate Name')
        public String candidateName;
    }
    
    @InvocableMethod(label='Get candidate under Job Req' description='Returns all candidates associated with a given Job Requisition')
    public static List<Output> getCandidateForJobReq(List<Input> inputs){
        

        Set <Id> jobReqIds= new Set<Id>();
        for (Input inp: inputs){
            jobReqIds.add(inp.jobReqId);
        }

        List<Candidate__c> allCandidates = [
            SELECT Id, Full_Name__c, Job_Requisition__c
            FROM Candidate__c
            WHERE Job_Requisition__c IN :jobReqIds
        ];

        // 3. Group candidates by their Job Requisition Id, multiple candidate can have same JobReqID,one map, where each Job Requisition Id points to the full list of candidates under it
        Map<Id, List<Candidate__c>> candidatesByJobReq = new Map<Id, List<Candidate__c>>();
        for (Candidate__c c : allCandidates) {

            //creating a bucket for each unique Job req Id
            if (!candidatesByJobReq.containsKey(c.Job_Requisition__c)) {
                candidatesByJobReq.put(c.Job_Requisition__c, new List<Candidate__c>());
            }

            //candidatesByJobReq.get('001XXXXX')  →  returns [Alice]
            // .add(c)                              →  adds Bob to that list
            candidatesByJobReq.get(c.Job_Requisition__c).add(c);
        }


        List<Output> results = new List<Output>();
        for (Input inp : inputs) {
            List<Candidate__c> matchedCandidates = candidatesByJobReq.get(inp.jobReqId);
            if (matchedCandidates != null) {
                for (Candidate__c c : matchedCandidates) {
                    Output out = new Output();
                    out.candidateId = c.Id;
                    out.candidateName = c.Full_Name__c;
                    results.add(out);
                }
            }
        }

        return results;


    }
}