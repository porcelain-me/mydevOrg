@isTest
public class RIF_Bulk_Update_SR2Test{
    public static Employee__c newEmp;
    public static Project__c newProj;
    public static Severance_And_Release__c newSnR;
    public static User newUser;
    public static void setupAllData(){
        // insert employee record
        newEmp = new Employee__c();
        newEmp.Name = 'Test Emp';
        newEmp.Emp_ID__c = '898989EW';
        newEmp.Email__c = 'test@test.com';
        insert newEmp;
        // insert the project record
        Id prjBsdRT = [Select Id from RecordType where DeveloperName = 'Project_Based_Termination' LIMIT 1].Id;
        Id oneOffRT = [Select Id from RecordType where DeveloperName = 'One_Off_Termination' LIMIT 1].Id;
        newProj = new Project__c();
        newProj.RecordTypeId = oneOffRT;
        newProj.Name = 'Test-Project --'+ system.now();
        newProj.Communication_Date__c = system.today();
        newProj.Termination_Date__c = system.today();
        newProj.Status__c = 'Active';
        newProj.Country__c = 'USA';
        insert newProj;
        // insert the severence and release record
        newSnR = new Severance_And_Release__c();
        //newSnR.RecordTypeId = prjBsdRT;
        newSnR.Project__c = newProj.Id;
        newSnR.Employee__c = newEmp.Id;
            //insert newSnR;
    }
    /* private static testMethod void bulkUpdateSR2Test () {
    Test.startTest();
    ApexPages.StandardController controller;
    RIF_Bulk_Update_SR2 bulksr2 = new RIF_Bulk_Update_SR2 (controller);
    Test.stoptest();
    } */
    // Test the constructor
    public static testMethod void loadConstructor(){
        setupAllData();
        Test.startTest();
        PageReference thisPage = Page.RIF_Bulk_Update_SR2;
        Test.setCurrentPage(thisPage);
        thisPage.getParameters().put('projectId',newProj.Id);
        thisPage.getParameters().put('recordType','Project_Based_Termination');
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
        theConst.attachMyFile();
        theConst.exit();
        theConst.importCSVFile();
        theConst.refreshPage();
        theConst.transfer();
        Test.stopTest();	
    }  
    public static testMethod void test_importCSVFile1(){
        setupAllData();
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit1.csv';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=newProj.id;
        insert attach;
        
        Test.startTest();
        PageReference thisPage = Page.RIF_Bulk_Update_SR2;
        Test.setCurrentPage(thisPage);
        thisPage.getParameters().put('projectId',newProj.Id);
        thisPage.getParameters().put('recordType','Project_Based_Termination');
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
       	theConst.importCSVFile();
        Test.stopTest();
    }
    public static testMethod void test_importCSVFile2(){
        setupAllData();
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit2.csv';
    	Blob bodyBlob=Blob.valueOf('EmpId,12BKR,02MFV,H8394');
    	attach.body=bodyBlob;
        attach.parentId=newProj.id;
        insert attach;
        
        Test.startTest();
        PageReference thisPage = Page.RIF_Bulk_Update_SR2;
        Test.setCurrentPage(thisPage);
        thisPage.getParameters().put('projectId',newProj.Id);
        thisPage.getParameters().put('recordType','Project_Based_Termination');
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
       	theConst.importCSVFile();
        Test.stopTest();
    }
    public static testMethod void test_saveFile(){
        setupAllData();
        Test.startTest();
        PageReference thisPage = Page.RIF_Bulk_Update_SR2;
        Test.setCurrentPage(thisPage);
        thisPage.getParameters().put('projectId',newProj.Id);
        thisPage.getParameters().put('recordType','Project_Based_Termination');
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
       theConst.saveFile();
        Test.stopTest();
    }
    public static testMethod void test_testProcess(){
        setupAllData();
        Test.startTest();
        PageReference thisPage = Page.RIF_Bulk_Update_SR2;
        Test.setCurrentPage(thisPage);
        thisPage.getParameters().put('projectId',newProj.Id);
        thisPage.getParameters().put('recordType','Project_Based_Termination');
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
        // put values in wrapelist
        //theConst.wrapEList 
        theConst.testProcess();
        Test.stopTest();
    } 
    public static testMethod void test_createErrorMessageWithMSID(){
        setupAllData();
        String mssid = 'MS001';
        String fieldName = 'Columnn1';
        String exceptionMessage = 'Exception:Unable_to_update';
        Test.startTest();
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2 theConst = new RIF_Bulk_Update_SR2(cont);
        theConst.createErrorMessageWithMSID(mssid, fieldName, exceptionMessage);
        Test.stopTest();
    }
    public static testMethod void test_allClasses(){
        setupAllData();
        String empID = 'EMP007';
        String errorMsg = 'Error Message';
        Decimal empDeci = 3.4;
        Test.startTest();
        ApexPages.StandardController cont = new ApexPages.StandardController(newProj);
        RIF_Bulk_Update_SR2.wrapperError warpErrorClass = new RIF_Bulk_Update_SR2.wrapperError(empID,errorMsg);
       	RIF_Bulk_Update_SR2.prepareSeveranceAndRelease prepSnRClass = new RIF_Bulk_Update_SR2.prepareSeveranceAndRelease(newSnR,newEmp);
        RIF_Bulk_Update_SR2.wrapEmployee wrapEmpClass = new RIF_Bulk_Update_SR2.wrapEmployee(newEmp,empDeci);
        Test.stopTest();
        
    }
}