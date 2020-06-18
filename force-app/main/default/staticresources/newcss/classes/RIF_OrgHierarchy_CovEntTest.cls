/** Test class for RIF_OrgHierarchy_CovEntPage VF page, the page lets the RIF Coverage user add new coverage entitlements for an employee**/
@isTest
public class RIF_OrgHierarchy_CovEntTest{
    public static User tempU;
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    
    public static void setupData(){
        tempU = new User();
        tempU = testUtil.createUser();
        testUtil.createHR();
    }
    // test the contoller for the page
    public static testMethod void test_cont(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            List<SelectOption> entSelectOptsList = new List<SelectOption>();
            entSelectOptsList.add(new SelectOption('None','--None--'));
            entSelectOptsList.add(new SelectOption('Super Division','Super Division'));
            entSelectOptsList.add(new SelectOption('Cost Center','Cost Center'));
            theContler.entTypes = entSelectOptsList;
            Test.stopTest();
        }
    }
    public static testMethod void test_blankId(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = new Coverage_Entitlement_Org__c();
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            Test.stopTest();
        }
    }
    public static testMethod void test_searchOrgCode(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            testUtil.insertOrgHierarchy();
            theContler.entitlementType = 'Super Division';
            theContler.searchOrgH = '10910';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Division';
            theContler.searchOrgH = '99190';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Super Department';
            theContler.searchOrgH = '25307';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Department';
            theContler.searchOrgH = '11002';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Sub Department';
            theContler.searchOrgH = '12255';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Sub Department 2';
            theContler.searchOrgH = '26424';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Cost Center';
            theContler.searchOrgH = '571195';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.entitlementType = 'Cost Center';
            theContler.orgHierCode = '571195 - SN FRN-CSH MGT (SB)';
            theContler.searchOrgCode();
            Test.stopTest();
        }
    }
    public static testMethod void test_searchOrgCodeIncorrect(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = new Coverage_Entitlement_Org__c();
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            testUtil.insertOrgHierarchy();
            theContler.entitlementType = 'None';
            theContler.searchOrgH = '10910';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Division';
            theContler.searchOrgH = '*sd @ s7';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Super Department';
            theContler.searchOrgH = '25';
            theContler.searchOrgCode();
            theContler.entitlementType = 'Super Department';
            theContler.searchOrgH = '23455';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = false;
            theContler.entitlementType = 'Cost Center';
            theContler.orgHierCode = ' * sd99 - 23';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = true;
            theContler.entitlementType = 'Cost Center';
            theContler.orgHierCode = '571195 - SN FRN-CSH MGT (SB)';
            theContler.searchOrgCode();
            theContler.directSearch = true;
            theContler.isEdit = false;
            theContler.entitlementType = 'Cost Center';
            theContler.orgHierCode = '3';
            theContler.searchOrgCode();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_saveOrgEntitlement(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id','');
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            testUtil.insertOrgHierarchy();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 - Wealth Management';
            theContler.saveOrgEntitlement();
            theContler.entitlementType = 'None';
            theContler.saveOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '';
            theContler.saveOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 Wealth Management';
            theContler.saveOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 - - Management';
            theContler.saveOrgEntitlement();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_updateOrgEntitlement(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            testUtil.insertOrgHierarchy();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 - Wealth Management';
            theContler.updateOrgEntitlement();
            theContler.entitlementType = 'None';
            theContler.updateOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '';
            theContler.updateOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 Wealth Management';
            theContler.updateOrgEntitlement();
            theContler.entitlementType = 'Super Division';
            theContler.orgHierCode = '10910 - - Management';
            theContler.updateOrgEntitlement();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_insertSelectedOrg(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            theContler.insertSelectedOrg();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_showOrgPopup(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
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
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            theContler.cancelOrgPopup();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_cancelMainPage(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            theContler.cancelMainPage();
            Test.stopTest();
        }
    }
    
    public static testMethod void test_cancelEditPage(){
        setupData();
        system.runAs(tempU){
            Test.startTest();
            PageReference thePage = Page.RIF_OrgHierarchy_CovEntPage;
            Test.setCurrentPage(thePage);
            Coverage_Entitlement_Org__c newChildCovEnt = testUtil.createChildCoverageEnt();
            thePage.getParameters().put('Id',newChildCovEnt.Id);
            ApexPages.StandardController cont = new ApexPages.StandardController(newChildCovEnt);
            RIF_OrgHierarchy_CovEnt theContler = new RIF_OrgHierarchy_CovEnt(cont);
            theContler.cancelEditPage();
            Test.stopTest();
        }
    }
}