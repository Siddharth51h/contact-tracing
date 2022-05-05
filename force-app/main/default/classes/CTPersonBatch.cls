public with sharing class CTPersonBatch implements Database.Batchable<Sobject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date today=Date.today();
        Date filterDate=today-14;
        List<string> status= new List<String>{'Red','Yellow','Orange'};

        return Database.getQueryLocator('SELECT Health_Status__c, Id, Status_Update_Date__c FROM Person__c where Status_Update_Date__c =: filterDate AND Health_Status__c IN :status');
    }

    public void execute(Database.BatchableContext bc, List<Person__c> scope ){
        for(Person__c person :scope){
            Person.Health_Status__c='Green';
        }
        update scope;
    }

    public void Finish(Database.BatchableContext bc){
         
        CTLocationBatch lBatch = new CTLocationBatch();
        Database.executeBatch(lBatch,200);
    }
    
    
}
