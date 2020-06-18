public class PP_ProperyDetailsComponent {

public String RequestId{get;set;}

Public list<property_Detail__c> getPropertyDetails(){
list<property_Detail__c> listDetails=[select Property_Name__c,Quantity__c,UOM__c,Description__c,Boxes__c,Items__c,Pallets__c from property_Detail__c where request_details__c=:RequestId and Asset_Tag__c=null and Serial_No__c=null];
return listDetails;
}



Public Property_Detail__c getPropertyDetailsTotal(){
    list<property_Detail__c> listDetails=[select Property_Name__c,Quantity__c,UOM__c,Description__c,Boxes__c,Items__c,Pallets__c from property_Detail__c where request_details__c=:RequestId and Asset_Tag__c=null and Serial_No__c=null];
    Property_Detail__c propertyDetailsTotal = new Property_Detail__c();
    integer itemsTotal = 0;
    integer boxesTotal= 0;
    integer palletsTotal = 0; 
    
    for(Property_Detail__c propertyDetails : listDetails){
        if(propertyDetails.Items__c!=null && propertyDetails.Items__c.trim()!=''){
            itemsTotal+=Integer.valueof(propertyDetails.Items__c); 
        }
        if(propertyDetails.Boxes__c!=null && propertyDetails.Boxes__c.trim()!=''){
            boxesTotal+=Integer.valueof(propertyDetails.Boxes__c); 
        }
        if(propertyDetails.Pallets__c!=null && propertyDetails.Pallets__c.trim()!=''){
            palletsTotal+=Integer.valueof(propertyDetails.Pallets__c); 
        }
    }
    propertyDetailsTotal.Items__c=string.valueof(itemsTotal);
    propertyDetailsTotal.Boxes__c=string.valueof(boxesTotal);
    propertyDetailsTotal.Pallets__c=string.valueof(palletsTotal);
    
    return propertyDetailsTotal;
}


}