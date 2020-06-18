@isTest
public class Common_UpdateUserBatchTest{
    static testMethod void myTest1(){ 
        User userRec  = [Select name from User where ID = :UserInfo.getUserId()];
        System.runAs(userRec)
        {
            Profile p = [SELECT Id FROM Profile WHERE name !='System Administrator' limit 1];
            List<User> userList = new List<User>();
            User tempUser1 = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                      emailencodingkey='UTF-8', lastname='Testing',
                                      languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,Short_Id__c='IMNL',
                                      timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
            userList.add(tempUser1);
            
            
            User tempUser2 = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                      emailencodingkey='UTF-8', lastname='Testing',
                                      languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = false,Short_Id__c='IMNLXVT',
                                      timezonesidkey='America/Los_Angeles', username='TU12' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
            userList.add(tempUser2);
            
            insert userList;
            
            String query='select Username, Short_Id__c,isActive from User where isActive=true and Short_Id__c!=null';
            test.startTest();
            Common_UpdateUserBatch cb = new Common_UpdateUserBatch(query);
            ID batchID= Database.executeBatch(cb,2000);
            test.stopTest();
            //System.abortJob(batchID);
        }
        
        
    }
    static testMethod void myTest2(){ 
        User userRec  = [Select name from User where ID = :UserInfo.getUserId()];
        System.runAs(userRec)
        {
            Profile p = [SELECT Id FROM Profile WHERE name !='System Administrator' limit 1];
            List<User> userList = new List<User>();
            User tempUser1 = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                      emailencodingkey='UTF-8', lastname='Testing',
                                      languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,Short_Id__c='IM44NL',
                                      timezonesidkey='America/Los_Angeles', username='TUdd' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
            userList.add(tempUser1);
            
            
            User tempUser2 = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                      emailencodingkey='UTF-8', lastname='Testing',
                                      languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = false,Short_Id__c='IM54T',
                                      timezonesidkey='America/Los_Angeles', username='TU1dd2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
            userList.add(tempUser2);
            
            insert userList;
            
            String query='select Username, Short_Id__c,isActive from User where isActive=false and Short_Id__c!=null limit 1000';
            test.startTest();
            Common_UpdateUserBatch cb = new Common_UpdateUserBatch(query);
            ID batchID= Database.executeBatch(cb,2000);
            test.stopTest();
            //System.abortJob(batchID);
        }
        
        
    }
    
}