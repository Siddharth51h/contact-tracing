public with sharing class CTPeopleTracingTiggerHandler {
    public static void beforeInsert(List<People_Tracing__c> newRecords){
     List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecords);
     if(duplicates!=null && duplicates.size()>0){
         for(People_Tracing__c ptc:newRecords){
             ptc.addError('The duplicate found. Person 1:'+ptc.Person_1__c +'Person 2 :'+ptc.Person_2__c);
         }
     }

    }
}
