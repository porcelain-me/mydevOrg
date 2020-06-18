@isTest (SeeAllData = false)  
public class PP_ActivateUserTest {
public static testMethod void activateuser()
     {                                            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,Emp_Id__c='15ABC', isActive=false,  
        TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');        
        insert tempUser;
        
        User userObj=[select id from User where id =:tempUser.id LIMIT 1];
	   Test.startTest();    
        PP_ActivateUser.updateApproverUser(userObj.Id);
       Test.stopTest();
}
}