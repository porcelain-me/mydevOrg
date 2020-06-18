@isTest
public class RIF_CustomEmpPageController_Test {
    public static User tempUser = new User();
    public static List<PermissionSetAssignment> psAssignList = new List<PermissionSetAssignment>();
    
    public static testMethod void testMethod1(){
        
        User thisUser = RIF_TestClassUtilities.getTempUser();
        insert thisUser;
        
        Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0,'12345', 'USA', 'MSSB', 'Director','123');
        emp.User__c = thisUser.id;
        emp.Super_Division__c='10910';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(emp);
        RIF_CustomEmpPageController customObj = new RIF_CustomEmpPageController(sc);
        
        System.runAs(thisUser){
            Unvested_Equity__c unEqu = new Unvested_Equity__c();
            
            test.startTest();
            customObj.unvestedObject = unEqu;
            customObj.iscompDataVisible = false;
            
            customobj.redirect();
            test.stopTest();
            
        }
    }
    
    @isTest
    public static void test_allFunctions(){
        Integer randSeed = Crypto.getRandomInteger();
        String seed = String.valueOf(randSeed).substring(0,5);
        tempUser = RIF_TestClassUtilities.getALLMSUser();
        tempUser.Username = seed + '@tester.com.fake';
        insert tempUser;  
        // assign RIF,DualHat and FFAP permission sets to this user
        List<PermissionSet> rifDualPSList = [SELECT Id From PermissionSet WHERE Name LIKE '%RIF_System_Admin%' OR Name LIKE '%Dual%' OR Name LIKE '%FFAP%'];
        if(rifDualPSList != null && !rifDualPSList.isEmpty()){
            for(PermissionSet pset : rifDualPSList){
                PermissionSetAssignment psAsgn = new PermissionSetAssignment(AssigneeId = tempUser.id, PermissionSetId = pset.Id);
                psAssignList.add(psAsgn);
            }
        }
        if(psAssignList != null && !psAssignList.isEmpty()){
            insert psAssignList;
        }
        
        System.runAs(tempUser){
            Integer randSeed1 = Crypto.getRandomInteger();
            String seed1 = String.valueOf(randSeed1).substring(1,5);
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(Integer.valueOf(seed1),seed1, 'USA', 'MSSB', 'Director','123');
            emp.User__c = tempUser.id;
            emp.Super_Division__c='10910';
            insert emp;
            
            Test.startTest();            
            PageReference thePage = Page.RIF_CustomEmpPage;
            Test.setCurrentPage(thePage);
            ApexPages.StandardController sc = new ApexPages.StandardController(emp);
            RIF_CustomEmpPageController customObj = new RIF_CustomEmpPageController(sc);
            customObj.createAgreement();
            customObj.ViewJPN();
            customObj.StartJPN();
            customObj.customEdit();
            customObj.ShowDET();            
            Test.stopTest();
        }
        
    }
}