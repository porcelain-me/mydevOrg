global class BatchContactUpdate implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    
    global Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, BillingStreet, BillingCity, BillingState, ' +
            'BillingPostalCode, (SELECT ID, MailingStreet, MailingCity, ' +
            'MailingState, MailingPostalCode FROM Contact) FROM Account ' + 
            'Where billingcountry = \'USA\''
        );
    }

    global void execute(Database.BatchableContext bc, List<Account> List2){
        
        List<Contact> contacts = new List<Contact>();
        for (Account account : List2) {
            for (Contact contact : account.contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingPostalCode = account.BillingPostalCode;
                
                contacts.add(contact);
                
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update contacts;
    }    

    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. saurabh!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        
        System.debug('Totalrecord processed'+ recordsProcessed);
    }    

}