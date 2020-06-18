/* Test class SharePrjtWithUsr_Batch class */ 
@isTest
public class SharePrjtWithUsr_Batch_Test {
    private static final string PROJECT_BASED_TERMINATION = 'Project Based Termination';
    public static void setupData(){
        // insert project
        RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
        insert proj;
        
        // insert user
        User tempUsr = RIF_TestClassUtilities.getALLMSUser();
        insert tempUsr;
        
        List<Share_Projects_with_User__c> prjtUserList = new List<Share_Projects_with_User__c>();
        //for(Integer i = 0 ; i <= 10 ; i++){
            Share_Projects_with_User__c temp = new Share_Projects_with_User__c(Project_ID__c = proj.Id , User_ID__c = tempUsr.Id);
            prjtUserList.add(temp);
        //}
        if(prjtUserList != null && !prjtUserList.isEmpty()){
            insert prjtUserList;
        }
    }
    public static testMethod void testBatch(){
        setupData();
        Test.startTest();
        Id batchId = Database.executeBatch(new SharePrjtWithUsr_Batch(), 200);
        Test.stopTest();
    }
}