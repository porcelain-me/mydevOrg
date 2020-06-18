@isTest(SeeAllData=false)
public class TestsyncUser {
    
    @testsetup static void setupData(){
        
        User Adminusr = CM_TestClassUtilities.getAdminUser()[0];
        
        system.runAs(Adminusr){
            
            T1C_CustomSettingsManager.setAllTriggerOn();
        
        	T1C_CustomSettingsManager.createPermissionsetsetting();
            
        }       

        
        List<user> u= new List<user>();
        
        List<GPSEmployee__c> emp= new List<GPSEmployee__c>();
        
        Id profileid=[Select Id from profile where Name ='All MS Employee' limit 1].Id;
        
        for(integer i=0;i<3;i++){
           
            User usr= new user(FirstName='fName',LastName='lName',alias=i+'alias',
                               username=i+UserInfo.getOrganizationId() + System.now().millisecond()+'user@test.com',
                              email=i+'testUser@test.com',profileId=profileid,TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8',Emp_Id__c=i+'alias');
            
            u.add(usr);
            
            GPSEmployee__c em= new GPSEmployee__c(First_Name__c=i+'PreffName',Last_Name__c=i+'lName',MS_ID__c=i+'alias');
            
            emp.add(em);
        }
        
        insert u;
        
        system.runAs(Adminusr){
            
            insert emp;
            
        }
        
        
    }
    
    @isTest static void testPermissionUpdate(){
        
        test.startTest();
        
        List<GPSEmployee__c> updatedEmployee= new List<GPSEmployee__c>();
        
        set<id> empIds= new set<id>();
        
        for(GPSEmployee__c emp:[Select Id,User__c,MS_ID__c,GPS_Campaign__c,GPS_Campaign_Admin__c,iiCampaign__c
                            ,iiCampaign_Admin__c,iiFanclub__c,iiFanclub_Admin__c,Login_As__c from GPSEmployee__c]){
          
            system.debug('emp='+emp);                    
                                
                                
        	emp.GPS_Campaign__c=true;
                                
			emp.GPS_Campaign_Admin__c=true;
			
			updatedEmployee.add(emp);                     
            
            empIds.add(emp.User__c);
                                
            system.debug('emp.User__c='+emp.User__c);                    
        }
        
        update updatedEmployee;
        
         test.stopTest();
        
        system.debug('empIds='+empIds);
        
         List<AggregateResult> pma= new List<AggregateResult>();
        
         Map<string,Campaign_Permission_Sets__c> permissions= Campaign_Permission_Sets__c.getAll();
        
        pma=[Select count(Id),PermissionSet.Name from PermissionSetAssignment where PermissionSet.Name in:permissions.keySet() and assigneeId in :empIds group by PermissionSet.Name];
        
        system.debug('pma='+pma);
        
	    system.assertEquals(2,pma.size());
        
        system.assertEquals(3,pma[0].get('expr0'));
        
       
        

        
    }

}