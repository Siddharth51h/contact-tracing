public with sharing class CTLocationTracingTriggerHandler {
    public static Void beforInsert(List<Location_Tracing__c>newRecords){
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecords);
        
    if(duplicates!=null && duplicates.size()>0){
        for(Location_Tracing__c ltc :duplicates){
            ltc.addError('Duplicate Found location :'+ltc.Location__c+ 'Person:'+ltc.Person__c);
            
            }
        }
    }
}
