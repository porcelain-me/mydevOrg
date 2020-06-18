@isTest
public class RIF_SNRShareBatchTest {
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    public static  User tempU;
    public static void setupData(){
        tempU = new User();
        //tempU = testUtil.createUser();
        tempU = testUtil.createUser2();
    }
    public static testmethod void testMethod3()
    {
        setupData();
        ID uid =userinfo.getUserId();
        User me = [Select ID from User where id=:uid limit 1];
        system.runAs(me){
            
            Profile p = new Profile();
            p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
            
            PermissionSet ps = new PermissionSet();
            ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
            User tempU1  = new User(Alias = 'standt', Email='Sysor12@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test12', Emp_Id__c = '0TEST', 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='Sysor12@testorg.com');
            insert tempU1;
            PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempU1.Id,PermissionSetId = ps.Id);
            insert psAsg;
            Employee__c emp = new Employee__c(Name = tempU1.Name,Emp_ID__c = tempU1.Emp_Id__c,Super_Division__c='98100',Status__c = 'Active',User__c = tempU1.Id);
            insert emp;
            Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
            Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            //Employee__c emp1 = testUtil.createEmployeeFromUser(tempU);
            User tempU2  = new User(Alias = 'standt', Email='Sysor11@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test11', Emp_Id__c = '0TEST1', 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='Sysor11@testorg.com');
            insert tempU2;
            PermissionSetAssignment psAsg1 = new PermissionSetAssignment(AssigneeId = tempU2.Id,PermissionSetId = ps.Id);
            insert psAsg1;
            Employee__c emp2 = new Employee__c(Name = tempU2.Name,Emp_ID__c = tempU2.Emp_Id__c,Super_Division__c='98100',Status__c = 'Active',User__c = tempU2.Id);
            insert emp2;
            
            //testUtil.insertOrgHierarchy();    
            //testUtil.createCoverageEntitlements(emp1);
            Coverage_Entitlement__c newCovEnt = new Coverage_Entitlement__c();
            newCovEnt.HR_Name__c = emp2.Id;
            insert newCovEnt; 
            
            Coverage_Entitlement_Org__c newChildCovEnt = new Coverage_Entitlement_Org__c();
            newChildCovEnt.Coverage_Entitlement__c = newCovEnt.Id;
            newChildCovEnt.Coverage_Entitlement_Type__c = 'Super Division';
            newChildCovEnt.Org_Hierarchy_Code__c = '	98100 - Technology & Data';
            insert newChildCovEnt;
            
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
            insert proj;        
            /*newPDU.Employee__c = emp.Id;
newPDU.HR_Signatory__c = emp.Id;
newPDU.Decisional_Unit_Name__c = 'Test One';
newPDU.Project__c = proj.id;
insert newPDU;*/
            
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr.Project_Level__c = pl.id;
            snr.Employee__c = emp.ID;
            //recordTypeId = recordTypeId,
            snr.Status__c = 'Selected';
            snr.Super_Division__c = '98100';
            snr.Project__c = proj.id;
            insert snr;
            
            Project__Share snrShare = new Project__Share();
            snrShare.ParentId = proj.Id;
            snrShare.UserOrGroupId =tempU2.id;
            //snrShare.RowCause =Schema.Severance_And_Release__Share.rowCause.ProjectBasedSharing__c;
            snrShare.AccessLevel = 'Read';
            insert snrShare;
            
            Test.startTest();
            ID jobID = Database.executeBatch(new RIF_SNRShareBatch());
            RIF_SNRShareBatch m = new RIF_SNRShareBatch();
            String sch = '20 30 8 10 2 ?';
            String jobID1 = system.schedule('Merge Job', sch, m);
            test.stopTest();
            
        }
    }
}