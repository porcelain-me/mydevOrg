// 08/16/2013 : JITENDRA : ORIGINAL
// Description : Test class for UserTrigger trigger and UserManager class 
@isTest
private class UserManagerTest {
    static list<Group> grpList;
    static list<RIF_PB_SuperDivision_Mapping__c> superDivisionList;
    static list<ER_Public_Group_to_Team_Mapping__c> caseTeamList;
    
    private static testMethod void testRIF_UserManager(){
        User tempUser = getTempUser(1);
        User u1 = getTempUser(2);
        system.RunAs(u1){
            setAllTriggerOn();
            insertCustomSettingForDivisionGroupMapping();
        }
        Test.startTest();
        List<GroupMember> gmList = [select id from GroupMember where GroupId in :grpList];
        System.assertEquals(0, gmList.size(),' List size should be 0');        
        
        tempUser.RIF_Allow_Super_Division__c = 'Super Division 1;';
        tempUser.ER_Case_Team_Allowed__c = 'Case Team 1;';
        insert tempUser;
        
        tempUser.RIF_Allow_Super_Division__c = '';
        tempUser.ER_Case_Team_Allowed__c = 'Case Team 2';
        update tempUser;
        
        tempUser.RIF_Allow_Super_Division__c = '';
        tempUser.ER_Case_Team_Allowed__c = 'Case Team 1';
        update tempUser;
        
        /*gmList = [select id from GroupMember where GroupId in :grpList];
        System.assertEquals(0, gmList.size(),' List size should be 0');*/
        
        tempUser.RIF_Allow_Super_Division__c = 'Super Division 2';
        tempUser.ER_Case_Team_Allowed__c = 'Case Team 2';
        update tempUser;
        
        Test.stopTest();
        
        //system.debug('Jitendra->' + [select Id, RIF_Allow_Super_Division__c from User where Id = :tempUser.Id]);
        system.debug('Jitendra->' + grpList);
        gmList = [select id from GroupMember where GroupId in :grpList];
        System.assertEquals(2, gmList.size(),' List size should be 2');
        
        
        
    }
    private static void insertCustomSettingForDivisionGroupMapping() {        
        grpList = new list<Group>();
        Group grp1 = new Group(Name = 'TESTSuper_Division_1');
        grpList.add(grp1);
        Group grp2 = new Group(Name = 'TESTSuper_Division_2');
        grpList.add(grp2);
        Group grp3 = new Group(Name = 'TESTCaseTeam_1');
        grpList.add(grp3);
        Group grp4 = new Group(Name = 'TESTCaseTeam_2');
        grpList.add(grp4);
        insert grpList;
        
        superDivisionList = new List<RIF_PB_SuperDivision_Mapping__c>();
        
        RIF_PB_SuperDivision_Mapping__c superDiv1 = new RIF_PB_SuperDivision_Mapping__c(Name = 'Super Division 1');
        superDiv1.Super_Division__c = 'Super Division 1';
        superDiv1.Public_Group__c = grp1.Name;
        superDivisionList.add(superDiv1);
                
        RIF_PB_SuperDivision_Mapping__c superDiv2 = new RIF_PB_SuperDivision_Mapping__c(Name = 'Super Division 2');
        superDiv2.Super_Division__c = 'Super Division 2';
        superDiv2.Public_Group__c = grp2.Name;
        superDivisionList.add(superDiv2);
        
        insert superDivisionList;
        
        caseTeamList = new List<ER_Public_Group_to_Team_Mapping__c>();
        
        ER_Public_Group_to_Team_Mapping__c caseTeam1 = new ER_Public_Group_to_Team_Mapping__c(Name = 'Case Team 1');
        caseTeam1.Team_Name__c = 'Case Team 1';
        caseTeam1.Public_Group_Name__c = grp3.Name;
        caseTeamList.add(caseTeam1);
                
        ER_Public_Group_to_Team_Mapping__c caseTeam2 = new ER_Public_Group_to_Team_Mapping__c(Name = 'Case Team 2');
        caseTeam2.Team_Name__c = 'Case Team 2';
        caseTeam2.Public_Group_Name__c = grp4.Name;
        caseTeamList.add(caseTeam2);
        
        insert caseTeamList;
        
    }
    
    private static User getTempUser(Integer index){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TUADMIN' + index + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUADMIN'  + index +  DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
    private static User getOtherUser(){
        Profile p = [SELECT Id FROM Profile WHERE name !='System Administrator' limit 1];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
    private static void setAllTriggerOn() { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusi
        if(dSwitch != null){
            //delete dSwitch;
            dSwitch = null;
        }       
        dSwitch = new Trigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        dSwitch.Is_User_trigger_off__c = false;
        insert dSwitch;
    }
}