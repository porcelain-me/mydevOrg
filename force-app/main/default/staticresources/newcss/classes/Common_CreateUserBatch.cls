/*******************************************************************************************************
*
* Change log
*
* MRM - 3/4/15 -    when creating new users add them as inactive - forceact will activate the user 
*                   removed automatic reactivation
*                   add checks so we don't attempt to add bad users         
*
* MRM 6/9/15 - no longer update email; too many complaints from users who don't even use salesforce (legal...etc..)
******************************************************************************************************/
global class Common_CreateUserBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful, System.Schedulable{
    
    public String queryStr = 'Select Id, User__c, Emp_Id__c, Login_Id_Directory__c, Email__c, First_name__c, Last_Name__c, Status__c '+
                             'from Employee__c where emp_Id__c <> null and Email__c != null and Login_Id_Directory__c!= null and last_name__c != null';  // and emp_id__c = \'59JRB\'';    
    Profile p ;
    String orgType;
    Id permissionSetId;
    
    public Common_CreateUserBatch(){
        orgType = '';
        String profileName = 'All MS Employee';
        String permissionSetName = 'MS_Employee';
        Employee_Acknowledgement_Settings__c generalSetting = Employee_Acknowledgement_Settings__c.getInstance('Default');
        system.debug('=========' + generalSetting);
        if(generalSetting <> null){
            if(generalSetting.Profile_Name__c <> null){
                profileName = generalSetting.Profile_Name__c;
            }
            if(generalSetting.Org_Type__c <> null){
                if(generalSetting.Org_Type__c <> 'Prod'){
                    orgType = generalSetting.Org_Type__c.toLowerCase();
                }
            }
            /*if(generalSetting.Permission_Set_Name__c <> null){
                permissionSetName = generalSetting.Permission_Set_Name__c;
            }*/
        }
        //permissionSetId = [Select Id from PermissionSet where Name =: permissionSetName limit 1].Id;
        p = [Select Id from Profile where Name = :profileName limit 1];
    }
    
    global Database.QueryLocator start(Database.BatchableContext c) {
        
        
        return Database.getQueryLocator(queryStr); 
    }
    
    /************************************************************************************
    * EXECUTE
    *************************************************************************************/
    global void execute(Database.BatchableContext c, List<Employee__c> empList){
        
        String orgWideEmailAddressId = CORE_UTILITIES.getOrgWideEmailAddressId('hrfrce-alerts');
        Integer length;
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        
        list<User> listUserToUpdate = new list<User>();
        list<User> listUserToInsert = new list<User>();
        
        map<String, Employee__c> empIdEmpMap = new map<String, Employee__c>();
        map<String,String> empIdEmailMap = new map<String,String>();
        map<String,Employee__c> shortIdEmpMap = new map<String,Employee__c>();
        map<String,User> empIdUserMap = new map<String,User>();
        map<String,User> userNameUserMap = new map<String,User>();
        map<String,String> empUserNameMap = new map<String,String>();
        
        /* map of all employees sent into batch */
        
        for(Employee__c emp : empList){
            empIdEmpMap.put(emp.Emp_Id__c, emp);
            empIdEmailMap.put(emp.email__c,emp.Emp_id__c);
            shortIdEmpMap.put(emp.Login_Id_Directory__c,emp);
            String tempUserName1 = emp.Login_Id_Directory__c + '+hr@ms.com' + (orgType <> '' ? '.'+orgType:'');
            empUserNameMap.put(tempUserName1,null);
        }
        
        system.debug('empIdEmp:' + empIdEmpMap);
        boolean isUserActive;
        String empStatus;
        
        /* populate a map of users by username*/
        List<User> u2List = new List<User>();
        u2List = [select emp_id__c,username, firstname, lastname, short_id__c, communitynickname from user where username in:empUserNameMap.keyset()];
        for (User u:u2List){
            userNameUserMap.put(u.username,u); //mosermar+hr@ms.com.dev,User
        }
        
        /* logic to deactivate/synch a user */ 
        for(User usr : [Select Emp_Id__c, firstname, lastname, isActive, email, short_id__c, alias, communitynickname from User where Emp_Id__c in:empIdEmpMap.keySet()]){
        
            if (empIdEmpMap.get(usr.Emp_id__c) != null){  //sometimes you may find user records with the same id
                empStatus = empIdEmpMap.get(usr.Emp_Id__c).Status__c;
                isUserActive = usr.isActive;
                
                if(isUserActive && empStatus <> 'Active'){
                    usr.isActive = false;
                    listUserToUpdate.add(usr);
                    
                     
                }
                else{  //update user fields
                    
                    Employee__c tempE = empIdEmpMap.get(usr.Emp_Id__c);
                    /* name compare */
                    Integer resultFirst = usr.firstName.compareTo(TempE.first_Name__c);
                    Integer resultLast = usr.LastName.compareTo(TempE.last_name__c);
                    if (resultFirst !=0  
                    || resultLast != 0 
                    || usr.communitynickname != TempE.login_id_directory__c + '_' + usr.emp_id__c
                    || usr.alias != usr.emp_id__c
                    || usr.Short_Id__c != TempE.login_id_directory__c
                    ){  //considers case
                        
                        system.debug('****** Simple Update *******');
                        system.debug(usr.firstname);
                        system.debug(resultFirst + ':' + resultLast);
                        system.debug(usr.email + ':' + tempe.email__c);
                        system.debug(usr.short_id__c + ':' + tempe.emp_id__c);
                        system.debug(usr.communitynickname  + ':' + TempE.login_id_directory__c + '_' + usr.emp_id__c);
                        system.debug(usr.alias + ':' + usr.emp_id__c);
                        system.debug('****** end of simple udpate ******');
                        usr.firstname = TempE.first_name__c;
                        usr.lastname = TempE.last_name__c;
                        //usr.Email = TempE.Email__c;
                        length = tempE.emp_id__c.length();
                        if (length > 8)
                            length = 8;
                        usr.short_id__c = TempE.login_id_directory__c;  
                        usr.alias= tempE.emp_id__c.substring(0,length);
                        usr.CommunityNickname = TempE.login_id_directory__c + '_' + usr.emp_id__c;
                        listUserToUpdate.add(usr);
                    }
                }
            
                empIdEmpMap.remove(usr.Emp_Id__c);
                empIdEmailMap.remove(usr.Email);
                
            }
        
        }
        
        /* last resord checks for exceptions */
        
        /* logic to synch up short id into user object, also if user exist don't try to insert (remove from processing list) */
        for(Employee__c e : empIdEmpMap.values()){
            
            String tempUserName = e.Login_Id_Directory__c + '+hr@ms.com' + (orgType <> '' ? '.'+orgType:'');
            User tempU = userNameUserMap.get(tempUserName);
        
            if (tempU != null){ //user exists
                /* send an informational notice if a user is found that has the short name of the employee but a different msid */
                /* not sure what this means; want to monitor */
                if (tempU.emp_id__c != e.emp_id__c){
                    CORE_UTILITIES.systemEmailNotification(
                         orgWideEmailAddressId
                        , 'hrfrce-alerts@morganstanley.com'
                        , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + listUserToUpdate + '\n' + 'Empid:' + e.id + ' UserId:' + tempU.id
                        ,'Informaitonal Only - Found a user/emp msid mismatch!'
                        );
                }
                
                empIdEmpMap.remove(e.Emp_Id__c); 
                
                /* name compare */
                Integer resultFirst2 = tempU.firstName.compareTo(e.first_Name__c);
                Integer resultLast2 = tempU.LastName.compareTo(e.last_name__c);
                     
                
                if (tempU.Short_Id__c != e.login_id_Directory__c 
                || tempU.emp_id__c != e.emp_id__c 
                || tempU.CommunityNickname != e.login_id_directory__c + '_' + e.emp_id__c
                || resultFirst2 !=0  || resultLast2 != 0
                ){
                    
                    tempU.short_id__c = e.login_id_directory__c;
                    tempU.emp_id__c = e.Emp_ID__c;
                    tempU.CommunityNickname = e.login_id_directory__c+'_' + e.emp_id__c;
                    //tempU.Email = e.Email__c;
                    tempU.firstname = e.first_name__c;
                    tempU.lastname = e.last_name__c;
                    length = e.emp_id__c.length();
                        if (length > 8)
                            length = 8;
                    tempU.alias = e.emp_id__c.substring(0,length); 
                    listUsertoUpdate.add(tempU);
                    CORE_UTILITIES.systemEmailNotification(
                         orgWideEmailAddressId
                        , 'hrfrce-alerts@morganstanley.com'
                        , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + listUserToUpdate + '\n' + 'Empid:' + e.id + ' UserId:' + tempU.id
                        ,'Informaitonal Only - Synched user info with user info!'
                        );
                }
                
                
            }
                
        }
        /* get a map of remaining users by email */
        Map<String,User> emailUserMap = new Map<String,User>();
        List<User> uList = [select id, email from User where email in :empIdEmailMap.keySet()];
        for (User u:uList){
            emailUserMap.put(u.email,u);
        }
        /* MRM 3/4/15 for the remaining employees in this batch; remove any employees without first name last name because user insert will fail*/
        
        for(Employee__c emp2 : empIdEmpMap.values()){
            if (emp2.first_name__c == null || emp2.last_name__c == null){
                empIdEmpMap.remove(emp2.emp_id__c);
            }   
        } 
        
       
        
        /* logic to create new users - only for active users */
        
        for(Employee__c emp : empIdEmpMap.values()){
            system.debug('creating new users');
            if(emp.Status__c == 'Active' && emp.Login_Id_Directory__c != null){
               
              
                /* mrm 3/4/15 added isactive = false */
                length = emp.emp_id__c.length();
                        if (length > 8)
                            length = 8;
                            
                listUserToInsert.add(new User(FirstName = emp.First_Name__c,
                                          LastName = emp.Last_Name__c,
                                          Email = emp.Email__c,
                                          Emp_Id__c = emp.Emp_Id__c,
                                          isactive = false,
                                          Short_Id__c = emp.login_id_directory__c,
                                          Alias = emp.emp_id__c.substring(0,length),
                                          CommunityNickName = emp.login_id_directory__c + '_' + emp.emp_id__c,
                                          UserName = emp.login_id_directory__c + '+hr@ms.com' + (orgType <> '' ? '.'+orgType:''),
                                          profileId = p.Id,
                                          emailencodingkey = 'UTF-8',
                                          languagelocalekey = 'en_US',
                                          timezonesidkey = 'America/New_York',
                                          localesidkey = 'en_US'));
            }
            
        }
        
        
        String insertErrorInfo = '';
        boolean saveError = false;
        if(!listUserToInsert.isEmpty()){
            Database.SaveResult[] srList = database.insert(listUserToInsert, dlo);
            for(Database.SaveResult sr : srList){
                system.debug(sr.getErrors());
                if (!sr.isSuccess()){
                    saveError = true;
                    insertErrorInfo = insertErrorInfo + ';' + sr.getErrors();
                }
                
            }
        }
        
       
        
        if (saveError){
            CORE_UTILITIES.systemEmailNotification(
                 orgWideEmailAddressId      
                , 'hrfrce-alerts@morganstanley.com'
                , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + insertErrorInfo + listUserToInsert
                ,'Create User Batch System Exception on Insert Occurred!'
                );
        }
        
        String updateErrorInfo = '';
        boolean updateError = false;
        system.debug('****** nbr of updates *****'  + listUserToUpdate.size());
        if(!listUserToUpdate.isEmpty()){
            Database.SaveResult[] srList = database.update(listUserToUpdate, dlo);
            for(Database.SaveResult sr : srList){
                system.debug('Error:' +  sr.getErrors());
                 if (!sr.isSuccess()){
                    updateError = true;
                    updateErrorInfo = updateErrorInfo + ';' + sr.getErrors();
                 }
                    
               
            }
        }
        
        if (updateError){ 
            CORE_UTILITIES.systemEmailNotification(
                 orgWideEmailAddressId
                , 'hrfrce-alerts@morganstanley.com'
                , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + updateErrorInfo + listUserToUpdate
                ,'Create User Batch System Exception on Update Occurred!'
                );
        }
    }
    
    global void finish(Database.BatchableContext c){
        
        datetime dt = system.now().addMinutes(1);        
        String sch = dt.second() + ' ' + dt.minute() + ' ' + dt.Hour() + 
                    ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('DG_UpdateEmployeeBatch'+datetime.now(), sch, new Common_UpdateEmployeeBatch());
        
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new Common_CreateUserBatch(), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}