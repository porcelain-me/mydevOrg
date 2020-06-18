@isTest(SeeALlData=true)
private class RIF_SeveranceAndReleaseTest{
    static testMethod void myTest(){
        
        /****Creating Employee****/
            
            
            
            Employee__c emp = new Employee__c();
            emp.emp_id__c = 'MS12';
            emp.name = 'Test';
            emp.Level_Dsc_Job__c = 'Professional';
            emp.Level_Job__c = '30';
            emp.MS_MSSB__c = 'MSSB';
            emp.Job_Country_Job__c  = 'USA';
            emp.Status__c = 'active';
            emp.Super_Division__c = '10910';
            insert  emp;
            
            /*****Creating  Project & Severance & Release*****************/
            
            
            Project__c proj = new Project__c();
            //proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
            proj.name = 'Test Project' ;
            proj.Country__c = 'USA' ; 
            proj.Status__c = 'Active' ;
            proj.Communication_Date__c  = Date.today();
            proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
            insert proj ;
            
            Severance_And_Release__c SnR = new Severance_And_Release__c();
            SnR.Project__c = proj.id ;
            SnR.Employee__c = emp.id ;
            snr.Communication_Date__c  = Date.today();//date.parse('12/27/2009');
            snr.Termination_Date__c = SnR.Communication_Date__c.addDays(15);
            
            
            
        Test.startTest();
            insert SnR; 
             snr.Termination_Date__c = SnR.Termination_Date__c.addDays(15); 
             update snr;  
            delete SnR;
        Test.stopTest();
    }
}