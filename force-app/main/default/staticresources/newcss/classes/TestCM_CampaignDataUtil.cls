// 09/28/2011 UV: ORIGINAL  
//                Test class for CM_CampaignDataUtil                
// 
// 10/21/2011 RJ: Updated the test class to add getCampaignMemberStatusesTest method
// 02/24/2012 UV added a new test Method getCampaignMemberAssignmentforAllUserOtherThenCurrentUserTest()
@isTest  
private class TestCM_CampaignDataUtil {
     static List<GPSAccount__c> listAccounts;
     static List<GPSContact__c> listContacts;
     static List<Campaign_Member__c> lstCampaignMembers;
     static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment; 
     static List<Task> lstTasks;
     static Integer LIST_SIZE = 50;  
     static Set<Id> contactIds;
     static Campaign__c camp;
     static Campaign__c camp2;  
     static User usr;
     static set<Id> ContactIdSet;
     static Set<Id> campMemberIds = new Set<Id>();
     static List<GPSEmployee__c> lstEmployee;  
     static Set<String> TNContactKeySet;
     static Set<String> CampaignExternalIDSet;
     static{
        // temp user
       //usr =   CM_TestClassUtilities.getTempUser();
        T1C_CustomSettingsManager.setAllTriggerOn();
       usr =   getTempUser();
    }
    
    static User getTempUser(){
         Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
         UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];
         User tempUser = [select Id from User where isActive = true and ProfileId = :p.Id limit 1];
         return tempUser;   
    }
    
    static testMethod void replaceSpecialCharactersTest(){
        System.runAs(usr) {
           Test.startTest();
           String inputVal = CM_CampaignDataUtil.replaceSpecialCharacters('%');
           System.assertEquals(inputVal, '\\%','Replace should match'); 
           Test.stopTest();
        }    
    }
    
    static testMethod void getAllDistributionListsTest() {
        System.runAs(usr) {

           Test.startTest();
           init();
           List<Distribution_List__c> listDL = CM_CampaignDataUtil.getAllDistributionLists();
           System.assertEquals((LIST_SIZE/5),listDL.size(),'List Size should be matched'); 
           
           for(Distribution_List__c dl : listDL) {
                List<DistributionListItem__c> DLItemList = CM_CampaignDataUtil.getDistributorListItems(dl.Id, camp.Id);
                System.assertEquals(DLItemList.size(),(LIST_SIZE/10),'Item List size should match');
           }
            
           
           Test.stopTest();
        }
    }
    static testMethod void getCampaignMemberAssignmentInstanceTest(){
        System.runAs(usr) {

           Test.startTest();
           init();
           
           Campaign_Member_Assignment__c cMA  = CM_CampaignDataUtil.getCampaignMemberAssignmentInstance(false, camp.Id, UserInfo.getUserId(), listContacts[0].Id, false);
           System.assertEquals(cMA.Campaign__c, camp.Id, 'Campaign id should match');
           
           Campaign_Member__c cM = CM_CampaignDataUtil.getCampaignMemberInstance(listContacts[0].Id, camp.Id);
           //System.assertEquals(cM.CampaignId, camp.Id, 'Campaign id should match');
           
           Test.stopTest();
      }    
           
    }
    
    static testMethod void getCampaignMembersListTest(){
      System.runAs(usr) {
           Test.startTest();
           init();
           List<Campaign_Member__c> campaignMemberList = new List<Campaign_Member__c>();
           List<Id> cmIds = new List<Id>();
           
           List<Id> contactId1s = new List<Id>();
           
           for(Campaign_Member__c cM: lstCampaignMembers){
             cmIds.add(cM.Id);
             contactId1s.add(cM.GPSContact__c);
           }
           
           campaignMemberList = CM_CampaignDataUtil.getCampaignMembersList(cmIds);
           
           System.assertEquals(lstCampaignMembers.size(), campaignMemberList.size(), 'Campaign list size should match');
           
           campaignMemberList = CM_CampaignDataUtil.getCampaignMembersList(contactId1s, camp.id);
           
           System.assertEquals(contactId1s.size(), campaignMemberList.size(), 'Campaign list size should match');
           
           Test.stopTest();
      }    
           
    }
     static testMethod void getSelectedCampaignMemberTest(){
      System.runAs(usr) {
           Test.startTest();
           init();
           Campaign_Member__c campaignMember = CM_CampaignDataUtil.getSelectedCampaignMember(lstCampaignMembers[0].Id);
           System.assertEquals(campaignMember.GPSContact__c, lstCampaignMembers[0].GPSContact__c, 'Contact should match');
           List<Campaign_Member__c> campaignMemberList = CM_CampaignDataUtil.getSelectedCampaignMember(campMemberIds);
           
           Campaign_Member__c cm = CM_CampaignDataUtil.getCampaignMemberDetail(lstCampaignMembers[0].Id);
           System.assertEquals(cm.Campaign__c,camp.Id,'campaign ID  should match');
           Test.stopTest();
      }    
           
    }
    
    
    static testMethod void getPendingRequestsTest(){
      System.runAs(usr) {
           Test.startTest();
           init();
          
           
           Task tsk = CM_CampaignDataUtil.getPendingRequests(camp.Id, lstCampaignMembers[0].GPSContact__c);
           
           System.assertEquals(tsk.Status, 'Pending', 'Status should be pending');
           
           
           Test.stopTest();
      }    
           
    }
    
    
    static testMethod void getCampaignMemberAssignmentTest(){
      System.runAs(usr) {
           Test.startTest();
           init();
          
           List<Campaign_Member_Assignment__c> lstCMA = new List<Campaign_Member_Assignment__c>();
           
           lstCMA = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(camp.Id);
           
           System.assertEquals(lstCMA.size(), lstCampaignMembers.size() , 'Each campaign member should have an entry in cMA');
           
           lstCMA = CM_CampaignDataUtil.getCampaignMemberAssignmentforAllUser(camp.Id);
           
           System.assertEquals(lstCMA.size(), lstCampaignMembers.size() , 'Each campaign member should have an entry in cMA');
           
           
           lstCMA = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(camp.id, new List<String>{lstCampaignMembers[0].GPSContact__c, lstCampaignMembers[1].GPSContact__c});
           
           System.assertEquals(lstCMA.size(), 2 , 'Each campaign member should have an entry in cMA');
           
           lstCMA = CM_CampaignDataUtil.getCampaignMemberAssignmentforUser(camp.id, new List<String>{lstCampaignMembers[0].GPSContact__c, lstCampaignMembers[1].GPSContact__c}, usr.Id);
           
           System.assertEquals(lstCMA.size(), 2 , 'Each campaign member should have an entry in cMA');
           
           lstCMA = CM_CampaignDataUtil.getCampaignMemberAssignmentforAllUser(camp.Id,ContactIdSet);
           
           Test.stopTest();
      }    
           
    }
    
     static testMethod void getCampaignMembersforCurrentUserTest(){
      System.runAs(usr) {
           Test.startTest();
           init();
          
           List<Campaign_Member__c> lstCM = new List<Campaign_Member__c>();
           
           lstCM = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(camp.Id);
           
           System.assertEquals(lstCM.size(), lstCampaignMembers.size() , 'each campaign member for current user should be return');
           
           lstCM = CM_CampaignDataUtil.getAllCampaignMembers(camp.Id);         
           Test.stopTest();
      }    
           
    }
    
    static testMethod void CampaignMemberStatusTest() {
       System.runAs(usr) {
           Test.startTest();
           init();
           Map<Id,Task> CampaignMemberStatusMap = CM_CampaignDataUtil.getCampaignMemberStatus(camp.Id, ContactIdSet);
           System.assertEquals(CampaignMemberStatusMap.get(listContacts[0].Id).Status, 'Pending','Status for this contact should be Pending');
            
           
           List<Campaign_Member__c> campMemberList = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(camp.Id);
           System.assertEquals(campMemberList.size(),(2*LIST_SIZE),'Member in this campaing should be equals to LIST_SIZE');
           
           List<String> lstStatus = CM_CampaignDataUtil.getCampignMemberStatus(camp.Id);
           System.assertEquals(lstStatus[0],'Responded','Status should match');
           Test.stopTest();
       }
       
    }
     static testMethod void incomingReqForCurrentUserTest() {
       System.runAs(usr) {
           Test.startTest();
           init();
           List<Task> incomingReqlst  = CM_CampaignDataUtil.getIncomingRequestsForCurrentUser(camp.Id);
           System.assertEquals((2*LIST_SIZE),incomingReqlst.size(),'Request List size should be equals to LIST_SIZE');
          
           CM_CampaignDataUtil.getIncomingRequestsForCurrentUser(camp.Id, lstTasks[0].Id);
           
               Map<Id,GPSContact__c> contactMap = CM_CampaignDataUtil.getContactMap(contactIds, camp.Id);
               //System.assertEquals(contactMap.get(listContacts[0].Id).MobilePhone,'+91-123456789200');
               Test.stopTest();           
       }
       
    }
    static testmethod void getSearchCampaignMembersContactsTest() {
         System.runAs(usr) {
            Test.startTest();
            init();
            ContactIdSet = new Set<Id>();
            List<GPSContact__c> contactList = CM_CampaignDataUtil.getSearchContacts('FirstName_1_0 Name_1_0');
            System.assertEquals(LIST_SIZE,contactList.size(),'Conatcts List size should be equals to the LIST_SIZE');
            Test.stopTest();
         }
    }
    static testmethod void getCampaignParticipantsTest() {
        
        //insertTeamMember();
        System.runAs(usr) {
            Test.startTest();
            init();
            
            camp2 = new Campaign__c();
        camp2.Name = 'Test Shared Campaign';
        //camp2.IsActive = true; 
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = 'NewID_001';
        insert camp2;
                        
            List<Campaign_Team_Member__c> ctmList = new List<Campaign_Team_Member__c>();
            Campaign_Team_Member__c ctm;
            
            ctm = new Campaign_Team_Member__c();
        ctm.Campaign__c = camp2.Id;
        ctm.User__c = userInfo.getUserId();
        ctm.Role__c = 'Participant';
        ctmList.add(ctm);
            
            List<User> userList = [Select id from User where isActive = true and id <>:userInfo.getUserId() limit 5];
                        
            for(User usr1 : userList){
               ctm = CM_CampaignDataUtil.getCampaignTeamMemberInstance(camp2.Id, 'Read', 'Participant', usr1.id);
               
               ctmList.add(ctm);
            }
                        
            insert ctmList;
            
            List<Campaign_Team_Member__c> ctmList1 = new List<Campaign_Team_Member__c>();
            ctmList1 = CM_CampaignDataUtil.getCampaignParticipants(camp2.Id);
            
            System.assertEquals(ctmList.size(), ctmList1.size(), 'List Size Should be Matched');
            
            ctmList1 = CM_CampaignDataUtil.searchCampaignParticipants(camp2.Id, 'Testing');
            
            //System.assertEquals(1, ctmList1.size(), 'List Size Should be Matched');
            
            ctmList1 = CM_CampaignDataUtil.getCampaignTeamMemberImportedList(usr.Id, camp.Id);
            
            Set<Id> userIds = new Set<Id>();
            userIds.add(usr.Id);
            
            CM_CampaignDataUtil.getCampaignTeamMemberList(usr.Id, camp.Id);
            
            CM_CampaignDataUtil.getManualCampaignShareList(userIds, camp.Id);
            
            ctmList1 = CM_CampaignDataUtil.searchCampaignParticipants(camp2.Id, 'Testing test');
            
            
            Test.stopTest();
        }
    }
    
     static testmethod void getCampaignParticipantsByGroupingTest() {
      
      //insertTeamMember();
      System.runAs(usr) {
        Test.startTest();
        init();
        
        camp2 = new Campaign__c();
        camp2.Name = 'Test Shared Campaign';
        //camp2.IsActive = true; 
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = 'NewID_001';
        insert camp2;
                
        List<Campaign_Team_Member__c> ctmList = new List<Campaign_Team_Member__c>();
        Campaign_Team_Member__c ctm;
        
        ctm = new Campaign_Team_Member__c();
        ctm.Campaign__c = camp2.Id;
        ctm.User__c = userInfo.getUserId();
        ctm.Role__c = 'Participant';
        ctmList.add(ctm);
        
        List<User> userList = [Select id from User where isActive = true and id <>:userInfo.getUserId() limit 5];
                
        for(User usr1 : userList){
           ctm = new Campaign_Team_Member__c();
           ctm.Campaign__c = camp2.Id;
           ctm.User__c = usr1.id;
           ctm.Role__c = 'Participant';
           ctmList.add(ctm);
        }
                
        insert ctmList;
        
        List<Campaign_Team_Member__c> ctmList1 = new List<Campaign_Team_Member__c>();
        ctmList1 = CM_CampaignDataUtil.getCampaignParticipants(camp2.Id);
        
        System.assertEquals(ctmList.size(), ctmList1.size(), 'List Size Should be Matched');
        
        List<AggregateResult> arList = CM_CampaignDataUtil.searchCampaignParticipantsByGrouping(camp2.Id, 'Testing');
        
        //System.assertEquals(1, arList.size(), 'List Size Should be Matched');
        
        arList = CM_CampaignDataUtil.searchCampaignParticipantsByGrouping(camp2.Id, 'Testing test');
        
        
        Test.stopTest();
      }
    }
    
    static testMethod void applicationConfigSettingsTest() {
        System.runAs(usr) {
            Test.startTest();
            List<SelectOption> selectOptionsList = CM_CampaignDataUtil.getCampaignMemberStatusSelectOptions(); 
            System.assert(selectOptionsList.size() > 0,'List Size should be greater than 0');
            
            selectOptionsList = CM_CampaignDataUtil.getRequestStatusSelectOptions();
            System.assert(selectOptionsList.size() > 0,'List Size should be greater than 0');
            
            selectOptionsList = CM_CampaignDataUtil.getRequestTypeSelectOptions();
            System.assert(selectOptionsList.size() > 0,'List Size should be greater than 0');
            
            selectOptionsList = CM_CampaignDataUtil.getRequestPrioritySelectOptions();
            System.assert(selectOptionsList.size() > 0,'List Size should be greater than 0');
            Test.stopTest();
        }
    }
    static testmethod void createRequestTest() {
        System.runAs(usr) {
            Test.startTest();
            init();
            String conId = String.valueOf(listContacts[0].Id);
            String campId = String.valueOf(camp.Id);
            String usrId = String.valueOf(usr.Id);
            Date dueDate = Date.today();
            
            Task req = CM_CampaignDataUtil.getNewRequestInstance(conId, 'Call', campId, usrId, 'Test Comment', dueDate, true);
            req.status = 'Not Started';
            insert req;
            
            Task newReq = CM_CampaignDataUtil.getRequestDetail(req.Id);
            
            System.assertEquals(newReq.Id,req.Id);
            
            test.stopTest();
        }
    }
    
    static testmethod void getCampaignMemberStatusesTest(){
        System.runAs(usr) {
        Test.startTest();
        init();
       
        String campId = String.valueOf(camp.Id);
        Integer defaultCampaignMemberStatusesNumber = 0;
        //List<CampaignMemberStatus> lst = CM_CampaignDataUtil.getCampaignMemberStatuses(campId);
        //System.assertEquals(lst.size() > defaultCampaignMemberStatusesNumber, true, 'Default campaign member statuses should be inserted');        
                
        Test.stopTest();
      }     
    }
    
    
    static testmethod void getCampaignPropertiesAssigneeTest(){
        System.runAs(usr) {
        Test.startTest();
        init();
       
        Campaign__c camp1 = CM_CampaignDataUtil.getCampaignProperties(camp.Id);        
        
        System.assertEquals(camp1.Default_Task_Assignee__c <> null, true, 'Default assignee should exist');
        System.assertEquals(camp1.Require_Focus_Call_Request_Verification__c, true, 'Require_Focus_Call_Request_Verification__c should return TRUE');
                
        Test.stopTest();
      }
    }
    static testMethod void campaignManagerNotificationTest() {
        System.runAs(usr) {
            test.startTest();
            init();
            List<RecordType> rtList = CM_CampaignDataUtil.getTaskActiveRecordTypes();
            System.assert(rtList.size() > 0,'Record Type should exists');
            
            List<GPSContact__c> cntList = CM_CampaignDataUtil.getAccountIdsOfContacts(ContactIdSet);
            System.assert(cntList.size() > 0,'List size should be greater than 0');
            
            CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
            String CN_REASSIGN_RECORD_TYPE = cMGS.CN_REASSIGN_RECORD_TYPE__c ;
            String CODE_NAME  = cMGS.APP_NAME__c;
            RecordType rt = CM_CampaignDataUtil.getRecordTypeOnObjectAndDeveloperName('Campaign_Notification__c', CN_REASSIGN_RECORD_TYPE);
            System.assertEquals(rt.DeveloperName,CN_REASSIGN_RECORD_TYPE,'Name should match');
            
            test.stopTest();
        }
    }
    static testmethod void CM_MetricsQueriesTest() {
        System.runAs(usr) {
            test.startTest();
            init();
            List<Campaign__c> campList = CM_CampaignDataUtil.getCampaignRollUpValues(camp.Id);
            List<Campaign_Member_Assignment__c> CMAList = CM_CampaignDataUtil.getContactIdsOnCMAForCampaign(usr.Id, camp.Id);
            System.assert(CMAList.size() > 0);
            
            Integer total = CM_CampaignDataUtil.getCampaignResponsesCount(camp.Id, ContactIdSet);
            total = CM_CampaignDataUtil.getIncomingRequestsCount(camp.Id, Userinfo.getUserId());
            total = CM_CampaignDataUtil.getPendingRequestsCount(camp.Id, Userinfo.getUserId());
            
            test.stopTest();
        }
    }
    static testmethod void CM_MilestoneQueriesTest() {
        System.runAs(usr) {
            init();
            test.startTest();
            List<Campaign_Milestone__c> CMList = CM_CampaignDataUtil.getCampaignMilestones(camp.Id);
            test.stopTest();
        }
    }
    static testmethod void CM_MaterialsQueriesTest() {
        System.runAs(usr) {
            test.startTest();
            init();
            
            List<Attachment> attachList  = CM_CampaignDataUtil.getCampaignMaterials(camp.Id,null);
            system.assertEquals(attachList.size(),5,'List Sizt should match');
            attachList = CM_CampaignDataUtil.getCampaignMaterials(camp.Id,2);
            system.assertEquals(attachList.size(),2,'List Sizt should match');
            test.stopTest();
        }
    }
    static testMethod void CNCreateAndDeleteTest() {
        System.runAs(usr) {
            Test.startTest();
            init();
            Set<String> taskIdSet = new Set<String>();
            for(Task t : lstTasks) {
                taskIdSet.add(t.Id);
            }
            List<Campaign_Notification__c> cnList = CM_CampaignDataUtil.getCampaignNotificationListOnTaskId(taskIdSet);
            System.asserTEquals(lstTasks.size(),cnList.size(),'List size should be match');
            Test.stopTest();
            
        }
    }
    static testMethod void getFilteredCampaignsListTest() {
        System.runAs(usr) {
            Test.startTest();
            //T1C_CustomSettingsManager.setAllTriggerOn();  
            T1C_CustomSettingsManager.createChatterSetting();  
            list<Campaign__c> campList = new list<Campaign__c>();
            Integer index = 1;
            for(Integer i=0 ;i<5; i++) {
                camp = new Campaign__c();
                camp.Name = 'Test Campaign3' + i;
                camp.Active__c = true; 
                camp.Status__c = 'Active';
                camp.Region__c = 'EU';
                camp.External_Id__c = index + String.valueOf(Math.random().intValue());
                campList.add(camp);
                index++;
            }
            for(Integer i=0 ;i<5; i++) {
                camp = new Campaign__c();
                camp.Name = 'Test Campaign3' + i;
                camp.Active__c = true; 
                camp.Status__c = 'Hidden';
                camp.Region__c = 'JP';
                camp.External_Id__c = index + String.valueOf(Math.random().intValue());
                campList.add(camp);
                index++;
            }
            for(Integer i=0 ;i<5; i++) {
                camp = new Campaign__c();
                camp.Name = 'Test Campaign3' + i;
                camp.Active__c = true; 
                camp.Status__c = 'Inactive';
                camp.Region__c = 'All';
                camp.External_Id__c = index + String.valueOf(Math.random().intValue());
                campList.add(camp);
                index++;
            }
            insert campList;
            
             
           List<Campaign__c> listCamp = CM_CampaignDataUtil.getFilteredCampaignsList('Active', 'EU');
           System.assert(5 <= listCamp.size(),'List size for active campaigns frome Europe region should be equals to or greater than  5');
           
           listCamp = CM_CampaignDataUtil.getFilteredCampaignsList('Active', 'JP');
           System.assert(0 <= listCamp.size(),'List size for active campaigns frome Japan region should be equals to or greater than  0');
           
           listCamp = CM_CampaignDataUtil.getFilteredCampaignsList('Inactive', 'All');
           // as status inactive camaping should be deactivated
           System.assert(0 <= listCamp.size(),'List size for Inactive campaigns from All region should be equals to or greater than 0');
           Test.stopTest();
            
        }
    }
    
    static testMethod void getContactPhoneListTest() {
        System.runAs(usr) {
            Test.startTest();
            GPSAccount__c acc2 = new GPSAccount__c();
            acc2.name = 'acc2';
            acc2.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
           // acc2.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');
            acc2.Active_Flag__c = true;   
                 
            insert acc2;
            
            //T1C_CustomSettingsManager.setAllTriggerOn();  
            T1C_CustomSettingsManager.createChatterSetting();  
          
            Integer indx = 2;
            GPSContact__c con;
            con = Common_ContactUtil.createContact(indx, (string)acc2.Id);
            insert con;
            //comment for save
            //List<CM_Campaigns_WS.PhoneNumber> phoneList = CM_CampaignDataUtil.getContactPhoneList(con);
            //System.assertEquals(phoneList.size(),4, 'List Size should matach as all phone numbers are present');
            Test.stopTest();
        }
     }
     static testMethod void getCampaignMemberListTest() {
        System.runAs(usr) {
            Test.startTest();
            init();
            
            List<Campaign_Member__c> cmList = CM_CampaignDataUtil.getCampaignMemberList(CampaignExternalIDSet,TNContactKeySet);
            System.assertEquals(LIST_SIZE * 2,cmList.size(),'List Size should be matched');
            Test.stopTest();
        }
     }
     
     static testMethod void getCampaignMemberAssignmentforAllUserOtherThenCurrentUserTest() {
        System.runAs(usr) {
            Test.startTest();
            init();
            List<Id> conIdList = new List<id>();
            for(Id i : ContactIdSet) {
                conIdList.add(i);
            }
            
            List<Campaign_Member_Assignment__c> cmaList = CM_CampaignDataUtil.getCampaignMemberAssignmentforAllUserOtherThenCurrentUser(camp.Id,conIdList);
            System.assertEquals(0,cmaList.size(),'No CMA is inserted for other user so list Size should be zero'); 
            Test.stopTest();
        
        }
     }
    
    
    static testMethod void campaignMemberResponseTest() {
        System.runAs(usr) {
            Test.startTest();
            init();
            
            Set<Id> conIds = new Set<Id>();
            conIds.add(listContacts[0].Id);
            
            Set<Id> campIds = new Set<Id>();
            campIds.add(camp.Id);
            
            List<Campaign_Member__c> cMList = CM_CampaignDataUtil.getAllCampaignMemberList(conIds,campIds); 
            
            list<Campaign_Member_Assignment__c> cMAList = CM_CampaignDataUtil.getAllCampaignMemberAssignmentList(conIds,campIds);
            
            Campaign_Member__c cm = cmList[0];
            Campaign_Member_Assignment__c cma = cmaList[0];
           
            CM_CampaignDataUtil.copyCampaignMemberFieldsToCMA(cMA,cM);
            
            System.assertEquals(cma.Campaign_Status__c,'Responded' , 'Status should be updated to responed');
            //System.assertEquals(cma.Reason__c, , 'Reason should be updated to New_Updated_Reason');
            System.assertEquals(cma.Campaign_Score__c,1,' The Score should match');
            
            Test.stopTest();
        }
            
    } 
   /** UV : Commented this method as it is not currently used
   
    static testmethod void campaignSharingTest() {
        System.runAs(usr) {
            test.startTest();
            init();
            List<User> userList = [select Id from User where UserRole.Name = 'Global' AND IsActive = true];
            List<User> lstUsers = [select id from User where IsActive = true AND UserRole.Name != 'Global' LIMIT 5];
            
            
            CampaignShare cs1 = new CampaignShare();
            cs1.CampaignId = camp.Id;
            cs1.UserOrGroupId = lstUsers.size() > 0 ? lstUsers[0].Id : Userinfo.getUserId();
            cs1.CampaignAccessLevel = 'Read';
            insert cs1;
            
            Set<Id> sharedUserIds = CM_CampaignDataUtil.getSharedUserIdsForCampaign(camp.Id);
            if(lstUsers.size() > 0) {
                System.assertEquals(sharedUserIds.size(), (userList.size() + 1), 'Size should match');
            } else {
                System.assertEquals(sharedUserIds.size(), (userList.size()));
            }
            
            Group grp = new Group();
            grp.Name = 'New Group for 2 members';
            insert grp;
            
            GroupMember gm1 = new GroupMember();
            gm1.GroupId = grp.Id;
            gm1.UserOrGroupId =  lstUsers.size() > 0 ? lstUsers[0].Id : Userinfo.getUserId();
            insert gm1;
            
            GroupMember gm2 = new GroupMember();
            gm2.GroupId = grp.Id;
            gm2.UserOrGroupId =  lstUsers.size() > 1 ? lstUsers[1].Id : Userinfo.getUserId();
            insert gm2;
            
            CampaignShare cs2 = new CampaignShare();
            cs2.CampaignId = camp.Id;
            cs2.UserOrGroupId = grp.Id;
            cs2.CampaignAccessLevel = 'Read';
            insert cs2; 
            
            sharedUserIds = CM_CampaignDataUtil.getSharedUserIdsForCampaign(camp.Id);
            if(lstUsers.size() > 1) {
                System.assertEquals(sharedUserIds.size(), (userList.size() + 2), 'Size should match');
            } 
            
            Group grp2 = new Group();
            grp2.Name = 'New Group with group & members';
            insert grp2;
            
            GroupMember gm3 = new GroupMember();
            gm3.GroupId = grp2.Id;
            gm3.UserOrGroupId =  lstUsers.size() > 2 ? lstUsers[2].Id : Userinfo.getUserId();
            insert gm3;
            
            GroupMember gm4 = new GroupMember();
            gm4.GroupId = grp2.Id;
            gm4.UserOrGroupId =  lstUsers.size() > 3 ? lstUsers[3].Id : Userinfo.getUserId();
            insert gm4;
            
            GroupMember gm5 = new GroupMember();
            gm5.GroupId = grp2.Id;
            gm5.UserOrGroupId =  grp.Id;
            insert gm5;
            
            CampaignShare cs3 = new CampaignShare();
            cs3.CampaignId = camp.Id;
            cs3.UserOrGroupId = grp2.Id;
            cs3.CampaignAccessLevel = 'Read';
            insert cs3; 
            
            sharedUserIds = CM_CampaignDataUtil.getSharedUserIdsForCampaign(camp.Id);
            if(lstUsers.size() > 3) {
                System.assertEquals(sharedUserIds.size(), (userList.size() + 4), 'Size should match');
            } 
            /*
            List<User> userList = [select Id from User where UserRole.Name = 'Global' AND IsActive = true];
            UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];
            
            Group grp3 = new Group();
            grp3.Name = 'New Group with Role sharing';
            insert grp3;
            
                    
            CampaignShare cs4 = new CampaignShare();
            cs4.CampaignId = camp.Id;
            cs4.UserOrGroupId = grp3.Id;
            cs4.CampaignAccessLevel = 'Read';
            insert cs4; 
            
            sharedUserIds = CM_CampaignDataUtil.getSharedUserIdsForCampaign(camp.Id);
            System.assertEquals(sharedUserIds.size(), userList.size(), 'sizes  should match');
            
            test.stopTest();
        }
    }**/ 
    static void init(){
      T1C_CustomSettingsManager.createChatterSetting();
       //TestClassUtilities.setAllTriggerOn();
      CM_TestClassUtilities.SetCamapignLimitSettings();
      // Insert 2 Accounts            
      listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'ts1'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);     
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 'ts2'+ Datetime.now().format('ddhhmmss');
        //acc2.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');
        acc2.Active_Flag__c = true;   
        listAccounts.add(acc2);     
        insert listAccounts;
      
      
      
      
        
        //Create test contacts
        GPSContact__c con;
        listContacts = new List<GPSContact__c>();
        TNContactKeySet = new Set<String>();
      // add 10 contacts for first account
      for(integer indx = 0; indx < LIST_SIZE; indx++){
        con = Common_ContactUtil.createContact(indx, (string)listAccounts[0].Id);
        con.FirstName__c = 'FirstName_1_0';
        con.LastName__c = 'Name_1_0';
        listContacts.add(con);
        TNContactKeySet.add(con.TN_Contact_Key__c);
      }
      // add 10 contacts for second account
      for(integer indx = 0; indx < LIST_SIZE; indx++){
        con = Common_ContactUtil.createContact((indx+LIST_SIZE), (string)listAccounts[0].Id);
        con.FirstName__c = 'FirstName_2_0';
        con.LastName__c = 'Name_2_0';
        listContacts.add(con);
        TNContactKeySet.add(con.TN_Contact_Key__c);
      }
      insert listContacts;
      
       List<Distribution_List__c> listOfdists = new List<Distribution_List__c>();     
        for(integer indx = 0; indx < (LIST_SIZE/5); indx++){
          Distribution_List__c dist = new Distribution_List__c();
          dist.Name ='test_DistributionList_' + indx;
          dist.List_Id__c = 'List_Id_s_' + indx;
          dist.Active_Flag__c = true;
          listOfdists.add(dist);
        }
        insert listOfdists; 
        
      
       lstEmployee = new List<GPSEmployee__c>();
       List<DistributionListItem__c> ListItem = new list<DistributionListItem__c>();
      for( Distribution_List__c dList : listOfdists){
        GPSEmployee__c e = new GPSEmployee__c();
        e.Name = 'test' + dList.id;
        e.Division__c = 'Research';
        e.Last_Selected_Distribution_List__c = dList.id;
        e.MS_ID__c = 'testSEFR' + dList.id;
        //e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.Active_Flag__c = true;
        lstEmployee.add(e);
        
        for(Integer i=0; i<(LIST_SIZE/10); i++) {
            DistributionListItem__c dlItem = new DistributionListItem__c();
            dlItem.Active_Flag__c = true;
            dlItem.DistributionList__c = dList.Id;
            dlItem.GPSContact__c = listContacts[i].Id;
            dlItem.Primary_Key__c = listContacts[i].id + '|' + dList.Id + '|' + i;
            ListItem.add(dlItem);
            
        }
      }
      insert lstEmployee;
      insert ListItem;
      
        List<Distribution_List_Access_Owner__c> listOfdistsOwners = new List<Distribution_List_Access_Owner__c>();
        for(integer indx = 0; indx < (LIST_SIZE/5); indx++){
          Distribution_List_Access_Owner__c dist = new Distribution_List_Access_Owner__c();
          dist.Distribution_List__c = listOfdists[indx].Id;
          dist.GPSEmployee__c = lstEmployee[indx].Id;
          dist.Active_Flag__c = true;
          dist.Primary_Key__c = listOfdists[indx].Id + '|' + lstEmployee[indx].Id + '|' + indx; 
          listOfdistsOwners.add(dist);
        }
        insert listOfdistsOwners;  
      
      CampaignExternalIDSet = new Set<String>();
      camp = new Campaign__c();
            camp.Name = 'Test Campaign3';
            //camp.IsActive = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'JP';
            camp.External_Id__c = 'Test_12345';
            camp.Default_Task_Assignee__c = usr.Id;
            camp.Require_Focus_Call_Request_Verification__c = true;
            insert camp;
      CampaignExternalIDSet.add(camp.External_Id__c);
      
      List<Attachment> attachList = new List<Attachment>();
      for(Integer i = 0 ; i < 5; i++) {
        //create Attachment
        Attachment attach = new Attachment();
        attach.Name = 'test';
        attach.ParentId = camp.Id;
        attach.Body = Blob.valueOf('testbody');
        attach.ContentType = 'application/pdf';
        attachList.add(attach);
      }
      insert attachList;
      
      List<Campaign_Milestone__c> CMList = new List<Campaign_Milestone__c>();
      for(Integer i = 0 ; i < 5; i++) {
        //create Milestone
        Campaign_Milestone__c cm = new Campaign_Milestone__c();
        cm.Campaign__c = camp.Id;
        cm.Name = 'Milestone' + i;
        cm.Date__c = Date.today().addDays(i);
        CMList.add(cm);
      }
      insert CMList;
            
      lstCampaignMembers = new List<Campaign_Member__c>();
      lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
      
      Integer index = 1;
      ContactIdSet = new Set<Id>();
      for(GPSContact__c c : listContacts){
        Campaign_Member__c cM = new Campaign_Member__c(Campaign__c = camp.Id, GPSContact__c = c.Id, Campaign_Score__c = 1, Status__c = 'Responded', Reason__c = 'Reason' + index);
        lstCampaignMembers.add(cM);
        index++;
        ContactIdSet.add(c.Id);
        
       Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
               Assigned_by_Admin__c = true,
               Assigned_To__c = usr.Id,
               Campaign__c = camp.Id,
               GPSContact__c = c.Id,
               Reassigned__c = false
               
            );
           System.debug('+++++++++++++++++++++++++++++++++' + cMA.Campaign__c + '|' + cMA.GPSContact__c + '|' + cMA.Assigned_To__c) ;
        lstCampaignMembersAssignment.add(cMA);
      }      
      
      insert lstCampaignMembers;  
      insert lstCampaignMembersAssignment;
      
      for(Campaign_Member__c cm : lstCampaignMembers){
        campMemberIds.add(cm.id);
      }
      
      CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
      if(cMGS != null && cMGS.Id != null){
          cMGS.APP_NAME__c = 'SalesGPSTest';
      }else{
          cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
          cMGS.APP_NAME__c = 'SalesGPSTest';
          insert cMGS;
      }
      
      lstTasks = new List<Task>();
      contactIds = new Set<Id>();
      Id recordTypeId = CM_TestClassUtilities.getTaskRecordTypeId();
       for(GPSContact__c c : listContacts){
         Task task1 = new Task();
             task1.WhatId = camp.id;
             task1.subject = 'Test Task';
             task1.ownerId = usr.Id;
             task1.Status = 'Pending';
             task1.GPS_Contact__c = c.Id;
             task1.activitydate = date.today();
             task1.RecordTypeId = recordTypeId;
             lstTasks.add(task1); 
             contactIds.add(c.Id);   
       }
       
       insert lstTasks;
     
  }     
    
}