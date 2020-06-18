@isTest(SeeAllData=true)
public class RIF_TemplateManagementControllerTest{
    static testMethod void myTest(){
        
        Severance_And_Release__c snr  = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;
        
        Attachment attach= new Attachment();    

        attach.Name='Unit Test Attachment';

        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');

        //attach.body=bodyBlob;

        //attach.parentId=snr.id;
        
        String selectedTemplate = snr.id;
        String selectedTemplate1 = null;
        
        //insert attach;

        Test.startTest();
        
        RIF_TemplateManagementController obj = new RIF_TemplateManagementController();
        RIF_TemplateManagementController obj1 = new RIF_TemplateManagementController();
        //obj.congaContentWrapper obj1 = new congaContentWrapper();
        
        
        
        obj.selectedTemplate = selectedTemplate;
        obj1.selectedTemplate = selectedTemplate1;
        obj1.selectedTag = 'Test';
        obj1.tempName= 'Test';
        obj1.otherTags = 'Test';
        obj.NewAttachment = attach;
        obj.NewAttachment.body = bodyBlob;
        obj.selectedContent = 'Package_Receipt_Date__c' ;
        obj.attach();
        obj.savecontent();
        obj1.savecontent();
        obj.refreshContents();
        obj.getLatestLinkURL();
        obj.getContents();
        obj.getsrTags();
        obj.displayContent();
        obj.getotherTagsList();
        obj.refreshtags();
        
        Test.stopTest();
    }
}