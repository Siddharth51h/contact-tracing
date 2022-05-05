public with sharing class CTPersonTriggerHandler {
    public static void beforeInsert( List<Person__c> newPersons){
        for(Person__c person:newPersons){
            person.Health_Status__c='Green';
            person.Token__c=CTPersonController.getToken(person.Mobile__c);
        }
    }
    public static void beforeUpdate(List<Person__c> newRecords,Map<Id,Person__c> oldRecords ){
       for(Person__c n:newRecords){
           if(n.Health_Status__c!=oldRecords.get(n.Id).Health_Status__c){
               n.Status_Update_Date__c=Date.today();
           }
       }
    }
    public static void afterUpdate(List<Person__c> newRecords,Map<Id,Person__c> oldRecords ){
        Set<Id> StatusChange=new Set<Id>();
        Set<Id> RedStatus =new Set<Id>();
        for(Person__c n :newRecords){
            if(n.Health_Status__c == 'Red' && oldRecords.get(n.Id).Health_Status__c!= 'Red'){
                RedStatus.add(n.Id);
            }
        }
        Set<Id> orangeStatus= new Set<Id>();
        Set<Id> yellowStatus= new Set<Id>();
        Set<Id> alreadyProcessed= new Set<Id>();
        alreadyProcessed.addAll(RedStatus);
        orangeStatus.addAll(CTPersonController.getAllCohabitants(RedStatus,alreadyProcessed));
        Set<Id> primaryContactIds= CTPersonController.getAllPrimaryContact(RedStatus,alreadyProcessed);
        orangeStatus.addAll(primaryContactIds);
       
         yellowStatus.addAll(CTPersonController.getAllSecondaryContact(primaryContactIds,alreadyProcessed)); 
        yellowStatus.addAll(CTPersonController.getAllNeighbour(RedStatus,alreadyProcessed));
       List<Person__c> personRecordstobeUpdated= new List<Person__c>();
        for(Id yellow :yellowStatus){
            personRecordstobeUpdated.add(new Person__c(Id=yellow,Health_Status__c='Yellow'));
        }
        for(Id Orange :orangeStatus){
            personRecordstobeUpdated.add(new Person__c(Id=Orange,Health_Status__c='Orange'));
        }

        update personRecordstobeUpdated;
     }
     
}
