/** Test classs to cover RIF_Util_Kumaresan class**/
@isTest(seealldata=true)
public class RIF_Util_Kumaresan_Test{
    public static User tempU = new User();
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    
    public static void setupData(){
        tempU = testUtil.createUser2();
    }
    public static testMethod void testAll(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c em = testUtil.createEmployeeFromUser(tempU);
            testUtil.createCoverageEntitlements(em);
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(445,'445XF', 'USA', 'MSSB', 'COO', '445');
            emp.Job_State_Job__c = 'NY';
            insert emp;
            RecordType rt = [Select Id, Name from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            Project__c prjt = RIF_TestClassUtilities.createTestProject(445,rt.Id);
            insert prjt;
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(445, 'USA', 'MSSB', 'COO', '445');
            sp.Primary_Key__c =  'MSSB' + '44' + 'US';
            insert sp;
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(prjt.Id,sp.Id);
            insert pl;
            RecordType snrRT = [Select Id, Name from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_and_Release__c' limit 1];
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id,emp.Id,snrRT.Id);
            snr.State_Home__c = 'NY';
            snr.Project__c = prjt.Id;
            snr.Super_Division__c = '10910';
            snr.Division__c = '99190';
            snr.Department__c = '11002';
            snr.Super_Department__c = '25307';
            snr.Sub_Department__c = '12255';
            snr.Sub_Department_2__c = '26424';
            snr.Cost_Center__c = '571195';
            List<Severance_And_Release__c> srList = new List<Severance_And_Release__c>();
            srList.add(snr);
            insert srList;
            
            Set<Id> srIdSet = new Set<Id>();
            srIdSet.add(snr.Id);
            
            Set<String> srIdSet2 = new Set<String>();
            srIdSet2.add(snr.Id);
            
            Set<String> templateSet = new Set<String>();
            
            List<APXTConga4__Conga_Template__c> templateList = [SELECT id FROM APXTConga4__Conga_Template__c];
            for(APXTConga4__Conga_Template__c template: templateList) {
                templateSet.add(template.Id);
            }
            
            RIF_Util_Kumaresan.updateSnROnContentManagementforSet(srIdSet, templateSet);
            RIF_Util_Kumaresan.updateSnROnContentManagement_New(templateSet, srList);
            RIF_Util_Kumaresan.getAccessableSRrecord(snr.Project__c);
            
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'sr', srIdSet2);
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'Proj', srIdSet2);
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'statisIds', srIdSet2);
            RIF_Util_Kumaresan.getAllFieldsFromSObject(snr, snr.Id, 'sr', srIdSet2);
            RIF_Util_Kumaresan.getAllFieldsFromSObject(snr, snr.Id, 'Proj', srIdSet2);
            Test.stopTest();
        }
        
    }
    
    public static testMethod void updateSnROnContentManagementforSet_test(){
        
        
        
        
    }
    
    
}