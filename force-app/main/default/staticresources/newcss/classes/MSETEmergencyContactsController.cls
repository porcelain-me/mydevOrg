public class MSETEmergencyContactsController {
    
    public List<MSET_Contact__c> contacts {get;set;}
    
    public string region {get;set;}
    
    public MSETEmergencyContactsController(){
        
       region= ApexPages.currentPage().getParameters().get('region');
        
       getEmergencyContacts(); 
        
    }
    
    public List<MSET_Contact__c> getEmergencyContacts(){
        
        contacts= [Select Id, MSET_Account__r.Name, MSET_Account__c, Email__c, Emergency_Contact_for__c, FirstName__c, LastName__c, Phone__c, Title__c
                   from MSET_Contact__c where Emergency_Contact_for__c includes (:region) ];
        
        return contacts;
        
        
    }

}