public with sharing class CTRecentChangeController {
    @AuraEnabled
   public static List<Person__c> getRecentPersonHealthChanges(){

        return CTPersonController.getRecentHealthChanges();
    }
    @AuraEnabled
    public static  List<Location__c>  getRecentLocationStatusChanges(){

        return CTLocationController.getRecentStatusChange();

    }
    @AuraEnabled
    public static List<Person__c> searchPeople(string searchTerm){

        return CTPersonController.searchPeople(searchTerm);

    }
    @AuraEnabled
    public static List<Location__c> searchLocation(string searchTerm){

        return CTLocationController.searchLocation(searchTerm);

    }
}
