public with sharing class CTLocationBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start (Database.BatchableContext bc){
        Date today=Date.today();
        Date filterDate=today-14;
        List<string> status= new List<String>{'Red','Yellow','Orange'};

        return Database.getQueryLocator('SELECT Id, Status_Update_Date__c, Status__c FROM Location__c where Status_Update_Date__c =: filterDate AND Status__c IN :status');
    }
    //Adding Comment
    public void execute(Database.BatchableContext bc, List<Location__c> scope ){
        for(Location__c location :scope){
            location.Status__c='Green';
        }
        update scope;
    }

    public void Finish(Database.BatchableContext bc){
         
        system.debug('Person Health Status Updated which are 14 days old.');
    }
}
