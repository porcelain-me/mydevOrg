// 10/04/2013 RA: Case_Note__c object need to removed
@isTest
private class ER_PermissionValidationsTest {
    
    static Case__c testCase;
    static Parties_Involved__c party;
    //static Case_Note__c cn;
    static Related_Cases__c rc;
    static Resolution__c res;
    static Attachment file;
    static Note testNote;
    
    static testMethod void TestWithSystemAdminUser() {
        User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOn();
            
            createData();
            
            testCase.status__c = 'Closed';
            update testCase;
            
            delete testCase;
            
            Test.StopTest();
        }
    }
    
    static testMethod void TestWithComplianceUser() {
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOff();
            
            createData();
            
            testCase.status__c = 'Closed';
            update testCase;
            
            try{
                update rc;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update party;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update testCase;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update testNote;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                delete testNote;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            try{
                delete testCase;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            try{
                update res;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                delete file;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            Test.StopTest();
        }
    }
    
    static testMethod void TestWithHRUser() {
        User thisUser = ER_TestClassUtilities.getHRTempUser();
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOff();
            
            createData();
            
            testCase.status__c = 'Closed';
            update testCase;
            
            try{
                update rc;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update testNote;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update party;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                update testCase;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                delete testCase;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            try{
                update res;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForCloseStatus));
            }
            
            try{
                delete file;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            try{
                delete testNote;  
            }Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.ER_RecordLockedForDelete));
            }
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            Case__c case1 = ER_TestClassUtilities.createTestCase(0, department.Id);
            case1.Status__c = 'Closed';
            
            try{
                insert case1;
            }catch(Exception ex){
                System.Assert(ex.getMessage().contains(Label.ER_CaseStatusOpenForHR));
            }
            
            case1.Status__c = 'Open';
            insert case1;
            
            system.assertEquals(true, case1.Id <> null, 'Case Must be inserted successfully');
            
            Test.StopTest();
        }
    }
    
    /*static testMethod void TestWithoutExecutingTrigger() {
User thisUser = ER_TestClassUtilities.getNonSystemAdminUser();
system.runAs(thisUser) {
Test.StartTest();
createData();
Test.StopTest();
}
}*/
    
    static testMethod void TestForFirWideRWUser() {
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        thisUser.ER_Case_Team_Allowed__c = 'Compliance - Firmwide - Read/Write';
        insert thisUser;
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            testCase.Team__c = 'Firmwide';
            insert testCase;
            
            system.assert(testCase.Id <> null, 'Case should be inserted susccessfully');
            Test.StopTest();
        }
    }
    
    static testMethod void TestForFirWideReadUser() {
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        thisUser.ER_Case_Team_Allowed__c = 'Compliance - Firmwide - Read Only';
        insert thisUser;
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            testCase.Team__c = 'Firmwide';
            try{
                insert testCase;
            }catch(exception ex){
                system.assertEquals(true, ex.getMessage().contains(Label.ER_CaseCreationUpdationOwner));
            }
            
            Test.StopTest();
        }
    }
    
  /*  static testMethod void TestForUserCaseTeamNotMatching() {
        
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        thisUser.ER_Case_Team_Allowed__c = 'Compliance - Asia Pac & Japan';
        insert thisUser;
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            testCase.Team__c = 'Firmwide';
            try{
                insert testCase;
            }catch(exception ex){
                system.assertEquals(true, ex.getMessage().contains(Label.ER_CaseCreationUpdation));
            }
            
            Test.StopTest();
        }
    } */
    
    static testMethod void TestForOwnerCaseTeamNotMatching() {
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        thisUser.ER_Case_Team_Allowed__c = 'Compliance - EMEA';
        insert thisUser;
        
        
        system.runAs(thisUser) {
            Test.StartTest();
            User anotherUser = ER_TestClassUtilities.getHRTempUser();
            anotherUser.ER_Case_Team_Allowed__c = 'Compliance - Asia Pac & Japan';
            insert anotherUser;
            ER_TestClassUtilities.setAllTriggerOn();
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            testCase.Team__c = 'EMEA';
            insert testCase;
            try{
                testCase.OwnerId = anotherUser.Id;
                update testCase;
            }catch(exception ex){
                system.assertEquals(true, ex.getMessage().contains(Label.ER_CaseCreationUpdationOwner));
            }
            
            Test.StopTest();
        }
    }
    
    static testMethod void getGroupsForUser(){
        ER_Public_Group_to_Team_Mapping__c erc = new ER_Public_Group_to_Team_Mapping__c();
        erc.Name='Compliance - Asia Pac & Japan';
        erc.Team_Name__c ='Asia Pac & Japan';
        erc.Public_Group_Name__c='ER - Team - Compliance - Asia Pac & Jap';
        erc.Name='Compliance - Firmwide - Read Only';
        erc.Team_Name__c ='Firmwide - Read Only';
        erc.Public_Group_Name__c='ER - Team - Compliance - Firmwide - Read';
        erc.Name='Compliance - Firmwide - Read/Write';
        erc.Team_Name__c ='Firmwide - Read/Write';
        erc.Public_Group_Name__c='ER - Team - Compliance - Firmwide - RW';
        erc.Name='Compliance - GWM - Read Only';
        erc.Team_Name__c ='GWM - Read Only';
        erc.Public_Group_Name__c='ER - Team - Compliance - GWM - Read Only';
        erc.Name='Compliance - GWM - Read/Write';
        erc.Team_Name__c ='GWM - Read/Write';
        erc.Public_Group_Name__c='ER - Team - Compliance - GWM - Read/Writ';
        erc.Name='Compliance - MSIM - Read/Write';
        erc.Team_Name__c ='MSIM - Read/Write';
        erc.Public_Group_Name__c='ER - Compliance - MSIM - Read/Write';
        erc.Name='Employment EMEA';
        erc.Team_Name__c ='Employment EMEA';
        erc.Public_Group_Name__c='ER - Team - Compliance - EMEA';
        erc.Name='HR - Asia';
        erc.Team_Name__c ='HR - Asia';
        erc.Public_Group_Name__c='ER - Team - HR - Asia';
        insert erc;
        group g1=new group(Name='ER_Compliance_MSIM_Read_Write');
        insert g1;
        group g2=new group(Name='ER_Team_Compliance_Asia_Pack_Jap');
        insert g2;
        group g3=new group(Name='ER_Team_Compliance_EMEA');
        insert g3;
        group g4=new group(Name='ER_Team_Compliance_Firmwide_Read');
        insert g4;
        group g5=new group(Name='ER_Team_Compliance_Firmwide_RW');
        insert g5;
        group g6=new group(Name='ER_Team_Compliance_GWM_Read_Only');
        insert g6;
        group g11=new group(Name='ER_Team_Compliance_GWM_Read_Writ');
        insert g11;
        group g7=new group(Name='ER_Team_Super_Group');
        insert g7;
        group g8=new group(Name='ER_Team_Employment_Law_Team');
        insert g8;
        group g9=new group(Name='ER_Team_HR_Asia');
        insert g9;
        group g0=new group(Name='ER_Team_HR_Super_Group');
        insert g0;
        
        
    }
    
    
    
    
    
    private static void createData(){
        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
        insert department;
        
        Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
        insert testCase;
        
        Case__c testCase1 = ER_TestClassUtilities.createTestCase(1, department.Id);
        insert testCase1;
        
        party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
        insert party;
        
        file = ER_TestClassUtilities.createTestTextAttachment(0, testCase.Id);
        insert file;
        
        testNote = New Note(parentId = testCase.Id);
        testNote.title = 'test note';
        insert testNote; 
        
        rc = ER_TestClassUtilities.createTestRelatedCases(testCase.Id, testCase1.Id);
        insert rc; 
        
        res = ER_TestClassUtilities.createTestResolution(testCase.Id, null);
        insert res;
    }   
    
}