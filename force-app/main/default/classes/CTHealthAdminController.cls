public with sharing class CTHealthAdminController {
   
    @AuraEnabled
    public static  Map<String,Integer> getPersonHealthStatusCount(){
        Map<String,Integer> statusCount =  CTPersonController.getHealthStatusCount();
        System.debug('The HealthStatus Of the Person is ' +statusCount);
        return statusCount;
    }
    //Adding comment for merge conflict
    // Adding another merge comment to check for merge conflict
    // Adding another merge conflict
    @AuraEnabled
    public static Map<String,Integer> getLocationStatusCount(){
        Map<String,Integer> statusCount =  CTLocationController.getStatusCount();
        System.debug('The Status Of the Location is ' +statusCount);
        return statusCount;
        
    }
}
