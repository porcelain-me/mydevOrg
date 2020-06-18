global with sharing class CustomsettingList {
	@auraEnabled
    public static List<Force_Activation__c> getAllregistrations() {
     	List<Force_Activation__c> reg = [SELECT Id, Display_Label__c, Encoded_URL__c FROM Force_Activation__c WHERE Display_Label__c != null ORDER BY Display_Label__c ASC];
        return reg;
    }
}