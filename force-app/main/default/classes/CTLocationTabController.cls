public with sharing class CTLocationTabController {
    @AuraEnabled
    public static locationInformation getLocationDetails(String locationId){

       Location__c location = CTLocationController.getLocationById(locationId);
       List<Location_Tracing__c> traces = CTLocationTracingController.getVisitors(locationId);
       LocationInformation locationInfo = new LocationInformation();
       
// Do not leave Space from--Test Branch 03
//Do not leave space
       if(location!=null){
      locationInfo.name = location.Address__c;
      locationInfo.pincode = location.Pincode__c;
      locationInfo.statusUpdatedOn=location.Status_Update_Date__c;
      locationInfo.redscore=string.valueOf(location.Red_Score__c);
      locationInfo.status=location.Status__c;


       }
       List<LocationContacts> closeContactsList = new List<LocationContacts>();
       Set<Id> ids = new Set<Id>();
       ids.add(locationId);
       if(traces!=null && traces.size()>0){
        LocationContacts con = new LocationContacts();
           for (Location_Tracing__c ptc : traces){
               
               if( ids.contains(ptc.Location__c)){
                con.Id= ptc.Person__c;
                con.name=ptc.Name;
                con.location =ptc.Location__c;
                con.contactDate=ptc.Visit_Date__c;
                
                
                
               }
               
               closeContactsList.add(con);
                
           }
       }
       ids.clear();
       locationInfo.conatcts=closeContactsList;
       

       return locationInfo;
    }

    public class LocationInformation{

       
       @AuraEnabled public string name;
       @AuraEnabled public string pincode;
       @AuraEnabled public Date statusUpdatedOn;
       @AuraEnabled public String redscore;
       @AuraEnabled public string status;
       @AuraEnabled public string count;
       @AuraEnabled public List<LocationContacts> conatcts;
    }

    public class LocationContacts{
        @AuraEnabled public string Id;
       @AuraEnabled public string name;
       @AuraEnabled public string location;
       @AuraEnabled public Date contactDate;
       
    }
}
