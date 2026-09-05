trigger OfferTrigger on Offer__c (after update) {
    new OfferTriggerHandler().run();
}