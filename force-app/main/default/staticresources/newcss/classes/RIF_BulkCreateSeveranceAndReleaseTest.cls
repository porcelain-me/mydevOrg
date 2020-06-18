@isTest
public class RIF_BulkCreateSeveranceAndReleaseTest{
    
    private static testMethod void bulkCreateSeveranceAndReleaseTest() {
        
        Test.starttest();
        PageReference thePage = Page.RIF_BulkCreateSeveranceAndRelease;
        Test.setCurrentPage(thePage);
        RIF_BulkCreateSeveranceAndRelease bulkCreatesnr = new RIF_BulkCreateSeveranceAndRelease();
        Blob b = Blob.valueOf('Test Data\n New Test Data \n');
         //  bulkCreatesnr .recordTypeName= 'Project Based Termination';
        bulkCreatesnr.fileContent = b;
        //bulkCreatesnr.UploadAndPrepareSeverenceAndRelease();
        
        Project__c proj  = new Project__c();
         proj.Communication_Date__c = System.today();
         proj.Country__c = 'USA';
         proj.Notice_Days__c = 19;
         proj.Is_Locked_By_Conga__c = false;
         proj.Package_Status__c = 'Running';
         proj.Package_Status_Message__c = 'hello';
         proj.Primary_Key__c = 'primkey';
         proj.Status__c = 'Active';
         proj.Super_Division__c ='Global Wealth Management Group';
         proj.System_Super_Division__c = 'Wealth Management';
         proj.Template__c = 'sample';
         proj.Template1__c = 'Template 2';
         proj.Termination_Date__c =System.today().addDays(19);
         proj.WARN__c = false;
         insert proj;   
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'my error msg');
        
        bulkCreatesnr .projectId = proj.id;
        bulkCreatesnr .recordTypeName = 'One_Off_Termination';
        
        System.debug('@@@@@@'+proj.id);
        
		bulkCreatesnr.UploadAndPrepareSeverenceAndRelease();
        bulkCreatesnr.populateEmpIdProcessStatus();
        bulkCreatesnr.getSucessResultCSV();
        bulkCreatesnr.getFailureResultCSV();
        bulkCreatesnr.CSVUploadSuccessResultsCSV();
        bulkCreatesnr.CSVUploadFailureResultsCSV();
        
        bulkCreatesnr.getSRRecordTypeId();
        bulkCreatesnr.createUpdateSR();
        bulkCreatesnr.validateFileExtension();
       
        Severance_And_Release__c sr = new Severance_And_Release__c();
        
        RIF_BulkCreateSeveranceAndRelease.csvWrapper wrpprClass = new RIF_BulkCreateSeveranceAndRelease.csvWrapper();
            wrpprClass .empId = 'a00f0000006awmxAAA';
            wrpprClass .result = 'Pass';
            wrpprClass .failureReason = 'Error';
        RIF_BulkCreateSeveranceAndRelease.csvWrapper wrpprClass1 = new RIF_BulkCreateSeveranceAndRelease.csvWrapper('a00f0000006awmxAAA','Pass','Error',sr );   
     
    Test.stopTest();
    }
}