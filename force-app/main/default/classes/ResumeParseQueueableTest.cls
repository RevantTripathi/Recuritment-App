
@isTest
private class ResumeParseQueueableTest {


    @TestSetup
    static void setupTestData(){
        Job_Requisition__c job_req = new Job_Requisition__c(Title__c = 'Test Role', Department__c = 'Test', Status__c = 'Open');
        insert job_req;
        Candidate__c cand = new Candidate__c( Email__c = 'test@example.com', Phone__c = '9999999999', Stage__c = 'Applied', Outcome__c = 'Pending', Job_Requisition__c = job_Req.Id ); 
        insert cand;
    }

    @isTest
    static void testResumeParsUpdatesCanidate() {
        Candidate__c cand = [Select Id from Candidate__c Limit 1];
        Test.startTest();
        System.enqueueJob(new ResumeParseQueueable(cand.Id));
        Test.stopTest();

        Candidate__c updateCandidate = [Select Id, Parsed_Skills__c,Parse_Status__c, Parsed_JSON__c from Candidate__c where Id =:cand.Id] ;
        System.assertEquals('Success', updateCandidate.Parse_Status__c, 'Result is not successful');
        System.assertEquals('Apex, LWC, Flows',updateCandidate.Parsed_Skills__c,'Skilled should be updated');
        System.assert(updateCandidate.Parsed_JSON__c!=Null, 'Expected Parsed_JSON to be populated');

    }
}