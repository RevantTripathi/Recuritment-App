@isTest
public class CandidateTriggerHandlerTest {

// Creates shared test data used by every @isTest method below. // Runs once automatically before each test method, with its own // isolated, auto-rolled-back copy of this data per test.

    @TestSetup
    static void setupTestData() { 

        Job_Requisition__c jobReq = new Job_Requisition__c(Title__c='Salesforce Developer', Department__c='Engineering',Status__c='Open');
        insert jobReq;

        Candidate__c cand = new Candidate__c(Email__c='test@gamail.com', Stage__c='Applied',Outcome__c='Pending', Phone__c='7309882920',Job_Requisition__c=jobReq.Id);
        insert cand;
    }


    @isTest
    static void testInterviewCreationOnStageChangeToInterview(){

        //This queries for the Candidate record created in @testSetup and testSetup already ran before this, so it will have the
        Candidate__c cand = [Select Id,Stage__c from Candidate__c Limit 1]; 
        
        
        Test.startTest();
        cand.Stage__c = 'Interview'; 
        update cand;                                       
        Test.stopTest();

        List<Interview__C> interview = [Select Id From Interview__c where Candidate__c =:cand.Id];
        system.assertEquals(1, interview.size(), 'Expected only one Interview Creation');

    }
}