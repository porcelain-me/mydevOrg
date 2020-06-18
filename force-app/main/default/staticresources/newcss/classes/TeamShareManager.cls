//7/6/2012 UV : create this class to manage team sharing with Users
//  18/03/2016:Replaced Employee__c with GPSEmployee__c by Swapnd
public without sharing class TeamShareManager {
        
      private static final String ACCESS_LEVEL = 'Edit';
      
      public static Team__Share getTeamShareRecord(Id teamId, Id userId){
         // Method to create team share records.
         Team__Share ts = new Team__Share();
         ts.parentId = teamId;
         ts.RowCause = Schema.Team__Share.RowCause.Team_Share__c;
         ts.AccessLevel = ACCESS_LEVEL;
         ts.UserOrGroupId = userId;
         return ts;                
      }
      
      public static List<GPSEmployee__c> getActiveEmployeeList(Set<Id> employeeIds){
      	// Method to get List of active Employees.
      	//After Campaing Migration Instead of Active_Flag__c using Inactive__c field: Modified by Sudarshan K. 26th Feb 2016
      	return [Select e.User__c,  e.Research_Team__r.Team_Id__c, e.Research_Team__c, e.MS_ID__c 
                   From GPSEmployee__c e
                   where id IN :employeeIds and e.User__r.IsActive = true 
                   and e.Active_Flag__c = true];
      }
      
      public static List<GPSEmployee__c> getActiveEmployeeListOnUsers(List<Id> userIds){
        // Method to get list of Active Employees related to given Users.
        //After Campaing Migration Instead of Active_Flag__c using Inactive__c field: Modified by Sudarshan K. 26th Feb 2016
        return [Select e.User__c,  e.Research_Team__r.Team_Id__c, e.Research_Team__c, e.MS_ID__c 
                   From GPSEmployee__c e
                   where User__c in : userIds and e.User__r.IsActive = true 
                   and e.Active_Flag__c = true];
      }
      
      public static List<Research_Team__c> getResearchTeamList(Set<Id> researchTeamIds){
      	// Method to get list of research teams.
      	return [Select r.Team_Id__c, r.Active_Flag__c From Research_Team__c r where id in :researchTeamIds];
      }
      
      public static List<Team__c> getTeamList(List<String> teamIds){
      	// Method to get List of Teams.
      	return [Select t.TeamID__c, t.Id, t.isHidden__c 
                            From Team__c t 
                            where t.TeamID__c in :teamIds];
      } 
        
           
      public static List<Region__c> getRegionList(Set<String> regionNames){
        // Method to get List of regions.
        return [Select Id,name from Region__c where name in : regionNames];
      }
      public static void removePreviouslySystemAddedPermissionForUsers(Set<Id> userIds){
	     // Method to remove existing Team Share records which are system added.
                  
	     List<Team__Share> teamShareRecords = [Select Id 
	                                           from Team__Share 
	                                           where RowCause = :Schema.Team__Share.RowCause.Team_Share__c
	                                           AND UserOrGroupId IN : userIds];
	                                           
	     if(!teamShareRecords.isEmpty()){	        
	         Database.DeleteResult[] ldR = Database.delete(teamShareRecords, false);
            // Process the delete results
            List<String> errorMessages = new List<String>();
	        for(Database.DeleteResult dr : ldR){
	            if(!dr.isSuccess()){
	                Database.Error err = dr.getErrors()[0];                
	                errorMessages.add('Unable to delete team share record due to following exception:' + err.getMessage());
	            }            
	        }
	        if(!errorMessages.isEmpty()){
	           //Util.LOG(errorMessages); 
	        }
	     }                                      
	  }
	  
	  public static void removePreviouslySystemAddedPermissionForUsers(Map<Id, Id> userTeamMapToInsert){
         // Method to remove existing Team Share records which are system added.
         // userTeamMapToInsert : Map of User Id and Team Id.
         // Key : user Id.
         // Value : Team Id.
         
         List<Team__Share> teamShareRecords = [Select Id 
                                               from Team__Share 
                                               where RowCause = :Schema.Team__Share.RowCause.Team_Share__c
                                               AND UserOrGroupId IN : userTeamMapToInsert.keyset() and
                                               ParentId in : userTeamMapToInsert.values()];
                                               
         if(!teamShareRecords.isEmpty()){           
             Database.DeleteResult[] ldR = Database.delete(teamShareRecords, false);
            // Process the delete results
            List<String> errorMessages = new List<String>();
            for(Database.DeleteResult dr : ldR){
                if(!dr.isSuccess()){
                    Database.Error err = dr.getErrors()[0];   
                    errorMessages.add('Unable to delete team share record due to following exception:' + err.getMessage());             
                }            
            }
            if(!errorMessages.isEmpty()){
               // Util.LOG(errorMessages); 
            }
         }                                      
      }
	  
	  
	  
	  public static void insertSystemAddedPermissionForUsersAndTeam(Map<Id, Id> userTeamMapToInsert){
	      // Method to add team share records for User.
          // teamUserMapToInsert : Map of User Id and Team Id.
          // Key : User Id
          // Value : Team Id
          
	      List<Team__Share> tsList = new List<Team__Share>();
	      for(Id userId : userTeamMapToInsert.keyset()){
	        Team__Share ts = TeamShareManager.getTeamShareRecord(userTeamMapToInsert.get(userId), userId);
	        tsList.add(ts); 
	      }      
	      if(!tsList.isEmpty()){
	        //insert tsList;
	        Database.SaveResult[] lsr = Database.insert(tsList, false);
	        List<String> errorMessages = new List<String>();        
            // Process the save results
            for(Database.SaveResult sr : lsr){
              if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                errorMessages.add('Unable to insert team share record due to following exception:' + err.getMessage());                             
              }            
            }
            if(!errorMessages.isEmpty()){
            	//Util.LOG(errorMessages);
            }
	      }      
	  }
	  
	
    public static void insertAndUpdateTeams(List<Team__c> teamsToInsertUpdate){
    	// Method to Insert new Teams.
    	// insert teams.
        if(!teamsToInsertUpdate.isEmpty()) {
            Database.UpsertResult[] luR = Database.upsert(teamsToInsertUpdate, false);
            // Process the delete results
            List<String> errorMessages = new List<String>();
            for(Database.UpsertResult ur : luR){
                if(!ur.isSuccess()){
                    Database.Error err = ur.getErrors()[0];                
                    errorMessages.add('Unable to upsert team share record due to following exception:' + err.getMessage());
                }            
            }
            if(!errorMessages.isEmpty()){
              // Util.LOG(errorMessages); 
            }
        }
    }
    
    public static Team__c copyResearchTeamsValuesIntoTeam(Research_Team__c rt, Team__c t, String regionId, boolean isIndustry){
    // Method to copy team values into teams
        t.Name = rt.Name ;
        t.TeamID__c = rt.Team_Id__c <> null ? rt.Team_Id__c : '';
        t.isHidden__c = false;
        // copy team function only if it is 'Industry'
        if(isIndustry) {
            t.Team_Function__c = rt.Team_Function__c; 
        }
        t.Team_Lead_Name__c = rt.TeamLead_Name__c <> null ? rt.TeamLead_Name__c : '';
        t.Team_Status__c = rt.Team_Status__c;
        t.Team_Region__c = regionId;
        return t;
    } 
    
    //After Campaing Migration Instead of Active_Flag__c using Inactive__c field: Modified by Sudarshan K. 26th Feb 2016
    public static List<GPSEmployee__c> getActiveEmployeeListOnResearchTeams(List<Research_Team__c> researchTeams){
    	return [Select id,User__c,User__r.IsActive, Active_Flag__c, Research_Team__c,
                                   Research_Team__r.Active_Flag__c,Research_Team__r.Team_Id__c 
                                   from GPSEmployee__c e
                                   where Research_Team__c in :researchTeams 
                                   and e.User__r.IsActive = true 
                                   and e.Active_Flag__c = true];
    }
}