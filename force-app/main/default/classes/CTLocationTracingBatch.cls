
    public with sharing class CTLocationTracingBatch implements Database.Batchable<SObject> {
    
        public Database.Querylocator start(Database.BatchableContext Bc){
            
            return Database.getQueryLocator('Select Id from Location_Tracing__c where visit_Date__C < Last_N_Days:30');
        }
        public void execute(Database.BatchableContext Bc, List<Location_Tracing__c> scope){
            
            delete scope;
    
        }
    // comment from --- Test Branch 03
        public void Finish(Database.BatchableContext bc){
            CTPersonBatch pBatch= new CTPersonBatch();
         Database.executeBatch(pBatch,200);
        }
    }
    

