//
//  06/07/2013: RJ: Data Tier (Facade class for database operations such as dql and dml)
//
//
// 06/25/2013 : MG : Added a new method to sync Accrual Information record with Severance And Release.
// 07/10/2013 : MG : Added a new method getListExistingAccrualInfoForEmpIds() to get list of Accrual Information assiciated with Emp Ids. 
//07/11/2013: RA: Add a new method getProjectDecisionalUnitOnProjectId() to get list of PDUs based on list of project
//07/19/2013: RA: Add a new method getSeveranceAndReleaseRecord() get single S&R record with all editable details.
//08/09/2013: Jitendra: Add a new method getSeveranceAndReleaseListOnSuperDivision()
//08/09/2013: Jitendra: Add a new method getUniqueProjectsfromProjectLevel()
//08/12/2013: Jitendra: Add a new method getSuperDivisionMapping() get super division and public group mapping from custom setting. 
//08/12/2013: Jitendra: Add a new method getProfileName()
// 09/02/2013 : MG : Updated method getListExistingAccrualInfoForEmpIds() to add new fields. HRFORCE-197
// 09/03/2013 : MG : Updated copyFieldsToSRFromEmployee() to copy city - home, state - home and zip - home from employee to S&R.
// 09/04/2013 : MG : Added a new method getUnvestedEquityForEmpIds() to get list of unvested equity records to denormalize total unvested value on S&R.
// 09/05/2013 : MG : Moved getSuperDivisionMapping() to UserManager.cls
// 09/24/2013 : MG : Updated method getListExistingAccrualInfoForEmpIds() to add new fields. HRFORCE-254

public class RIF_DataUtil {
 
    //public static string CALCULATE_AND_OVERRIDE_MANUAL_CHANGES = 'Calculate and Override Manual Changes';
    
    public static Trigger_Switch__c getTriggerSwitch(){
        return Trigger_Switch__c.getInstance();
    }
    
    
    public static String getProfileId(String profileName){
        Profile pf = [SELECT Id 
                      FROM Profile 
                      WHERE Name = :profileName 
                      limit 1];
        return pf.Id;
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
    
    public static List<OrgWideEmailAddress> getOrgWideEmaillAddresses(String name){
      return [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = :name limit 1];
    }
    public static list<GroupMember> getExistingGroupMembers(Map<Id,Set<Id>> mapUserIdListGroupIds){
    // This method returns list of existing GroupMembers.
    // mapUserIdGroupId : map of UserId and GroupId.
        Set<Id> allGroupIds = new Set<Id>();
        for(Set<Id> groupIds : mapUserIdListGroupIds.values()){
            allGroupIds.addAll(groupIds);
        }
            
        return getExistingGroupMembers(allGroupIds, mapUserIdListGroupIds.keySet());
               
    }
    
    public static list<GroupMember> getExistingGroupMembers(Set<Id> allGroupIds, Set<Id> userIds){
    // This method returns list of existing GroupMembers.
    // mapUserIdGroupId : map of UserId and GroupId.        
        return [Select GroupId,UserOrGroupId 
                from GroupMember 
                where GroupId in :allGroupIds 
                and UserOrGroupId in : userIds]; 
    }
    
    public static GroupMember createGroupMember(Id userOrGroupId, Id groupId){
        // this method creates group member
        return new GroupMember(UserOrGroupId = userOrGroupId, GroupId = groupId);
    }
    
    public static void deleteGroupMembers(list<GroupMember> listGroupMembersToDelete){
    // Delete list of existing Group Member Records from database.
        if(!listGroupMembersToDelete.isEmpty()){           
             Database.DeleteResult[] ldR = Database.delete(listGroupMembersToDelete, false);
            // Process the delete results
            List<String> errorMessages = new List<String>();
            for(Database.DeleteResult dr : ldR){
                if(!dr.isSuccess()){
                    Database.Error err = dr.getErrors()[0];   
                    System.debug('Unable to insert Group Member record due to following exception:' + err.getMessage());             
                }            
            }
         }    
    }
    
    public static void insertGroupMembers(list<GroupMember> listGroupMembersToInsert){
    // insert new group members into database.
        if(!listGroupMembersToInsert.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(listGroupMembersToInsert, false);
            List<String> errorMessages = new List<String>();        
            // Process the save results
            for(Database.SaveResult sr : lsr){
              if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                System.debug('Unable to insert Group Member record due to following exception:' + err.getMessage());
              }            
            }
        }
    }
   
    /*public static List<Severance_Parameters__c> getSeverancePrameters(List<String> severanceParameterIds, String country, string msmssb, string levelDsc, string whereCondition){
      
        String strQuery = 'Select s.Name, s.Weekly_Mulitple__c, s.Template__c, s.Sev_Weeks__c, '+ 
                        's.Sev_Weeks_Min__c, s.Sev_Weeks_Max__c, s.OutPlacement__c, s.Notice_Calc__c, '+
                        's.MS_MSSB__c, s.Los_Through__c,  s.Level_Dsc__c, level__c, '+
                        's.Is_NonUS__c, s.Id, s.Enhanced_Percent__c, s.Enhanced_Min__c, s.Enhanced_Max__c,  '+
                        's.Covenant_Notice__c, s.Country__c, s.Cobra_Months__c, s.Basic_Min__c, '+ 
                        's.Basic_Max__c, s.Back_Out_Notice__c '+ 
                        'From Severance_Parameters__c s ';
        
        strQuery += whereCondition ;
        system.debug(strQuery);
        return (List<Severance_Parameters__c>)Database.query(strQuery);
        
    }*/
    
    public static List<Severance_Parameters__c> getSeverancePrameters(List<String> severanceParameterIds, String country, string msmssb, string levelDsc, string whereCondition){
      
        String strQuery = 'Select s.Name, s.Weekly_Mulitple__c, s.Template__c, s.Sev_Weeks__c, '+ 
                        's.Sev_Weeks_Min__c, s.Sev_Weeks_Max__c, s.OutPlacement__c, s.Notice_Calc__c, '+
                        's.MS_MSSB__c, s.Los_Through__c,  s.Level_Dsc__c, level__c, '+
                        's.Is_NonUS__c, s.Id, s.Enhanced_Percent__c, s.Enhanced_Min__c, s.Enhanced_Max__c,  '+
                        's.Covenant_Notice__c, s.Country__c, s.Cobra_Months__c, s.Basic_Min__c, '+ 
                        's.Basic_Max__c, s.Back_Out_Notice__c '+ 
                        'From Severance_Parameters__c s ';
        
        strQuery += whereCondition ;
        system.debug(strQuery);
        return (List<Severance_Parameters__c>)Database.query(strQuery);
        
    }
   
   public static List<Severance_Parameters__c> getSeverancePrametersForCountry(String country){
        country = country == null? '': country;
        string whereCondition = 'where s.Country__c = :country ';           
        return getSeverancePrameters(null, country, null, null, whereCondition);
   }
   
   /*public static List<Severance_Parameters__c> getSeverancePrametersForCountry(String country, List<String> fieldsList){
        String strQuery = String.join(fieldsList, ',');
        return (List<Severance_Parameters__c>)Database.query('Select ' + strQuery +  ' From Severance_Parameters__c s where s.Country__c = :country ');
   }*/
   
    
   public static List<Severance_Parameters__c> getSeverancePrameters(String severanceParameterId){
        return getSeverancePrameters(new list<string>{severanceParameterId});         
   }    
   
   public static List<Severance_Parameters__c> getSeverancePrameters(List<String> severanceParameterIds){
        severanceParameterIds = severanceParameterIds == null? new list<string>(): severanceParameterIds;
        string whereCondition = 'where s.id in : severanceParameterIds';
        return getSeverancePrameters(severanceParameterIds, null, null, null, whereCondition); 
   }
   
   public static List<Severance_Parameters__c> getSeverancePrameters(String country, string msmssb, string levelDsc){
        country = country == null? '': country;
        msmssb = msmssb == null? '': msmssb;
        levelDsc = levelDsc == null? '': levelDsc;
        string whereCondition = 'where s.Country__c = : country AND s.MS_MSSB__c = :msmssb And s.Level_Dsc__c = :levelDsc';
        return getSeverancePrameters(null, country, msmssb, levelDsc, whereCondition);
   }
   
   public static Project_Level__c cloneSevParamToProjectLevel(Severance_Parameters__c sevParam){
     Project_Level__c pL = new Project_Level__c(
        Weekly_Mulitple__c = sevParam.Weekly_Mulitple__c,
        Template__c = sevParam.Template__c, 
        Severance_Parameters__c = sevParam.id, 
        Sev_Weeks__c = sevParam.Sev_Weeks__c, 
        Sev_Weeks_Min__c = sevParam.Sev_Weeks_Min__c, 
        Sev_Weeks_Max__c = sevParam.Sev_Weeks_Max__c, 
        Project__c = null, 
        Outplacement__c = sevParam.OutPlacement__c, 
        Notice_Calc__c = sevParam.Notice_Calc__c, 
        MS_MSSB__c = sevParam.MS_MSSB__c, 
        Los_Through__c = sevParam.Los_Through__c, 
        Level__c = sevParam.Level__c,
        Level_Dsc__c = sevParam.Level_Dsc__c,  
        Enhanced_Percent__c = sevParam.Enhanced_Percent__c, 
        Enhanced_Min__c = sevParam.Enhanced_Min__c, 
        Enhanced_Max__c = sevParam.Enhanced_Max__c, 
        Covenant_Notice__c = sevParam.Covenant_Notice__c, 
        Country__c = sevParam.Country__c, 
        Cobra_Months__c = sevParam.Cobra_Months__c, 
        Basic_Min__c = sevParam.Basic_Min__c, 
        Basic_Max__c = sevParam.Basic_Max__c, 
        Back_Out_Notice__c = sevParam.Back_Out_Notice__c
     ); 
     return pL;      
   }
   
   public static Project_Level__c cloneSevParamToProjectLevel(Project_Level__c pl, Severance_Parameters__c sevParam){
        if(pl <> null){
            pl.Weekly_Mulitple__c = sevParam.Weekly_Mulitple__c;
            pl.Template__c = sevParam.Template__c;
            pl.Severance_Parameters__c = sevParam.id; 
            pl.Sev_Weeks__c = sevParam.Sev_Weeks__c; 
            pl.Sev_Weeks_Min__c = sevParam.Sev_Weeks_Min__c; 
            pl.Sev_Weeks_Max__c = sevParam.Sev_Weeks_Max__c; 
            pl.Outplacement__c = sevParam.OutPlacement__c; 
            pl.Notice_Calc__c = sevParam.Notice_Calc__c; 
            pl.MS_MSSB__c = sevParam.MS_MSSB__c; 
            pl.Los_Through__c = sevParam.Los_Through__c; 
            pl.Level__c = sevParam.Level__c;
            pl.Level_Dsc__c = sevParam.Level_Dsc__c;  
            pl.Enhanced_Percent__c = sevParam.Enhanced_Percent__c; 
            pl.Enhanced_Min__c = sevParam.Enhanced_Min__c; 
            pl.Enhanced_Max__c = sevParam.Enhanced_Max__c; 
            pl.Covenant_Notice__c = sevParam.Covenant_Notice__c; 
            pl.Country__c = sevParam.Country__c; 
            pl.Cobra_Months__c = sevParam.Cobra_Months__c; 
            pl.Basic_Min__c = sevParam.Basic_Min__c; 
            pl.Basic_Max__c = sevParam.Basic_Max__c;    
            pl.Back_Out_Notice__c = sevParam.Back_Out_Notice__c;
        }else{
            return cloneSevParamToProjectLevel(sevParam);
        }
            
        return pl;      
   }
   
   
  public static List<Project_Level__c> getProjectLevelsOfSeveranceParameter(String severanceParameterId){
      return [Select p.Weekly_Mulitple__c, p.Template__c, p.Severance_Parameters__c, 
                    p.Sev_Weeks__c, p.Sev_Weeks_Min__c, p.Sev_Weeks_Max__c, p.Project__c, p.Outplacement__c, p.Notice_Calc__c, 
                    p.Name, p.Los_Through__c, p.Level__c, p.Level_Dsc__c, p.MS_MSSB__c, 
                    Is_NonUS__c, p.IsDeleted, p.Id, p.Enhanced_Percent__c,p.Enhanced_Min__c, p.Enhanced_Max__c, 
                    p.Covenant_Notice__c, p.Country__c, p.Cobra_Months__c,p.Basic_Min__c, p.Basic_Max__c, 
                    p.Back_Out_Notice__c 
             From Project_Level__c p   
             where p.Severance_Parameters__c =: severanceParameterId];
   }    
   public static List<ApexPages.Message> insertResult(List<SObject> lstSObj){
       Database.SaveResult[] lsr = Database.insert(lstSObj, false);   
       List<ApexPages.Message> errorMessages = new List<ApexPages.Message>();             
        // Process the save results
        for(Database.SaveResult sr : lsr){
          if(!sr.isSuccess()){
            Database.Error err = sr.getErrors()[0]; 
            errorMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to insert due to exception:' + err.getMessage()));            
          }            
        }
        return errorMessages;
   }
   
   public static List<ApexPages.Message> upsertResult(List<SObject> lstSObj){
       Database.UpsertResult[] lsr = Database.upsert(lstSObj, false);
       List<ApexPages.Message> errorMessages = new List<ApexPages.Message>();             
        // Process the save results
        for(Database.UpsertResult sr : lsr){
          if(!sr.isSuccess()){
            Database.Error err = sr.getErrors()[0]; 
            errorMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to save due to exception:' + err.getMessage()));            
          }            
        }
        return errorMessages;
   } 
   
   public static void insertResult(SObject sObj){
          insertResult(new List<SObject>{sObj});
   }
   
   public static List<RecordType> getProjectRecordTypeForId(String recordTypeId){
     return [Select r.Name, r.Id 
             From RecordType r 
             where SobjectType = 'Project__c' 
             and id = :recordTypeId];
   }
   
   public static List<RecordType> getRecordTypeForName(String recordTypeName){
     return [Select r.Name, r.Id, r.SobjectType 
             From RecordType r 
             where Name = :recordTypeName];
   }
   
   public static List<RecordType> getRecordTypeForId(String recordTypeId, string sObjectName){
     return [Select r.Name, r.Id 
             From RecordType r 
             where SobjectType = :sObjectName 
             and id = :recordTypeId];
   }
      
   public static list<RIF_Default_Notice_Period__c> getListDefaultNoticePeriodsFromCustomSetting(){
        return RIF_Default_Notice_Period__c.getAll().values();
    }
    
    public static List<Project_Level__c> getProjectLevels(set<string> projectLevelIds){
        return [Select Project__r.Notice_Days__c, Outplacement__c, project__c  
                  from Project_Level__c 
                  where id in :projectLevelIds];
    }
    
    public static List<Project_Level__c> getProjectLevels(string projectId, string country, string levelDsc, string msmssb){
        return [Select id, project__c, Severance_Parameters__c, Level__c,Basic_Max__c,Basic_Min__c, Cobra_Months__c,Los_Through__c,Covenant_Notice__c,Enhanced_Max__c,
                  Enhanced_Min__c,Notice_Calc__c,Sev_Weeks__c,Sev_Weeks_Max__c,Sev_Weeks_Min__c,Weekly_Mulitple__c,Back_Out_Notice__c from Project_Level__c 
                  where project__r.Id =: projectId and
                    Country__c =: country and
                    Level_Dsc__c =: levelDsc and
                    MS_MSSB__c =: msmssb];
    }
    
    
    public static List<Project_Level__c> getProjectLevelsForProject(string projectId){
        return [Select id, project__c, Severance_Parameters__c, Level__c , project__r.Country__c, Level_Dsc__c, MS_MSSB__c, Country__c
                  from Project_Level__c 
                  where project__r.Id =: projectId ];
    }
    public static List<Project_Level__c> getProjectLevelsForMassProjects(set <id> projectIds){
        return [Select id, project__c, Severance_Parameters__c, Level__c , project__r.Country__c, Level_Dsc__c, MS_MSSB__c, Country__c
                  from Project_Level__c 
                  where project__r.Id IN: projectIds]; 
    }
   
    public static map<Id,Employee__c> getEmployeeList(Set<String> empRecordIds){ 
        return new map<Id,Employee__c>([select Job_State_Job__c,Job_Title__c,Job_Title_Dsc_Job__c,DOH_Original__c,Sched_Hours_Job__c,Id, Birth_Date__c,IND_Basic_Salary_Amount__c,Base_Annual_Amount__c   ,Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c,
                   Emp_ID__c, age__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c,Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                   Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c, 
                   DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c,Days_of_Perm_Serv_Total_LOS__c, 
                   Login_Id_Directory__c, Name, Empl_Type_Job__c, Ethnic_Group__c, Gender__c, Jobcode_Job__c, Status__c,CA_Flag__c,
                   Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c, City_Home__c, State_Home__c, Zip_Home__c,Phone_Area_Code_Home__c, Phone_Number_Home__c 
               from Employee__c
               where id in :empRecordIds ]);     //MSN:RIF#117 Added Job_State_Job__c,Job_Title__c,Job_Title_Dsc_Job__c,DOH_Original__c,Sched_Hours_Job__c in query 4th April 18
    }
    
    public static List<Employee__c> getEmployee(String empRecordIds){
      return getEmployeeList(new Set<String>{empRecordIds}).values();       
    }
    public static Employee__c getSingleEmployeeRecord(String empRecordId){
      return [select Id, IND_Basic_Salary_Amount__c,Base_Annual_Amount__c,Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c,
                   Emp_ID__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c,Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                   Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c, 
                   DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c,Days_of_Perm_Serv_Total_LOS__c, 
                   Login_Id_Directory__c, Name, Empl_Type_Job__c, Ethnic_Group__c, Gender__c, Jobcode_Job__c, Status__c,
                   Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c, City_Home__c, State_Home__c, Zip_Home__c  
               from Employee__c
               where Emp_ID__c=:empRecordId];          
    }
    // 26-Sep-2016 : Defect#1792 : Allow for override of HR Contact & HR Signatory
    public static List<Employee__c> getEmpRecForHR(String empRecordId){
        List<Employee__c> retList = [SELECT Id,Emp_ID__c,Name 
                                     FROM Employee__c
                                     WHERE Emp_ID__c =: empRecordId];     
        return retList;
    }
    
    // 19-Sep-2016 : Defect#1792 : Allow for override of HR Contact & HR Signatory
    // Added new method to check if the employee entered in the CSV belongs to 81200 CC and is Active
    public static Boolean isValidHREmp(String empRecordId){
      Boolean isValidHR = false;
      List<Employee__c> results = new List<Employee__c>();
      results = [SELECT Id FROM Employee__c WHERE Emp_ID__c =: empRecordId AND Status__c = 'Active' AND Dept_Org__c = '81200'];  
      if(results != null && !results.isEmpty()){
            isValidHR = true;
      }
        return isValidHR;
    }
    // 2-Nov-2016 : ALM#1792 : Allow for override of HR Contact & HR Signatory
    // get all the valid HRs in the system
    public static Map<String,String> getAllValidHREmployees(){
        Map<String,String> allHRsMap = new Map<String,String>();
        List<Employee__c> allRes = new List<Employee__c>();
        allRes = [SELECT Id,Emp_ID__c FROM Employee__c WHERE Status__c = 'Active' AND Dept_Org__c = '81200'];
        if(!allRes.isEmpty()){
            for(Employee__c eachEmp : allRes){
                allHRsMap.put(eachEmp.Emp_ID__c, eachEmp.Id);
            }
        }
        return allHRsMap;
    }
    
    public static void copyFieldsToSRFromEmployee(Severance_And_Release__c sr, Employee__c emp){
        if(emp <> null){
            sr.Employee__c = emp.id; 
            sr.Emp_Id__c=emp.Emp_ID__c;
            sr.Cost_Center__c = emp.Cost_Center__c ;
            sr.Cost_Center_Desc__c = emp.Cost_Center_Desc__c;             
            sr.Department__c = emp.Dept_Org__c;
            sr.Department_Desc__c = emp.Dept_Dsc_Org__c; 
            sr.Division__c = emp.Division_Org__c;
            sr.Division_Desc__c = emp.Division_Dsc_Org__c; 
            sr.Level__c = emp.Level_Job__c; 
            sr.Job_Region__c = emp.Region_Dsc_Org__c; 
            sr.Sub_Department__c = emp.Subdept_Org__c;  
            sr.Sub_Department_Desc__c = emp.Subdept_Dsc_Org__c; 
            sr.Sub_Department_2__c = emp.Sub_Depart2_Org__c;
            sr.Sub_Department_2_Desc__c = emp.Sub_Depart2_Dsc_Org__c;
            sr.Super_Department__c = emp.Super_Depart_Org__c;
            sr.Super_Department_Desc__c = emp.Super_Depart_Dsc_Org__c; 
            sr.Super_Division__c = emp.Super_Division__c;
            sr.Super_Division_Desc__c = emp.Super_Division_Dsc_Org__c;
            //sr.Days_of_Perm_Serv_Total_LOS__c = emp.Days_of_Perm_Serv_Total_LOS__c;
            sr.DOH_Recent__c = emp.DOH_Recent__c;
            sr.Country__c = emp.Job_Country_Job__c;
            sr.MS_MSSB__c = emp.MS_MSSB__c;
            sr.Level_Desc__c = emp.Level_Dsc_Job__c;
            //MSN:RIF#121 Changes 4th April 2018 - Starts
            sr.Job_State_Job__c  = emp.Job_State_Job__c;
            sr.Job_Title__c = emp.Job_Title__c;
            sr.Job_Title_Dsc_Job__c = emp.Job_Title_Dsc_Job__c;
            sr.DOH_Original__c = emp.DOH_Original__c;
            sr.Sched_Hours_Job__c = emp.Sched_Hours_Job__c;
            //MSN:RIF#121 Changes 4th April 2018 - Ends
            
            /*sr.Address_1_Home__c = emp.Address_1_Home__c;
            sr.Address_2_Home__c = emp.Address_2_Home__c;
            sr.Address_3_Home__c = emp.Address_3_Home__c;
            sr.Address_4_Home__c = emp.Address_4_Home__c;
            sr.City_Home__c = emp.City_Home__c;
            sr.State_Home__c = emp.State_Home__c;
            sr.Zip_Home__c = emp.Zip_Home__c;*/     
            
            //Added by Anshul on 27 october 2015
            //if(emp.IND_Basic_Salary_Amount__c != ''){
               //sr.Base_Salary__c = Decimal.valueOf(emp.IND_Basic_Salary_Amount__c.trim()).setScale(2);
               //System.debug('##sr.Base_Salary__c##'+sr.Base_Salary__c); 
               //sr.Base_Salary__c =  Decimal.valueOf(emp.IND_Basic_Salary_Amount__c);
                /*if(emp.IND_Basic_Salary_Amount__c.contains(','))
                    string temp= emp.IND_Basic_Salary_Amount__c.replaceall(',','');}
                    Pattern dollarPattern = Pattern.compile('[\\p{Sc}]');
                    string s = dollarPattern.matcher(temp).replaceAll('');
                    sr.Base_Salary__c = decimal.valueof(s);
                    System.debug('####'+sr.Base_Salary__c); */ 
            //}
            
        }
    }
    //method to calculate formula fields on s&R
    public static void calculateFormulaValuesOnSR(Severance_And_Release__c sr, Employee__c emp,Project_Level__c pl){  
        //System.debug('sr.age*****from employee:'+sr.age__c);
        //calculate Weekly Rate
        //if(sr.Base_Salary_Override__c != null && Decimal.valueOf(sr.Base_Salary_Override__c) > 0) 
            //sr.Weekly_Rate__c = String.valueOf((Decimal.valueOf(sr.Base_Salary_Override__c)/52).setScale(2));
        //else
            //sr.Weekly_Rate__c = String.valueOf((Decimal.valueOf(sr.Base_Salary__c)/52).setScale(2));
            
        //calculate DailyRate
        //system.debug('######communication date of project inside calculateFormulaValuesOnSR()######'+pl.Project__r.Communication_Date__c);
        /*if(pl.Project__r.Communication_Date__c != null && sr.Base_Salary_Override__c  != null && Decimal.valueOf(sr.Base_Salary_Override__c) > 0){
            if(Date.isLeapYear(pl.Project__r.Communication_Date__c.year())){
                sr.Daily_Rate__c = String.valueOf((decimal.valueOf(sr.Base_Salary_Override__c)/366).setScale(2));
            }
            else if(!Date.isLeapYear(pl.Project__r.Communication_Date__c.year())){
                sr.Daily_Rate__c = String.valueOf((decimal.valueOf(sr.Base_Salary_Override__c)/365).setScale(2));
            }
        } */
        /*if(pl.Project__r.Communication_Date__c != null && sr.Base_Salary__c  != null && Decimal.valueOf(sr.Base_Salary__c) > 0) {     
            
            if(Date.isLeapYear(pl.Project__r.Communication_Date__c.year())){
                    sr.Daily_Rate__c = String.valueOf((decimal.valueOf(sr.Base_Salary__c)/366).setScale(2));
            }
            else if( !Date.isLeapYear(pl.Project__r.Communication_Date__c.year())){
                    sr.Daily_Rate__c = String.valueOf((decimal.valueOf(sr.Base_Salary__c)/365).setScale(2));
            }
        } */      
        //calculate cobra1Month
        /*IF(Project_Level__r.Severance_Parameters__r.Cobra_One_Month__c > 500,
            Project_Level__r.Severance_Parameters__r.Cobra_One_Month__c, 
        500)*/
        /*sr.Cobra_One_Month__c = String.valueOF(500);
        if(Decimal.valueOf(sr.Cobra_Grossup_Amount_Cobra__c) > 500) {
            sr.Cobra_One_Month__c = sr.Cobra_Grossup_Amount_Cobra__c; 
        }*/
        
        //Additional LOS Days
        //Last_Day_On_Premises__c - Communicated_Date__c
        /*sr.Additional_LOS_Days1__c = String.valueOf(0);
        if(sr.Last_Day_On_Premises__c != null && sr.Communicated_Date__c != null) {
            sr.Additional_LOS_Days1__c = String.valueOf(sr.Last_Day_On_Premises__c.daysBetween(sr.Communicated_Date__c));
        }*/
        
        // (Doubt)LOS
        //Days_of_Perm_Serv_Total_LOS__c + Additional_LOS_Days__c)/365.25
        //sr.LOS_1__c = String.valueOf(((Decimal.valueOf(sr.Days_of_Perm_Serv_Total_LOS__c) + Decimal.valueOf(sr.Additional_LOS_Days1__c))/365.25).setScale(2)); 

        //Basic Severance Local
        //Daily_Rate__c * LOS__c * Project_Level__r.Weekly_Mulitple__c
         //sr.Basic_Severance_Local__c =  String.valueOf((Decimal.valueOf(sr.Daily_Rate__c) * Decimal.valueOf(sr.LOS_1__c) * pl.Weekly_Mulitple__c).setScale(2));  
        //Additional Severance
        //if(sr.Additional_Severance1__c != null)
            //sr.Additional_Severance1__c = String.valueOf((Decimal.valueOf(sr.Additional_Severance1__c)).setScale(2));
        //else
           //sr.Additional_Severance1__c = String.valueOf(0);
        //Basic & Additional Severance  
        //sr.Basic_Additional_Severance__c = String.valueOf((decimal.valueOf(sr.Basic_Severance_Local__c)).setScale(2) + (decimal.valueOf(sr.Additional_Severance1__c)).setScale(2));
        //sr.Basic_Additional_Severance__c = String.valueOf((decimal.valueOf(sr.Basic_Severance_Local__c)).setScale(2));
        //Notice Days
        //IF(TEXT(Project_Level__r.Notice_Calc__c) = "Last Day On Premises", (Termination_Date__c - Last_Day_On_Premises__c)+1, (Termination_Date__c - Communication_Date__c)+1)
        
        /*if(pl.Notice_Calc__c == 'Last Day On Premises' )
            sr.Notice_Days_1__c = String.valueOf(Integer.valueOf(sr.Last_Day_On_Premises__c.daysBetween(sr.Termination_Date__c)) + 1) ;
        else
           sr.Notice_Days_1__c = String.valueOf(Integer.valueOf(sr.Communication_Date__c.daysBetween(sr.Termination_Date__c)) + 1) ;
          */        
        
        //Notice Amount:IF( NOT(ISBLANK(Notice_Days_Override__c)), Notice_Days_Override__c* Daily_Rate__c, Notice_Days_1__c * Daily_Rate__c )
        /*if(sr.Notice_Days_1__c != null )
            sr.Notice_Amount__c = String.valueOf((Decimal.valueOf(sr.Notice_Days_1__c) * Decimal.valueOf(sr.Daily_Rate__c)).setScale(2));
         */
        //(Doubt)Base Severance Weeks
        /* "IF(Project_Level__r.Project__r.Name  = ""Project Hastings"", 
        (Project_Level__r.Sev_Weeks__c * LOS__c) + Project_Level__r.Basic_Max__c,
        Project_Level__r.Sev_Weeks__c * LOS__c
        )"
        */
        //if(pl.Project__r.Name  == 'Project Hastings')
            //sr.Base_Severance_Weeks__c = String.valueOf((pl.Sev_Weeks__c * Decimal.ValueOF(sr.LOS_1__c)) + Decimal.ValueOF(pl.Basic_Max__c));
        //else
        //sr.Base_Severance_Weeks__c =String.valueOf((pl.Sev_Weeks__c * Decimal.valueOF(sr.LOS_1__c)).setScale(2));
        //Total Week of Severance
        /*IF(Base_Severance_Weeks__c < Project_Level__r.Sev_Weeks_Min__c, Project_Level__r.Sev_Weeks_Min__c, 
        IF(Base_Severance_Weeks__c > Project_Level__r.Sev_Weeks_Max__c, Project_Level__r.Sev_Weeks_Max__c, Base_Severance_Weeks__c ))
        */
        /*if(Decimal.valueOF(sr.Base_Severance_Weeks__c).setScale(2) < pl.Sev_Weeks_Min__c)
            sr.Total_Week_Of_Severance__c=String.valueOf(pl.Sev_Weeks_Min__c);
        else if(Decimal.valueOF(sr.Base_Severance_Weeks__c).setScale(2) > pl.Sev_Weeks_Max__c)  
            sr.Total_Week_Of_Severance__c=String.valueOf(pl.Sev_Weeks_Max__c);
        else
            sr.Total_Week_Of_Severance__c=sr.Base_Severance_Weeks__c;*/
        //Cobra (Cobra_1_Month__c * Project_Level__r.Cobra_Months__c)
        //sr.Cobra__c=String.valueOF((Decimal.valueOf(sr.Cobra_One_Month__c)*pl.Cobra_Months__c).setScale(2));
        //Enhanced severance
        /*
        "IF(Project_Level__r.Enhanced_Percent__c = 1.1,
        (Termination_Date__c - DATE(2009,12,31) )* Additional_Comp__c/365,
        Additional_Comp__c*Project_Level__r.Enhanced_Percent__c
        )"
        
        */
        /*if(sr.Additional_Comp1__c!=null && pl.Enhanced_Percent__c!=null){
            if(pl.Enhanced_Percent__c == 1.1)
                sr.Enhanced_Severance_Local__c=string.valueOf(((Date.newInstance(2009,12,31).daysBetween(sr.Termination_Date__c) )* Decimal.valueOf(sr.Additional_Comp1__c)/365).setScale(2))   ;
           else
                sr.Enhanced_Severance_Local__c=String.valueOf((Decimal.valueOf(sr.Additional_Comp1__c)*pl.Enhanced_Percent__c).setScale(2));
        }*/
        //sr.Notice_Amount_Override__c=String.valueOf((decimal.valueOf(sr.Base_Salary__c)/365*100).setScale(2)+Decimal.valueOf(sr.Base_Severance_Weeks__c));
    }
    
   
    //method to convert string value into currency
    public static String convertStringToCurrency(String i) {
        String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
        return s.substring(0,s.length()-1);
    }
    public static void copyFieldsToSRFromProjectLevelAndProject(Severance_And_Release__c sr,Project_Level__c projLevel){
        system.debug('-----------------'+sr);
        system.debug('----------####projLevel.Project__r.Communication_Date__c-------'+projLevel.Project__r.Communication_Date__c);
        system.debug('-----------#####projLevel.Project__r.Termination_Date__c------'+projLevel.Project__r.Termination_Date__c);
        if(projLevel.Project__r.Communication_Date__c <> null){  //&& projLevel.Project__r.Notice_Days__c <> null
            //sr.Communication_Date__c = projLevel.Project__r.Communication_Date__c;
            //sr.Last_Day_On_Premises__c = projLevel.Project__r.Termination_Date__c;
            //sr.Termination_Date__c =projLevel.Project__r.Termination_Date__c; 
              
        }
        //sr.Recalculation_Type__c = CALCULATE_AND_OVERRIDE_MANUAL_CHANGES;
        sr.Outplacement__c = projLevel.Outplacement__c;  
        System.debug('##End of copyFieldsToSRFromProjectLevelAndProject()###'+'comm date:'+projLevel.Project__r.Communication_Date__c+'term date:'+projLevel.Project__r.Termination_Date__c); 
        
    } 
    
    public static void copyFieldsToSRFromUnvestedEquity(Severance_And_Release__c sr, Unvested_Equity__c unvestedEquity){
        if(unvestedEquity <> null){
            //sr.Conga_Total_Unvested_Value__c =unvestedEquity.unvested_total_balance__c;
            sr.Conga_Total_Unvested_Value__c =unvestedEquity.Unvested_total_balance__c; 
            sr.Unvested_As_of_Date__c =unvestedEquity.Date_as_of__c; 
            
        }
    } 
    
    public static List<Project__c> getProject(string projectId){
        return getProjectList( new list<string> {ProjectId});
    }
    
    public static List<Project__c> getProjectList(List<string> projectIds){
        return [SELECT Id, Name, CurrencyIsoCode, RecordTypeId, S_R_Warn_Count__c, Template__c, WARN__c, 
                Is_NonUS__c, Country__c,Notice_Days__c, Communication_Date__c,Termination_Date__c, Primary_Key__c, Super_Division__c,status__c
                from Project__c 
                where id in: projectIds];
    }
     public static List<Project__c> getProjectListFromIds(set<id> projectIds){
        return [SELECT Id, Name, CurrencyIsoCode, RecordTypeId, S_R_Warn_Count__c, Template__c, WARN__c, 
                Is_NonUS__c, Country__c,Notice_Days__c, Communication_Date__c,Termination_Date__c, Primary_Key__c, Super_Division__c,status__c
                from Project__c 
                where id in: projectIds];
    }
    
    public static list<Project__c> getProjectListOnRecordTypeName(string recordTypeName){
        return [SELECT Id, Name, CurrencyIsoCode, RecordTypeId, S_R_Warn_Count__c, Template__c, WARN__c,
                       Is_NonUS__c, Country__c,Notice_Days__c, Communication_Date__c,Termination_Date__c, Primary_Key__c
                from Project__c 
                where RecordType.Name =: recordTypeName 
                and Status__c = 'Active'];
    }
    
    public static List<Severance_And_Release__c> getSeveranceAndReleaseList(List<string> SRIds){
        return [select id, Project_Level__c, Project_Level__r.Project__c, Project_Level__r.Project__r.RecordTypeId ,project__r.RecordTypeId
                from Severance_And_Release__c 
                where Id in :SRIds]; 
    }
    public static List<Severance_And_Release__c> getSeveranceAndReleaseListFromSetIds(set<id> SRIds){
        return [select id, Project_Level__c, Project_Level__r.Project__c, Project_Level__r.Project__r.RecordTypeId ,project__r.RecordTypeId,project__c 
                from Severance_And_Release__c  
                where Id in :SRIds];  
    }
    /*public static Map<id,id> getsrToDecUnitIDMapByProjectDecUnits(Set <id> decUnitIds){
       Map<id,id> srToDecUnitIDMap=new  Map<id,id>();
       for(Severance_And_Release__c severanceObj: [select id, Decisional_Unit__c,Project_Decisional_Org_Level__c,Project_Level__c, Project_Level__r.Project__c, Project_Level__r.Project__r.RecordTypeId 
                from Severance_And_Release__c where Decisional_Unit__c in :decUnitIds]){ 
            srToDecUnitIDMap.put(severanceObj.id,severanceObj.Decisional_Unit__c);            
                                    
       }
       return srToDecUnitIDMap;  
    }*/
    //added on Nov 25,2015 for getting employee record based on logged in User sf ID
     /*public static Employee__c  getEmpForUserID(String userID){
                Employee__c  empRecord_loggedInUser=[select id,name,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:userID];
        return empRecord_loggedInUser;
     } */
    //added on Nov 25,2015 for checking the logged in user has coverage entitlement to view the current employee record
     public static boolean checkEmpCompDataVisibility(String userID,Employee__c empRecord){
                Employee__c  empRecord_loggedInUser=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:userID];
                Coverage_Entitlement__c covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_User__c,HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empRecord_loggedInUser.id limit 1];
                System.debug('####covEntitlementObj####'+covEntitlementObj);
                boolean showEmpCompDataFlag=false;
                if(covEntitlementObj==null ) 
                    showEmpCompDataFlag=false;
                else if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                    //System.debug('### covEntitlementObj.HR_Coverage_Orgs__r'+covEntitlementObj.HR_Coverage_Orgs__r);
                    Map <string,set <string>> covTypeToCodeMap= new Map <string,set <string>> ();
                    for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                        //covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covEntOrg.Coverage_Entitlement_Org_Code_Derived__c );
                        if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                            set<String> covCodeSet=new set<String>();
                            covCodeSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covCodeSet);
                        }  
                        else{
                            covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c).add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                        }        
                    }
                    //system.debug('####covEntitlementObj####'+covTypeToCodeMap.get('Super Division'));
                    //system.debug('###empRecord_loggedInUser.Super_Division__c####'+empRecord_loggedInUser.Super_Division__c);
                    if( (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(empRecord.Super_Division__c)) )  
                         showEmpCompDataFlag=true;  
                    else if( (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(empRecord.Division_Org__c)) )  
                         showEmpCompDataFlag=true; 
                    else if( (covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(empRecord.Super_Depart_Org__c)) )  
                         showEmpCompDataFlag=true;    
                    else if( (covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(empRecord.Dept_Org__c)) )  
                         showEmpCompDataFlag=true;  
                    else if( (covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(empRecord.Subdept_Org__c)) )    
                         showEmpCompDataFlag=true; 
                    else if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(empRecord.Sub_Depart2_Org__c)) )      
                        showEmpCompDataFlag=true;
                    else if( (covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(empRecord.Cost_Center__c)) )   
                        showEmpCompDataFlag=true; 
                    
                }
                else if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()==0)
                    showEmpCompDataFlag=true;
                System.debug('####showEmpCompDataFlag in data util####'+showEmpCompDataFlag);  
                return showEmpCompDataFlag;
            
    }
    //added on Nov 25,2015 for checking the logged in user has any of the RIF permission set (HR covrage users,Ops users,comp users,doc admin users,hrint users or generic users based on the permission set assignment)
    public static boolean checkRIFUser(String userID){
        List<permissionsetAssignment> psaObj = new List<permissionsetAssignment>();
        // 31-Aug-17 : JIRA-29 : Added check for RIF Super user
          psaObj  =[select id,assigneeid,permissionsetid,permissionset.name from permissionsetAssignment where assigneeid =:userID and
                                        (permissionset.name='RIF_HR_Coverage' OR permissionset.name='RIF_HR_Operations' OR permissionset.name='RIF_HR_Compensation' OR
                                         permissionset.name='RIF_HR_International' OR permissionset.name='RIF_System_Admin' OR permissionset.name='RIF_Document_Admin' OR 
                                         permissionset.name='RIF_Generic_User' OR permissionset.name = 'RIF_Super_User')
                                        ];
        System.debug('HipsaObj--'+psaObj);
        if(psaObj!=null && !psaObj.isEmpty())
            return true;
        else
            return false;   
    }
    
    //added on 15 march 2016 for accessing all SR records
     public static List<Severance_And_Release__c> getAllSRRecords(String projID){
        List<Severance_And_Release__c> allSRRecords=new List<Severance_And_Release__c>();
        if(projID != null){
            allSRRecords=[select id,Emp_Id__c,Project__c,Communicated__c,Communicated_Date__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c,Communication_Date__c,Termination_Date__c,
                             Enhanced_Severance_Local_Override__c,Last_Day_On_Premises__c,DOH_Recent__c,Exhibit_A__c,Overnight_Package__c,Is_employee_eligible_for_rehire__c,Additional_Notice_Override__c, Additional_Severance_Override1__c,Base_Salary_Override__c,Basic_Severance_Local_Override__c,Notice_Amount_Override__c,
                            Cobra_Override__c, Status__c from Severance_And_Release__c where Project__c=:projID ];
        }
        return allSRRecords; 
            
     }
     //***************COMMENTED BY RAJEEV, USE BELOW METHOD*********************//
     /************************
     public static boolean checkOrgPDUEligibility(Child_Project_Decisional_Unit__c childPDU){
        boolean isOrgPduAccessible=false;
        Boolean addEmployee = false; 
        system.debug('####childPDU#####'+childPDU); 
        Employee__c  empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
        system.debug('####empObj#####'+empObj);    
        List<Coverage_Entitlement__c> covEntitlementList= new  List<Coverage_Entitlement__c>([select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1]);
        Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
        if(covEntitlementList!=null && covEntitlementList.size()>0){
            system.debug('####empObj#####'+covEntitlementList[0].HR_Coverage_Orgs__r); 
            for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementList[0].HR_Coverage_Orgs__r){
                if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                    set<String> tempSet=new set<String>();
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }  
                else{
                    set<String> tempSet=new set<String>();
                    tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                    //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }   
            }
        }
        system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap);
        // 31-Aug-2016 : Org Hierarchy changes      
        // system.debug('####childPDU.Decisional_Unit_Code__c#####'+childPDU.Decisional_Unit_Code__c);
        system.debug('####childPDU.Org_Hierarchy__c#####'+childPDU.Org_Hierarchy__c);
        // where code_type__c = 'Super Division' and code__c =:emprecord.Super_Division__c
        // 31-Aug-2016 : Org Hierarchy changes -- STARTS
         if(String.isNotBlank(childPDU.Decisional_Unit_Derived__c) && childPDU.Decisional_Unit_Type__c != 'Employee'){
             //Org_Codes__c orgCode = [SELECT Id,Name, Code_Type__c, Code__c from org_codes__c where id=:childPDU.Decisional_Unit_Code__c];
             // get all the codes from Org Hierarchy object
             //Org_Hierarchy__c orgHier = [SELECT Id,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Department_ID__c FROM Org_Hierarchy__c WHERE Id =: childPDU.Org_Hierarchy__c];
                if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(childPDU.Decisional_Unit_Derived__c)){  
                     isOrgPduAccessible=true;
                     system.debug('####childPDU.Decisional_Unit_Derived__c inside if loop for covTypeToCodeMap#####'+childPDU.Decisional_Unit_Derived__c);   
                }
                else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;   
                else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(childPDU.Decisional_Unit_Derived__c) )    
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Decisional_Unit_Derived__c) )      
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(childPDU.Decisional_Unit_Derived__c) )   
                     isOrgPduAccessible=true;
         }
         // 31-Aug-2016 : Org Hierarchy changes -- ENDS
         // 07-18-2016 : Check for the employee entry,  this will extract all org codes from the new employee and check it against the org codes of the HR or logged-in user
         // 31-Aug-2016 : Org Hierarchy changes
         //else if(String.isBlank(childPDU.Decisional_Unit_Code__c) && childPDU.Decisional_Unit_Type__c == 'Employee'){
            // TODO add other additional checks with employee
             else if(childPDU.Decisional_Unit_Type__c == 'Employee'){
             Set<String> empOrgCodesSet = new Set<String>();
             List<Employee__c> newEmp = [SELECT Id,Dept_Org__c,Division_Org__c,Sub_Depart2_Org__c,Subdept_Org__c,Super_Depart_Org__c,Super_Division__c,Cost_Center__c FROM Employee__c WHERE Id =: childPDU.Employee__c];
             for(Employee__c eachEmp : newEmp){
                 empOrgCodesSet.add(eachEmp.Dept_Org__c);
                 empOrgCodesSet.add(eachEmp.Division_Org__c);
                 empOrgCodesSet.add(eachEmp.Sub_Depart2_Org__c);
                 empOrgCodesSet.add(eachEmp.Subdept_Org__c);
                 empOrgCodesSet.add(eachEmp.Super_Depart_Org__c);
                 empOrgCodesSet.add(eachEmp.Super_Division__c);
                 empOrgCodesSet.add(eachEmp.Cost_Center__c);
             } 
             for(Set<String> each : covTypeToCodeMap.values()){
                 for(String eachOrg : each){
                    if(empOrgCodesSet.contains(eachOrg)){
                        isOrgPduAccessible = true;
                    }
                 }
             }
         }
        system.debug('####isOrgPduAccessible#####'+isOrgPduAccessible); 
        return isOrgPduAccessible;      
     }
     **********************/
     
     /**********METHOD TO CORRECTLY IDENTIFY COVERAGE ENTITLEMENT AFTER ORG FEED IS IN PLACE ********************/
     public static boolean checkOrgPDUEligibility(Child_Project_Decisional_Unit__c childPDU){
        boolean isOrgPduAccessible=false;
        Boolean addEmployee = false; 
        system.debug('####childPDU#####'+childPDU); 
        Employee__c  empObj;
         
         if(!RIF_OrgHierarchySharingRecalBatch.batch){
             empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
         }
         else{
             String userId = [select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN (select id from permissionset where name='RIF_System_Admin') LIMIT 1].assigneeid;
             empObj=[select id from Employee__c where User__c=:userId limit 1];
         }
           
        system.debug('####empObj#####'+empObj);    
        List<Coverage_Entitlement__c> covEntitlementList= new  List<Coverage_Entitlement__c>([select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1]);
        Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
        if(covEntitlementList!=null && covEntitlementList.size()>0){
            system.debug('####empObj#####'+covEntitlementList[0].HR_Coverage_Orgs__r); 
            for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementList[0].HR_Coverage_Orgs__r){
                if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                    set<String> tempSet=new set<String>();
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }  
                else{
                    set<String> tempSet=new set<String>();
                    tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                    //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }   
            }
        }
        
        string strWhereClause = '';
        if(String.isNotBlank(childPDU.Decisional_Unit_Type__c) && string.isNotBlank(childPDU.Decisional_Unit_Derived__c)){

            if(childPDU.Decisional_Unit_Type__c == 'Super Division')
                strWhereClause = 'Super_Division__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Division')
                strWhereClause = 'Division__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Super Department')
                strWhereClause = 'Super_Department__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Department')
                strWhereClause = 'Department__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Sub Department')
                strWhereClause = 'Sub_Department__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Sub Department 2')
                strWhereClause = 'Sub_Department_2__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Cost Center')
                strWhereClause = 'Department_ID__c';
            
            /***********
            if(childPDU.Decisional_Unit_Type__c == 'Super Division')
                strWhereClause = 'Super_Division__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Division')
                strWhereClause = 'Division__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Super Department')
                strWhereClause = 'Super_Department__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Department')
                strWhereClause = 'Department__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Sub Department')
                strWhereClause = 'Sub_Department__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Sub Department 2')
                strWhereClause = 'Sub_Department_2__c =childPDU.Decisional_Unit_Derived__c';
            else if(childPDU.Decisional_Unit_Type__c == 'Cost Center')
                strWhereClause = 'Department_ID__c =childPDU.Decisional_Unit_Derived__c';
                **************/
                //Think about Employee???
        }
        
        string strQuery = '';
        //List<Org_Hierarchy__c> lstOrgHierarchy = new List<Org_Hierarchy__c> ();

        if(childPDU.Decisional_Unit_Type__c != 'Employee'){
            strQuery = 'SELECT Id,Name, Super_Division__c, Super_Division_Description__c, Division__c, Division_Description__c, Super_Department__c, Super_Department_Description__c, Department__c,'; 
            strQuery += ' Department_Description__c, Sub_Department__c, Sub_Department_Description__c, Sub_Department_2__c, Sub_Department_2_Description__c, Department_ID__c,'; 
            strQuery += ' Cost_Center_Description__c from org_hierarchy__C where Effective_Status__c = true and ' + strWhereClause + '=\''+ childPDU.Decisional_Unit_Derived__c +'\' limit 1';
            system.debug('***************************strQuery:'+strQuery);
            List<Org_Hierarchy__c> lstOrgHierarchy = database.query(strQuery);
                                                            
            //if(!lstOrgHierarchy.isEmplty()){
                for(Org_Hierarchy__c oH: lstOrgHierarchy){
                    if(String.isNotBlank(childPDU.Decisional_Unit_Derived__c) && childPDU.Decisional_Unit_Type__c != 'Employee'){   
                        for(string s: covTypeToCodeMap.keyset()){
                            if(covTypeToCodeMap.get(s).contains(oH.Department_ID__c) || covTypeToCodeMap.get(s).contains(oh.sub_department_2__c) || covTypeToCodeMap.get(s).contains(oh.Sub_Department__c)
                            || covTypeToCodeMap.get(s).contains(oH.Department__c) || covTypeToCodeMap.get(s).contains(oH.Super_Department__c) || covTypeToCodeMap.get(s).contains(oH.Division__c)
                            || covTypeToCodeMap.get(s).contains(oH.Super_Division__c) ){

                                isOrgPduAccessible=true;
                                system.debug('####childPDU.Decisional_Unit_Derived__c inside if loop for covTypeToCodeMap#####'+childPDU.Decisional_Unit_Derived__c);   
                            }
                        }
                        
                    }
                }
            //}
        }             
      /****************************  
        system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap);
        // 31-Aug-2016 : Org Hierarchy changes      
        // system.debug('####childPDU.Decisional_Unit_Code__c#####'+childPDU.Decisional_Unit_Code__c);
        system.debug('####childPDU.Org_Hierarchy__c#####'+childPDU.Org_Hierarchy__c);
        // where code_type__c = 'Super Division' and code__c =:emprecord.Super_Division__c
        // 31-Aug-2016 : Org Hierarchy changes -- STARTS
         if(String.isNotBlank(childPDU.Decisional_Unit_Derived__c) && childPDU.Decisional_Unit_Type__c != 'Employee'){
             //Org_Codes__c orgCode = [SELECT Id,Name, Code_Type__c, Code__c from org_codes__c where id=:childPDU.Decisional_Unit_Code__c];
             // get all the codes from Org Hierarchy object
             //Org_Hierarchy__c orgHier = [SELECT Id,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Department_ID__c FROM Org_Hierarchy__c WHERE Id =: childPDU.Org_Hierarchy__c];
                if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(childPDU.Decisional_Unit_Derived__c)){  
                     isOrgPduAccessible=true;
                     system.debug('####childPDU.Decisional_Unit_Derived__c inside if loop for covTypeToCodeMap#####'+childPDU.Decisional_Unit_Derived__c);   
                }
                else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;   
                else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(childPDU.Decisional_Unit_Derived__c) )  
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(childPDU.Decisional_Unit_Derived__c) )    
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Decisional_Unit_Derived__c) )      
                     isOrgPduAccessible=true;  
                else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(childPDU.Decisional_Unit_Derived__c) )   
                     isOrgPduAccessible=true;
         }
         // 31-Aug-2016 : Org Hierarchy changes -- ENDS
         // 07-18-2016 : Check for the employee entry,  this will extract all org codes from the new employee and check it against the org codes of the HR or logged-in user
         // 31-Aug-2016 : Org Hierarchy changes
         //else if(String.isBlank(childPDU.Decisional_Unit_Code__c) && childPDU.Decisional_Unit_Type__c == 'Employee'){
            // TODO add other additional checks with employee
            ********************/
             else if(childPDU.Decisional_Unit_Type__c == 'Employee'){
             //if(childPDU.Decisional_Unit_Type__c == 'Employee'){
                 Set<String> empOrgCodesSet = new Set<String>();
                 List<Employee__c> newEmp = [SELECT Id,Dept_Org__c,Division_Org__c,Sub_Depart2_Org__c,Subdept_Org__c,Super_Depart_Org__c,Super_Division__c,Cost_Center__c FROM Employee__c WHERE Id =: childPDU.Employee__c];
                 for(Employee__c eachEmp : newEmp){
                     empOrgCodesSet.add(eachEmp.Dept_Org__c);
                     empOrgCodesSet.add(eachEmp.Division_Org__c);
                     empOrgCodesSet.add(eachEmp.Sub_Depart2_Org__c);
                     empOrgCodesSet.add(eachEmp.Subdept_Org__c);
                     empOrgCodesSet.add(eachEmp.Super_Depart_Org__c);
                     empOrgCodesSet.add(eachEmp.Super_Division__c);
                     empOrgCodesSet.add(eachEmp.Cost_Center__c);
                 } 
                 for(Set<String> each : covTypeToCodeMap.values()){
                     for(String eachOrg : each){
                        if(empOrgCodesSet.contains(eachOrg)){
                            isOrgPduAccessible = true;
                        }
                     }
                 }
         }
        system.debug('####isOrgPduAccessible#####'+isOrgPduAccessible); 
        return isOrgPduAccessible;      
     }
     
     // 31-Aug-2016 : Org Hierarchy changes - Commenting the whole method as this validation will not be relevent now
    // 07-18-2016 : Method to perform basic validations on project decision unit org record
    /*public static String checkOrgPDUFields(Child_Project_Decisional_Unit__c childPDU){
        String errorMsg = '';
        if(childPDU.Decisional_Unit_Type__c == 'Employee' && (String.isBlank(childPDU.Employee__c))){
            errorMsg = 'Please select an Employee for this Decisional Unit Type';
            return errorMsg;
        }
        else if(childPDU.Decisional_Unit_Type__c != 'Employee' && (String.isBlank(childPDU.Decisional_Unit_Code__c))){
            errorMsg = 'Please select a Decisional Unit Code';
            return errorMsg;
        }
        return errorMsg;
    } */
     public static boolean getAccessibleEmployee(Employee__c emp){ 
        
        
        boolean isemployeeAccessible=false;
        Employee__c  empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
            
        List<Coverage_Entitlement__c> covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
        Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
        if(covEntitlementObj!=null){
            for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj[0].HR_Coverage_Orgs__r){
                if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                    set<String> tempSet=new set<String>();
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }  
                else{
                    set<String> tempSet=new set<String>();
                    tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                    //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                }   
            }
        }
        system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap); 
        if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(emp.Super_Division__c.trim())){  
             isemployeeAccessible=true;
             system.debug('####emp.Super_Division__c inside if loop for covTypeToCodeMap#####'+emp.Super_Division__c);   
        }
        else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(emp.Division_Org__c.trim()) )  {
             isemployeeAccessible=true;  
             system.debug('####emp.Division_Org__c inside if loop for covTypeToCodeMap#####'+emp.Division_Org__c);   
        }
        else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(emp.Super_Depart_Org__c.trim()) )  
             isemployeeAccessible=true;   
        else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(emp.Dept_Org__c.trim()) )  
             isemployeeAccessible=true;  
        else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(emp.Subdept_Org__c.trim()) )    
             isemployeeAccessible=true;  
        else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(emp.Sub_Depart2_Org__c.trim()) )      
             isemployeeAccessible=true;  
        else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(emp.Cost_Center__c.trim()) )   
             isemployeeAccessible=true;
        else
            isemployeeAccessible=false;
            System.debug('###########isemployeeAccessible###########'+isemployeeAccessible);
        return isemployeeAccessible;  
                
     }
     
     
     
     //added on 12 May 2016 for checking particular S&R record exist in HR COmp or Op User entitlement
     public static Set <id> checkSRRecordAccessibleForUser( List <Severance_And_Release__c> listSR,String userID){        
        Set <id> accessibleSRIds= new Set <id>();  
        
        Employee__c  empObj;
        if(userID != null && !Test.isRunningTest()) {
            empObj=[select id from Employee__c where User__c=:userID limit 1];
            Coverage_Entitlement__c covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,
                                                Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c
                                                 from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
               
            if(listSR!=null && listSR.size()>0 && covEntitlementObj!=null  && covEntitlementObj.HR_Coverage_Orgs__r != null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                    Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
                    for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                        if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                            set<String> tempSet=new set<String>();
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }  
                        else{
                            set<String> tempSet=new set<String>();
                            tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                            //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }   
                    }
                    system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap); 
                    for(Severance_And_Release__c sr: listSR){
                        if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c)){  
                             accessibleSRIds.add(sr.id);
                             //system.debug('####sr.Super_Division__c inside if loop for covTypeToCodeMap#####'+sr.Super_Division__c);   
                        }
                        else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(sr.Division__c) )  
                            accessibleSRIds.add(sr.id);  
                        else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c) )  
                             accessibleSRIds.add(sr.id);  
                        else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(sr.Department__c) )  
                            accessibleSRIds.add(sr.id); 
                        else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c) )    
                             accessibleSRIds.add(sr.id);  
                        else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c) )      
                             accessibleSRIds.add(sr.id);  
                        else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c) )   
                             accessibleSRIds.add(sr.id);
                                     
                    }
                  covTypeToCodeMap.clear();
                  
            }
        }
        return accessibleSRIds;
     }
     //added on Nov 17,2015 for getting SR records as per coverage entitlements
     public static List<Severance_And_Release__c> getAccessibleSRRecordsFromSRList(List <Severance_And_Release__c> srList){
        List<Severance_And_Release__c> accessibleSRList=new List<Severance_And_Release__c>();
        
        //if(projID != null){
            
            Map<Id,Permissionset> sysAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
            
            //List<permissionsetAssignment> isSysadmin=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:sysAdminPermissionMap.keyset() AND assigneeid=:userinfo.getuserID() ];
            List<permissionsetAssignment> isSysadmin=[select id from permissionsetAssignment where permissionsetid IN:sysAdminPermissionMap.keyset() AND assigneeid=:userinfo.getuserID() ];
            
            //Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:Userinfo.getuserID()];
            sysAdminPermissionMap.clear();
            Employee__c  empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
            
            List<Coverage_Entitlement__c> covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
            
            
            system.debug('#####All srlist####'+srList.size());                                                                              
            /*if(srlist != null && srlist.size() >0 && covEntitlementObj != null && covEntitlementObj.size() >0 && ( covEntitlementObj[0].HR_Coverage_Orgs__r ==null || (covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size()==0)) ){
                accessibleSRList.addAll(srlist);  
            }*/
            if(isSysadmin != null && isSysadmin.size() >0){
                accessibleSRList.addAll(srlist);
            }
            else if(srlist != null && srlist.size() >0 && covEntitlementObj!=null && covEntitlementObj.size() >0 && covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size()>0){
                Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
                for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj[0].HR_Coverage_Orgs__r){
                    if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                        set<String> tempSet=new set<String>();
                        tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                    }  
                    else{
                        set<String> tempSet=new set<String>();
                        tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                        tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                        //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                    }   
                }
                system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap); 
                for(Severance_And_Release__c sr: srlist){
                    if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c)){  
                         accessibleSRList.add(sr);
                         system.debug('####sr.Super_Division__c inside if loop for covTypeToCodeMap#####'+sr.Super_Division__c);   
                    }
                    else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(sr.Division__c) )  
                         accessibleSRList.add(sr);  
                    else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c) )  
                         accessibleSRList.add(sr);   
                    else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(sr.Department__c) )  
                         accessibleSRList.add(sr);  
                    else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c) )    
                         accessibleSRList.add(sr);  
                    else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c) )      
                         accessibleSRList.add(sr);  
                    else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c) )   
                         accessibleSRList.add(sr);             
                }
                covTypeToCodeMap.clear();
            }
            //isSysadmin.clear();
            //empObj = null;
            //covEntitlementObj.clear();
            //srlist.clear();

        //}    
         System.debug('### RIF_DataUtils.getAccessibleSRRecords::: accessibleSRList'+accessibleSRList.size());          
        return accessibleSRList;
    }
    
    //added on Nov 17,2015 for getting SR records as per coverage entitlements
    public static List<Severance_And_Release__c> getAccessibleSRRecords(String projID){
        List<Severance_And_Release__c> accessibleSRList=new List<Severance_And_Release__c>();
        
        if(projID != null){
            // 31-Aug-17 : JIRA#87 : RIF System admins will not longer see all the SNRs
            //Map<Id,Permissionset> sysAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
            
            //List<permissionsetAssignment> isSysadmin=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:sysAdminPermissionMap.keyset() AND assigneeid=:userinfo.getuserID() ];
            //List<permissionsetAssignment> isSysadmin=[select id from permissionsetAssignment where permissionsetid IN:sysAdminPermissionMap.keyset() AND assigneeid=:userinfo.getuserID() ];
            
            //Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:Userinfo.getuserID()];
            //sysAdminPermissionMap.clear();
            //MSN:Added try catch block 4th May
            try
            {
                Employee__c  empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
                
                List<Coverage_Entitlement__c> covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
                
                /**List<Severance_And_Release__c> srlist=new List<Severance_And_Release__c>([select id,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c,Communication_Date__c,Termination_Date__c,
Enhanced_Severance_Local_Override__c,Last_Day_On_Premises__c,DOH_Recent__c,Exhibit_A__c,Overnight_Package__c,Is_employee_eligible_for_rehire__c,Additional_Notice_Override__c, Additional_Severance_Override1__c,Base_Salary_Override__c,Basic_Severance_Local_Override__c,Notice_Amount_Override__c,
Cobra_Override__c from Severance_And_Release__c where Project__c=:projID Order by First_Name__c ASC]);
**/
                //system.debug('####covEntitlementObj####'+covEntitlementObj);
                //system.debug('####covEntitlementObj[0].HR_Coverage_Orgs__r####'+covEntitlementObj[0].HR_Coverage_Orgs__r);
                List<Severance_And_Release__c> srlist=new List<Severance_And_Release__c>([select id,ownerid,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c from Severance_And_Release__c where Project__c=:projID ]);//Order by First_Name__c ASC
                system.debug('#####All srlist####'+srlist.size());  
                /** CHANGED BY RAJEEV ON 7th FEB 2017:
**  EVERY USERS ARE GETTING ACCESS TO ALL SNRS, IF THEY DONT HAVE ANY COVERAGE ENTITLEMENTS
** BELOW CODE SHD BE COMMENTED **/
                /*
if(srlist != null && srlist.size() >0 && covEntitlementObj != null && covEntitlementObj.size() >0 && ( covEntitlementObj[0].HR_Coverage_Orgs__r ==null || (covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size()==0)) ){
accessibleSRList.addAll(srlist);  
}
else */
                // 31-Aug-17 : JIRA#87 : RIF System admins will no longer see all the SNRs
                /*if(isSysadmin != null && isSysadmin.size() >0){
accessibleSRList.addAll(srlist);
}
else */ 
                if(srlist != null && srlist.size() >0 && covEntitlementObj!=null && covEntitlementObj.size() >0 && covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size()>0){
                    Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
                    for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj[0].HR_Coverage_Orgs__r){
                        if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                            set<String> tempSet=new set<String>();
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }  
                        else{
                            set<String> tempSet=new set<String>();
                            tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                            //covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c)
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }   
                    }
                    system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap); 
                    for(Severance_And_Release__c sr: srlist){
                        if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c)){  
                            accessibleSRList.add(sr);
                            system.debug('####sr.Super_Division__c inside if loop for covTypeToCodeMap#####'+sr.Super_Division__c);   
                        }
                        else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(sr.Division__c) )  
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c) )  
                            accessibleSRList.add(sr);   
                        else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(sr.Department__c) )  
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c) )    
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c) )      
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c) )   
                            accessibleSRList.add(sr);             
                    }
                    covTypeToCodeMap.clear();
                }
                //isSysadmin.clear();
                empObj = null;
                covEntitlementObj.clear();
                srlist.clear();
            }
            catch(Exception e)
            {
                System.debug('--RIF_DataUtils.getAccessibleSRRecords Exception--'+e);
            }
        }    
        System.debug('### RIF_DataUtils.getAccessibleSRRecords::: accessibleSRList'+accessibleSRList.size());          
        return accessibleSRList;
    }
    // 9-Aug-2016 : Changes for PDU deletion, added extra fields in the query
    public static Map<id,List <Severance_And_Release__c> >  getPDUToSRListMap(Set <id> decUnitIds){
         Map<id,List <Severance_And_Release__c> > PDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> ();
         for(Severance_And_Release__c severanceObj: [select id,Name, Emp_Id__c,status__c,Decisional_Unit__c,Project_Decisional_Org_Level__c,Project_Level__c, Project_Level__r.Project__c, Project_Level__r.Project__r.RecordTypeId,Employee__r.Cost_Center__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Subdept_Org__c,Employee__r.Dept_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Division_Org__c,Employee__r.Super_Division__c,Project_Decisional_Org_Level__r.Decision_Unit_Type_Level__c 
                from Severance_And_Release__c where Decisional_Unit__c in :decUnitIds]){ 
            if(!PDUToSRListMap.containsKey(severanceObj.Decisional_Unit__c)){
                List <Severance_And_Release__c> templist= new List <Severance_And_Release__c> {severanceObj};
                PDUToSRListMap.put(severanceObj.Decisional_Unit__c,templist);
            }
            else if(PDUToSRListMap.containsKey(severanceObj.Decisional_Unit__c)){
                List <Severance_And_Release__c> templist= new List <Severance_And_Release__c>(PDUToSRListMap.get(severanceObj.Decisional_Unit__c));
                templist.add(severanceObj);
                PDUToSRListMap.put(severanceObj.Decisional_Unit__c,templist);
            }            
                                    
         }
         return PDUToSRListMap; 
    }
    
    public static Map<id,List <Severance_And_Release__c> > getOrgPDUToSRListMap(Set <id> orgDecUnitIds){ 
        Map<id,List <Severance_And_Release__c> > orgPDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> ();
        // 3-Apr-2017 : Added Emp ID in the query
         for(Severance_And_Release__c severanceObj: [select id, emp_id__c,status__c,Decisional_Unit__c,Project_Decisional_Org_Level__c,Project_Level__c, Project_Level__r.Project__c, 
                Employee__r.Super_Division__c, Employee__r.Division_Org__c, Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c, Employee__r.Subdept_Org__c, 
                Employee__r.Sub_Depart2_Org__c,  Employee__r.Cost_Center__c, Employee__r.Emp_ID__c    
                   from Severance_And_Release__c where Project_Decisional_Org_Level__c in : orgDecUnitIds]){ 
            if(!orgPDUToSRListMap.containsKey(severanceObj.Project_Decisional_Org_Level__c)){
                List <Severance_And_Release__c> templist= new List <Severance_And_Release__c> {severanceObj};
                orgPDUToSRListMap.put(severanceObj.Project_Decisional_Org_Level__c,templist);
            }
            else if(orgPDUToSRListMap.containsKey(severanceObj.Project_Decisional_Org_Level__c)){
                List <Severance_And_Release__c> templist= new List <Severance_And_Release__c>(orgPDUToSRListMap.get(severanceObj.Project_Decisional_Org_Level__c));
                templist.add(severanceObj);
                orgPDUToSRListMap.put(severanceObj.Project_Decisional_Org_Level__c,templist); 
            }            
                                    
         }
         return orgPDUToSRListMap;      
    }
    public static void updateSRWithOtherOrgPduANDPdu(Id orgPduID,Id projID,List <Severance_And_Release__c> SRList,String mode){
        List <Severance_And_Release__c> updatedSRList= new List <Severance_And_Release__c>();
        for(Severance_And_Release__c sr: SRList){
            List <Child_Project_Decisional_Unit__c> eligiblechildPDuList= new List <Child_Project_Decisional_Unit__c>(getEligibleOrgPDuForSR(sr,projID,orgPduID,mode));
            if(eligibleChildPDuList.size()>=1){
                system.debug('inside updateSRWithOtherOrgPduANDPdu() eligiblechildPDuList[0].Project_Decisional_Unit__c'+eligiblechildPDuList[0].Project_Decisional_Unit__c);
                system.debug('eligiblechildPDuList[0].Decision_Unit_Type_Level__c'+eligiblechildPDuList[0].Decision_Unit_Type_Level__c);
                sr.Project_Decisional_Org_Level__c=eligiblechildPDuList[0].id;
                sr.Decisional_Unit__c=eligiblechildPDuList[0].Project_Decisional_Unit__c;
                updatedSRList.add(sr);
            }
            if(updatedSRList!=null && updatedSRList.size()>0){
                update updatedSRList;
            }
            
        }       
    }
    public static List <Child_Project_Decisional_Unit__c> getEligibleOrgPDuForSR(Severance_And_Release__c sr,Id projID,Id orgPduID,String mode){
        List <Child_Project_Decisional_Unit__c> eligibleOrgPDUList= new List <Child_Project_Decisional_Unit__c> ();
        List <Child_Project_Decisional_Unit__c> orgPDUList= new List <Child_Project_Decisional_Unit__c>();
        if(mode=='delete')
            orgPDUList=[select id,Decisional_Unit_Type__c,Decisional_Unit_Derived__c,Project_Decisional_Unit__c,Decision_Unit_Type_Level__c from 
                                                          Child_Project_Decisional_Unit__c where ProjectID__c=:projID AND id!=:orgPduID order by Decision_Unit_Type_Level__c desc];
        if(mode=='edit')
            orgPDUList=[select id,Decisional_Unit_Type__c,Decisional_Unit_Derived__c,Project_Decisional_Unit__c,Decision_Unit_Type_Level__c from 
                                                          Child_Project_Decisional_Unit__c where ProjectID__c=:projID order by Decision_Unit_Type_Level__c desc];
        for(Child_Project_Decisional_Unit__c childPDU: orgPDUList){
            if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Division')){
                if(sr.Employee__r.Super_Division__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Division')){
                if(sr.Employee__r.Division_Org__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Department')){
                if(sr.Employee__r.Super_Depart_Org__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Department')){
                if(sr.Employee__r.Dept_Org__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department')){
                if(sr.Employee__r.Subdept_Org__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department 2')){
                if(sr.Employee__r.Sub_Depart2_Org__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            else if(childPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Cost Center')){
                if(sr.Employee__r.Cost_Center__c.equals(childPDU.Decisional_Unit_Derived__c))
                    eligibleOrgPDUList.add(childPDU);
            }
            
        }
        return eligibleOrgPDUList;
        
    }
    /*
    public static Set <id> getSRListInTriggerCoveredByAllOrgPDU(Id oldOrgPduID,Id projID,List <Severance_And_Release__c> SRList){ 
        Set <id> coveredSRIds= new Set <id>(); 
        for(Child_Project_Decisional_Unit__c childPDU: [select id,Decisional_Unit_Type__c,Decisional_Unit_Derived__c,Decision_Unit_Type_Level__c from Child_Project_Decisional_Unit__c where ProjectID__c=:projID]){
            //List <Severance_And_Release__c> tempCoveredSRList= new List <Severance_And_Release__c>(getSRListCoveredByOtherOrgPDU(childPDU,SRList));
            Set <id> tempSRIDSetCoveredByOrgPDU= new Set <id>(getSRListCoveredByOtherOrgPDU(childPDU,SRList));
            System.debug('##InsidegetSRListInTriggerCoveredByOtherOrgPDU()#tempSRIDSetCoveredByOrgPDU####'+tempSRIDSetCoveredByOrgPDU);
            if(tempSRIDSetCoveredByOrgPDU!=null && tempSRIDSetCoveredByOrgPDU.size()>0){
                coveredSRIds.addALL(tempSRIDSetCoveredByOrgPDU);   
            }
            
        }
        return coveredSRIds;  
          
    }
    */
    // 3-Apr-2017 : JIRA#RIF-22 : Use this new method instead of the above one
    public static Set <id> getSRListInTriggerCoveredByAllOrgPDU(List<Child_Project_Decisional_Unit__c> newOrgLevelPDUList,List<Severance_And_Release__c> SRList){ 
        Set <id> coveredSRIds = new Set <id>(); 
        Map<String,Child_Project_Decisional_Unit__c> existingOrgPDUMap = new Map<String,Child_Project_Decisional_Unit__c>();
        List<Child_Project_Decisional_Unit__c> childPDUList = new List<Child_Project_Decisional_Unit__c>();
        // check if the updated details
        for(Child_Project_Decisional_Unit__c newOrg : newOrgLevelPDUList){
            coveredSRIds = getSRListCoveredByOtherOrgPDU(newOrg,SRList);
        }
        return coveredSRIds;  
    }
    
    public static Set <id> getSRListInTriggerCoveredByOtherOrgPDU(Id oldOrgPduID,Id projID,List <Severance_And_Release__c> SRList){ 
        Set <id> coveredSRIds= new Set <id>(); 
        for(Child_Project_Decisional_Unit__c childPDU: [select id,Decisional_Unit_Type__c,Decisional_Unit_Derived__c,Decision_Unit_Type_Level__c from Child_Project_Decisional_Unit__c where ProjectID__c=:projID AND id!=:oldOrgPduID]){
            //List <Severance_And_Release__c> tempCoveredSRList= new List <Severance_And_Release__c>(getSRListCoveredByOtherOrgPDU(childPDU,SRList));
            Set <id> tempSRIDSetCoveredByOrgPDU= new Set <id>(getSRListCoveredByOtherOrgPDU(childPDU,SRList));
            System.debug('##InsidegetSRListInTriggerCoveredByOtherOrgPDU()#tempSRIDSetCoveredByOrgPDU####'+tempSRIDSetCoveredByOrgPDU);
            if(tempSRIDSetCoveredByOrgPDU!=null && tempSRIDSetCoveredByOrgPDU.size()>0){
                coveredSRIds.addALL(tempSRIDSetCoveredByOrgPDU);   
            }
            
        }
        return coveredSRIds;  
          
    }
    public static Set <id> getSRListCoveredByOtherOrgPDU(Child_Project_Decisional_Unit__c newchildPDU, List <Severance_And_Release__c> SRList){
        Set <id> srIDSetCoveredByOrgPDU= new Set <id>();
        if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Division')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Super_Division__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Division')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Division_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Department')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Super_Depart_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Department')){
            for(Severance_And_Release__c sr: SRList){
                System.debug('#Both#org pdu decisional unit derived##'+newchildPDU.Decisional_Unit_Derived__c+'###sr.Employee__r.Dept_Org__c###:'+sr.Employee__r.Dept_Org__c);
                if(sr.Employee__r.Dept_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c)){
                    System.debug('##Inside dept If sr.Employee__r.Dept_Org__c:'+sr.Employee__r.Dept_Org__c);
                    srIDSetCoveredByOrgPDU.add(sr.id);
                }
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Subdept_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department 2')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Sub_Depart2_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Cost Center')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Cost_Center__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        // 3-Apr-2017 : JIRA#RIF-22 : Added the check for employee
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Employee')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Emp_ID__c.equals(newchildPDU.Emp_ID__c))
                    srIDSetCoveredByOrgPDU.add(sr.id);
            }       
        }
        system.debug('###srIDSetCoveredByOrgPDU##'+srIDSetCoveredByOrgPDU); 
        return srIDSetCoveredByOrgPDU;  
    }
    public static boolean checkOrgPDUScopeDowngraded(Child_Project_Decisional_Unit__c newchildPDU, List <Severance_And_Release__c> SRList){
        // [select id,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where ID IN:];
        List <Severance_And_Release__c> newSRListDerivedByOrgLevelPDu= new List <Severance_And_Release__c>();
        if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Division')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Super_Division__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Division')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Division_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Super Department')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Super_Depart_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Department')){
            for(Severance_And_Release__c sr: SRList){
                System.debug('#Both#org pdu decisional unit derived##'+newchildPDU.Decisional_Unit_Derived__c+'###sr.Employee__r.Dept_Org__c###:'+sr.Employee__r.Dept_Org__c);
                if(sr.Employee__r.Dept_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c)){
                    System.debug('##Inside dept If sr.Employee__r.Dept_Org__c:'+sr.Employee__r.Dept_Org__c);
                    newSRListDerivedByOrgLevelPDu.add(sr);
                }
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Subdept_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Sub Department 2')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Sub_Depart2_Org__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        else if(newchildPDU.Decisional_Unit_Type__c.equalsIgnoreCase('Cost Center')){
            for(Severance_And_Release__c sr: SRList){
                if(sr.Employee__r.Cost_Center__c.equals(newchildPDU.Decisional_Unit_Derived__c))
                    newSRListDerivedByOrgLevelPDu.add(sr);
            }       
        }
        system.debug('###newSRListDerivedByOrgLevelPDu##'+newSRListDerivedByOrgLevelPDu+'###SRList##'+SRList);
        if(SRList.equals(newSRListDerivedByOrgLevelPDu))
            return false;
        else
            return true;
        
    }
    public static List<Severance_And_Release__c> getSeveranceAndReleaseListByOrgLevelProjectDecUnits(Set<id> orgLeveldecUnitIds){
        return [select id, Decisional_Unit__c,Project_Decisional_Org_Level__c,Emp_Id__c,Project_Level__c, Project_Level__r.Project__c, Project_Level__r.Project__r.RecordTypeId 
                from Severance_And_Release__c 
                where Project_Decisional_Org_Level__c in :orgLeveldecUnitIds];
    }
    
    public static List<Severance_And_Release__c> getSeveranceAndRelease(string SRId){
        return getSeveranceAndReleaseList( new list<string> {SRId});
    }
    
    public static List<Project__c> getProjectListOnName(String name){
        return [select id 
                from project__c 
                where name = : name];
    }
    
     //(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
    /*public static list<Covenant_Parameters__c> getCovenantParamsList(Set<String> setMSSB, set<String> setCountry, set<String> setjobLevel){
        return [Select id, Covenant_Notice__c,MS_MSSB__c, Country__c, Level_Dsc__c 
                from Covenant_Parameters__c 
                where MS_MSSB__c in : setMssb 
                and Country__c in : setCountry 
                and Level_Dsc__c in : setJobLevel];
    }
    public static list<Covenant_Parameters__c> getCovenantParamsList(string mssb,string country, string level_desc){
        return getCovenantParamsList(new Set<String>{mssb}, new set<String>{country}, new set<String>{level_desc});
    }*/
    
    public static List<String> getConfiguredFieldsList(string recordTypeName){
        List<String> strList = new List<String>();    
        if(recordTypeName == 'One Off Termination'){
            for(RIF_Step2FieldConfiguration__c rif_SFC : [Select r.Field_API_Name__c 
                                                          From RIF_Step2FieldConfiguration__c r 
                                                          where Is_Displayed_In_One_Off__c = true 
                                                          order by One_Off_Field_Order__c asc]){
                strList.add(rif_SFC.Field_API_Name__c);                                           
            }
            }else{
                for(RIF_Step2FieldConfiguration__c rif_SFC : [Select r.Field_API_Name__c 
                                                          From RIF_Step2FieldConfiguration__c r 
                                                          where Is_Displayed_In_Project_Based__c = true 
                                                          order by Project_Based_Field_Order__c asc]){
                strList.add(rif_SFC.Field_API_Name__c);                                          
            }   
        }  
      return strList;                                                 
    }
    public static List<Project_Level__c> getProjectLevel(string projectLevelId){
        return getProjectLevelList( new list<string> {ProjectLevelId});
    }
    
    public static List<Project_Level__c> getProjectLevelList(List<string> projectLevelIds){
        return [SELECT Id, Name, CurrencyIsoCode, Severance_Parameters__c, Project__c, Back_Out_Notice__c,Basic_Max__c, Basic_Min__c, 
                        Cobra_Months__c, Country__c, Covenant_Notice__c,  Enhanced_Percent__c, Is_NonUS__c,Enhanced_Max__c, Enhanced_Min__c,
                        Level_Dsc__c, Level__c, Los_Through__c, S_R_Warn_Count__c, Notice_Calc__c, Outplacement__c, Sev_Weeks_Max__c, 
                        Sev_Weeks_Min__c, Sev_Weeks__c, Template__c, WARN__c, Weekly_Mulitple__c, MS_MSSB__c, Project__r.Notice_Days__c 
                from Project_Level__c 
                where id in: projectLevelIds];    
    }
    
    
    public static List<Project_Level__c> getProjectLevelsForSRCreation(string plid){
         return getProjectLevelsForSRCreation(new list<String>{plId});
    }
    
    public static list<Project_Level__c> getProjectLevelsForSRCreation(list<String> plIds){
        return [Select id, project__c, project__r.Communication_Date__c,project__r.Termination_Date__c, Project__r.Notice_Days__c, project__r.Country__c, Country__c, MS_MSSB__c, Level_Dsc__c, Outplacement__c,
                       Project__r.Super_Division__c,Weekly_Mulitple__c,Notice_Calc__c,Sev_Weeks__c,Sev_Weeks_Max__c,Sev_Weeks_Min__c,Cobra_Months__c,Enhanced_Percent__c
                from Project_Level__c
                where id IN: plids];   
    }
    
    
    /*public static list<Comp_Data__c> getCompDataForEmpIds(list<String> empIds){
        return [select Current_Base_Local__c, Additional_Comp__c, Emp_Id__c, Current_Base_Currency__c 
                from Comp_Data__c 
                where Emp_Id__c IN : empIds];
    }*/
    
    // 14-Feb-17: Added user fields to the below query
    public static list<Employee__c> getEmployeesForEmpIds(set<String> emp_Ids){
        
         List <employee__c> empList= new List <employee__c>([select Id, IND_Basic_Salary_Amount__c,Base_Annual_Amount__c,Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c,
                   Emp_ID__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c,Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                   Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c, 
                   Days_of_Perm_Serv_Total_LOS__c, DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c, 
                   Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c,User__c  
               from Employee__c
               where Emp_ID__c in :emp_Ids]);
        System.debug('###empList in Data Util#####'+empList);
        return empList;
    }
    
    public static map<Id, Employee__c> getEmployeesMapForEmpIds(set<String> emp_Ids){
        return new map<Id, Employee__c>([select Id, First_Name__c, Last_Name__c, emp_id__c,IND_Basic_Salary_Amount__c,Base_Annual_Amount__c,Cost_Center__c, Cost_Center_Desc__c,
                                         Dept_Org__c,Dept_Dsc_Org__c,Division_Org__c,Division_Dsc_Org__c,Level_Job__c,Region_Dsc_Org__c,Subdept_Org__c,
                                         Subdept_Dsc_Org__c,Sub_Depart2_Org__c,Sub_Depart2_Dsc_Org__c,Super_Depart_Org__c,Super_Depart_Dsc_Org__c,
                                         Super_Division__c,Super_Division_Dsc_Org__c,Days_of_Perm_Serv_Total_LOS__c,DOH_Recent__c,Job_Country_Job__c,MS_MSSB__c,Level_Dsc_Job__c,
                                         Address_1_Home__c,Address_2_Home__c,Address_3_Home__c,Address_4_Home__c,City_Home__c,State_Home__c,
                                         Zip_Home__c from Employee__c where Emp_ID__c in :emp_Ids]);
    } 
    
    public static list<Severance_And_Release__c> getSeveranceAndReleaseListOnProjectId(string projectId){
        return [select id, Project_Level__c, Project_Level__r.Project__c, Emp_Id__c, Name, Employee__c, WARN__c,Weekly_Rate__c,
           Total_Week_Of_Severance__c, Outplacement__c, Notice_Days_1__c, LOS_1__c, Cobra_One_Month__c,Cobra__c,Enhanced_Severance_Local__c,Daily_Rate__c,
           Base_Salary__c,Additional_Severance1__c,Additional_Notice__c,Super_Division__c,Division__c,Basic_Severance_Local__c,
           Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c 
           from Severance_And_Release__c 
           where Project_Level__r.Project__c = :projectId];
           
    }
    
    public static list<Severance_And_Release__c> findSeveranceAndReleaseInProject(set<string> empIds, string projectId){
        return [select id, Country__c, MS_MSSB__c, Level_Desc__c, Emp_Id__c, status__c, Project_Level__r.Project__c,Project_Level__r.Project__r.name
                from Severance_And_Release__c 
                where Emp_Id__c in :empIds 
                and (Project_Level__r.Project__c = :projectId 
                OR (status__c = 'Selected' 
                and Project_Level__r.Project__r.Status__c = 'Active'))];
    }
    
    // 4-July-2017 : JIRA#88 : When adding an employee to a project, the employee should not be present in any other ACTIVE project
    public static List<Severance_And_Release__c> findSNRInActiveProject(Set<String> empIds){
        return [SELECT Id, Project__c, Project__r.Status__c, Country__c, MS_MSSB__c, Level_Desc__c, 
                        Emp_Id__c, status__c, Project_Level__r.Project__c,Project_Level__r.Project__r.Name
                FROM Severance_And_Release__c 
                WHERE Emp_Id__c IN : empIds 
                AND Project__r.Status__c = 'Active'];
    }    
    
    public static list<Severance_And_Release__c> findAllSeveranceAndReleaseInProject(set<string> empIds, string projectId){
        return [select id, Country__c, MS_MSSB__c, Level_Desc__c, Emp_Id__c, status__c, Project_Level__r.Project__c,Project_Level__r.Project__r.name
                from Severance_And_Release__c 
                where Emp_Id__c in :empIds  and Project_Level__r.Project__c = :projectId];  
                
    }
    //Added on 09/12/2015 for applying validation on One-off
    public static list<Severance_And_Release__c> findSeveranceAndReleaseInProjectOneOff(string empId){
        return [select id, Country__c, MS_MSSB__c, Level_Desc__c, Emp_Id__c, status__c, Project_Level__r.Project__c,Project_Level__r.Project__r.name
                from Severance_And_Release__c 
                where Emp_Id__c=:empId
                and status__c = 'Selected' ];
               // and Project_Level__r.Project__r.Status__c = 'Active'];
    }
    // 13-Mar-17 : Added delta field to capture the value of Additional Notice Amount
    public static list<Accrual_Information__c> getListExistingAccrualInfoForEmpIds(set<String> setEmpIds){
        return [SELECT EMP_ID__c, Additional_Severance__c, Basic_Severance__c, Benefits__c, Additional_Notice__c, Buy_Out_Of_Termination__c, Enhanced_Severance_Lcl__c, Ex_Gracia_Cash_Payment__c,
                       Notice_Amount__c, pay_in_lieu_of_ben_lcl__c, Pension_Contribution__c, Social_Insurance__c, Statutory_Redundancy_Pay__c, Termination_Bonus__c, 
                       Buy_Out_of_Notice_Per_Lcl__c, Notice_Days__c ,Severance_And_Release__c, Additional_Notice_Amount__c  
                FROM Accrual_Information__c 
                Where Emp_ID__c in : setEmpIds   
                order by Emp_Id__c ASC, Communicated_Date__c DESC, LastModifiedDate DESC];
    }
    public static list<Accrual_Information__c> getListExistingAccrualInfoForSR(set<String> setSR){
        return [SELECT EMP_ID__c, Accrual_Type__c,Additional_Severance__c, Basic_Severance__c, Benefits__c, Additional_Notice__c, Buy_Out_Of_Termination__c, Enhanced_Severance_Lcl__c, Ex_Gracia_Cash_Payment__c,
                       Notice_Amount__c, pay_in_lieu_of_ben_lcl__c, Pension_Contribution__c, Social_Insurance__c, Statutory_Redundancy_Pay__c, Termination_Bonus__c, 
                       Buy_Out_of_Notice_Per_Lcl__c, Notice_Days__c,Severance_And_Release__c ,Delta_Additional_Severance__c 
                FROM Accrual_Information__c 
                where Severance_And_Release__c IN: setSR   
                order by Emp_Id__c ASC, Communicated_Date__c DESC, LastModifiedDate DESC]; 
    }
    
    public static list<Project_Decisional_Unit__c> getProjectDecisionalUnitOnProjectId(set<string> projectIds){
        return [select id,Decisional_Unit_Name__c, Project__c,Employees__c,HR_Signatory__c,Employee__c
                from Project_Decisional_Unit__c
                where Project__c in :projectIds];
    }
    public static list<Project_Decisional_Unit__c> getProjectDecisionalUnitOnProjectIdsSet(set<Id> projectIds){
        return [select id,Decisional_Unit_Name__c, Project__c,Employees__c,HR_Signatory__c,Employee__c
                from Project_Decisional_Unit__c
                where Project__c in :projectIds];
    }
    // 07-18-2016 : Added employee fields for PDU type = Employee to the query 
    public static list<Child_Project_Decisional_Unit__c> getProjectDecisionalOrgLevelsOnProjectId(set<string> projectIds){ 
       return [select id, ProjectID__c, Decisional_Unit_Type__c, Decisional_Unit__c,Decisional_Unit_Derived__c,Project_Decisional_Unit__c, Employee__c, Emp_ID__c, Project_Decisional_Unit__r.project__c,Decision_Unit_Type_Level__c
                from Child_Project_Decisional_Unit__c where Project_Decisional_Unit__r.project__c in :projectIds order by Decision_Unit_Type_Level__c desc]; //ProjectID__c
    }
    public static list<Child_Project_Decisional_Unit__c> getProjectDecisionalOrgLevelsOnDecisionalUnitId(set<id> decUnitIds){
       return [select id, ProjectID__c,Project_Decisional_Unit__r.project__c, Decisional_Unit_Type__c, Decisional_Unit__c,Decisional_Unit_Derived__c,Project_Decisional_Unit__c
                from Child_Project_Decisional_Unit__c where Project_Decisional_Unit__c in : decUnitIds];
    }
   // 13-Sep-2016 : HR Signatory/Contact related changes, added the new fields to the query
   // 24-Nov-2016 : Added Disable_Status_picklist__c field to the query
   // 3-Jan-17: Added Severance_Package_Communicated__c to the query
   // 24-Apr-17 : Added all the 'Is Changed' flags for override fields
   // 2-May-17 : Added Historical_Data_Load__c field
   // 31-July-17 : Fields for Default reverse accrual and default base currency fields 
   // 6th-Sept-17 : Added OwnerId
   //13-march-18:added Pay_in_Lieu_of_Benefits_Local__c field to the query <!--MSN: RIF#149 Changes -->  
   //2-apr-18:added Release_Processed_Date__c,Payment Effective Date 1,Payment Effective Date 2,Release Returned Flag , Returned Date <!--MSN: RIF#139 Changes -->  
    public static Severance_And_Release__c getSeveranceAndReleaseRecord(string srId){ 
        list<Severance_And_Release__c> lstSR = [Select Id,recordtypeid,Employee__c,Over_40__c,Over_40_Age_Disclosure__c,Employee__r.Birth_Date__c,Conga_Total_Severance_Payments__c ,Base_Salary__c,Base_Salary_Override__c,Status_Credit_Or_Selected__c ,Status_Sev_NoSev__c,Is_termination_related_to_Project__c,Communicated_Date__c,Communicated_Details_of_Package__c,Package_Receipt_Date__c,Release_Returned__c,Release_Returned_Date__c,Work_Requirement_for_Severance__c, recordType.Name , Name, First_Name__c, Last_Name__c, Emp_Id__c, Project_Level__c,
                                                    Recalculation_Type__c, Status__c, Is_employee_a_security_risk__c, Communicated__c, WARN__c,EPK_Code__c,Overnight_Delivery_Date__c, 
                                                    Should_systems_building_access_be_term__c,Should_a_term_record_be_created__c, Exhibit_A__c, Is_employee_eligible_for_rehire__c,
                                                    Decisional_Unit__c,Project_Name__c,  Employee__r.name,Level__c,Level_Desc__c,Project__c,Project__r.name,Project__r.Status__c,
                                                    Comments__c,  Notice_Days_1__c,Notice_Days_Override__c, Last_Day_On_Premises__c,Project_Level__r.Name,Outplacement__c ,
                                                     Termination_Date__c,Basic_Severance_Local__c,Notice_Amount__c,Notice_Amount_Override__c,HR_Contact_Email__c,Days_of_Perm_Serv_Total_LOS__c ,Additional_Notice_Amount__c ,Additional_Notice_Amount_Override__c,
                                                     Additional_Notice__c, Additional_Notice_Override__c,Total_Week_Of_Severance__c ,Basic_Severance_Local_Override__c,
                                                      DOH_Recent__c, Cobra_Override__c,Enhanced_Severance_Local__c,Address_1_Home__c,Address_2_Home__c,Address_3_Home__c,Address_4_Home__c,Project_Decisional_Org_Level__c,
                                                     Warn_Payoff_Local_SetB__c,Base_Salary_Override_SetB__c,Cobra__c,Enhanced_Severance_Local_Override__c,City_Home__c,State_Home__c,Country__c,Zip_Home__c, 
                                                    Warn_Payoff_Local_Override_SetB__c, Basic_Severance_Local_SetB__c, Buy_Out_of_Termination__c,Weekly_Rate__c, Is_Released_To_Vendor__c,Unused_Vacation_Days__c,CA_Flag__c,
                                                    Basic_Severance_Local_Override_SetB__c, Additional_Severance_Local_SetB__c, Social_Insurance__c, LOS_1__c ,Basic_Additional_Severance__c ,Basic_Additional_Severance_Override__c,
                                                    Additional_Severance1__c,Additional_Severance_Override1__c,Additional_Severance_Local_Override_SetB__c, Enhanced_Severance_Local_SetB__c, Cobra_One_Month__c,Daily_Rate__c,
                                                    Enhanced_Severance_Local_Override_SetB__c, Cobra_SetB__c, Cobra_Override_SetB__c ,communication_date__C,Base_Severance_Weeks__c,
                                                    Ex_Gracia_Cash_Payment__c, Pension_Contribution__c, Statutory_Redundancy_Pay__c, Termination_Bonus__c ,Overnight_Package__c,Sep_Summary_Notice_Amount__c,Sep_Summary_Additional_Notice_Amount__c,Sep_Summary_Basic_Severance__c,Sep_Summary_Enhanced_Severance__c,Sep_Summary_Benefits__c,Sep_Summary_Total_Payments__c,Sep_Summary_Base_Salary__c,
                                                    Sum_Severance_Release_Agreement__c,Has_Additional_Notice_Amount__c,Has_More_Than_1_Month_Cobra__c,Has_Health_Insurance__c,
                                                    SEP_SUMMARY_TOTAL_PAYMENTS_WORDS__c,SEP_SUMMARY_TOTAL_PAYMENTS_FORMATTED__c,COBRA_WORDS__c,COBRA_FORMATTED__c,Home_Phone_Number__c,Conga_Total_Unvested_Value__c,
                                                    SEP_SUMMARY_TOTAL_PAYMENTS_WITH_COBRA__c,SEP_SUMMARY_ADDITIONAL_SEVERANCE__c,Has_Additional_Severance__c,Has_Base_Salary__c,Has_Basic_Severance__c,Has_Benefits__c,Has_Enhanced_Severance__c,Has_Notice_Amount__c,Has_Total_Payments_With_Cobra__c,Has_Unvested_Total_Balance__c,HR_Signatory_lkp__c,HR_Contact_lkp__c,HR_Signatory__c,HR_Contact__c,Disable_Status_picklist__c,Severance_Package_Communicated__c, 
                                                    Is_Changed_Add_Notice_Override__c,Is_Changed_Add_Sev_Override__c,Is_Changed_Base_Salary_Override__c,Is_Changed_Basic_Sev_Override__c,Is_Changed_Cobra_Override__c,Is_Changed_Enhan_Sev_Override__c,Is_Changed_Notice_Amt_Override__c,Historical_Data_Load__c ,Reverse_accrual_default__c ,Base_currency_default__c, OwnerId,Pay_in_Lieu_of_Benefits_Local__c,Release_Processed_Date__c,Payment_Effective_Date_1__c,Payment_Effective_Date_2__c,Exhibit_A_Received__c
                                                from Severance_And_Release__c s
                                                where id = :srId];
                                                
                                                
        if(!lstSR.isEmpty()){   
            return lstSR[0];
        }
        return new Severance_And_Release__c();
    }
    public static list<AggregateResult> getSeveranceAndReleaseListOnSuperDivision(set<Id> projectIds){
        return [select Project_Level__r.Project__c proj, Super_Division__c
           from Severance_And_Release__c 
           where Project_Level__r.Project__c IN :projectIds
           group by Project_Level__r.Project__c, Super_Division__c
           order by Super_Division__c];
    }
    public static Set<Id> getUniqueProjectsfromProjectLevel(set<Id> projectLevelIds){
        Set<Id> projectIds = new Set<Id>();
        List<Project_Level__c> projectLevelList = [Select Project__c 
                                                   from Project_Level__c 
                                                   where Id IN :projectLevelIds];
        for(Project_Level__c pl : projectLevelList){
            projectIds.add(pl.Project__c);
        }
        return projectIds;
    }
    
    public static list<Unvested_Equity__c> getUnvestedEquityForEmpIds(list<String> empIds){
        return [Select  id,current_holdings__c,Date_as_of__c,Emp_Id__c,Employee_temp__c,total_cash_balance__c,total_balance__c,total_equity_balance__c,
                unvested_cash_balance__c,Unvested_Equity_Balance__c,unvested_total_balance__c,unvested_holdings__c from Unvested_Equity__c
                where emp_Id__c in : empIds];   
    }
    
    public static list<Unvested_Equity__c> getUnvestedEquityForEmployee(String empId){
        return [Select  id,current_holdings__c,Date_as_of__c,Emp_Id__c,Employee_temp__c,total_cash_balance__c,total_balance__c,total_equity_balance__c,
                unvested_cash_balance__c,Unvested_Equity_Balance__c,unvested_total_balance__c,unvested_holdings__c from Unvested_Equity__c
                where employee_temp__c = : empId];   
    }
    
    
    
     //Added by Anshul on July 17,2015 for restricting the S&R to be created by the Non-coverage HR User
    /*****
    public static List<Severance_And_Release__c> getDisqualifiedSRForUserCoverage(List<Severance_And_Release__c> listSR,Map <string,set <string>> covTypeToCodeMap){ 
        List<Severance_And_Release__c> tempListDisqualifiedSR   = new List<Severance_And_Release__c>();
        
        for(Integer i=0;i<listSR.size();i++){ 
                    //|| (covTypeToCodeMap.containsKey('Division'))|| (covTypeToCodeMap.containsKey('Division'))
                    //(!covTypeToCodeMap.get('Division').equalsIgnoreCase(sr.Employee__r.Division_Org__c))
                    Boolean tempFlag=false;
                    if( (covTypeToCodeMap.containsKey('Super Division')) && (!(covTypeToCodeMap.get('Super Division').contains(listSR[i].Super_Division__c))) ){  
                         tempListDisqualifiedSR.add(listSR[i]); 
                         tempFlag=true;
                    }  
                    
                    if( (covTypeToCodeMap.containsKey('Division')) && (!covTypeToCodeMap.get('Division').contains(listSR[i].Division__c)) && (tempFlag==false)) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    }
                    else if( (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(listSR[i].Division__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false; 
                    }
                    
                    if( (covTypeToCodeMap.containsKey('Super Department')) && (!covTypeToCodeMap.get('Super Department').contains(listSR[i].Super_Department__c)&& (tempFlag==false)) ) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    } 
                    else if( (covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(listSR[i].Super_Department__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false;     
                    }  
                    
                    if( (covTypeToCodeMap.containsKey('Department')) && (!covTypeToCodeMap.get('Department').contains(listSR[i].Department__c)&& (tempFlag==false)) ) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    } 
                    else if( (covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(listSR[i].Department__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false;     
                    }  
                    
                    if( (covTypeToCodeMap.containsKey('Sub Department')) && (!covTypeToCodeMap.get('Sub Department').contains(listSR[i].Sub_Department__c)&& (tempFlag==false)) ) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    } 
                    else if( (covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(listSR[i].Sub_Department__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false;     
                    }
                      
                    if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (!covTypeToCodeMap.get('Sub Department 2').contains(listSR[i].Sub_Department_2__c)&& (tempFlag==false)) ) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    } 
                    else if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(listSR[i].Sub_Department_2__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false;     
                    } 
                    
                    if( (covTypeToCodeMap.containsKey('Cost Center')) && (!covTypeToCodeMap.get('Cost Center').contains(listSR[i].Cost_Center__c)&& (tempFlag==false)) ) { 
                         tempListDisqualifiedSR.add(listSR[i]);
                         tempFlag=true; 
                    } 
                    else if( (covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(listSR[i].Cost_Center__c)) && (tempFlag==true)    ) { 
                        tempListDisqualifiedSR.remove(i); 
                        tempFlag=false;     
                    } 
                    
                    /*if( (covTypeToCodeMap.containsKey('Cost Center')) && (!covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c)) )  { 
                        tempListDisqualifiedSR.add(sr); 
                    } */
          /**            
         }
         return tempListDisqualifiedSR; 
    } 
    ***/

    //Added by Rajeev to Fix showstopper defect#
    public static List<Severance_And_Release__c> getDisqualifiedSRForUserCoverage(List<Severance_And_Release__c> listSRFromCallingMethod,Map <string,set <string>> covTypeToCodeMap){ 
        system.debug('###entry getDisqualifiedSRForUserCoverage()');
        system.debug('--- listSRFromCallingMethod --- ' + listSRFromCallingMethod);
        Set <id> srIds= new Set <id> ();
        Set <String> empIDSet = new Set<String>();
        for(Severance_And_Release__c sr: listSRFromCallingMethod){
            srIds.add(sr.id);  
           empIDSet.add(sr.emp_id__c); 
        }
               
        system.debug('###srIds:'+srIds);
        system.debug(' -- empIDSet -- ' + empIDSet);
       // List<Severance_And_Release__c> listSR = new List<Severance_And_Release__c>([select id,Emp_Id__c,super_division__c,division__c, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c where id in :srIds]);
        // 14-Oct-2016 : Added missing fields to the query
        // 8-Nov-2016 : GM : Fix for incorrect Coverage check while direct emp add and bulk add
        List<Severance_And_Release__c> listSR = new List<Severance_And_Release__c>();
        //MSN:RIF#162 Commeneted below query and added another query
        //listSR = [select id,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c where emp_id__c in :empIDSet] ;
        listSR = [select id,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c where emp_id__c in :empIDSet and id=:srIds] ;
        system.debug(' -- listSR -- ' + listSR);	
       // added by Avinash Munaga on 23/06/2016 - ALM 1700
        System.debug('size-'+listSR.size());
          
        if(listSR != null && listSR.size() <= 0)
            listSR = listSRFromCallingMethod; 
            
        // added by Avinash Munaga on 23/06/2016 - ALM 1700
         
        List<Severance_And_Release__c> tempListDisqualifiedSR   = new List<Severance_And_Release__c>();
        for(Severance_And_Release__c sr: listSR){    //listSRFromCallingMethod
            
            system.debug('Disqualified SnR--->:sr.Super_Division__c##'+sr.Super_Division__c);
            Boolean tempFlag=false;
            if( (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c)) ){  
                tempFlag=true;
            }
            else if( (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(sr.Division__c)) ){
                tempFlag=true;
            } 
            else if( (covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c) )){
                tempFlag=true;
            } 
            else if( (covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(sr.Department__c))) {                 
                tempFlag=true;
            } 
            else if( (covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c)) ) { 
                tempFlag=true;     
            }
            else if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c)) ) { 
                 tempFlag=true; 
            } 
            else if( (covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c)) ) { 
                tempFlag=true;     
            }
            
            if(!tempFlag){
                tempListDisqualifiedSR.add(sr); 
                system.debug('Disqualified SnR--->:'+sr);
            } 
       
        }
        system.debug('Return Disqualified SnR List--->:'+tempListDisqualifiedSR);
        return tempListDisqualifiedSR; 
    } 
    
    //Added by Anshul on July 17,2015 for restricting the S&R to be created by the Non-coverage HR User
    public  static Map <string,set<String>> getLoggedInUSerCovEntitlementTypeWithCode(String userID){  
        Map <string,set<String>> covTypeToCodeMap= new Map <string,set<String>> (); 
        Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:userID];
            Coverage_Entitlement__c covEntitlementObj;
            try{
                covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
            }
            catch( Exception e){
                System.debug(e);
                     
            }
            if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                    if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                        set<String> covCodeSet=new set<String>();
                        covCodeSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covCodeSet);
                    }  
                    else{
                        set <string> tempSet= new set <string>(covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c));
                        tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet); 
                    }       
                }
            }
            
        return covTypeToCodeMap;
    
    }
    
    //Added for use into RIF_RegionalAcrualUpload Page
    public static List <RIF_File_Upload_History__c> getFileUploadHistories(String fileType){
        return [select id,File_Name__c,Total_Failed_Records__c,Total_Records__c,Total_Success_Records__c,Uploaded_User_Emp_ID__c,LastModifiedDate,LastModifiedBy.Name,LastModifiedBy.Emp_id__c  from RIF_File_Upload_History__c 
                where File_type__c=:fileType order by lastmodifieddate DESC limit 10]; 
    }
}