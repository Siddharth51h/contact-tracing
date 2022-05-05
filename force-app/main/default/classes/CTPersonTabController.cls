public with sharing class CTPersonTabController {
    @AuraEnabled
    public static UserInformation getPersonDetails(string userId){
       Person__c Person = CTPersonController.getPersonById(userId);
       List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(userId);
       UserInformation userInfo = new UserInformation();
       

       if(Person!=null){
      userInfo.name = Person.Name;
      userInfo.token = Person.Token__c;
      userInfo.statusUpdatedOn=Person.Status_Update_Date__c;
      userInfo.phone=Person.Mobile__c;
      userInfo.status=Person.Health_Status__c;


       }
       List<closeContacts> closeContactsList = new List<closeContacts>();
       Set<Id> ids = new Set<Id>();
       ids.add(userId);
       if(traces!=null && traces.size()>0){
        closeContacts con = new closeContacts();
           for (People_Tracing__c ptc : traces){
               
               if( ids.contains(ptc.Person_1__c)){
                con.Id= ptc.Person_2__c;
                con.status =ptc.Person_2__r.Health_Status__c;
                con.token=ptc.Person_2__r.Token__c;
                
                
               }
               if(ids.contains(ptc.Person_2__c)){
                con.Id= ptc.Person_1__c;
                con.status =ptc.Person_1__r.Health_Status__c;
                con.token=ptc.Person_1__r.Token__c;
                
                
               }
               closeContactsList.add(con);
                
           }
       }
       ids.clear();
       userInfo.conatcts=closeContactsList;
       

       return userInfo;
    }

    public class UserInformation{

       
       @AuraEnabled public string name;
       @AuraEnabled public string token;
       @AuraEnabled public Date statusUpdatedOn;
       @AuraEnabled public string phone;
       @AuraEnabled public string status;
       @AuraEnabled public string count;
       @AuraEnabled public List<closeContacts> conatcts;
    }

    public class closeContacts{
        @AuraEnabled public string Id;
       @AuraEnabled public string token;
       @AuraEnabled public Date contactDate;
       @AuraEnabled public string status;
    }
}
