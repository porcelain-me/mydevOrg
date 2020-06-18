/** Util class to create test data and dummy records **/
@isTest
public class RIF_OrgHierarchy_TestUtil {
	public static Profile p;
    public static PermissionSet ps;
    public static User tempU,tempHR;
    public static PermissionSetAssignment psAsg;
    public static Employee__c emp;
    public Coverage_Entitlement__c newCovEnt;
    public Coverage_Entitlement_Org__c newChildCovEnt;
    public Project_Decisional_Unit__c newPDU;
    public Child_Project_Decisional_Unit__c NewChildPDU;
    /* Create a RIF Coverage User, assign the PS and create a corresponding employee record*/ 
    public User createUser(){
        p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
        tempU  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = '0TEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempU;
        psAsg = new PermissionSetAssignment(AssigneeId = tempU.Id,PermissionSetId = ps.Id);
        insert psAsg;
        createEmployee();
        return tempU;
    }
    
    public User createUser2(){
        p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
        tempU  = new User(Alias = 'standt', Email='Sysor@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = '0TEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='Sysor@testorg.com');
        insert tempU;
        psAsg = new PermissionSetAssignment(AssigneeId = tempU.Id,PermissionSetId = ps.Id);
        insert psAsg;
        return tempU;
    }
    
    @future
    public static void createEmployee(){
        emp = new Employee__c(Name = tempU.Name,Emp_ID__c = tempU.Emp_Id__c,Status__c = 'Active',User__c = tempU.Id);
        insert emp;
    }
    public Employee__c createEmployeeFromUser(User userRec){
        Employee__c empRec = new Employee__c();
        empRec = new Employee__c(Name = userRec.Name,Emp_ID__c = userRec.Emp_Id__c,Status__c = 'Active',User__c = userRec.Id, Cost_Center__c = '81200', Cost_Center_Code__c = '81200', Dept_Org__c = '81200' , Cost_Center_Desc__c = 'Department');
        insert empRec;
        return empRec;
    }
    
    public void createHR(){
        p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
        tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
    }
    
    public void createCoverageEnt(){
        newCovEnt = new Coverage_Entitlement__c();
        // creating the emp again as the createEmployee() method run on @future
        Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id);
        insert emp1;
        newCovEnt.HR_Name__c = emp1.Id;
        insert newCovEnt;
    }
    
    public Coverage_Entitlement_Org__c createChildCoverageEnt(){
        createCoverageEnt();
        Coverage_Entitlement_Org__c newChildCovEnt = new Coverage_Entitlement_Org__c();
        newChildCovEnt.Coverage_Entitlement__c = newCovEnt.Id;
        newChildCovEnt.Coverage_Entitlement_Type__c = 'Super Division';
        newChildCovEnt.Org_Hierarchy_Code__c = '10200 - Operations';
        insert newChildCovEnt;
        return newChildCovEnt;
    }
    
    public void createCoverageEntitlements(Employee__c em){
        Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
        covEnt.HR_Name__c = em.Id;
        insert covEnt;
        List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
        Coverage_Entitlement_Org__c ceSD = new Coverage_Entitlement_Org__c();
        ceSD.Coverage_Entitlement__c = covEnt.Id;
        ceSD.Coverage_Entitlement_Type__c = 'Super Division';
        ceSD.Org_Hierarchy_Code__c = '10910 - Wealth Management';
        covEntOrgList.add(ceSD);
        Coverage_Entitlement_Org__c ceD = new Coverage_Entitlement_Org__c();
        ceD.Coverage_Entitlement__c = covEnt.Id;
        ceD.Coverage_Entitlement_Type__c = 'Division';
        ceD.Org_Hierarchy_Code__c = '99190 - Wealth Management Field';
        covEntOrgList.add(ceD);
        Coverage_Entitlement_Org__c ceSupD = new Coverage_Entitlement_Org__c();
        ceSupD.Coverage_Entitlement__c = covEnt.Id;
        ceSupD.Coverage_Entitlement_Type__c = 'Super Department';
        ceSupD.Org_Hierarchy_Code__c = '25307 - Western';
        covEntOrgList.add(ceSupD);
        Coverage_Entitlement_Org__c ceDpt = new Coverage_Entitlement_Org__c();
        ceDpt.Coverage_Entitlement__c = covEnt.Id;
        ceDpt.Coverage_Entitlement_Type__c = 'Department';
        ceDpt.Org_Hierarchy_Code__c = '11002 - 1 - Northwest';
        covEntOrgList.add(ceDpt);
        Coverage_Entitlement_Org__c ceSubD = new Coverage_Entitlement_Org__c();
        ceSubD.Coverage_Entitlement__c = covEnt.Id;
        ceSubD.Coverage_Entitlement_Type__c = 'Sub Department';
        ceSubD.Org_Hierarchy_Code__c = '12255 - CMP008 - San Francisco';
        covEntOrgList.add(ceSubD);
        Coverage_Entitlement_Org__c ceSubD2 = new Coverage_Entitlement_Org__c();
        ceSubD2.Coverage_Entitlement__c = covEnt.Id;
        ceSubD2.Coverage_Entitlement_Type__c = 'Sub Department 2';
        ceSubD2.Org_Hierarchy_Code__c = '26424 - BR164-SAN FRANCISCO, CA 2';
        covEntOrgList.add(ceSubD2);
        Coverage_Entitlement_Org__c ceCC = new Coverage_Entitlement_Org__c();
        ceCC.Coverage_Entitlement__c = covEnt.Id;
        ceCC.Coverage_Entitlement_Type__c = 'Cost Center';
        ceCC.Org_Hierarchy_Code__c = '571195 - SN FRN-CSH MGT (SB)';
        covEntOrgList.add(ceCC);
        insert covEntOrgList; 
    }
    
    public void createPDU(){
        newPDU = new Project_Decisional_Unit__c();
        // creating the emp again as the createEmployee() method run on @future
        Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
        // insert project
        // get record type of project
        RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
        // insert project
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
        insert proj;        
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
    }
    
    public Project_Decisional_Unit__c createPDU1(Employee__c empl){
        newPDU = new Project_Decisional_Unit__c();
        // insert project
        // get record type of project
        RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
        // insert project
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
        insert proj;
        newPDU.Employee__c = empl.Id;
        newPDU.HR_Signatory__c = empl.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        return newPDU;
    }
    
    public Child_Project_Decisional_Unit__c createChildPDU(){
        createPDU();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Super Division';
        NewChildPDU.Org_Hierarchy_Code__c = '10910 - Wealth Management';
        insert NewChildPDU;
        return NewChildPDU;
    }
    
    public Child_Project_Decisional_Unit__c createChildPDU1(Employee__c emply){
        createCoverageEntitlements(emply);
        Project_Decisional_Unit__c pduNew = createPDU1(emply);    
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = pduNew.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Super Division';
        NewChildPDU.Org_Hierarchy_Code__c = '10910 - Wealth Management';
        insert NewChildPDU;
        return NewChildPDU;
    }
    
    public void insertOrgHierarchy(){
        Org_Hierarchy__c newOrgHier = new Org_Hierarchy__c(TREE_Effective_Date__c = Date.valueOf('2016-07-13') ,Effective_Status__c = true, Super_Division__c = '10910' , Super_Division_Description__c = 'Wealth Management', 
            Division__c = '99190', Division_Description__c = 'Wealth Management Field', Super_Department__c = '25307' , Super_Department_Description__c = 'Western',
            Department__c = '11002', Department_Description__c = '1 - Northwest', Sub_Department__c = '12255', Sub_Department_Description__c = 'CMP008 - San Francisco',
            Sub_Department_2__c = '26424', Sub_Department_2_Description__c = 'BR164-SAN FRANCISCO, CA 2' , Department_ID__c = '571195', Cost_Center_Description__c = 'SN FRN-CSH MGT (SB)');
        insert newOrgHier;
            
    } 
    
    public RecordType getRecordType(String recName){
        RecordType recType = [SELECT Id,DeveloperName from RecordType WHERE DeveloperName =:  recName LIMIT 1];
        return recType;
    }
}