public with sharing class ResumeParseQueueable implements Queueable {


    private Id candidateId;

    public ResumeParseQueueable(Id candidateId){
            this.candidatId = candidateId;
    }
    
    public void execute(QueueableContext context) {
       
        // TODO: implement job logic here
    }

    
}
