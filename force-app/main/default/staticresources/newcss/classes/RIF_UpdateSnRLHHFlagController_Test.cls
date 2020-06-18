@isTest (SeeAllData = true) 
public class RIF_UpdateSnRLHHFlagController_Test{
    public static String negativeString = '';
    public static String positiveString = '';    
    public static void dataSetup(){
    

    string FILETYPE='Bulk Create Severance And Release';
     RIF_File_Upload_History__c historyObj= new RIF_File_Upload_History__c ( File_Name__c='Test File',File_type__c=FILETYPE,Total_Records__c=1,Total_Success_Records__c=1,Total_Failed_Records__c=0);
     insert historyObj;
     
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(445,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = UserInfo.getUserId();
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
     
     // get record type of project
            RecordType rt = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
  
            
            Project__c proj = RIF_TestClassUtilities.createTestProject(446, rt.Id );
            proj.Status__c = 'Mod';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(446, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            // insert pdu
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            //pdu.Employee__c = hrEmp.id;
            //pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            RecordType rtSNR = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            Insert snr;
            
            Severance_And_Release__c  sNew = [select Id, Name from Severance_And_Release__c where id = : snr.id order by createddate desc limit 1];

            negativeString = sNew.name+ ',0\n Testing, Test docTest ,Doc1Test, Doc2 \r Test,tr';
            positiveString = sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+','+sNew.name+','+sNew.name+',1\n'+sNew.name+'Test1,'+sNew.name+'Test,'+sNew.name+'Test,1\n';
    }
    static testMethod void validateimportCSVFileNegative() {
        test.startTest();
        dataSetup();
        RIF_UpdateSnRLHHFlagController  fileUoloadCntrl = New RIF_UpdateSnRLHHFlagController();
        
        fileUoloadCntrl.csvFileBody = blob.valueOf(negativeString);
        fileUoloadCntrl.errorMessageString = '';
        fileUoloadCntrl.importCSVFile();
        test.stopTest();        
    }
    
    static testMethod void validateimportCSVFilePositive() {
        test.startTest();
        dataSetup();
        RIF_UpdateSnRLHHFlagController  fileUoloadCntrl = New RIF_UpdateSnRLHHFlagController();
        
        fileUoloadCntrl.csvFileBody = blob.valueOf(positiveString);
        fileUoloadCntrl.errorMessageString = '';
        fileUoloadCntrl.importCSVFile();  
        test.stopTest();

      
        
    }
}