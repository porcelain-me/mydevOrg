@isTest
private class TestSetTargetListMemberEligibleForEmail {  

    static list<Target_List__c> targetList;
    static List<Target_List_Member__c> targetListMember;
    static List<GPSContact__c> listContacts;
    static List<iiCampaign__c> campList;
    static User testUser;
    static Set<String> idset ;
    
    private static User getTempUser(){
    // Commented and Added By Aditya : JIRA 4438 : To Improve the performance of test Class
    /*
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing', MSID__c = 'MSID_1234',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id);
    
        return tempUser; 
        */
        return CM_TestClassUtilities.getAdminUser()[0];       
   }
    
    static testMethod void testInsertTargetListMember() 
    {
        //Temp user
        testUser = getTempUser();// DataUtil.getTestUserWithRole();
        System.runas(testUser){
       	TestClassUtilities.setAllTriggerOn();
        createData();
        
       
         List<Target_List_Member__c> lsttargetListMember = new List<Target_List_Member__c>();
            for(Integer i=0;i<20;i++){
                    Target_List_Member__c targetListMember1 = new Target_List_Member__c();
                    
                    targetListMember1.Target_List_Member_Key__c = 'key'+i;
                    targetListMember1.GPSContact__c = listContacts[0].id;
                targetListMember1.Blanket_Voter__c = true;
                 if(i<10){
                    targetListMember1.Target_List__c = targetList[0].id;
                  }
                 else{
                        targetListMember1.Target_List__c = targetList[1].id;
                    }
                    lsttargetListMember.add(targetListMember1);
                }
        
        insert lsttargetListMember;
        List<Target_List_Member__c> yesList = [select id,Eligible_for_email__c,Target_List__c  From Target_List_Member__c t where Target_List__c = :targetList[0].id];
         
         //Target List Member Eligible for email which Target List have Sends_Email__c ='No'
         
         System.assertEquals(yesList.size(),10);
         for(Target_List_Member__c tlm :yesList){
            //System.assertEquals(tlm.Eligible_for_email__c,false);
         }
          
            List<Target_List_Member__c> NoList = [select id,Eligible_for_email__c,Target_List__c  From Target_List_Member__c t where Target_List__c = :targetList[1].id];
         
         //Target List Member Eligible for email which Target List have Sends_Email__c ='Yes'
         System.assertEquals(NoList.size(),10);
         for(Target_List_Member__c tlm :NoList){
            System.assertEquals(tlm.Eligible_for_email__c,true);
         }
        }
       
        
    }

static testMethod void testUpdateEmailEligibleByRemoveReason() 
    {
        //Temp user
        testUser = getTempUser();// DataUtil.getTestUserWithRole();
        System.runas(testUser){
        TestClassUtilities.setAllTriggerOn();	
        createData();
        
       //For Coverage of Trigger UpdateEmailEligibleByRemoveReason 
        List<Target_List_Member__c> lsttargetListMember = new List<Target_List_Member__c>(); 
        Set<Id> setTLMs = new Set<Id>();
        
        for(Integer i=0;i<10;i++)
        {
          Target_List_Member__c targetListMember1 = new Target_List_Member__c();
          targetListMember1.Target_List_Member_Key__c = 'key'+i;
          targetListMember1.GPSContact__c = listContacts[0].id;
          targetListMember1.Blanket_Voter__c = true;
                 
                    //Yes Part
                    targetListMember1.Target_List__c = targetList[1].id;
                    targetListMember1.Removed_Reason__c = 'This contact does not vote for II';
                    targetListMember1.Eligible_for_email__c = true;
                    lsttargetListMember.add(targetListMember1);
                    
         }
         
         insert lsttargetListMember;
         
         for(Target_List_Member__c tlm:lsttargetListMember)
          {
            setTLMs.add(tlm.id);
                     system.debug('QueryStringggggtargetListMember1.id' + tlm.id);
          }
         String QueryString = 'select count() from Target_List_Member__c where id in :setTLMs and Eligible_for_email__c = false';
         //All Target List Members's are not eligible for email now.
         system.assertEquals(10,Database.countQuery(QueryString));
        
         for(Target_List_Member__c tlm:lsttargetListMember)
          {
            
            tlm.Removed_Reason__c = 'Email Only';
          }
       
       upsert lsttargetListMember;
        // all Target List Members's are eligible for email now.
         system.assertEquals(0,Database.countQuery(QueryString));
       
       
       for(Target_List_Member__c tlm:lsttargetListMember)
          {
            
            tlm.Removed_Reason__c = 'I have no relationship with this contact';
          }
       
       upsert lsttargetListMember;
        // all Target List Members's are Not eligible for email now.
         system.assertEquals(10,Database.countQuery(QueryString));
    }
}  

static testMethod void testUpdateTargetList() {
         //Temp user
        testUser = getTempUser();// DataUtil.getTestUserWithRole();
        System.runas(testUser){
         	TestClassUtilities.setAllTriggerOn();
        	createData();
            
	       targetListMember = new List<Target_List_Member__c>();
	       
	        Target_List_Member__c targetListMember1 = new Target_List_Member__c();
	            targetListMember1.Target_List__c = targetList[0].id;
	            targetListMember1.Target_List_Member_Key__c = '123';
	            targetListMember1.GPSContact__c = listContacts[0].id;
	            targetListMember1.Eligible_for_email__c = true;
	                   
	         targetListMember.Add(targetListMember1);

	         Target_List_Member__c targetListMember2 = new Target_List_Member__c();
	            targetListMember2.Target_List__c = targetList[1].id;
	            targetListMember2.Target_List_Member_Key__c = '123';
	            targetListMember2.GPSContact__c = listContacts[0].id;
	            targetListMember2.Eligible_for_email__c = true;
	        targetListMember.Add(targetListMember2);
	        
	        Target_List_Member__c targetListMember3 = new Target_List_Member__c();
	            targetListMember3.Target_List__c = targetList[1].id;
	            targetListMember3.Target_List_Member_Key__c = '123';
	            targetListMember3.GPSContact__c = listContacts[0].id;
	            targetListMember3.Eligible_for_email__c = true;
	        
	        targetListMember.Add(targetListMember3);
	        
	         Target_List_Member__c targetListMember4 = new Target_List_Member__c();
	            targetListMember4.Target_List__c = targetList[2].id;
	            targetListMember4.Target_List_Member_Key__c = '123';
	            targetListMember4.GPSContact__c = listContacts[0].id;
	            targetListMember4.Eligible_for_email__c = true;
	        
	        targetListMember.Add(targetListMember4);
	        
			insert targetListMember;
             
            List<Target_List_Member__c>  lstTLM = [select Eligible_for_email__c From Target_List_Member__c t where Target_List__c = :targetList[1].id];
            system.assertEquals(2,lstTLM.size());
            //Check Eligible_for_email__c  before update. It should be true
            for(Target_List_Member__c tlm :lstTLM ){
                system.assertEquals(true,tlm.Eligible_for_email__c);
            }
            
            //Update TargetList
             Target_List__c tList = [select id,Sends_Email__c from Target_List__c where id = :targetList[1].id];
            if(tList != null)
             {
                 tlist.Sends_Email__c = 'No';
                 update tlist;
             }
            
           //Retrieve  Target_List_Member__c after Target list is updated
            lstTLM = [select Eligible_for_email__c From Target_List_Member__c t where Target_List__c = :targetList[1].id];
            system.assertEquals(2,lstTLM.size());
            //Check that the Eligible_for_email__c is set to false
            for(Target_List_Member__c tlm :lstTLM ){
                system.assertEquals(false,tlm.Eligible_for_email__c);
            }
            
            //Assert that the other Target List Members are unchanged
             lstTLM = [select Eligible_for_email__c From Target_List_Member__c t where Target_List__c = :targetList[2].id];
            system.assertEquals(1,lstTLM.size());
            //Check that the Eligible_for_email__c is set to true
            for(Target_List_Member__c tlm :lstTLM ){
                system.assertEquals(true,tlm.Eligible_for_email__c);
            }
        }
}
static testmethod void testUpdateAllTargetMember(){
	 testUser = getTempUser();// DataUtil.getTestUserWithRole();
	 User testuser1 =  CM_TestClassUtilities.getAdminUser()[0];
        System.runas(testUser){
         	TestClassUtilities.setAllTriggerOn();
        	createData();
        	targetListMember = new List<Target_List_Member__c>();
	       
	        Target_List_Member__c targetListMember1 = new Target_List_Member__c();
	            targetListMember1.Target_List__c = targetList[1].id;
	            targetListMember1.Target_List_Member_Key__c = '123';
	            targetListMember1.GPSContact__c = listContacts[0].id;
	            targetListMember1.Contact_has_been_called__c = true;
	            targetListMember1.Eligible_for_email__c = true;
	                   
	         targetListMember.Add(targetListMember1);
			 
	         Target_List_Member__c targetListMember2 = new Target_List_Member__c();
	            targetListMember2.Target_List__c = targetList[2].id;
	            targetListMember2.Target_List_Member_Key__c = '123';
	            targetListMember2.GPSContact__c = listContacts[0].id;
	             targetListMember2.Contact_has_been_called__c = true;
	            targetListMember2.Eligible_for_email__c = true;
	            targetListMember2.User_Who_Called_the_Contact__c = testuser1.Id;
	        targetListMember.Add(targetListMember2);
	        
        	insert targetListMember;
        	
        	iiCampaign__c  iicamlist = [select id,Synch_Target_List_Member_Statuses__c from iiCampaign__c where id = :campList[1].id];
            if(iicamlist != null)
             {
                 iicamlist.Synch_Target_List_Member_Statuses__c = true;
                 update iicamlist;
             }
             List<Target_List_Member__c>  lstTLM = [select Contact_has_been_called__c From Target_List_Member__c t where Target_List__c = :targetList[1].id];
             system.assertEquals(1,lstTLM.size());
             //Check that the Eligible_for_email__c is set to true
             for(Target_List_Member__c tlm :lstTLM ){
                system.assertEquals(true,tlm.Contact_has_been_called__c);
             }
             system.debug('iicampaingbefire update'+campList[2]);
             iiCampaign__c  iicamlist1 = [select id,Synch_Target_List_Member_Statuses__c from iiCampaign__c where id = :campList[2].id];
            if(iicamlist1 != null)
             {
                 iicamlist1.Synch_Target_List_Member_Statuses__c = false;
                 update iicamlist1;
             }
           
             system.debug('iicampaing after update'+campList[2]);
             List<Target_List_Member__c>  lstTLM1 = [select Contact_has_been_called__c, User_Who_Called_the_Contact__c, Target_List__r.User__c From Target_List_Member__c t where Target_List__c = :targetList[2].id];
             
             system.assertEquals(1,lstTLM1.size());
             //Check that the Eligible_for_email__c is set to true
             for(Target_List_Member__c tlm1 :lstTLM1 ){
             	system.debug('iicampaing after update111'+tlm1.User_Who_Called_the_Contact__c);
                system.debug('iicampaing after update111'+targetList[2].User__c);
                if(tlm1.User_Who_Called_the_Contact__c !=targetList[2].User__c){
                	system.debug('hello');
                }
                system.assertEquals(false,tlm1.Contact_has_been_called__c);
             }
             
        }
} 
        
    static void createData()
        {
        //TestClassUtilities.setAllTriggerOn();
        T1C_CustomSettingsManager.createChatterSetting();
        idset = new Set<String>();
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
        GPSAccount__c acc1 = new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'TN-007';
       // acc1.Client_Type__c = 'Internal';
        listAccounts.add(acc1);
        
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 'TN-008';
        //acc2.Client_Type__c = 'Internal';
        listAccounts.add(acc2);
        
        insert listAccounts;
        
        //Create test contacts
        GPSContact__c con;
        listContacts = new List<GPSContact__c>();
        Integer cnt = 0;
        for(GPSAccount__c acc : listAccounts){
            con = new GPSContact__c();
            con = Common_ContactUtil.createContact(acc.id, cnt++); 
            listContacts.add(con);
        }
        
        insert listContacts;
            
            campList = new List<iiCampaign__c>();
         
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Synch_Target_List_Member_Statuses__c = true;
         camp.Users_can_set_if_contacts_get_email__c =true;
         campList.add(camp);
         
         
         iiCampaign__c camp1 = new iiCampaign__c();
         camp1.Campaign_Name__c  ='TEST CAMPAINGS';
         camp1.Start_Date__c = Date.today();
         camp1.Active_Flag__c = true;
         camp1.Synch_Target_List_Member_Statuses__c = false;
         camp1.Users_can_set_if_contacts_get_email__c =true;
         campList.add(camp1);
         
         iiCampaign__c camp2 = new iiCampaign__c();
         camp2.Campaign_Name__c  ='TEST CAMPAINGS';
         camp2.Start_Date__c = Date.today();
         camp2.Active_Flag__c = true;
         camp2.Synch_Target_List_Member_Statuses__c = true;
         camp2.Users_can_set_if_contacts_get_email__c =true;
         campList.add(camp2);
         
         database.insert(campList);
         
         targetList = new List<Target_List__c>();
        
         
        Target_List__c targetList1 = new Target_List__c();
        targetList1.User__c = testUser.Id;
        targetList1.iiCampaign__c= campList[0].id;
        targetList1.Authorized__c = true;
        targetList1.Sends_Email__c = 'No';
        
        targetList.add(targetList1);
        
        targetList1 = new Target_List__c();
        targetList1.User__c = testUser.Id;
        targetList1.iiCampaign__c= campList[1].id;
        targetList1.Authorized__c = true;
        targetList1.Sends_Email__c = 'Yes';        
        targetList.add(targetList1);
        
        Target_List__c targetList2 = new Target_List__c();
        
        targetList2.User__c = testUser.Id;
        targetList2.iiCampaign__c= campList[2].id;
        targetList2.Authorized__c = true;        
        targetList.add(targetList2);
        
        insert targetList;
        
        idset.add(targetList[0].id);
        idset.add(targetList[1].id);
         
        }
}