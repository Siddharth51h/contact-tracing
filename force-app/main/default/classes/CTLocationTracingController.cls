public with sharing class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
        FROM Location_Tracing__c Where Id=:locationId
        Order BY Visit_Date__c  desc];

    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id>personIds){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
        FROM Location_Tracing__c 
        Where Id IN:personIds 
        AND Visit_Date__c =LAST_N_DAYS:10
        Order BY Visit_Date__c  desc 
       ];
        
    }
    public static List<Location_Tracing__c> getLocatiopnByLocationIds(Set<Id>locationIds){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
        FROM Location_Tracing__c 
        Where Id IN:locationIds
        And Person__r.Health_Status__c='Green'
         AND Visit_Date__c =LAST_N_DAYS:10
        Order BY Visit_Date__c  desc 
        ];
    }
        /**
         * CheckDuplicates
         * @return list of Duplicates Location_Tracing__c record
         */
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c>locationTraces){
            set<Id> locationIds=new Set<Id>();
            Set<Id> personIds= new Set<Id>();
            for(Location_Tracing__c newloc:locationTraces){
                locationIds.add(newloc.Location__c);
                personIds.add(newloc.Location__c);
            }
            List<Location_Tracing__c> existingLocations= [SELECT Id, Name, Person__c, Location__c, Visit_Date__c 
            FROM Location_Tracing__c 
            Where Id IN:locationIds
            And Person__c In:personIds];
            Map<Id,set<Id>> mapOfLocationandPerson= new Map<Id,set<Id>>();
            List<Location_Tracing__c>duplicaterlocatiotracingrecords=new List<Location_Tracing__c>();
            if(existingLocations!=null && existingLocations.size()>0){
                    for(Location_Tracing__c ltc : existingLocations){
                        if(!mapOfLocationandPerson.containsKey(ltc.Location__c)){
                            mapOfLocationandPerson.put(ltc.Location__c,new Set<Id>());
                        }
                        mapOfLocationandPerson.get(ltc.Location__c).add(ltc.Person__c);
                    }
                    
                    
            }
            for(Location_Tracing__c findlocationtraces:locationTraces){
                if(mapOfLocationandPerson.containsKey(findlocationtraces.Location__c)&& 
                mapOfLocationandPerson.get(findlocationtraces.Location__c).contains(findlocationtraces.Person__c))
                duplicaterlocatiotracingrecords.add(findlocationtraces);
            }

        return duplicaterlocatiotracingrecords;
    }

}

