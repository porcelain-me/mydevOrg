//07/09/2012 UV: created this test class for the TeamShareManager
@isTest
private class TestTeamShareManager {

    
    private static final Integer LIST_SIZE = 20;
    
    //enable the trigger as need to test the manager functionality
     public static void createTriggerSwitchSettings() {
        GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();
        if(dSwitch != null && dSwitch.id <> null){
            dSwitch.Is_EmployeeTeamSharing_On__c = true;
            dSwitch.Is_SyncResearchTeamWithTeam_On__c = true;
            update dSwitch;
         }else{
            dSwitch.Is_EmployeeTeamSharing_On__c = true;
            dSwitch.Is_SyncResearchTeamWithTeam_On__c = true;
           insert dSwitch;
         }  
        
    }
    
    static testmethod void insertAndUpdateEmployeeTest() {
          
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         Profile p1 = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User thisUser = new User(alias = 'newUser', email='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p1.Id,
            timezonesidkey='America/Los_Angeles', username='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = 'MGTEST_01');
           
         system.runAs(thisUser) {
            Test.startTest();
             T1C_CustomSettingsManager.setAllTriggerOn();
            //createTriggerSwitchSettings();
            //create active research teams
            list<GPSEmployee__c> empList = new List<GPSEmployee__c>();
            List<User> usrList = new List<User>();
            
            
             Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User tempUser1 = new User(alias = 'newUser2', email='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = '1XYZ123!@', isActive=true);
            
            
            User tempUser2 = new User(alias = 'newUser1', email='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = DateTime.now().format('ddyyhhmmss'), isActive=true);
            
            //List<User> usrList = [select Id, Emp_Id__c from User where isActive = true and Emp_Id__c <> null and email like '%morganstanley.com%' limit 20];
            usrList.add(tempUser1);
            usrList.add(tempUser2);
            
            insert usrList;
            
            
            
            for(User duser : usrList) {
                GPSEmployee__c emp = new GPSEmployee__c();
                emp.Name = 'Test Employee';
                emp.MS_ID__c = duser.Emp_Id__c;
                emp.Office_Title__c = 'Test Tittle';
                emp.Division__c = 'Test Div';
                //emp.Cost_Center_Desc__c = 'Desc-01';
                emp.Active_Flag__c = duser.IsActive;
                emp.User__c = duser.Id;
                empList.add(emp);
                
            }
            insert empList;
            
            Region__c reg = new Region__c();
            reg.Name = 'TestReg10n';
            reg.RegionID__c = 'TestReg10n'; 
            reg.Show_Quintile__c = true;
            insert reg; 
            
            List<Team__c> teamList = new List<Team__c>();
            /*for(Integer i = 0; i < LIST_SIZE ; i++) {
                Team__c t = new Team__c();
                t.TeamID__c = 'TestID_' + i;
                t.Team_Lead_Name__c = rtList[i].TeamLead_Name__c;
                t.Team_Status__c = 'Open';
                t.Team_Region__c = reg.Id;
                t.Name = 'Test_UV' + i;
                t.Team_Function__c = 'Industry';
                t.isHidden__c = false;
                teamList.add(t);
            }       
            insert teamList;
            */
            Set<String> teamIds = new Set<String>();
            list<Research_Team__c> rtlist = new list<Research_Team__c>();
            for(Integer i = 0; i < LIST_SIZE ; i++) {
                Research_Team__c rt = new Research_Team__c();
                rt.Team_Id__c = 'TestID_' + i;
                rt.GPS_Team_Lead__c = empList[math.mod(i, 2)].Id;            
                rt.Active_Flag__c = true;
                rt.Team_Region_Name__c = reg.Name;
                rt.Team_Status__c = 'Open';
                rt.Team_Function__c = 'Industry';
                rt.Name = 'Test_UV' + i;
                teamIds.add('TestID_' + i);
                rtList.add(rt);//Research_Team__c. 
            }
            insert rtList;
            
            teamList = [Select Id from Team__c where TeamID__c in :teamIds];
            
            
            
            System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
            
            List<Team__Share> tsList = [select id from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
            // team share should be 0, because employees are not active
            System.assertEquals(0,tsList.size(),'Team share records should be equals to 0');
            
            Research_Team__c rt = new Research_Team__c();
            rt.Team_Id__c = 'TestID_123';
            rt.GPS_Team_Lead__c = empList[0].Id;
            rt.Active_Flag__c = true;
            rt.Team_Region_Name__c = reg.Name;
            rt.Team_Status__c = 'Open';
            rt.Team_Function__c = 'Industry';
            rt.Name = 'Test_UV 123';
            insert rt;
             //activating the Users
            for(User dusr : usrList) {
                dusr.isActive = true;
            }
            update usrList;
            
            //activating the employees
            for(GPSEmployee__c emp : empList) {
                emp.Active_Flag__c = true;
                emp.Research_Team__c = rtList[0].Id;
            }
            update empList;
            
            tsList = [select id from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
            System.assertEquals(empList.size(),tsList.size(),'Team share records should be equals to Team Records');
            
             //deactivating the Users
            for(User dusr : usrList) {
                dusr.isActive = false;
            }
            update usrList;
            //deactivating the employees
            for(GPSEmployee__c emp : empList) {
                emp.Active_Flag__c = false;
            }
            update empList;
            
            tsList = [select id,UserOrGroupId from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
           // System.assertEquals(empList.size(),tsList.size(),'Team share records should be equals to 0');
            
            Set<Id> userIds = new Set<Id>();
            for(Team__Share ts : tsList) {
                userIds.add(ts.UserOrGroupId);
            }
            TeamShareManager.removePreviouslySystemAddedPermissionForUsers(userIds);
            
           Test.stopTest();
            
        }
    
    }
    
    static testMethod void insertAndUpdateUserTest() {
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         Profile p1 = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User thisUser = new User(alias = 'newUser', email='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p1.Id,
            timezonesidkey='America/Los_Angeles', username='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = 'MGTEST_01');
         T1C_CustomSettingsManager.setAllTriggerOn();
         T1C_CustomSettingsManager.createChatterSetting();
         system.runAs(thisUser) {
            Test.startTest();
            //createTriggerSwitchSettings();
            //create active research teams
            list<GPSEmployee__c> empList = new List<GPSEmployee__c>();
            List<User> usrList = new List<User>();
            
            
             Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User tempUser1 = new User(alias = 'newUser2', email='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = '1XYZ123!@');
            
            
            User tempUser2 = new User(alias = 'newUser1', email='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = DateTime.now().format('ddyyhhmmss'));
            
            //List<User> usrList = [select Id, Emp_Id__c from User where isActive = true and Emp_Id__c <> null and email like '%morganstanley.com%' limit 20];
            usrList.add(tempUser1);
            usrList.add(tempUser2);
            
            insert usrList;
            
            
            for(User duser : usrList) {
                GPSEmployee__c emp = new GPSEmployee__c();
                emp.Name = 'Test Employee';
                emp.MS_ID__c = duser.Emp_Id__c;
                emp.Office_Title__c = 'Test Tittle';
                emp.Division__c = 'Test Div';
                //emp.Cost_Center_Desc__c = 'Desc-01';
                emp.Active_Flag__c = true;
                empList.add(emp);
                duser.isActive = false;
                
            }
            insert empList;
            update usrList;
            
            Region__c reg = new Region__c();
            reg.Name = 'TestReg10n';
            reg.RegionID__c = 'TestReg10n'; 
            reg.Show_Quintile__c = true;
            insert reg; 
            
            List<Team__c> teamList = new List<Team__c>();
            for(Integer i = 0; i < LIST_SIZE ; i++) {
                Team__c t = new Team__c();
                t.TeamID__c = 'TestID_' + i;
                t.Team_Lead_Name__c = empList[math.mod(i, 2)].Name;
                t.Team_Status__c = 'Open';
                t.Team_Region__c = reg.Id;
                t.Name = 'Test_UV' + i;
                t.Team_Function__c = 'industry';
                teamList.add(t);
            }       
            insert teamList;
            
            
            
            List<Research_Team__c> rtlist = new list<Research_Team__c>();
            for(Integer i = 0; i < LIST_SIZE ; i++) {
                Research_Team__c rt = new Research_Team__c();
                rt.Team_Id__c = 'TestID_' + i;
                rt.GPS_Team_Lead__c = empList[math.mod(i, 2)].Id;
                rt.Active_Flag__c = true;
                rt.Team_Region_Name__c = reg.Name;
                rt.Team_Status__c = 'Open';
                rt.Team_Function__c = 'industry';
                rt.Name = 'Test_UV' + i;
                rtList.add(rt);//Research_Team__c. 
            }
            insert rtList;
            
            System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
            
            List<Team__Share> tsList = [select id,UserOrGroupId from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
            System.assertEquals(0,tsList.size(),'Team share records should be equals to 0');
            //activating the Users
            for(User dusr : usrList) {
                dusr.isActive = true;
            }
            update usrList;
            
            
            Test.stopTest();
            
            //team_share records are created in future method so cannot be test in assert conditions.           
            
        }
    
    
    }
    
    static testMethod void insertAndUpdateResearchTeamTest() {
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         Profile p1 = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User u= new User(alias = 'newUser', email='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p1.Id,
            timezonesidkey='America/Los_Angeles', username='T' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            Emp_Id__c = 'MGTEST_01');
        
        T1C_CustomSettingsManager.setAllTriggerOn();
        system.runAs(u) {
            Test.startTest();
            
            //TestClassUtilities.setAllTriggerOn();
            //createChatterSetting();
            
            list<GPSEmployee__c> empList = new list<GPSEmployee__c>();
            list<User> usrList = new list<User>();
            list<Region__c> rList = new list<Region__c>();
            set<String> teamIds = new set<String>();
            list<Research_Team__c> rtlist = new list<Research_Team__c>();
            list<Team__c> teamList = new list<Team__c>();
            list<Team__Share> tsList = new list<Team__Share>();
            
            Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];

            User tempUser1 = new User(alias = 'newUser2', email='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                    emailencodingkey='UTF-8', lastname='Testing',
                    languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
                    timezonesidkey='America/Los_Angeles', username='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                    Emp_Id__c = '1XYZ123!@', isActive = true);
            usrList.add(tempUser1);
            
            User tempUser2 = new User(alias = 'newUser1', email='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                    emailencodingkey='UTF-8', lastname='Testing',
                    languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
                    timezonesidkey='America/Los_Angeles', username='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                    Emp_Id__c = DateTime.now().format('ddyyhhmmss'),  isActive = true);
            usrList.add(tempUser2);
            
            insert usrList;
            
            for(User duser : usrList) {
                GPSEmployee__c emp = new GPSEmployee__c();
                emp.Name = 'Test Employee';
                emp.MS_ID__c = duser.Emp_Id__c;
                emp.User__c = duser.Id;
                emp.Office_Title__c = 'Test Tittle';
                emp.Division__c = 'Test Div';
                //emp.Cost_Center_Desc__c = 'Desc-01';
                emp.Active_Flag__c = true;
                //emp.Cost_Center_Code__c = 'cc-01';
                emp.Business_Unit__c = 'test unit-01';
                empList.add(emp);
            }
            insert empList;
            
            Region__c r = new Region__c();
            r.Name = 'asia pacific';
            rList.add(r);
            
            Region__c r1 = new Region__c();
            r1.Name = 'Japan';
            rList.add(r1);
            
            insert rList;
            
            //create active research teams
            for(Integer i = 0; i < LIST_SIZE ; i++) {
                Research_Team__c rt = new Research_Team__c();
                rt.Team_Id__c = 'TestID_' + System.now() + '--'+i;
                rt.GPS_Team_Lead__c = empList[math.mod(i, 2)].Id;
                rt.Active_Flag__c = true;
                rt.Team_Function__c = 'Industry';
                rt.Team_Region_Name__c = 'Asia Pacific';
                rt.Team_Status__c = 'open';
                teamIds.add(rt.Team_Id__c);
                rtList.add(rt); 
            }
            insert rtList;
            
            // team records must be inserted for each active research team
            teamList = [select id from Team__c where TeamId__c IN : teamIds and isHidden__c = false];
            
            System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equal to research Teams');
            
            // there are no employees associated with the research team so No team share record exists.
            tsList = [select id from Team__Share where parentId IN : teamList and  rowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
            System.assertEquals(tsList.size(),0,'Team share records should be equal to 0');
            
            delete teamList ;
            
            // associate employee with research team and then update research team to fire the trigger.
            // Now team share records will be created for each emaployee and associated team.
            teamIds.clear();
            Integer i = 0;
            for(Research_Team__c rt : rtList){
                for(GPSEmployee__c emp : empList){
                    emp.Research_Team__c = rt.Id;
                }
                rt.Team_Id__c = 'TestId---'+i++;
                teamIds.add(rt.Team_Id__c);
            }
            update empList ;
            update rtList;   
            
            // Since tema id of all reserach teams has been changed so new teams will be created.
            teamList = [select id from Team__c where TeamId__c IN : teamIds and isHidden__c = false];
            
            System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equal to research Teams');
            // All the old team share records will be deleted and Team share records will be created for each employee and team value.
            // so number of team shares must be equal to teamList Size * empList Size
            tsList = [select id,UserOrGroupId,ParentId from Team__Share where parentId IN : teamList and  rowCause = :Schema.Team__Share.RowCause.Team_Share__c];
            
            System.assertEquals(teamList.size()*empList.size(),40,'Team share records should be equal to 0');
            
            Map<Id,Id> userTeamMap = new Map<Id,Id>();
            for(Team__Share ts : tsList) {
                userTeamMap.put(ts.UserOrGroupId,ts.ParentId);
            }
            TeamShareManager.removePreviouslySystemAddedPermissionForUsers(userTeamMap);
            
         }
    }
}