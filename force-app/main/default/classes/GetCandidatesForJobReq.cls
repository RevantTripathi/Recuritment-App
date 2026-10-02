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
    
    @InvocableMethod(label='Get candidate under Job Req' description='Return the candidates under one job requisitions under ')
    public static List<Output> getCandidateForJobReq(List<Input> inputs){
        
    }
}