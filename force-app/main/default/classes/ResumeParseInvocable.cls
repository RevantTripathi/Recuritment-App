public class ResumeParseInvocable {
    
    // This is the WRAPPER class Flow will use to pass data IN
    //Request is a container/box that HOLDS an Id — it's not itself an Id. So List<Request> isn't a list of Ids directly; it's a list of small boxes, and each box happens to have one compartment inside it, labeled candidateId
    
    public class Request{
        @InvocableVariable (required = True) //tells Flow's UI: 'you MUST provide a value for this field when configuring the action.'
        public Id candidateId;
    }
    
    @InvocableMethod(label='Enqueue Resume Parsing'description='Kicks off async resume parsing for a Candidate')
    public static void enqueueParsing(List<Request> request){
        for( Request req: request){
            System.enqueueJob(new ResumeParseQueueable(req.candidateId));
        }
    }
    
}