// 09/30/2013 : MG : ORIGINAL
// A batch class which updates Employee Name Field with First Name <Space> Last Name.
// This is one time run batch

global class Batch_UpdateEmployeeMailId implements Database.Batchable<SObject>{
    
    static final string QUERY = 'Select Name, First_Name__c, Last_Name__c, Email__c from Employee__c';
    global Database.QueryLocator start(Database.BatchableContext c) {    
        return Database.getQueryLocator(QUERY);        
    }
  
    global void execute(Database.BatchableContext c, List<Sobject> objects) {
        String email;
        
        for(sObject obj : objects){
            email = obj.get('Email__c') <> null ? (String)obj.get('Email__c') : 'test@ms.com';
            obj.put('Email__c', email + '.dev');
        }
        try{
            update objects;
        }catch(exception ex){
            system.debug('Error while updating employees:' + ex.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext c) {
    }
  
}