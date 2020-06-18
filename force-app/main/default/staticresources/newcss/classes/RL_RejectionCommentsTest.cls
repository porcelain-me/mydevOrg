@isTest(SeeAllData=false)
public class RL_RejectionCommentsTest {
    
    public RL_RejectionCommentsTest()
    {
    system.debug('------------Test------------');
    }
       
    static testmethod void testRejComments()
    { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
      
         
       system.runas(tempUser)
       {
       Test.startTest();   
           RL_RejectionComments rc = new RL_RejectionComments();
           rc.getActorDetails();
           rc.getApprovalSteps();              
            
       Test.stopTest();
    }    
    
    } 
    
}