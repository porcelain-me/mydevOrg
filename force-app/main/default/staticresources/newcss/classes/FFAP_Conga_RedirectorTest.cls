@isTest(SeeAllData = false)
private class FFAP_Conga_RedirectorTest {
    private static User ffapUser;
    private static Employee__c emp1;
    private static Employee__c emp3;
    private static FFAP_Agreement__c faAgreement1;
    private static FFAP_Agreement__c faAgreement2;
    private static List<Attachment> attachList;
    private static JPN_Change__c jpnChange;
    private static FA_Account__c faAccount;
    
    private static final Integer PRIMARY_COUNT = 0;
    private static final Integer JPN_COUNT = 1;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT;
    
   	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	String uId = userinfo.getUserId();
        	
        	User u = [select emp_id__c, email from User where id = :uId];
        	
        	Employee__c e = new Employee__c (name = 'Test User',  email__c=u.email, emp_id__c = u.emp_id__c);
        	insert e;
        	
        	
        	PageReference pageRef = Page.FFAP_Conga_Redirector;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().put('packageType', 'Commitment');
        	
        	FFAP_Conga_Redirector frd = new FFAP_Conga_Redirector();
        	
        	frd.generateDocumentForCommitment();
        	frd.generateCongaTemplates();
        	frd.generateDocuments();
        	frd.goToEmbeddedSigning_ForPreviousCommitment();
        	frd.generateDocumentsOld();
        	frd.logError('test');
        	frd.goToSigning();
        	frd.commitmentEnvId = 'test';
        	frd.goToSigning();
        	frd.checkDocumentGenerationStatus();
        	 
        	Test.StopTest();
     
    }
}