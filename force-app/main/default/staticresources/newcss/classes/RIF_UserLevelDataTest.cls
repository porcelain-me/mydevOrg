@isTest()
public class RIF_UserLevelDataTest {
    static testMethod void myTest(){
        Project__c proj = new Project__c();
        //getting multiple proj rec type id
        //Id rtId = projRecordTypeInfo.get('Project_Based_Termination').getRecordTypeId();
        proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        //PROJ.RecordTypeId  = rtId;
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        //proj.Partner_Server_URL__c = 'https://morganstanleyhr----Dev-cs16-my-salesforce-com.ccg-dev.ms.com/services/Soap/u/29.0/00Df0000002K0p7_290' ;
        insert proj ;
              
        Employee__c emp1 = new Employee__c();
            emp1.emp_id__c = 'MS12';
            emp1.name = 'Test';
            emp1.Level_Dsc_Job__c = 'Professional';
            emp1.Level_Job__c = '30';
            emp1.MS_MSSB__c = 'MSSB';
            emp1.Job_Country_Job__c  = 'USA';
            emp1.Status__c = 'Active';
        	emp1.Dept_Org__c = '81200';
            emp1.Super_Division__c = '10910';
            insert  emp1;
    
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
           
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
        
        Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Project__c = proj.id;
         
         
         insert snr;
        
         Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
             									sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
												sretl.Employee__c = emp1.Id;
												sretl.Project__c = proj.Id;
												sretl.Severance_And_Release__c = snr.Id;
												sretl.Active__c = True;
		insert sretl;             
          
        Test.startTest();
            RIF_UserLevelData.getSRLIStInUserMode(proj.id);
            RIF_UserLevelData.getSyncSRLIStInUserMode(proj.id);
            RIF_UserLevelData.getSRLIStfromSNRName(proj.id);
            RIF_UserLevelData.getSyncSRTemp(proj.id);
            RIF_UserLevelData.getPDUs(proj.id);
            RIF_UserLevelData.getPrjtSRLIStInUserMode(proj.id);

        Test.stopTest();  
    }
}