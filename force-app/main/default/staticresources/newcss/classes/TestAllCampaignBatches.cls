/* Created by Sudarshan K. on 13th May 2016
Purpose: Achieve coverage of all batch classes used in campaigns.
*/
@isTest
private class TestAllCampaignBatches {
    
    static testmethod void TouchAllGPSEmployeeTest(){
        Test.startTest();
        T1C_CustomSettingsManager.setAllTriggerOn();
            
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
        
         empList[0].MS_ID__c = null;
         empList[1].MS_ID__c = null;
         
         update empList;
        
        TouchAllGPSEmployee touchGPSEmp = new TouchAllGPSEmployee();
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().addMinutes(5).minute()); String ss = String.valueOf(Datetime.now().second());
        
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        System.schedule('Schedule Touch All GPSEmployee batch class', nextFireTime, touchGPSEmp);
        
       Test.stopTest(); 
    }   
    
    static testmethod void TouchAllContactsTest(){
        Test.startTest();
        T1C_CustomSettingsManager.setAllTriggerOn();
        
        GPSAccount__c acc = new GPSAccount__c(Name = 'TestAccount', Active_Flag__c = true, Trading_Name_ID__c = 'TN123456');
        insert acc;
        
        GPSContact__c contact = Common_ContactUtil.createContact(acc.Id, 10);
        insert contact;
        
        Database.executeBatch(new TouchAllContacts());
        
        Test.stopTest();
    }
    
    static testmethod void ScheduleReassignedContactNotificationTest(){
        Test.startTest();
        T1C_CustomSettingsManager.setAllTriggerOn();
        
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        User dUser = new User(alias = 'newUser2', email='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
        emailencodingkey='UTF-8', lastname='Testing',
        languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
        Emp_Id__c = '1XYZ123!@', isActive=true);
        
        insert dUser; 
        
        GPSAccount__c acc = new GPSAccount__c(Name = 'TestAccount', Active_Flag__c = true, Trading_Name_ID__c = 'TN123456');
        insert acc;
        
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        listContacts.add(Common_ContactUtil.createContact(acc.Id, 2));
        listContacts.add(Common_ContactUtil.createContact(acc.Id, 3));
        
        insert listContacts;
        
        iiCampaign__c camp = new iiCampaign__c();
        camp.Campaign_Name__c  ='TEST CAMPAINGS';
        camp.Start_Date__c = Date.today();
        camp.Active_Flag__c = true;
        insert camp;
        
        Target_List__c targetList = new Target_List__c();
        targetList.User__c = dUser.Id;
        targetList.Authorized__c = true;
        targetList.iiCampaign__c = camp.id; 
        insert targetList;
        
        List<Target_List_Member__c> lstTLM = new List<Target_List_Member__c>();
        for(GPSContact__c cont : listContacts) {
            Target_List_Member__c targetListMember = new Target_List_Member__c();
            targetListMember.GPSContact__c = cont.Id;
            targetListMember.Target_List__c = targetList.id;
            targetListMember.Target_List_Member_Key__c = '123';
            targetListMember.Viewed_by_User__c = true;
            lstTLM.add(targetListMember);
        }
        insert lstTLM;
        
        ScheduleReassignedContactNotification scheduleRCN = new ScheduleReassignedContactNotification();
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().addMinutes(5).minute()); 
        String ss = String.valueOf(Datetime.now().second());
        
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
        System.schedule('Schedule Reassigned Contact Notification for test', nextFireTime, scheduleRCN);
        
        Test.stopTest();
    }
    
    static testmethod void PurgeRecordsTest(){
        Test.startTest();
        T1C_CustomSettingsManager.setAllTriggerOn();
        
        Database.executeBatch(new Purge_Records('GPSContact__c', 'Active_Flag__c = true'));
        
        GPSAccount__c acc = new GPSAccount__c(Name = 'TestAccount', Active_Flag__c = true, Trading_Name_ID__c = 'TN123456');
        insert acc;
        
        List<GPSContact__c> lstContact = new List<GPSContact__c>();
        lstContact.add(Common_ContactUtil.createContact(acc.Id, 10));
        lstContact.add(Common_ContactUtil.createContact(acc.Id, 11));
        insert lstContact;
        
        Database.executeBatch(new Purge_Records('GPSContact__c', 'Active_Flag__c = true', 10));
                
        Test.stopTest();
    }

}