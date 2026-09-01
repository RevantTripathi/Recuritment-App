trigger CandidateTrigger on Candidate__c (after update) {

    new CandidateTriggerHandler().run();        // Delegates all logic to CandidateTriggerHandler. // Kept intentionally empty

}