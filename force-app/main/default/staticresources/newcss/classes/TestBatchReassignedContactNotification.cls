/***
* 
*   (c) 2009 Appirio, Inc.
*
*   Test Class for BatchReassignedContactNotification
*
*   Aug 04, 2010     Prafull Gupta       Original
*   Sept 08, 2010    Parth Tamhaney      USe DataUtil.getTestUserWithRole() to get existing user
*   Nov  25,2010    Parth Tamahney      Removed use of User.
*   May  18,2011     Rahul Jain          Updated myUnitTest data to add asserts in case of apex job gets failed.
**/
@isTest
private class TestBatchReassignedContactNotification {

  //static User testUser;
  static Target_List__c targetList1;
  static Target_List__c targetList2;
  static Target_List_Member__c targetListMember1;
  static Target_List_Member__c targetListMember2;
  static Target_List_Member__c targetListMember3;
  static List<Target_List_Member__c> listTargetMemberList;
  
    
  static testMethod void myUnitTest() {
       
       createTestData();
       Test.startTest();
        
            BatchReassignedContactNotification batchController = new BatchReassignedContactNotification();
           ID batchprocessid =  Database.executeBatch(batchController);
      
        
       Test.stopTest();
       AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ];
       
       // 05/18/2011 RJ : If job gets failed then the number of errors should be more then zero.
       if(aaj.Status != 'Completed'){
        System.assert(aaj.NumberOfErrors > 0, true);        
       }else{
        System.assertEquals(aaj.Status, 'Completed');
        System.assertEquals(aaj.JobItemsProcessed,1);
        System.assertEquals(aaj.TotalJobItems,1);
        System.assertEquals(aaj.NumberOfErrors,0);
       }
    
    }
    
     static void createTestData() {
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
            System.assertNotEquals(acc.id , null);
        }
        
        //Create test contacts
        //Swapna Comment RecordType record = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'GPSContact__c' and r.Name = 'Voters'];
       //Swapna Comment System.assertNotEquals(record.id , null);
        
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        for(integer i = 0; i<listAccounts.size(); i++){
            listContacts.add(Common_ContactUtil.createContact((string)listAccounts[i].Id, i));
            
        }
        
        insert listContacts; 
        for(GPSContact__c cons : listContacts){
                System.assertNotEquals(cons.id ,null);
        }
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         insert camp;
         //Preparing test target list
        List<Target_List__c> listTargetList = new List<Target_List__c>(); 
        
        targetList1 = new Target_List__c();
        //This MSID__c Field is primarily for importing data purpose {External ID}.
        targetList1.MSID__c = 'Test_List1';
        targetList1.User__c =  system.Userinfo.getUserId();//testUser.Id;
        targetList1.Authorized__c = true;
        targetList1.iiCampaign__c = camp.id;
        listTargetList.add(targetList1);
        
        targetList2 = new Target_List__c();
        //This MSID__c Field is primarily for importing data purpose {External ID}.
        targetList2.MSID__c = 'Test_List2';
        targetList2.User__c = system.Userinfo.getUserId();//testUser.Id;
        targetList2.Authorized__c = true;
        targetList2.iiCampaign__c = camp.id;
        listTargetList.add(targetList2);
        
        insert listTargetList;
        
        for(Target_List__c tl : listTargetList){
            System.assertNotEquals(tl.id , null);
        }
        
        listTargetMemberList = new List<Target_List_Member__c>(); 
        
        
         targetListMember1 = new Target_List_Member__c();
         targetListMember1.Target_List__c = targetList1.id;
         targetListMember1.Removed_Reason__c = null;
         targetListMember1.Reassigned_By__c = system.Userinfo.getUserId();//testUser.Id;
         targetListMember1.Viewed_By_User__c = false;
         targetListMember1.Reassigned_Date__c = System.now().addHours(-10);
       
         //Composite key that concatenates the MSID and TN GPSContact__c Key (TN + CIS).Only used during import to prevent from creating duplicate contacts.
         targetListMember1.Target_List_Member_Key__c = '123';
         targetListMember1.GPSContact__c = listContacts[0].Id;
         
         listTargetMemberList.add(targetListMember1);
         
         targetListMember2 = new Target_List_Member__c();
         targetListMember2.Target_List__c = targetList2.id;
         targetListMember2.Removed_Reason__c = null;
         targetListMember2.Reassigned_By__c = system.Userinfo.getUserId();//testUser.Id;
         targetListMember2.Viewed_By_User__c = false;
         targetListMember2.Reassigned_Date__c = System.now().addHours(-2);
         
         //Composite key that concatenates the MSID and TN GPSContact__c Key (TN + CIS).Only used during import to prevent from creating duplicate contacts.
         targetListMember2.Target_List_Member_Key__c = '123';
         targetListMember2.GPSContact__c = listContacts[1].Id;
         
         listTargetMemberList.add(targetListMember2);
         
         //////
          targetListMember3 = new Target_List_Member__c();
         targetListMember3.Target_List__c = targetList2.id;
         targetListMember3.Removed_Reason__c = null;
         targetListMember3.Reassigned_By__c = system.Userinfo.getUserId();//testUser.Id;
         targetListMember3.Viewed_By_User__c = false;
         targetListMember3.Reassigned_Date__c = System.now().addHours(-2);
         
         //Composite key that concatenates the MSID and TN GPSContact__c Key (TN + CIS).Only used during import to prevent from creating duplicate contacts.
         targetListMember3.Target_List_Member_Key__c = '123';
         targetListMember3.GPSContact__c = listContacts[1].Id;
         
         listTargetMemberList.add(targetListMember3);
         
         
        
        insert listTargetMemberList;
        
        for(Target_List_Member__c tlm : listTargetMemberList){
            System.assertNotEquals(tlm.id , null);
        }
    } 
    
}