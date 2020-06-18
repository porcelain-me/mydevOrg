@isTest (SeeAllData = false)
public class RIF_DownloadController_Test{ 
    public static Project__c proj ;
    public static List<Severance_and_Release__c> snrList;
    public static Severance_And_Release__c snr;
     public static Severance_And_Release__c snr1;
    
    public static void dataSetup(){
        
        RecordType rt = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
        proj = new project__c();
        proj = RIF_TestClassUtilities.createTestProject(446, rt.Id );
        proj.Status__c = 'Mod';
        proj.Communication_Date__c = Date.today();
        proj.Termination_Date__c = Date.today().addDays(14);
        insert proj;
        
        // insert severance parameters
        Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(446, 'USA', 'MSSB', 'Director', '123');
        insert sp;
        
        Employee__c emp = RIF_TestClassUtilities.createTestEmployee(445,'12345', 'USA', 'MSSB', 'Director','123');
        emp.User__c = UserInfo.getUserId();
        emp.Super_Division__c='10910';
        emp.DOH_Recent__c = Date.newInstance(2018, 03, 03);
        insert emp;
        
        // insert project level
        Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
        insert pl;
        
        // insert pdu
        Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
        pdu.Project__c = proj.id;
        pdu.Decisional_Unit_Name__c = 'Super Division';
        insert pdu;
        
        // insert Project Decisional Org Level	
        Org_Codes__c orgcodeemp = new Org_Codes__c(Code__c = '10910' , Code_Type__c = 'Super Division', Description__c='Global Wealth Management Group');
        insert orgcodeemp ;
        Child_Project_Decisional_Unit__c pduOrgLevel = new Child_Project_Decisional_Unit__c ();
        //pduOrgLevel.name='test org pdu';
        pduOrgLevel.Project_Decisional_Unit__c = pdu.id ;
        pduOrgLevel.Decisional_Unit_Type__c = 'Super Division'; 
        pduOrgLevel.Decisional_Unit_Code__c = orgcodeemp.id ;  
        pduOrgLevel.Org_Hierarchy_Code__c= '10910 - Wealth Management';
        insert pduOrgLevel ;
        
        RecordType rtSNR = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
        snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
        snr.Super_Division__c = '10910';
        snr.Project__c = proj.id;
        snr.Status__c='Selected';
        snr.Last_Day_On_Premises__c = date.today().addDays(30);
        Insert snr;
        
      
    }
    
    
    static testMethod void validateMethod() {
        test.startTest();
        dataSetup();
        PageReference pageRef = Page.RIF_Download;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('snr1', snr.id);
        pageRef.getParameters().put('documents', 'All;');
        pageRef.getParameters().put('ID', proj.id);
        pageRef.getParameters().put('version', 'Draft');
        pageRef.getParameters().put('selectedIDSize','10');
        
        Attachment aList = new Attachment();
        aList.ParentId =snr.id;
        aList.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList.Body=Blob.valueOf('Test');
        aList.Description='Release Agreement';        
        insert aList;
        
        Attachment aList1 = new Attachment();
        aList1.ParentId =snr.id;
        aList1.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList1.Body=Blob.valueOf('Test');
        aList1.Description='Release Agreement';    
        insert aList1;
    
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        RIF_DownloadController DC = New RIF_DownloadController(sc);
        DC.processDownloads();
        DC.createConfigRecords();
        test.stopTest();
    }
    
     static testMethod void validateMethod1() {
        test.startTest();
        dataSetup();
        PageReference pageRef = Page.RIF_Download;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('snr1', snr.id);
        pageRef.getParameters().put('documents', 'All;');
        pageRef.getParameters().put('ID', proj.id);
        pageRef.getParameters().put('version', 'Draft');
        pageRef.getParameters().put('selectedIDSize','10');
        
        Attachment aList = new Attachment();
        aList.ParentId =snr.id;
        aList.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList.Body=Blob.valueOf('Test');
        aList.Description='Separation Summary';        
        insert aList;
        
        Attachment aList1 = new Attachment();
        aList1.ParentId =snr.id;
        aList1.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList1.Body=Blob.valueOf('Test');
        aList1.Description='Separation Summary';   
        insert aList1;
    
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        RIF_DownloadController DC = New RIF_DownloadController(sc);
        DC.processDownloads();
        DC.createConfigRecords();
        test.stopTest();
    }
    
    static testMethod void validateMethod2() {
        test.startTest();
        dataSetup();
        PageReference pageRef = Page.RIF_Download;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('snr1', snr.id);
        pageRef.getParameters().put('documents', 'All;');
        pageRef.getParameters().put('ID', proj.id);
        pageRef.getParameters().put('version', 'Final');
        pageRef.getParameters().put('selectedIDSize','0');
        
        
        Attachment aList = new Attachment();
        aList.ParentId =snr.id;
        aList.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList.Body=Blob.valueOf('Test');
        aList.Description='Release Agreement';
        insert aList;
        
        Attachment aList1 = new Attachment();
        aList1.ParentId =snr.id;
        aList1.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList1.Body=Blob.valueOf('Test');
        aList1.Description='Release Agreement';
        insert aList1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        RIF_DownloadController DC = New RIF_DownloadController(sc);
        DC.processDownloads();
        DC.createConfigRecords();
        test.stopTest();
    }
    
     static testMethod void validateMethod3() {
        test.startTest();
        dataSetup();
        PageReference pageRef = Page.RIF_Download;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('snr1', snr.id);
        pageRef.getParameters().put('documents', 'All;');
        pageRef.getParameters().put('ID', proj.id);
        pageRef.getParameters().put('version', 'Final');
        pageRef.getParameters().put('selectedIDSize','0');
        
        
        Attachment aList = new Attachment();
        aList.ParentId =snr.id;
        aList.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList.Body=Blob.valueOf('Test');
        aList.Description='Separation Summary';
        insert aList;
        
        Attachment aList1 = new Attachment();
        aList1.ParentId =snr.id;
        aList1.Name= 'Stewart_Elizabeth_05_Benefits FAQs.pdf';
        aList1.Body=Blob.valueOf('Test');
        aList1.Description='Separation Summary';
        insert aList1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        RIF_DownloadController DC = New RIF_DownloadController(sc);
        DC.processDownloads();
        DC.createConfigRecords();
        test.stopTest();
    }
    
    static testMethod void validateMethod4() {
        test.startTest();
        dataSetup();
   Snr1=[select id,Status__c from severance_and_release__c where id=:snr.id];
        Snr1.Status__c='Not Selected';
        update snr1;
        
        PageReference pageRef = Page.RIF_Download;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('snr1', '');
        pageRef.getParameters().put('documents', 'All;');
        //pageRef.getParameters().put('ID', proj.id);
       // pageRef.getParameters().put('version', 'Final');
        pageRef.getParameters().put('selectedIDSize','0');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        RIF_DownloadController DC = New RIF_DownloadController(sc);
        DC.processDownloads();
        DC.createConfigRecords();
        test.stopTest();
    }
    
}