//
//  07/24/2013: RA: Data Tier for ER Module (Facade class for database operations such as sql and dml)
//
// 08/30/2013 : MG : Added a new method getSystemGeneratedPartiesInvolvedIdsOnCaseIds() to get system generated party involved records based on case ids.
// 09/05/2013 : MG : Moved getCaseTeamMapping() to UserManager.cls

public without sharing class ER_DataUtil {

    public static list<Case__c> getCaseStatus(list<string> caseId){
        return [select id, Status__c, Name, T360_Case__c 
                from Case__c 
                where Id in :caseId];
    }
    
    public static Case__c getCaseDetails(String caseId){
        return getCaseStatus(new list<String>{caseId})[0];
    }
    // JIRA#ERCM7 : make sure the user cannot edit/delete the primary parties involved record
    // added tirgger_record flag    
    public static list<Parties_Involved__c> getPartiesInvoled(list<string> Ids){
        return [Select Id, Case__c, Is_a_trigger_record__c
              From Parties_Involved__c  
              where Id in :Ids];
    } 
    
    
    public static User getUserDetails(Id userId){
        User user = [SELECT Id, RIF_Allow_Super_Division__c, Profile.Name, ER_Case_Team_Allowed__c 
                     FROM User 
                     WHERE Id = :userId 
                     limit 1];
        return user;
    }
    
    public static list<User> getUserDetailsOnUserIds(list<string> userIds){
        return [SELECT Id, RIF_Allow_Super_Division__c, Profile.Name, ER_Case_Team_Allowed__c 
                FROM User 
                WHERE Id in :userIds]; 
    }
    
    
    /*public static set<Id> getSystemGeneratedPartiesInvolvedIdsOnCaseIds(list<String> CaseIds){
        map<id, Parties_Involved__c> mapPI = new map<id, Parties_Involved__c>([select id 
                                                                               from Parties_Involved__c 
                                                                               where Case__c in :CaseIds 
                                                                               and Is_System_Case_Record__c = true]);
        return mapPI.keySet();
    }*/
    
    public static list<Parties_Involved__c> getPartiesInvoledDetails(list<string> Ids){
        return [SELECT Workphone__c, Super_Division__c, Super_Dept__c, Sub_Dept__c, Status__c, Role__c, Person__c, Party_Name__c, 
                      Mobilephone__c, Location__c, JobCode__c, Is_Person_External__c, Is_Person_Anonymous__c, Id, Gender__c, 
                      External_Party_Name__c, Is_a_trigger_record__c,Ethnicity__c, Emp_Type__c, Email__c, Division__c, Departmant__c, Cost_Center__c, Case__c,
                      External_Phone__c, External_Email__c, External_Others__c, Level_Job__c, Level_Dsc_Job__c, RecordTypeId, Emp_Id__c, Party_Full_Name__c,
                      Is_System_Case_Record__c, Cost_Center_Desc__c, Dept_Dsc__c, Division_Desc__c, Job_Title_Dsc__c, Region_Desc__c, Super_Division_Desc__c,Primary_Pay_Company_Job__c
                      ,Primary_Pay_Company_Dsc_Job__c,Sub_Depart2_Org__c,Subdept_Dsc_Org__c,Super_Depart_Org__c,Super_Depart_Dsc_Org__c  
              FROM Parties_Involved__c
              WHERE Id = :Ids];
    } 
    
    public static string getProfileNameForLoggedinUser(){
        for(Profile p: [select name 
                        from profile 
                        where id = :UserInfo.getProfileId()]){
            return p.Name; 
        }
        return '';
    }
    
     public static map<Id,Employee__c> getEmployeeList(Set<String> empRecordIds){
        system.debug('In getEmployeeList************'+ empRecordIds);
        return new map<Id,Employee__c>([select Id, Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c, 
                   Emp_ID__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c, Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                   Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c,  
                   Days_of_Perm_Serv_Total_LOS__c, DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c,
                   Login_Id_Directory__c, Name, Empl_Type_Job__c, Ethnic_Group__c, Gender__c, Jobcode_Job__c, Status__c, Job_Title_Dsc_Job__c,
                   Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c, City_Home__c, State_Home__c, Zip_Home__c, Primary_Pay_Company_Job__c,
                   Primary_Pay_Company_Dsc_Job__c   
               from Employee__c
               where id in :empRecordIds]);
    }
    
    public static List<Employee__c> getEmployee(String empRecordIds){
        system.debug('In getEmployee************'+ empRecordIds);
      return getEmployeeList(new Set<String>{empRecordIds}).values();       
    }    
    
    
    public static List<Related_Cases__c> getRelatedCasesOnCaseId(String caseId){
        return [Select Id, Name, Related_Case__c, Related_Case__r.Name, Case__c, Case__r.Name,Case__r.T360_Case__c  
                from Related_Cases__c 
                where Case__c = :caseId 
                OR Related_Case__c = :caseId];
    }
}