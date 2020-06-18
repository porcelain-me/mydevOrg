@isTest
private class TestT1C_EmployeeToUserDeactivation {

     static list<User> usrList;
	 static list<Profile> profileList;
	 static List<GPSEmployee__c> empList;
	 static List<PermissionSet> permissionSetsData;
	 static List<GroupMember> userGrpMember;
	 static List<PermissionSetAssignment> assignment;
    

    public static  void permissionSetAndGroupDataCreation(){
          
        permissionSetsData = new List<PermissionSet>();
        PermissionSet permissionSet1 = new PermissionSet(name = 'testSet1', label ='testSet1');
        permissionSetsData.add(permissionSet1);
        PermissionSet permissionSet2 = new PermissionSet(name = 'testSet2', label ='testSet2');
        permissionSetsData.add(permissionSet2);
        insert permissionSetsData;
        
                
        assignment = new List<PermissionSetAssignment>();
        PermissionSetAssignment pas = new PermissionSetAssignment(AssigneeId = usrList[0].id,PermissionSetId = permissionSetsData[0].id);
        assignment.add(pas);
        PermissionSetAssignment pas1 = new PermissionSetAssignment(AssigneeId = usrList[1].id,PermissionSetId = permissionSetsData[1].id);
        assignment.add(pas1); 
        insert assignment;
        
        Group grp = new Group(name = 'userGroup');
        insert grp;
        
        userGrpMember = new List<GroupMember>();
        GroupMember grpMem = new GroupMember(GroupId = grp.id,UserOrGroupId = usrList[0].id  );
        userGrpMember.add(grpMem );
        GroupMember grpMem2 = new GroupMember(GroupId = grp.id,UserOrGroupId = usrList[1].id  );
        userGrpMember.add(grpMem2 );
        insert userGrpMember; 
        
         iiCampaign__c campaign = new  iiCampaign__c(Active_Flag__c = true,name = 'N1');
         insert campaign; 
        
         Target_List__c target = new  Target_List__c(User__c =  usrList[0].Id,iiCampaign__c = campaign.id );   
         insert  target;
        
    }

        public static  void createCampaign(){
        
         iiCampaign__c campaign = new  iiCampaign__c(Active_Flag__c = true,name = 'N1');
         insert campaign; 
        
         Target_List__c target = new  Target_List__c(User__c =  usrList[0].Id,iiCampaign__c = campaign.id );   
         insert  target; 
        
    }
    private static void createUsers(){
    	
         profileList = [SELECT Id FROM Profile Limit 1];
         usrList = new list<User>();
         User tempUser1 = new User(alias = 'U2', email='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                emailencodingkey='UTF-8', lastname='Testing',
                languagelocalekey='en_US', localesidkey='en_US', profileid = profileList[0].Id,
                timezonesidkey='America/Los_Angeles', username='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                Emp_Id__c = '76767', isActive = true);
        usrList.add(tempUser1);
        
        User tempUser2 = new User(alias = 'U1', email='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                emailencodingkey='UTF-8', lastname='Testing',
                languagelocalekey='en_US', localesidkey='en_US', profileid = profileList[0].Id,
                timezonesidkey='America/Los_Angeles', username='T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                Emp_Id__c = '76768',  isActive = true);
        usrList.add(tempUser2);
    }
    
    private static void createEmployees(){
    	
        empList = new List<GPSEmployee__c>();
        GPSEmployee__c  emp = new GPSEmployee__c ();
        emp.Business_Unit__c = 'Test Business Unit';
        emp.City__c = 'Test City';
        //emp.Cost_Center_Code__c = 'Test CCID';
       // emp.Cost_Center_Desc__c = 'Test CC Name';
        //emp.Division__c = 'Test Division' ;
        emp.MS_ID__c = '76767';
        emp.Last_Name__c = 'lastName';
        emp.FIRMWIDE_ID__c = '76767';
        //emp.Telephony_Device_Data__c = 'BT';
        emp.Active_Flag__c = true;
        emp.User__c=usrList[0].id;
        empList.add(emp);
        
        
        emp = new GPSEmployee__c();
       // emp.Telephony_Device_Data__c = 'BT';
        emp.Business_Unit__c = 'Test Business Unit2';
        emp.City__c = 'Test City2';
        //emp.Cost_Center_Code__c = 'Test CCID2';
        //emp.Cost_Center_Desc__c = 'Test CC Name2';
        //emp.Division__c = 'Test Division2' ;
        emp.MS_ID__c = '76768';
        emp.Last_Name__c = 'lastName';
        emp.FIRMWIDE_ID__c = '76768';
        emp.Active_Flag__c = true;
        emp.User__c=usrList[1].id;
        empList.add(emp);      
        
        
    }    
    public static  testmethod void runtest(){
    	
        List<GPSEmployee__c> empListUpdate = new  List<GPSEmployee__c>();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
        	
            // create custom settings.
	        T1C_CustomSettingsManager.setAllTriggerOn();
	        T1C_CustomSettingsManager.createChatterSetting();
	        GPSTrigger_Switch__c dSwitch = new GPSTrigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
	        dSwitch.Is_T1C_SyncEmployeeToUser_Trigger_On__c  = true;
	        insert dSwitch;
	        // create Users
	        createUsers();
	        insert usrList;
	        // create PermissionSet 
        	permissionSetAndGroupDataCreation();

        }
        
        // create Employee
        createEmployees();
        insert empList;
        
        // create campaign
        createCampaign();
        
        Test.startTest();
        // update employee
        for(GPSEmployee__c  emp : empList){
        	
        	emp.Active_Flag__c = false;
        	empListUpdate.add(emp);
        	
        }
        
        update empListUpdate;  
        
        Test.StopTest();
               
    }

}