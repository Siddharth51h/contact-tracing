public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChange(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c
        Order By Status_Update_Date__c desc NULLS LAST LIMIT 100];
    }

    public static List<Location__c> searchLocation(String searchTerm){
        searchTerm = searchTerm + '%';
        List<Location__c> listSearchedLocation=[SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c
         where Name Like :searchTerm 
                                    OR Pincode__c Like :searchTerm 
                                    OR Address__c Like :searchTerm 
                                    Order By Status_Update_Date__c desc NULLS LAST];
        return listSearchedLocation;
    }
    /**
     * search a Location  by Id
     * @return Location__c
     */
    public static Location__c getLocationById(String locationId){
        List<Location__c> location=[SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c where Id=:locationId];
        if(location!=null&&location.size()>0){
            return location[0];
        }
        return null;
    }
     /**
     * get the number of people in each Health Status
     * @ return Map<String,Integer>
     */
    public static Map<String,Integer> getStatusCount(){
        AggregateResult[] countOfStatus =[SELECT Status__c ,  Count(Id)
        FROM Location__c
        Group By Status__c];
         Map<String,Integer> mapOfStatusCount= new Map<String,Integer>();
         for(AggregateResult agr:countOfStatus){
           
            mapOfStatusCount.put(String.valueOf(agr.get('Status__c')),Integer.valueOf(agr.get('expr0')));
         }
         return mapOfStatusCount;
     }
}

