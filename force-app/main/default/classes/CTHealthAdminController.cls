public with sharing class CTHealthAdminController {
   
    @AuraEnabled
    public static  Map<String,Integer> getPersonHealthStatusCount(){
        Map<String,Integer> statusCount =  CTPersonController.getHealthStatusCount();
        System.debug('The HealthStatus Of the Person is ' +statusCount);
        return statusCount;
    }


    //Adding tax call for merge
    @AuraEnabled
    public static Map<String,Integer> getLocationStatusCount(){
        Map<String,Integer> statusCount =  CTLocationController.getStatusCount();
        System.debug('The Status Of the Location is ' +statusCount);
        return statusCount;
        
    }
}
