/**
 * GetJobReqByName
 *
 * Invocable Apex action used by the Agentforce "Recruitment Assistant" agent
 * to resolve a Job Requisition's auto-number Name (e.g. 'JR0001') directly to
 * its Salesforce Id — without requiring the user to browse a list first.
 *
 * Design notes:
 * - Lets the agent handle a user typing an exact Job Req code directly
 *   (e.g. "show me candidates for JR0001"), resolving the Id in one call,
 *   then chaining into GetCandidatesForJobReq with that Id.
 * - Bulk-safe (List in, List out), consistent with the other actions, even
 *   though it's typically invoked with one name at a time.
 * - Map is built manually (not via the Map<Id, SObject> shortcut constructor),
 *   since the lookup key here is Name (String), not Id.
 * - Returns a blank Output (not a skipped record) when a name has no match,
 *   to preserve positional alignment between Input and Output lists.
 */

public with sharing class GetJobReqByName {

    public class Input{
        @InvocableVariable(label='Job req name' description='The auto-number Name of the Job Requisition, e.g. JR0001' required=true)
        public String jobReqName;
    }
    
    public class Output{
        @InvocableVariable(label='Id of the Job req')
        public Id jobReqId;
    }

    @InvocableMethod(label='Get job Id from Name' description='When user provides the Name of Job, return its Salesforce Id')
    public static List<Output> getJobReqByName(List<Input> inputs){

        Set<String> allJobReqNames = new Set<String>();

        for(Input inp: inputs){
            allJobReqNames.add(inp.jobReqName);
        }

        List<Job_Requisition__c> allJobReq = [Select Id, Name from Job_Requisition__c where Name in :allJobReqNames];

        Map<String, Job_Requisition__c> jobReqMap = new Map<String, Job_Requisition__c>();
        for(Job_Requisition__c j:allJobReq){
            jobReqMap.put(j.Name,j);
        }

        List<Output> result = new List<Output>();

        for(Input inp: inputs){
            Job_Requisition__c matchedJobs = jobReqMap.get(inp.jobReqName);

            Output out = new Output();
            if(matchedJobs != null){
                out.jobReqId = matchedJobs.Id;
            }
            result.add(out);
        }
        return result;
    }

}