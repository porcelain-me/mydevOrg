@isTest
public class EnginesRequestsExtnControllerTest {
    
    public static testMethod void test_1()
    {
        Engines_Requests__c engineR = new Engines_Requests__c();
        ApexPages.StandardController engineCont= new ApexPages.StandardController(engineR);
        EnginesRequestsExtnController obj = new EnginesRequestsExtnController(engineCont);
        obj.calcAccount();
        obj.save();
        obj.sendEmailFoSetupTypeEngines();
         
        engineR = new Engines_Requests__c();
        RecordType RecordTypeId=[Select Id,name,DeveloperName from RecordType where DeveloperName ='TNL'];
        MSET_Account__c  testacct = new MSET_Account__c(name = 'ProdRequestAccount', recordtypeid = RecordTypeId.id);
        insert testacct;
        engineR.MSET_Account__c = testacct.Id;
        engineCont= new ApexPages.StandardController(engineR);
        obj = new EnginesRequestsExtnController(engineCont);
        engineR.Requested_By__c = null;
        obj.calcAccount();
        obj.save();
         
    }

}