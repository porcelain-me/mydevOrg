@istest
public class RIF_OrgHierarchy_DataUtil_Test {
    public static Org_Hierarchy__c newOrg;
    public static Project_Decisional_Unit__c allPDUs;
    public static Coverage_Entitlement_Org__c orgRecDet;
    //public static Boolean validOrgCodeCheck; 
    public static RIF_OrgHierarchy_TestUtil datUtil = new RIF_OrgHierarchy_TestUtil();
    
    public static RIF_OrgHierarchy_DataUtil dataUtil = new RIF_OrgHierarchy_DataUtil();
    
    public static void setupData(){
        newOrg = new Org_Hierarchy__c(Super_Division__c = '10910', Super_Division_Description__c = 'Wealth Management', Division__c = '99190', Division_Description__c = 'Wealth Management Field', Super_Department__c ='25307', Super_Department_Description__c = 'Western', Department__c = '11002', Department_Description__c = '1 - Northwest', Sub_Department__c= '12254', Sub_Department_Description__c = 'CMP010 - Menlo Park', Sub_Department_2__c = '26457', Sub_Department_2_Description__c = 'BR233-MENLO PARK, CA 1', Department_ID__c = '100038', Cost_Center_Description__c = 'MENLO PARK - ZYNGA FCP', Effective_Status__c = true);
        insert newOrg;
        // insert user
        // insert PS on user
        // insert emp
        // insert project
        
        // public static Child_Project_Decisional_Unit__c 
    } 
    public static testMethod void test_con(){
        Test.startTest();
        dataUtil.orgHLst = new List<Org_Hierarchy__c>();
        dataUtil.orgHierMap = new Map<String,Org_Hierarchy__c>();
        dataUtil.allPDUs = new Project_Decisional_Unit__c();
        dataUtil.childPDU= new Child_Project_Decisional_Unit__c();
        //dataUtil.totalRecs= new Integer totalRecs();
        Test.stopTest();        
    }
    public static testMethod void test_searchOrgHierarchies_SD(){
        setupData();
        String unitTypesupdiv = 'Super Division';
        String searchStr1 = '10910';
        String unitTypediv = 'Division';
        String searchStr2 = '99190';
        String unitTypesupdept = 'Super Department';
        String searchStr3 = '25307';
        String unitTypedept = 'Department';
        String searchStr4 = '11002';
        String unitTypesubdept = 'Sub Department';
        String searchStr5 = '12254';
        String unitTypesubdept2 = 'Sub Department 2';
        String searchStr6 = '26457';
        String unitTypecc = 'Cost Center';
        String searchStr7 = '100038';
        Test.startTest();
        dataUtil.searchOrgHierarchies(unitTypesupdiv, searchStr1);
        dataUtil.searchOrgHierarchies(unitTypediv, searchStr2);
        dataUtil.searchOrgHierarchies(unitTypesupdept, searchStr3);
        dataUtil.searchOrgHierarchies(unitTypedept, searchStr4);
        dataUtil.searchOrgHierarchies(unitTypesubdept, searchStr5);
        dataUtil.searchOrgHierarchies(unitTypesubdept2, searchStr6);
        dataUtil.searchOrgHierarchies(unitTypecc, searchStr7);
        Test.stopTest();
    }
    public static testMethod void orgHierStrFormatter_SD(){
        setupData();
        string selectedOrgId = newOrg.Id;
        string unitTypeSupDiv = 'Super Division';
        string unitTypeDiv = 'Division';
        string unitTypeSupdept = 'Super_Department';
        string unitTypeDept = 'Department';
        string unitTypeSubDept = 'Sub Department';
        string unitTypeSubDept2 = 'Sub Department 2';
        string unitTypeDeptId = 'Cost Center';
        
        Test.startTest();
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeSupDiv);
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeDiv);       
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeSupdept);
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeDept);
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeSubDept);
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeSubDept2);
        dataUtil.orgHierStrFormatter(selectedOrgId, unitTypeDeptId);
        Test.stopTest();
    }   
    
    public static testMethod void test_setPDUs(){
        User tempU = datUtil.createUser();
        datUtil.createHR();
        RecordType recType = datUtil.getRecordType('Project_Based_Termination');
        system.runAs(tempU){
            Test.startTest();
            Project__c newPrjt = new Project__c(Name = 'Test Prjt', Communication_Date__c = Date.today(), Termination_Date__c = Date.today().addDays(20),Country__c = 'USA', Status__c = 'Active', RecordTypeId = recType.Id);
            insert newPrjt;
            User userRec = [SELECT Id,Name,Emp_ID__c FROM User LIMIT 1];
            Employee__c tempEmp = datUtil.createEmployeeFromUser(userRec);
            allPDUs = new Project_Decisional_Unit__c(Decisional_Unit_Name__c = 'Super Division',Employee__c = tempEmp.Id, HR_Signatory__c = tempEmp.Id,Project__c = newPrjt.Id);
            insert allPDUs;
            dataUtil.setPDUs(String.valueOf(allPDUs.Id));
            Test.stopTest();
        }
    }
    
    
    /* public static testMethod void setChildPDU(){

}*/
    
    //public static testMethod  test_setEntitlements(){
    
    public static testMethod void  test_setEntitlementOrgs(){
        Test.startTest();
        Coverage_Entitlement__c coveEnt = new Coverage_Entitlement__c();
        insert coveEnt;
        orgRecDet = new Coverage_Entitlement_Org__c ( Coverage_Entitlement__c= coveEnt.Id,Coverage_Entitlement_Type__c='Super Division',Org_Hierarchy_Code__c='10910 - Wealth Management');
        insert orgRecDet;
        Test.stopTest();
        
    }
    
    public static testmethod void test_validOrgCodeCheck(){
        setupData();
        string deptTypSupDiv = 'Super Division';
        string deptTypDiv = 'Division';
        string deptTypSupdept = 'Super Department';
        string deptTypDept = 'Department';
        string deptTypSubDept = 'Sub Department';
        string deptTypSubDept2 = 'Sub Department 2';
        string deptTypDeptId = 'Cost Center';
        string deptIDtring = '98100 - Technology & Data';
        string deptTypSupDivId = '98100 - Technology & Data';
        string deptTypDivId = '99140 - Individual Investor Group';
        string deptTypSupdeptId = '10910 - Wealth Management';
        string deptTypDepartId = '11011 - 8 - New England';
        string deptTypSubDeptId = '12037 - CMP011 - Palo Alto/Hawaii';
        string deptTypSubDept2Id = '10910 - Wealth Management';
        
        
        Test.startTest();
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypSupDiv,deptTypSupDivId);
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypDiv, deptTypDivId);       
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypSupdept, deptTypSupdeptId);
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypDept, deptTypDepartId);
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypSubDept, deptTypSubDeptId);
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypSubDept2, deptTypSubDept2Id);
        RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(deptTypDeptId, deptIDtring);
        Test.stopTest();
    }   
}