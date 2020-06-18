@isTest
public class PostTradeRequestTest {
    
  static testMethod void Page_Test_1()
    { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@morganstanley.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@morganstanley.com.test');
        
        insert u;
        
       System.runAs(u) {
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        RDS_Request__c reAccount = new RDS_Request__c();
        reAccount.MSET_Account__c=testacct.id;
        reAccount.Target_Date__c=date.today();
        reAccount.NA_Coverage_Person__c='Scott.Barry@morganstanley.com.test';
        reAccount.Priority__c='low';
        reAccount.Trade_Region__c='North America';
        
        insert reAccount;
        }
        
    }   
}