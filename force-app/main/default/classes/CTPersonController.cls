public with sharing class CTPersonController {
    
    public  static String getToken(string mobilenumber){
     Blob numberConvertedtoBlob=  Blob.valueOf(mobilenumber);
     Blob encryptedMobileNumber=(Crypto.generateDigest('MD5', numberConvertedtoBlob));
     //get the string value of hash blob

     return EncodingUtil.base64Encode(encryptedMobileNumber);
    }
    public static List<Person__c> getRecentHealthChanges(){
        List<Person__c> listPersons=[SELECT Id,  Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c Order By Status_Update_Date__c desc NULLS LAST LIMIT 100];
        return listPersons;
    }
    /**
     * search a person by name,token or mobile
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        List<Person__c> listSearchedPeople=[SELECT Id,  Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c where Name Like :searchTerm 
                                    OR Mobile__c Like :searchTerm 
                                    OR Token__c Like :searchTerm 
                                    Order By Status_Update_Date__c desc NULLS LAST];
        return listSearchedPeople;
    }
    /**
     * search a person by Id
     * @return Person__c
     */
    public static Person__c getPersonById(String personId){
        List<Person__c> person=[SELECT Id,  Name,  Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c where Id=:personId];
        if(person!=null&&person.size()>0){
            return person[0];
        }
        else{
            return null;
        }
        
    }
    /**
     * get the number of people in each Health Status
     * @ return Map<String,Integer>
     */
    public static Map<String,Integer> getHealthStatusCount(){
       AggregateResult[] countOfHealthStatus =[SELECT  Health_Status__c,  Count(Id)
        FROM Person__c
        Group By Health_Status__c];
        Map<String,Integer> mapOfHealthStatusCount= new Map<String,Integer>();
        for(AggregateResult agr:countOfHealthStatus){
          
            mapOfHealthStatusCount.put(String.valueOf(agr.get('Health_Status__c')),Integer.valueOf(agr.get('expr0')));
        }
        return mapOfHealthStatusCount;
    }
    public static Set<Id> getAllCohabitants(Set<Id> updatedPersonIds,Set<Id> alreadyProcessed){
        
        Set<String> healthStatus= new Set<String>{'Green','Yellow'};
        Set<Id> cohabitant =new Set<Id>();
        
      List<People_Tracing__c> cohabitants= [SELECT Id, Name, Contact_Date__c, Person_1__c, Contact_Type__c, Person_2__c 
        FROM  People_Tracing__c
        Where Contact_Type__c='Cohabitant'
        And (Person_1__c IN : updatedPersonIds OR Person_2__c IN : updatedPersonIds)
        And (Person_1__r.Health_Status__c  IN : healthStatus OR  Person_2__r.Health_Status__c  IN : healthStatus )];
      
        for(People_Tracing__c pt : cohabitants){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                cohabitant.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                cohabitant.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return cohabitant;
    }
    public static Set<Id> getAllNeighbour(Set<Id> updatedPersonIds,Set<Id> alreadyProcessed){
        
        Set<String> healthStatus= new Set<String>{'Green'};
        Set<Id> neighbour =new Set<Id>();
       
      List<People_Tracing__c> Neighbours= [SELECT Id, Name, Contact_Date__c, Person_1__c, Contact_Type__c, Person_2__c 
        FROM  People_Tracing__c
        Where Contact_Type__c='Neighbour'
        And (Person_1__c IN : updatedPersonIds OR Person_2__c IN : updatedPersonIds)
        And (Person_1__r.Health_Status__c  IN : healthStatus OR  Person_2__r.Health_Status__c  IN : healthStatus )];
      
        for(People_Tracing__c pt : Neighbours){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                neighbour.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
           
                if(!alreadyProcessed.contains(pt.Person_2__c)){
                    neighbour.add(pt.Person_2__c);
                    alreadyProcessed.add(pt.Person_2__c);
                }
        }
        return neighbour;
    }
    public static Set<Id> getAllPrimaryContact(Set<Id> updatedPersonIds,Set<Id> alreadyProcessed){
       
        Set<String> healthStatus= new Set<String>{'Green','Yellow'};
        Set<Id> primaryContact =new Set<Id>();
       
      List<People_Tracing__c> Contacts= [SELECT Id, Name, Contact_Date__c, Person_1__c, Contact_Type__c, Person_2__c 
        FROM  People_Tracing__c
        Where Contact_Type__c='Other'
        And (Person_1__c IN : updatedPersonIds OR Person_2__c IN : updatedPersonIds)
        And (Person_1__r.Health_Status__c  IN : healthStatus OR  Person_2__r.Health_Status__c  IN : healthStatus )];
      
        for(People_Tracing__c pt : Contacts){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                primaryContact.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            
                if(!alreadyProcessed.contains(pt.Person_2__c)){
                    primaryContact.add(pt.Person_2__c);
                    alreadyProcessed.add(pt.Person_2__c);
                }
        }
        return primaryContact;
    }
   
    public static Set<Id> getAllSecondaryContact(Set<Id> updatedPersonIds,Set<Id> alreadyProcessed){
       
        Set<String> healthStatus= new Set<String>{'Green'};
        Set<Id> SecondaryContact =new Set<Id>();
        
      List<People_Tracing__c> Contacts= [SELECT Id, Name, Contact_Date__c, Person_1__c, Contact_Type__c, Person_2__c 
        FROM  People_Tracing__c
        Where Contact_Type__c='Other'
        And (Person_1__c IN : updatedPersonIds OR Person_2__c IN : updatedPersonIds)
        And (Person_1__r.Health_Status__c  IN : healthStatus OR  Person_2__r.Health_Status__c  IN : healthStatus )];
      
        for(People_Tracing__c pt : Contacts){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                SecondaryContact.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            
                if(!alreadyProcessed.contains(pt.Person_2__c)){
                    SecondaryContact.add(pt.Person_2__c);
                    alreadyProcessed.add(pt.Person_2__c);
                }
        }
        return SecondaryContact;
    }
    
}
