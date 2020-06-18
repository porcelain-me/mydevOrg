/*****************************************************************************
This is a batch class to Update those Active User records where there is a disparity between the Short ID and its Corresponding Usernames.
*/
global class Common_UpdateUserBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    private final String  query;
    String updateErrorInfo = '';
    boolean updateError = false;
    boolean updateSuccess = false;
    String updateSuccessInfo='';
    Set<String> setUsername = new Set<String>();
    /************* Constructor *************/
    global Common_UpdateUserBatch (String q){
        System.debug('***************Querry*********'+q);
        query=q;
        
    }
    
    
    /*********************** Start Function of the Batch Class*********/    
    global Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('***************Querry*********'+query);
        return Database.getQueryLocator(query);
    }
    
    
    /********************Execute function of the Batch Class*******/
    global void execute(Database.BatchableContext bc, List<User> scope){
        String orgWideEmailAddressId = CORE_UTILITIES.getOrgWideEmailAddressId('hrfrce-alerts');
        Integer length;
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        List<User> listExistingInactiveUser = new List<User>();
        List<String> listExistingUsername = new List<String>();
        List<User> listExistingInactiveUserUpdate = new List<User>();
        List<User> listOfUsersToBeUpdated = new List<User>();
        list<User> activeusers = new List<User>();
        list<User> inactiveusers = new List<User>();
        System.debug('***************Scope*********'+scope);
         System.debug('***************Scopesize*********'+scope.size());
        for(User userObj: scope){
            if(userObj.Short_Id__c!=userObj.Username.substringBefore('+')){
                listOfUsersToBeUpdated.add(userObj);
                listExistingUsername.add(userObj.Short_Id__c+Label.UserNameSuffix);
            }
            
        }
        listExistingInactiveUser = [Select Username,ID, Emp_Id__c,Short_Id__c,isActive from User where isActive=false and Username in :listExistingUsername];
        if(listExistingInactiveUser!=null && !listExistingInactiveUser.isEmpty())
        {
           
            for(User usr : listExistingInactiveUser)
            {
                usr.Username = usr.username+'.'+usr.Emp_Id__c+'.inactive';
                listExistingInactiveUserUpdate.add(usr);
              
            }
        }
        if(listExistingInactiveUserUpdate!=null && !listExistingInactiveUserUpdate.isEmpty())
        {
            Database.update(listExistingInactiveUserUpdate,false);
        }
        System.debug('listExistingInactiveUser--'+listExistingInactiveUser.size());
        System.debug('User To update Size--'+listOfUsersToBeUpdated.size());
        System.debug('User To update--'+listOfUsersToBeUpdated);
        if(listOfUsersToBeUpdated.size()>0){
            for(User updatedUserObj: listOfUsersToBeUpdated){
                if(updatedUserObj.isActive == True){
                    activeusers.add(updatedUserObj);
                    //setUsername.add(updatedUserObj.Short_Id__c+Label.UserNameSuffix);
                }
                else {
                    //if(!setUsername.contains(updatedUserObj.Short_Id__c+Label.UserNameSuffix))
                    	inactiveusers.add(updatedUserObj);
                }
                
            }
        }
        if(activeusers.size()>0){
            System.debug('*****************Active users**************'+activeusers);
            for(User updatedUserObj: activeusers){
                updatedUserObj.isActive = false;
            }    
        }
        
        //String updateErrorInfo = '';
        //boolean updateError = false;
        if(!activeusers.isEmpty()){
            System.debug('*****************Converting Active users to Inactive**************');
            Database.SaveResult[] srList = database.update(activeusers, dlo);
            for(Integer i = 0; i < activeusers.size(); i++){
                Database.SaveResult sr =srList[i];
                User userRec = activeusers[i];
                system.debug('Error:' +  sr.getErrors());
                if (!sr.isSuccess()){
                    updateError = true;
                    updateErrorInfo = updateErrorInfo + 'Error:' + sr.getErrors()+'Short ID:'+ userRec.Short_Id__c+'User ID:'+ userRec.ID+'\n';
                } 
            }
        }
        /*if (updateError){ 
CORE_UTILITIES.systemEmailNotification(
orgWideEmailAddressId
, 'hrfrce-alerts@morganstanley.com'
, string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + updateErrorInfo + listOfUsersToBeUpdated
,'Create User Batch System Exception on Update Occurred!'
);
}*/
        System.debug('*****************Active Before now Inactive**************'+activeusers);
     
        /*if (updateError){ 
CORE_UTILITIES.systemEmailNotification(
orgWideEmailAddressId
, 'hrfrce-alerts@morganstanley.com'
, string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + updateErrorInfo + listOfUsersToBeUpdated
,'Create User Batch System Exception on Update Occurred!'
);
}*/
        if(activeusers.size()>0){
            for(User updatedUserObj: activeusers){
                updatedUserObj.Username=updatedUserObj.Short_Id__c;
                updatedUserObj.Username+=Label.UserNameSuffix;
            }
            
        } 
        
        if(!activeusers.isEmpty()){
            System.debug('*****************Updating Active Users******************');
            Database.SaveResult[] srList = database.update(activeusers, dlo);
            for(Integer i = 0; i < activeusers.size(); i++){
                Database.SaveResult sr =srList[i];
                User userRec = activeusers[i];
                system.debug('Error:' +  sr.getErrors());
                if (!sr.isSuccess()){
                    updateError = true;
                    updateErrorInfo = updateErrorInfo + 'Error:' + sr.getErrors()+'Short ID:'+ userRec.Short_Id__c+'User ID:'+ userRec.ID+'\n';
                } 
                else
                {
                    updateSuccess = true;
    			    updateSuccessInfo = updateSuccessInfo+'\n' + 'Updated :Short ID :'+ userRec.Short_Id__c+':ID:'+userRec.ID+'\n';
                }
            }
        }
        /*if (updateError){ 
CORE_UTILITIES.systemEmailNotification(
orgWideEmailAddressId
, 'hrfrce-alerts@morganstanley.com'
, string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + updateErrorInfo + listOfUsersToBeUpdated
,'Create User Batch System Exception on Update Occurred!'
);
}   */
        System.debug('*****************Updated Active users**************'+activeusers);
        if(activeusers.size()>0){
            for(User updatedUserObj: activeusers){
                updatedUserObj.isActive = true;
            }
            
        } 
        
        if(!activeusers.isEmpty()){
            System.debug('*****************Converting InActive users to Active back **************');
            Database.SaveResult[] srList = database.update(activeusers, dlo);
            for(Integer i = 0; i < activeusers.size(); i++){
                Database.SaveResult sr =srList[i];
                User userRec = activeusers[i];
                system.debug('Error:' +  sr.getErrors());
                if (!sr.isSuccess()){
                    updateError = true;
                    updateErrorInfo = updateErrorInfo + 'Error:' + sr.getErrors()+'Short ID:'+ userRec.Short_Id__c+'\n';
                } 
            }
        }
		
		if(inactiveusers.size()>0){
            System.debug('*****************InActive users**************'+inactiveusers);
            Set<String> setOfUsername = new Set<String>();
            for(User updatedUserObj: inactiveusers){
                if(!setOfUsername.contains(updatedUserObj.Short_Id__c+Label.UserNameSuffix))
                {
                    updatedUserObj.Username=updatedUserObj.Short_Id__c;
                    updatedUserObj.Username+=Label.UserNameSuffix;
                    setOfUsername.add(updatedUserObj.Short_Id__c+Label.UserNameSuffix);
                }
            }
            
        }
		
		   if(!inactiveusers.isEmpty()){
            System.debug('**********Updating Inactive users*************');
            Database.SaveResult[] srList = database.update(inactiveusers, dlo);
            for(Integer i = 0; i < inactiveusers.size(); i++){
                Database.SaveResult sr =srList[i];
                User userRec = inactiveusers[i];
                system.debug('Error:' +  sr.getErrors());
                if (!sr.isSuccess()){
                    updateError = true;
                    updateErrorInfo = updateErrorInfo + 'Error:' + sr.getErrors()+'Short ID:'+ userRec.Short_Id__c+'User ID:'+ userRec.ID+'\n';
                }
                else
                {
                    updateSuccess = true;
    			    updateSuccessInfo = updateSuccessInfo+'\n'+ 'Updated :Short ID :'+ userRec.Short_Id__c+':ID:'+userRec.ID+'\n';
                }
            }
        }
		
        
        /*if (updateError){ 
CORE_UTILITIES.systemEmailNotification(
orgWideEmailAddressId
, 'hrfrce-alerts@morganstanley.com'
, string.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + updateErrorInfo + listOfUsersToBeUpdated
,'Create User Batch System Exception on Update Occurred!'
);
}*/
        System.debug('*****************Active Before made Inactive & Now ACtive again**************'+activeusers);
        
    }
    
    
    /*****************Finish function of the Batch Class*****/
    global void finish(Database.BatchableContext BC){
        String orgWideEmailAddressId = CORE_UTILITIES.getOrgWideEmailAddressId('hrfrce-alerts');
        if (updateError){
            CORE_UTILITIES.systemEmailNotification(
                orgWideEmailAddressId
                , 'mayur.naik1@morganstanley.com'
                , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm())+'\n' + updateErrorInfo 
                ,'Create User Batch System Exception on Update Occurred!'
            );
        }
        if(updateSuccess && Label.Common_UpdateUserBatch_Email_Execution=='True')
        {
             CORE_UTILITIES.systemEmailNotification(
                orgWideEmailAddressId
                , 'mayur.naik1@morganstanley.com'
                , string.valueOf(URL.getSalesforceBaseUrl().toExternalForm())+'\n' + updateSuccessInfo 
                ,'Informational Only(Common_UpdateUserBatch) - User Updated Successfully'
            );
        }
    }
    
}