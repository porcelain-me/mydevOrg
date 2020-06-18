@isTest(seeAllData='true')
public class RIF_WebService_MassPrint_Test {
    
    @isTest
    public static void test1(){
        Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;
            
        Project__c proj = [SELECT id FROM Project__c WHERE id=:snr.Project__c];
        
        Employee__c emp = [SELECT id, Name, User__c FROM Employee__c WHERE Id=:snr.Employee__c];
            
        RIF_Print_Project_Config__c printProj = new RIF_Print_Project_Config__c();
        printProj.Doc_Version__c = 'Draft';
        printProj.DocNames__c = 'All';
        printProj.Name = 'Test Config';
        printProj.Project__c = proj.Id;
        printProj.User__c = emp.User__c;
        printProj.SRIDs__c = snr.Id;
        insert printProj;
        
        insertAttachment(snr);
        
        User userObj = [SELECT id FROM USER WHERE Id = :emp.User__c];
        System.runAs(userObj) {
            Test.startTest();
                RIF_WebService_MassPrint webServiceObj = new RIF_WebService_MassPrint();
                
                String name = 'test';
                Blob body = Blob.valueOf('testbody');
                RIF_WebService_MassPrint.sf sfObj = new RIF_WebService_MassPrint.sf(name,body);
                
                RIF_WebService_MassPrint.sf[] webArray = RIF_WebService_MassPrint.getEncodedAttachments(proj.Id);
                System.assertNotEquals(1000, webArray.size(), 'Actual size of Array is ' + webArray.size());
            Test.stopTest();
        }
    }
    
    @isTest
    public static void test2(){
        Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;
            
        Project__c proj = [SELECT id FROM Project__c WHERE id=:snr.Project__c];
        
        Employee__c emp = [SELECT id, Name, User__c FROM Employee__c WHERE Id=:snr.Employee__c];
            
        RIF_Print_Project_Config__c printProj = new RIF_Print_Project_Config__c();
        printProj.Doc_Version__c = 'Final';
        printProj.DocNames__c = 'All';
        printProj.Name = 'Test Config';
        printProj.Project__c = proj.Id;
        printProj.User__c = emp.User__c;
        printProj.SRIDs__c = snr.Id;
        insert printProj;
        
        insertAttachment(snr);
        
        User userObj = [SELECT id FROM USER WHERE Id = :emp.User__c];
        System.runAs(userObj) {
            Test.startTest();
                RIF_WebService_MassPrint webServiceObj = new RIF_WebService_MassPrint();
                
                String name = 'test';
                Blob body = Blob.valueOf('testbody');
                RIF_WebService_MassPrint.sf sfObj = new RIF_WebService_MassPrint.sf(name,body);
                
                RIF_WebService_MassPrint.sf[] webArray = RIF_WebService_MassPrint.getEncodedAttachments(proj.Id);
                System.assertNotEquals(1000, webArray.size(), 'Actual size of Array is ' + webArray.size());
            Test.stopTest();
        }
    }
    
    public Static Id insertAttachment(Severance_And_Release__c sr) {
        Attachment attach = new Attachment();
        attach.Body = Blob.valueOf('This is a text body');
        attach.Description = 'Testing attachment';
        attach.Name = 'test.txt';
        attach.ParentId = sr.Id;
        insert attach;
        
        return attach.Id;
    }
}