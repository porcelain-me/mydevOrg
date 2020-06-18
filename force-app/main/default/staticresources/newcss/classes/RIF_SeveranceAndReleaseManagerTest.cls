@isTest(seeAllDAta=true)
public class RIF_SeveranceAndReleaseManagerTest{
   
    static testMethod void myTest(){
    
            Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            List<Severance_And_Release__c>  SnRList = new List<Severance_And_Release__c>();
            SnRList.add(snr);
            insert SnRList;
            
            boolean isInsert = true;
            boolean isUpdate = true;
            boolean isDelete = true;
            boolean isBefore = true;
            String projectid = snr.Project__c;
            String recordTypeId = snr.RecordTypeId;
            System.debug('*********RecordType'+recordTypeId );
            String mode = 'test';
            String mode1 = null ;
            
            Map<Id,Severance_And_Release__c> oldmap = new Map<Id,Severance_And_Release__c>();
            
            for(Severance_And_Release__c obj : SnRList){
                oldmap.put(obj.id , obj);
            }
            
            
            Test.startTest();
            
                RIF_SeveranceAndReleaseManager obj = new RIF_SeveranceAndReleaseManager();
                RIF_SeveranceAndReleaseManager.populateDenormalizedFieldsIntoSR(SnRList,oldmap,isInsert,isUpdate,isDelete,isBefore);
                RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectid ,recordTypeId ,SnRList,mode);
                RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectid ,recordTypeId ,SnRList,mode1);
                RIF_SeveranceAndReleaseManager.shareSRWithRIFRoles(SnRList); 
                RIF_SeveranceAndReleaseManager.changeSRRecordTpe(snr);
                RIF_SeveranceAndReleaseManager.deleteOneOffproject(SnRList,oldmap);
                
            
            Test.stopTest(); 
        
    
    }
    
    static testMethod void myTest1(){
    
            
            
            List<Severance_And_Release__c>  SnRList = new List<Severance_And_Release__c>();
            
            
            /*********************Creating ONe-Off Termination SnR*******************/
            Severance_And_Release__c oneOffSnr;
        
            //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
            RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
            testUtil.insertOrgHierarchy();
            
            User thisUser = RIF_TestClassUtilities.getALLMSUser();
            insert thisUser;
            
            System.runAs(thisUser) {
            // Assign permission sets to user
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Coverage' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            // Create Employee with above user
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(1,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            emp.Super_Division__c='10910';
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            //covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
            covEntOrg.Org_Hierarchy_Code__c='10910 - Wealth Management';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            // get hr employee
            Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = '10910';
            pdu.Employee__c = hrEmp.id;
            pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
           /* Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            insert projOrgLevel;*/
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'One Off Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert snr
            oneOffSnr= RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
            oneOffSnr.Super_Division__c = '10910';
            oneOffSnr.Project__c = proj.id;
            //oneOffSnr.Project_Decisional_Org_Level__c = projOrgLevel.Id;
            oneOffSnr.Decisional_Unit__c = pdu.Id;
        }
            SnRList.add(oneOffSnr);       
            insert SnRList;
            
            boolean isInsert = true;
            boolean isUpdate = true;
            boolean isDelete = true;
            boolean isBefore = true;
            String projectid = oneOffSnr.Project__c;
            String recordTypeId = oneOffSnr.RecordTypeId;
            System.debug('*********RecordType'+recordTypeId );
            String mode = 'test';
            String mode1 = null ;
            
            Map<Id,Severance_And_Release__c> oldmap = new Map<Id,Severance_And_Release__c>();
            
            for(Severance_And_Release__c obj : SnRList){
                oldmap.put(obj.id , obj);
            }
            
            
            Test.startTest();
            
                RIF_SeveranceAndReleaseManager obj = new RIF_SeveranceAndReleaseManager();
                RIF_SeveranceAndReleaseManager.populateDenormalizedFieldsIntoSR(SnRList,oldmap,isInsert,isUpdate,isDelete,isBefore);
                RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectid ,recordTypeId ,SnRList,mode);
                RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectid ,recordTypeId ,SnRList,mode1);
        		RIF_SeveranceAndReleaseManager.validatePrjtSyncSNR(projectid  ,SnRList,mode1);
                RIF_SeveranceAndReleaseManager.shareSRWithRIFRoles(SnRList); 
                RIF_SeveranceAndReleaseManager.changeSRRecordTpe(oneOffSnr);
                RIF_SeveranceAndReleaseManager.deleteOneOffproject(SnRList,oldmap);
                
            
            Test.stopTest(); 
        
    
    }

}