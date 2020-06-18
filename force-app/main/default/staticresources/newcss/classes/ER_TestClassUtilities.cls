//
//
//07/27/2013 RA: TestClassUtilities.cls Created, helper method for writing test class
// 08/06/2013 : MG : Renamed to ER_TestClassUtilities and added methods for test data creation used in ER App.
//
//
public without sharing class ER_TestClassUtilities {

    public static User getSystemAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com', ER_Case_Team_Allowed__c='test Team');
  
        return tempUser;
    }
    
    public static User getComplianceTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name= 'All MS Employee'];
       
        User tempUser = new User(alias = 'newUser', email='Comp' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='Comp' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com', ER_Case_Team_Allowed__c='test Team');
  
        return tempUser;
    }
    
    public static User getHRTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name= :Label.ER_HR_Profile];
        
        User tempUser = new User(alias = 'newUser', email='HR' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='HR' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com', ER_Case_Team_Allowed__c='test Team');
  
        return tempUser;
    } 
    
    public static User getNonSystemAdminUser(){
        Profile p = [SELECT Id FROM Profile WHERE name !='System Administrator'][0];
        
        User tempUser = new User(alias = 'newUser', email='TU1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com', ER_Case_Team_Allowed__c='test Team');
  
        return tempUser;
    } 
    
    public static void setAllTriggerOn() { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusi
        if(dSwitch != null){
            //delete dSwitch;
            dSwitch = null;
        }       
        dSwitch = new Trigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        dSwitch.Is_ER_Case_Off__c = false ;
        dSwitch.IS_ER_CaseAttachment_Off__c = false ;
        dSwitch.Is_ER_CaseNote_Off__c = false ;
        dSwitch.Is_ER_Resolution_Off__c = false ;
        dSwitch.Is_ER_PartiesInvolved_Off__c = false;
        dSwitch.Is_ER_RelatedCases_Off__c = false; 
        insert dSwitch;
    }
    
    public static void setAllTriggerOFF() { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusi
        if(dSwitch != null){
            //delete dSwitch;
            dSwitch = null;
        }       
        dSwitch = new Trigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        dSwitch.Is_ER_Case_Off__c = true ;
        dSwitch.IS_ER_CaseAttachment_Off__c = true ;
        dSwitch.Is_ER_CaseNote_Off__c = true ;
        dSwitch.Is_ER_Resolution_Off__c = true ;
        dSwitch.Is_ER_PartiesInvolved_Off__c = true;
        dSwitch.Is_ER_RelatedCases_Off__c = true; 
        insert dSwitch;
    }
    
    public static void setERPermissionsOn() { 
        ER_Permissions__c erPermission = ER_Permissions__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusi
        if(erPermission != null){
            //delete erPermission;
            erPermission = null;
        }       
        erPermission = new ER_Permissions__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        erPermission.Is_ER_CaseAttachmentLockedForCloseStatus__c = false ;
        erPermission.Is_ER_CaseDeleteAllowed__c = true ;
        erPermission.Is_ER_CaseLockedForCloseStatus__c = false ;
        erPermission.Is_ER_CaseNoteLockedForCloseStatus__c = false;
        erPermission.Is_ER_PartiesInvolvedLockForCloseStatus__c = false; 
        erPermission.Is_ER_RelatedCasesLockedForCloseStatus__c = false; 
        erPermission.Is_ER_ResolutionLockedForCloseStatus__c = false;
        insert erPermission;
        
    }
    
    public static void setERPermissionsOFF() { 
        ER_Permissions__c erPermission = ER_Permissions__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusi
        if(erPermission != null){
            //delete erPermission;
            erPermission = null;
        }       
        erPermission = new ER_Permissions__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        erPermission.Is_ER_CaseAttachmentLockedForCloseStatus__c = true ;
        erPermission.Is_ER_CaseDeleteAllowed__c = false ;
        erPermission.Is_ER_CaseLockedForCloseStatus__c = true ;
        erPermission.Is_ER_CaseNoteLockedForCloseStatus__c = true;
        erPermission.Is_ER_PartiesInvolvedLockForCloseStatus__c = true; 
        erPermission.Is_ER_RelatedCasesLockedForCloseStatus__c = true;
        erPermission.Is_ER_ResolutionLockedForCloseStatus__c = true;                      
        insert erPermission;
        
    }
    
    public static Employee__c createTestEmployee(Integer indx, String Country, String divisionOrg, String MSSB, String jobLevelDsc, String jobLevel){
        Employee__c emp = new Employee__c(Name = 'Test Employee_' + indx, 
                                          emp_Id__c = 'emp!#_' + indx, 
                                          Job_Country_Job__c = Country,
                                          Division_Org__c = divisionOrg,
                                          MS_MSSB__c = MSSB, 
                                          Level_Dsc_Job__c = jobLevelDsc, 
                                          Covenant_Date__c = Date.today(), 
                                          Level_Job__c = jobLevel);
        return emp;
    }
    
    public static Org_Codes__c createTestOrgCode(String codeType, String codeValue){
        Org_Codes__c department = new Org_Codes__c();
        department.Code__c = codeValue;
        department.Code_Type__c = codeType;
        return department;
    }
    
    public static Case__c createTestCase(Integer indx, Id departmentId){
        Case__c testCase = new Case__c();
        testCase.Subject__c = 'test case_' + indx;
        testCase.Department__c = departmentId;
        testCase.Incident_Date__c = Date.Today().addDays(-indx);
        testCase.Reported_Date__c = Date.Today().addDays(-indx);
        testCase.Status__c = 'Open';
        testCase.Team__c = 'test Team';
        testCase.OwnerId = userInfo.getUserId();
        return testCase;
    }
     
    public static Parties_Involved__c createTestPartiesInvolved_External(Integer indx, Id caseId){
        Parties_Involved__c party = new Parties_Involved__c();
        party.Case__c = caseId;
        party.Is_Person_External__c = true;
        party.External_Party_Name__c = 'Test Party_' + indx;
        return party;
    }
        
    public static Attachment createTestTextAttachment(Integer indx, Id parentId){
        Attachment file = new Attachment();
        file.ContentType = 'text';
        file.Body = blob.valueOf('test file content');
        file.Name = 'Test File_' + indx;
        file.ParentId = parentId;
        return file;
    }  
    // 10/04/2013: RA: Case_Note__c object is not required    
    /*public static Case_Note__c createTestCaseNote(Id caseId, Id partiesInvolvedId)   {
        Case_Note__c cn = new Case_Note__c();
        cn.Case__c = caseId;
        cn.Applies_To__c = partiesInvolvedId;
        return cn;
        return null;
    } */
        
    public static Related_Cases__c createTestRelatedCases(Id caseId, Id relatedCaseId)  {
        Related_Cases__c rc = new Related_Cases__c();
        rc.Case__c = caseId;
        rc.Related_Case__c = relatedCaseId;
        return rc;
    } 
        
    public static Resolution__c createTestResolution(Id caseId, Id partiesInvolvedId)  {
        Resolution__c rc = new Resolution__c();
        rc.Case__c = caseId;
        //rc.Party_Involved__c = partiesInvolvedId;
        return rc;
    }  
    
    public static void createSearchPermissions(boolean isCompliance, boolean isHR){
        ER_CaseSearch_Permissions__c searchPerm = new ER_CaseSearch_Permissions__c();
        searchPerm.IS_Compliance__c = isCompliance;
        searchPerm.IS_HR__c = isHR;
        searchPerm.SetupOwnerId = userInfo.getProfileId();
        system.debug(searchPerm);
        insert searchPerm;
    } 
    
}