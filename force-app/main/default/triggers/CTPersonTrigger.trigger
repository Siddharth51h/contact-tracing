trigger CTPersonTrigger on Person__c (before insert,before Update,before Delete,after Insert,after Update,after Delete,after Undelete) {
 
 switch on Trigger.operationType {
     when BEFORE_INSERT  {
        CTPersonTriggerHandler.beforeInsert(trigger.new);
     }
     when BEFORE_UPDATE {
        CTPersonTriggerHandler.beforeUpdate(trigger.new,trigger.oldMap);
         
     }
 }
}