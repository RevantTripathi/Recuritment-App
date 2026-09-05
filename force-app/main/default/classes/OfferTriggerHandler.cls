public class OfferTriggerHandler extends TriggerHandler {
    protected override void afterUpdate(List<SObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        
        List<Offer__c> newOffer = (List<Offer__c>)newList;
        Map<Id,Offer__c> oldOffersMap = (Map<Id,Offer__c>)oldMap;
        
        Set<Id> eligbleOffers = new Set<Id>();
        
        for(Offer__c off:newOffer){
            
            offer__c oldOffer = oldOffersMap.get(off.Id);
            if(off.Status__c== 'Approved' && oldOffer.Status__c != 'Approved'){
                eligbleOffers.add(off.Id);
            }
        }
        
        if (eligbleOffers.isEmpty()) {
            return;
        }
        
        Map<Id, Id> approverIdByOfferId = new Map<Id, Id>();
        
        for(ProcessInstanceStep step:[SELECT Id,ActorId,ProcessInstance.TargetObjectId from ProcessInstanceStep where StepStatus ='Approved' and ProcessInstance.TargetObjectId in :eligbleOffers]){
            
            approverIdByOfferId.put(step.ProcessInstance.TargetObjectId, step.ActorId);
            
        }
        
        List<Offer__c> offersToUpdate = new List<Offer__c>();
        for(Id eOffer: eligbleOffers){
            if(approverIdByOfferId.containsKey(eOffer)){
                Offer__c newOfferToadd = new Offer__c();
                newOfferToadd.Id = eOffer;
                newOfferToadd.Approved_By__c = approverIdByOfferId.get(eOffer);
                
                offersToUpdate.add(newOfferToadd);
            }
        }
        
        if(!offersToUpdate.isEmpty()){
            update offersToUpdate;
        }
        
    }
}