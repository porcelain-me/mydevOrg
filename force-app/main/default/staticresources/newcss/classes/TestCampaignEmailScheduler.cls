/**

Test class for scheduler CampaignEmailScheduler
Author :Vipin Makhija
Date :21/04/2015

**/
@isTest
public  class TestCampaignEmailScheduler {  

	    static User dUser;
	    //static User testUser2; 
	    static Target_List__c targetList;
	    static Target_List__c targetList2;
	    static Target_List__c targetList3;
	    static List<Target_List_Member__c> members;
	    static List<Candidate_Information__c> listConInfo;
	    static List<iiCampaign__c> campaings = new List<iiCampaign__c>();

	    
     private static User getTempUser(){
     	
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];
       // User tempUser  = [select id from User where ProfileId = : p.Id AND UserRoleId = : r.id limit 1];
        User tempUser = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 // T1C_User_Short_ID__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true );

        return tempUser;        
   }	    

	 public static testMethod void testCampaignEmailScheduler(){
	
			dUser = getTempUser();
	            

	        
	        system.runAs(dUser){

		        TestClassUtilities.setAllTriggerOn();
		        T1C_CustomSettingsManager.createChatterSetting();
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
		        
		        GPSAccount__c acc3 = new GPSAccount__c();
		        acc3.name = 'acc3';
		        acc3.Trading_Name_ID__c = 'TN-009';
		        // acc3.Client_Type__c = 'Internal';
		        listAccounts.add(acc3);
		        
		        GPSAccount__c acc4 = new GPSAccount__c();
		        acc4.name = 'acc4';
		        acc4.Trading_Name_ID__c = 'TN-010';
		        //acc4.Client_Type__c = 'Internal';
		        listAccounts.add(acc4);
		        
		        insert listAccounts;
		        
		        //Create test contacts
		        GPSContact__c con;
		        List<GPSContact__c> listContacts = new List<GPSContact__c>();
		        Integer indx = 0;
		        for(GPSAccount__c acc : listAccounts){
		            con = new GPSContact__c();
		            con = Common_ContactUtil.createContact(acc.id, indx); 
		            con.Language_Preference__c ='English';
		            listContacts.add(con);
		            indx++;
		        }
		        
		        insert listContacts; 
		               
		         iiCampaign__c camp = new iiCampaign__c();
		         camp.Campaign_Name__c  ='TEST CAMPAINGS';
		         camp.Start_Date__c = Date.today();
		         camp.Active_Flag__c = true;
		         campaings.add(camp);
		         
		         iiCampaign__c camp2 = new iiCampaign__c();
		         camp2.Campaign_Name__c  ='TEST CAMPAINGS2';
		         camp2.Start_Date__c = Date.today();
		         camp2.Active_Flag__c = true;
		         campaings.add(camp2);
		          
		         insert campaings;
		        
		        
		        List<Target_List__c> targetLists = new List<Target_List__c>();
		        targetList = new Target_List__c();
		        targetList.User__c = dUser.Id;
		        targetList.Authorized__c = true;
		        targetList.iiCampaign__c = camp.id;
		        targetLists.add(targetList);
		        
		        targetList2 =  new Target_List__c();
		        targetList2.User__c = dUser.Id;
		        targetList2.Authorized__c = true;
		        targetList2.iiCampaign__c = camp.id;
		        targetLists.add(targetList2);
		        
		        targetList3 =  new Target_List__c();
		        targetList3.User__c = dUser.Id;
		        targetList3.Authorized__c = true;
		        targetList3.iiCampaign__c =  campaings[1].Id;
		        targetLists.add(targetList3);
		        
		        
		        Target_List__c otherOwnerTargetList = new Target_List__c();
		        otherOwnerTargetList.User__c = dUser.Id;
		        otherOwnerTargetList.Authorized__c = true;
		        otherOwnerTargetList.iiCampaign__c = camp.id;
		        targetLists.add(otherOwnerTargetList);
		    
		        insert targetLists;
		        system.debug('__________USER_____'+dUser.Id);
		        //Create test Candidate Information
		        listConInfo = new List<Candidate_Information__c>();
		        
		        Candidate_Information__c candInfo = new Candidate_Information__c();
		        candInfo.Candidate_Name__c = 'Candidate1';
		        candinfo.iiCampaign__c = camp.Id;
		        listConInfo.add(candInfo);
		        
		        candInfo = new Candidate_Information__c();
		        candInfo.Candidate_Name__c = 'Candidate2';
		        candinfo.iiCampaign__c = camp2.Id;
		        listConInfo.add(candInfo);
		        
		        insert listConInfo;
		        
		        for(Candidate_Information__c cr : listConInfo){
		            System.assert(cr.id != null);
		        }
		        
		        //Create test Voter Recommendation
		        List<Voter_Recommendation__c> listVoterRecom  = new List<Voter_Recommendation__c>();
		        indx = 0;
		        for (Candidate_Information__c cand : listConInfo)
		        {
		            Voter_Recommendation__c voterRecomm  = new Voter_Recommendation__c();
		            voterRecomm.Candidate_Information__c = cand.Id;
		            voterRecomm.GPSContact__c = listContacts[0].id;
		            //03/15/2011  Urminder : added Unique_VR_Key__c unique key to voter Recommendation 
		            voterRecomm.Unique_VR_Key__c = 'testUnique' + indx + Datetime.now();
		            listVoterRecom.add(voterRecomm);
		            indx++;
		        }
		        insert listVoterRecom;
		        
		        
		        members = new List<Target_List_Member__c>(); 
		        Target_List_Member__c targetListMember;
		        integer index = 0;
		        for(GPSContact__c cont : listContacts) {
		            targetListMember = new Target_List_Member__c();
		            if(index <= 1)
		                targetListMember.Target_List__c = targetList.id;
		            else
		                targetListMember.Target_List__c = targetList2.id;
		            targetListMember.Target_List_Member_Key__c = '123';
		            targetListMember.GPSContact__c = cont.Id;
		            //targetListMember.Removed_Reason__c = 'Email Only';
		            targetListMember.Viewed_by_User__c = true;
		            members.add(targetListMember);
		        }
		        
		        for(GPSContact__c cont : listContacts) {
		            targetListMember = new Target_List_Member__c();
		            targetListMember.Target_List__c = otherOwnerTargetList.id;
		            targetListMember.Target_List_Member_Key__c = '123';
		            targetListMember.GPSContact__c = cont.Id;
		            targetListMember.User_who_left_Voicemail_del__c = dUser.id;
		            targetListMember.user_who_confirmed_ballot_received__c = dUser.id;
		            targetListMember.User_Who_Called_the_Contact__c = dUser.id;
		            targetListMember.User_who_confirmed_Vote_Last__c = duser.Id;
		            //targetListMember.Removed_Reason__c = 'Email Only';
		            members.add(targetListMember);
		        }
		        
		        insert members;
		        
		        Test.StartTest();
		 
		 		Datetime sysTime = System.now();
		        
		        sysTime = sysTime.addSeconds(900);
		        String schedule_Time = sysTime.second()+' '+ sysTime.minute() + ' ' + sysTime.hour() + 
		        ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
		               
				try{
				     System.schedule('testSchedule',null, new CampaignEmailScheduler());
		   		}
		        catch(exception e){
				        
		        } 				
				System.schedule('testSchedule',schedule_Time, new CampaignEmailScheduler()); 
				
				Test.stopTest(); 
			
	     }
	}
}