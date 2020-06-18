@isTest(SeeAllData=true)
public class RIF_SharingTest{
    public static User u; 
    static {
        u = [Select id from User where id =: userinfo.getuserid()];
    }
    static testMethod void myTest(){
     
        Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee'];
        User tempuser = new User(Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey = 'America/Los_Angeles', UserName='standarduser@morganstanley.com');
        insert tempuser;
     
        System.runAs(u){
            
            Permissionset ps = [select id,name,label from permissionset where name='RIF_System_Admin'];
            
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.id, AssigneeId = tempuser.id);
            insert psa;
        }
     
     
        /*****************Create Project ******************/
        
        Project__c proj = new Project__c();
        proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        insert proj ;
        
        
        /*****************Create Another Project ******************/
        
        Project__c project = new Project__c();
        proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        proj.name = 'Test Data Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        insert project ;
        
        
        
        /****************Create Employee *******************/
        
        Employee__c emp = new Employee__c();
            emp.emp_id__c = 'MS12';
            emp.name = 'Test';
            emp.Level_Dsc_Job__c = 'Professional';
            emp.Level_Job__c = '30';
            emp.MS_MSSB__c = 'MSSB';
            emp.Job_Country_Job__c  = 'USA';
            emp.Status__c = 'active';
            emp.Super_Division__c = '10910';
            insert emp;
            
        /***********Create Severance & Release ************/
        
        Severance_And_Release__c SnR = new Severance_And_Release__c();
        SnR.Project__c = proj.id ;
        SnR.Employee__c = emp.id ; 
        insert SnR;
        
        
        
        
       /*****************Creating Employee List****************************/
         
        List<Employee__c> lstEmp = new List<Employee__c>();
        for(Integer i=0; i < 20; i++){
            Employee__c empobj = new Employee__c();
            empobj.emp_id__c = 'MS12'+i;
            empobj.name = 'Test'+i + ' Test456';
            empobj.Level_Dsc_Job__c = 'Professional';
            empobj.Level_Job__c = '30';
            empobj.MS_MSSB__c = 'MSSB';
            empobj.Job_Country_Job__c  = 'USA';
            empobj.Status__c = 'active';
            empobj.Super_Division__c = '10910';
            lstEmp.add(empobj );
        }
        insert lstEmp;
        
        
        /*****************Creating Second Employee List****************************/
         
        List<Employee__c> lstEmp1 = new List<Employee__c>();
        for(Integer i=0; i < 20; i++){
            Employee__c empobject = new Employee__c();
            empobject.emp_id__c = 'MS69'+i;
            empobject.name = 'Test'+i + ' Test420';
            empobject.Level_Dsc_Job__c = 'Professional';
            empobject.Level_Job__c = '30';
            empobject.MS_MSSB__c = 'MSSB';
            empobject.Job_Country_Job__c  = 'USA';
            empobject.Status__c = 'active';
            empobject.Super_Division__c = '10910';
            lstEmp1.add(empobject);
        }
        insert lstEmp1;
        
        /*******Creating Severance & Release List**********/
        
          List<Severance_And_Release__c>  SnRList = new List<Severance_And_Release__c>();
        
        
        for (Employee__c employee: lstEmp)  {
            Severance_And_Release__c SnRrelease = new Severance_And_Release__c();
            SnRrelease .Project__c = proj.id ;
            SnRrelease .Employee__c = employee.id ; 
            SnRList.add(SnRrelease );
        } 
        insert SnRList;
        
        
        /*******Creating Second Severance & Release List**********/
        
        List<Severance_And_Release__c>  eligibleS_R_TO_Share = new List<Severance_And_Release__c>();
        for (Employee__c employeeobj: lstEmp1)  {
            Severance_And_Release__c SnRobj = new Severance_And_Release__c();
            SnRobj .Project__c = proj.id ;
            SnRobj .Employee__c = employeeobj.id ; 
            eligibleS_R_TO_Share.add(SnRobj );
        } 
        insert eligibleS_R_TO_Share;
        
        /**********************Create PDU List**********************/
        
        List<Project_Decisional_Unit__c>  PDUList = new List<Project_Decisional_Unit__c>();
        Employee__c tempEmp=[SELECT id,emp_id__c,name,Level_Dsc_Job__c,Level_Job__c,MS_MSSB__c,Job_Country_Job__c from Employee__c where Job_Country_Job__c='USA' AND Dept_Org__c='81200' AND Status__c='active' Limit 1 ]; 
        for(Integer i=0; i < 20; i++){
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Decisional_Unit_Name__c = 'Test PDU'+ i;
            pdu.Project__c = proj.id;
            pdu.Employee__c = tempEmp.id ;
            pdu.HR_Signatory__c = tempEmp.id ;
            PDUList.add(pdu) ;
        }
        insert PDUList;
        
         /**********************Create PDU List**********************/
         
        List<Project_Decisional_Unit__c>  eligible_PDU_TO_Share = new List<Project_Decisional_Unit__c>();
        Employee__c HR=[SELECT id,emp_id__c,name,Level_Dsc_Job__c,Level_Job__c,MS_MSSB__c,Job_Country_Job__c from Employee__c where Job_Country_Job__c='USA' AND Dept_Org__c='81200' AND Status__c='active' Limit 1 ]; 
        for(Integer i=0; i < 20; i++){
            Project_Decisional_Unit__c pduobj = new Project_Decisional_Unit__c();
            pduobj.Decisional_Unit_Name__c = 'Test Data PDU'+ i;
            pduobj.Project__c = proj.id;
            pduobj.Employee__c = HR.id ;
            pduobj.HR_Signatory__c = HR.id ;
            eligible_PDU_TO_Share.add(pduobj) ;
        }
        insert eligible_PDU_TO_Share;
        
        
        
        
        List<User> Userlist = new List<User>();
        
        /****** Creating User List*************************/
        
        for(Integer i=0; i < 20; i++){
            User tempuserobj = new User(Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey = 'America/Los_Angeles', UserName='standarduser'+i+'@morganstanley.com');
            Userlist.add(tempuserobj );
        }
        insert Userlist;
        
        ID srid = SnR.id; 
        ID loggedinUserID = tempuser.id ; //'005f0000001P709';
        ID projectID = proj.id ;
        set<ID> srids = new set<ID>();
        set<ID> pduids = new set<ID>();
        Set <id> userIDs = new Set <id>();
        
        for(Severance_And_Release__c srobj : SnRList){
             srids.add(srobj.id);   
        }
        
        for(User uObject : Userlist){
            userIDs.add(uObject.id);
        }
        
        for(Project_Decisional_Unit__c pduobj :PDUList){
            pduids.add(pduobj.id); 
        }
        
        String accessLevel = 'Read';
        
        
            Test.startTest();
            
            RIF_Sharing.shareSRWithUsers(srid ,userIDs , accessLevel );
            RIF_Sharing.shareSRListWithUsers(srids ,userIDs , accessLevel);
            RIF_Sharing.shareProjectWithUsers(proj.id,userIDs , accessLevel);
            RIF_Sharing.shareProjectDecUnitsWithUsers(pduids ,userIDs , accessLevel);
            RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share, loggedinUserID,accessLevel );
            RIF_Sharing.Share_PDU_From_Project(eligible_PDU_TO_Share,loggedinUserID,accessLevel );
            
            Test.stopTest(); 
          
    }
}