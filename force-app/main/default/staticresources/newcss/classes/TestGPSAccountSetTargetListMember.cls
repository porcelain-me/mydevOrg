/***********************************************************************************
Name        : TestAccountSetTargetListMember 
Author      : Appirio Offshore (Chetan Garg)
Date        : March 31, 2010
Description : Test Class for Trigger AccountSetTargetListMember 
Related PR  : PR-04225
01/09/2013 : Urminder : move instance of new contact to common_contactUtil.
************************************************************************************/
@isTest
private class TestGPSAccountSetTargetListMember {
	static User thisUser;
	static{ 
        // temp user
       //usr =  CM_TestClassUtilities.getTempUser();
       thisUser = getTempUser();
       }
       
     static User getTempUser(){
    
        Profile p = [select id from Profile where Name = 'System Administrator'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 // T1C_User_Short_ID__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true );
        return u;
     }  
    static testMethod void testTrigger() {
         //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         system.runAs(thisUser) {
            TestClassUtilities.setAllTriggerOn();
           //Create test accounts
            List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
            
            GPSAccount__c acc1 = new GPSAccount__c();
            acc1.name = 'acc1';
            acc1.Trading_Name_ID__c = 'TN-007';
            //acc1.Client_Type__c = 'Internal';
            listAccounts.add(acc1);
            
            GPSAccount__c acc2 = new GPSAccount__c();
            acc2.name = 'acc2';
            acc2.Trading_Name_ID__c = 'TN-008';
            //acc2.Client_Type__c = 'Internal';
            listAccounts.add(acc2);
            
            insert listAccounts;
            for(GPSAccount__c acc : listAccounts){
                  system.assertNotEquals(acc.id ,null);
            }
            
            GPSContact__c con;
            List<GPSContact__c> listContacts = new List<GPSContact__c>();
            Integer cnt = 0;
            for(GPSAccount__c acc : listAccounts){
                for(Integer indx = 0; indx < 10; indx++){
                    con = new GPSContact__c(); 
                    con = Common_ContactUtil.createContact(acc.Id, cnt++);
                    listContacts.add(con);
                }
            }
            
            insert listContacts; 
            
            iiCampaign__c camp = new iiCampaign__c();
            camp.Campaign_Name__c  ='TEST CAMPAINGS';
            camp.Start_Date__c = Date.today();
            camp.Active_Flag__c = true;
            insert camp;
            
            Target_List__c tList  = new Target_List__c();
            tList.iiCampaign__c = camp.id;
            tList.User__c = system.Userinfo.getUserId();
            
            insert tList;
            
            List<Target_List_Member__c> mmeberlist = new List<Target_List_Member__c>();
            Target_List_Member__c member;
            for(GPSContact__c con1 : listContacts){
                    member = new Target_List_Member__c();
                    member.GPSContact__c = con1.id;
                    member.Target_List__c = tList.id;
                    mmeberlist.add(member);
            }
             
             insert mmeberlist;
             
            // TEST 
            //If Account_does_not_vote_in_iiCampaigns__c is set to true for GPSAccount__c 
            // then Removed_Reason__c for All Target List member of that account should be "This Firm does not vote for II" 
            for(GPSAccount__c acc : listAccounts){
                acc.Account_does_not_vote_in_iiCampaigns__c = true;
            }
            update  listAccounts;
            
           for(Target_List_Member__c tMember : [Select Removed_Reason__c, id  
                                                FROM  Target_List_Member__c 
                                                where Target_List__c =: tList.id ]){
            system.assertEquals('This Firm does not vote for II', tMember.Removed_Reason__c);
           } 
        }
    }
}