public with sharing class CTPeopleTracingBatch implements Database.Batchable<SObject> {
    
    public Database.Querylocator start(Database.BatchableContext Bc){
        
        return Database.getQueryLocator('Select Id from People_Tracing__c where contact_Date__C < Last_N_Days:30');
    }
    public void execute(Database.BatchableContext Bc, List<People_Tracing__c> scope){
        
        delete scope;

    }

    public void Finish(Database.BatchableContext bc){
        CTLocationTracingBatch ltBatch= new CTLocationTracingBatch();
        Database.executeBatch(ltBatch,200);
    }
}
