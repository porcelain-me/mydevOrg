@istest
public class RIF_OrgHierarchy_OrgLevelPDU_Test{
    public static User tempU;
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    
    public static void setupData(){
        tempU = new User();
        //tempU = testUtil.createUser();
        tempU = testUtil.createUser2();
    }
    // test the contoller for the page
    public static testMethod void test_cont(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            List<SelectOption> PduSelectOptsList = new List<SelectOption>();
            PduSelectOptsList.add(new SelectOption('None','--None--'));
            PduSelectOptsList.add(new SelectOption('Super Division','Super Division'));
            PduSelectOptsList.add(new SelectOption('Cost Center','Cost Center'));
            theContler.unitTypes = PduSelectOptsList;
            Test.stopTest();
        }
    }
    public static testMethod void test_blankId(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            Test.stopTest();
        }
    }
    
    /*
    public static testMethod void test_searchOrgCode(){
        testUtil.createHR();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            //theContler.decisionalUnitType = 'Super Division';
            //theContler.searchOrgH = '10910';
            //theContler.orgHierCode = '10910 - Wealth Management';
            //theContler.searchOrgCode();
            // theContler.decisionalUnitType = 'Cost Center';
            Test.stopTest();
        }
    }
    */
    public static testMethod void test_searchOrgCodeIncorrect(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            testUtil.insertOrgHierarchy();
            // correct codes
            theContler.decisionalUnitType = 'Division';
            theContler.searchOrgH = '99190';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Super Division';
            theContler.searchOrgH = '10910';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Super Department';
            theContler.searchOrgH = '25307';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Department';
            theContler.searchOrgH = '11002';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Sub Department';
            theContler.searchOrgH = '12255';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Sub Department 2';
            theContler.searchOrgH = '26424';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Cost Center';
            theContler.searchOrgH = '571195';
            theContler.searchOrgCode();
            // direct search
            theContler.decisionalUnitType = 'Cost Center';
            theContler.orgHierCode = '571195';
            theContler.directSearch = true;
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Cost Center';
            theContler.orgHierCode = '571195 - Some';
            theContler.directSearch = true;
            theContler.searchOrgCode();
            
            // Incorrect codes, validation checks
            theContler.decisionalUnitType = 'None';
            theContler.searchOrgH = '10910';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Division';
            theContler.searchOrgH = '*sd @ s7';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Super Department';
            theContler.searchOrgH = '25';
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Super Department';
            theContler.orgHierCode = '25';
            theContler.directSearch = true;
            theContler.searchOrgCode();
            theContler.decisionalUnitType = 'Super Department';
            theContler.searchOrgH = '23455';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = false;
            theContler.decisionalUnitType = 'Cost Center';
            theContler.orgHierCode = ' * sd99 - 23';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = true;
            theContler.decisionalUnitType = 'Cost Center';
            theContler.orgHierCode = '571195 - SN FRN-CSH MGT (SB)';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = false;
            theContler.decisionalUnitType = 'Cost Center';
            theContler.orgHierCode = '3';
            theContler.searchOrgCode();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_saveOrgPDU(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.decisionalUnitType = 'Super Division';
            theContler.orgHierCode = '10910 - Wealth Management';
            theContler.saveOrgPDU();
            
            theContler.decisionalUnitType = 'Division';
            theContler.searchOrgH = '99190';
            theContler.orgHierCode = '99190 - Wealth Management Field';
            theContler.saveOrgPDU();
            theContler.decisionalUnitType = 'Super Department';
            theContler.searchOrgH = '25307';
            theContler.orgHierCode = '25307 - Western';
            theContler.saveOrgPDU();
            theContler.decisionalUnitType = 'Department';
            theContler.searchOrgH = '11002';
            theContler.orgHierCode = '11002 - 1 - Northwest';
            theContler.saveOrgPDU();
            theContler.decisionalUnitType = 'Sub Department';
            theContler.searchOrgH = '12255';
            theContler.orgHierCode = '571195 - CMP008 - San Francisco';
            theContler.saveOrgPDU();
            theContler.decisionalUnitType = 'Sub Department 2';
            theContler.searchOrgH = '26424';
            theContler.saveOrgPDU();
            theContler.orgHierCode = '26424 - BR164-SAN FRANCISCO, CA 2';
            theContler.decisionalUnitType = 'Cost Center';
            theContler.searchOrgH = '571195';
            theContler.orgHierCode = '571195 - SN FRN-CSH MGT (SB)';
            theContler.saveOrgPDU();
            Test.stopTest();
        }
    }
    public static testMethod void test_updatePDUOrg(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',newChildPdu.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            testUtil.insertOrgHierarchy();
            theContler.decisionalUnitType = 'Super Division';
            theContler.orgHierCode = '10910 - Wealth Management';
            theContler.updatePDUOrg();
            theContler.decisionalUnitType = 'None';
            theContler.updatePDUOrg();
            theContler.decisionalUnitType = 'Super Division';
            theContler.orgHierCode = '10910 - Wealth Management';
            theContler.updatePDUOrg();
            theContler.decisionalUnitType = 'Super Division';
            theContler.orgHierCode = '10910 Wealth Management';
            theContler.updatePDUOrg();
            theContler.decisionalUnitType = 'Super Division';
            theContler.orgHierCode = '10910 - - Management';
            theContler.updatePDUOrg();
            Test.stopTest();
        }
    }
    public static testMethod void test_insertSelectedOrg(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.insertSelectedOrg();
            Test.stopTest();
        }
    }
    public static testMethod void test_showOrgPopup(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.showOrgPopup();
            theContler.orgHierCode = '571195 - SN FRN-CSH MGT (SB)';
            theContler.showOrgPopup();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_cancelOrgPopup(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.cancelOrgPopup();
            Test.stopTest();
        }
    }
    public static testMethod void test_cancelMainPage(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.cancelMainPage();
            Test.stopTest();
        }
    }
    public static testMethod void test_cancelEditPage(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            Employee__c emp = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();
            PageReference thePage = Page.RIF_OrgHierarchy_OrgLevelPDUPage;
            Test.setCurrentPage(thePage);
            Child_Project_Decisional_Unit__c NewChildPDU = testUtil.createChildPDU1(emp);
            thePage.getParameters().put('Id',NewChildPDU.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(NewChildPDU);
            RIF_OrgHierarchy_OrgLevelPDU theContler = new RIF_OrgHierarchy_OrgLevelPDU(cont);
            theContler.cancelEditPage();
            Test.stopTest();
        }
    }
}