public with sharing class CTPeopleTracingController {
   public static List<People_Tracing__c> getTraces(String RecordId){
       return [SELECT Id, Name, Contact_Date__c, Person_1__c,Person_2__r.Health_Status__c,Person_2__r.Token__c,Person_1__r.Health_Status__c,
       Person_1__r.Token__c, Contact_Type__c, Person_2__c 
       FROM  People_Tracing__c 
       Where (Person_1__c =:RecordId
       OR Person_2__c=:RecordId)
       AND Contact_Date__c = LAST_N_DAYS :30
       Order By Contact_Date__c desc];
   }

   public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces){
        Set<Id> personIds=new Set<Id>();
        for (People_Tracing__c newtraces:peopleTraces){
            if(!personIds.contains(newtraces.Person_1__c)){
                personIds.add(newtraces.Person_1__c);
            }
        }
        List<People_Tracing__c> existingRecords=[SELECT Id, Name, Contact_Date__c, Person_1__c, Contact_Type__c, Person_2__c 
        FROM  People_Tracing__c 
        Where Id IN :personIds];
        Map<Id,Set<Id>> peopleTracing = new Map<Id,Set<Id>>();
        if(existingRecords !=null && existingRecords.size()>0){
            for(People_Tracing__c ex:existingRecords){
                if(!peopleTracing.containsKey(ex.Person_1__c)){
                    peopleTracing.put(ex.Person_1__c,new Set<Id>());
                }
               peopleTracing.get(ex.Person_1__c).add(ex.Person_2__c);
               if(!peopleTracing.containsKey(ex.Person_2__c)){
                peopleTracing.put(ex.Person_2__c,new Set<Id>());
            }
           peopleTracing.get(ex.Person_2__c).add(ex.Person_1__c);
            
            }
        }
        List<People_Tracing__c> duplicateRecord= new List<People_Tracing__c>();
        for(People_Tracing__c newpeopleTraces:peopleTraces){
            if(peopleTracing.containsKey(newpeopleTraces.Person_1__c) && 
                peopleTracing.get(newpeopleTraces.Person_1__c).contains(newpeopleTraces.Person_2__c)
                ||peopleTracing.containsKey(newpeopleTraces.Person_2__c) && 
                peopleTracing.get(newpeopleTraces.Person_2__c).contains(newpeopleTraces.Person_1__c)){
                duplicateRecord.add(newpeopleTraces);
            }
        } 
        return duplicateRecord;

        
   }
    
}
