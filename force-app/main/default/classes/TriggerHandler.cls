public virtual class TriggerHandler {
    public void run(){
        if(!Trigger.isExecuting)
        return;

        if(Trigger.isBefore){
            if(Trigger.isInsert) beforeInsert(Trigger.new);
            if(Trigger.isUpdate) beforeUpdate(Trigger.new, Trigger.oldMap);
        }else{
            if(Trigger.isInsert) afterInsert(Trigger.new, Trigger.newMap);
            if(Trigger.isUpdate) afterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
            
        }
    }

    protected virtual void beforeInsert(List<SObject> newList) {} 
    protected virtual void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {} 
    protected virtual void beforeDelete(List<SObject> oldList, Map<Id, SObject> oldMap) {} 
    protected virtual void afterInsert(List<SObject> newList, Map<Id, SObject> newMap) {} 
    protected virtual void afterUpdate(List<SObject> newList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {} 
    protected virtual void afterDelete(List<SObject> oldList, Map<Id, SObject> oldMap) {} 
    protected virtual void afterUndelete(List<SObject> newList, Map<Id, SObject> newMap) {}
}