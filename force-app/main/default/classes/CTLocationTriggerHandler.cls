public with sharing class CTLocationTriggerHandler {
     public static Void beforeInsert(List<Location__c> newLocations){
         for(Location__c loc:newLocations){
             loc.Status__c='Green';
             
         }
     }
     public static Void beforeUpdate(List<Location__c> newLocations,Map<Id,Location__c> oldMap){
        for(Location__c loc:newLocations){
            if(loc.Status__c!=oldMap.get(loc.Id).Status__c){
                loc.Status_Update_Date__c=Date.today();
            }
            
        }
    }
    public static Void afterUpdate(List<Location__c> newLocations,Map<Id,Location__c> oldMap){
        Set<Id> locationIds = new Set<Id>();
        for(Location__c loc:newLocations){
            if(loc.Status__c=='Red' && oldMap.get(loc.Id).Status__c !='Red'){
                locationIds.add(loc.Id);
            }
            
        }
       List<Location_Tracing__c> locationTracingrecords =CTLocationTracingController.getLocatiopnByLocationIds(locationIds);
        Set<Id> personIds = new Set<Id>();
       for(Location_Tracing__c lcr:locationTracingrecords ){
            personIds.add(lcr.Person__c);
       }
       List<Person__c> personsToUpdate = new List<Person__c>();
       for (Id pid : personIds){
        personsToUpdate.add(new Person__c(Id=pid,Health_Status__c='Yellow'));
       }
       update personsToUpdate;
    }
}
