public with sharing class testNewContactPage {
	
	    static testMethod void Page_Test_1()
    {
        PageReference pageRef = Page.ContactsEdit;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'ContactRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        MSET_Contact__c test_1 = new MSET_Contact__c();
        ApexPages.StandardController conreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Phone__c = '+1 215 2341234';
        test_1.FirstName__c = 'Macy';
        test_1.LastName__c = 'Summers';
        //test_1.TITLE = 'UNKNOWN';
        test_1.TITLE__C = 'UNKNOWN';
        test_1.MailingStreet__c = '225 City Line Avenue Suite 200';
        test_1.MailingCity__c = 'Bala Cynwyd';
        test_1.MailingState__c = 'Pennsylvania';
        test_1.MailingPostalCode__c = '19004';
        test_1.MailingCountry__c = 'United States of America';
        insert test_1;

        ContactControllerExtension contactrequest_extn = new ContactControllerExtension(conreq);
        
        //System.assertEquals(contactrequest_extn.calcIsPEFprofile(),0);
        System.assertEquals(contactrequest_extn.getPEFprofile(),0);

   }
	

}