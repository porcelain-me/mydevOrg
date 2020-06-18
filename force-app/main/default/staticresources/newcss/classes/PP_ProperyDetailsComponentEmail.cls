public class PP_ProperyDetailsComponentEmail {

public String RequestId{get;set;}

Public list<property_Detail__c> getPropertyDetails(){
list<property_Detail__c> listDetails=[select Property_Name__c,Quantity__c,UOM__c,Description__c,Items__c,Boxes__c,Pallets__c from property_Detail__c where request_details__c=:RequestId];
return listDetails;
}


}