trigger CTPeopleTracingTrigger on People_Tracing__c (before insert) {
       
    switch on trigger.operationType {
        when BEFORE_INSERT {
            CTPeopleTracingTiggerHandler.beforeInsert(Trigger.new);
        }
        when else {
            
        }
    }
    
}