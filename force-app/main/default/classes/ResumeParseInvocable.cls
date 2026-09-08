public class ResumeParseInvocable {
    
    // This is the WRAPPER class Flow will use to pass data IN
    public class Request{
        @InvocableVariable (required = True) //tells Flow's UI: 'you MUST provide a value for this field when configuring the action.'
        public Id candidateId;
    }

    @InvocableMethod(label='Enqueue Resume Parsing'description='Kicks off async resume parsing for a Candidate')
    public static void enqueueParsing(List<Request> Request){
        for( Request req: Request){
             System.enqueueJob(new ResumeParseQueueable(req.candidateId));
        }
    }
    
}