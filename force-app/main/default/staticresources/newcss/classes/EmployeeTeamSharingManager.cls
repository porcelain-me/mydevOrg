public without sharing class EmployeeTeamSharingManager {
    
    
  /***  LOGIC IMPLEMENTATION
    Fire trigger when:
                    Employee record is added / made active OR 
                    Employee record’s Research Team value is modified OR 
                    User record is added / made active
    
    Change sharing permissions only when the following conditions are met:
                    IF
                    Employee has a matching active User record, AND
                    Employee has a non-null Research Team value, AND 
                    That Research Team has a matching active Team record
                    THEN
                    Add that Team Sharing Permission
                    Remove any other previously system-added Team Sharing Permission (do not remove "manual overrides")
  **/
  /** USE CASE
            1. Scenario >>  Employee record changes team – matching user record
               Team Action >> Team should already exist.
               Team Sharing Permission Actions >> Employee’s Team Sharing value automatically added for user
                                                  Employee’s Old Team Sharing value automatically removed for any system-added teams (manual overrides remain). 
        
        
            2. Scenario >> Employee record changes team – no matching user record
               Team Action >> None
               Team Sharing Permission Actions >> None 
    18/03/2016:Replaced Employee__c with GPSEmployee__c by Swapnd
  **/
  public static void updateTeamSharing(Map<Id, GPSEmployee__c> newMap, Map<Id, GPSEmployee__c> oldMap, boolean isUpdate){
        // properties and variable defination
        List<GPSEmployee__c> newList = new List<GPSEmployee__c>();
        Map<Id, Id> userTeamMapToInsert = new Map<Id, Id>();
        Map<Id, Id> userTeamMapToRemove = new Map<Id, Id>();        
        Map<Id, String> researchTeamTeamIdMap = new Map<Id, String>();
        Map<String, Id> allTeamMap = new Map<String, Id>();
        Set<String> activeTeamSet = new Set<String>();
        Set<Id> researchTeamIds = new Set<Id>();
        Set<Id> employeeIdsToUpdate = new Set<Id>();
        
        //Fire trigger when: Employee record is added / made active OR Employee record's Research Team value is modified 
        for(GPSEmployee__c emp: newMap.values()){
        	
        	// get currently associated research team id; we need to add team sharing for this team with current employee
            if(emp.Research_Team__c <> null)  researchTeamIds.add(emp.Research_Team__c);
            
            // get previously associated research team id with current employee; if previous research team is not null.
            // we need previous research team id because we have to remove team sharing for that team with current employee.
            if(isUpdate && oldMap.get(emp.id).Research_Team__c <> null) researchTeamIds.add(oldMap.get(emp.id).Research_Team__c);
            
            //Employee record is updated by making it active OR Employee record's Research Team value is modified   
            //After Campaing Migration Instead of Active_Flag__c using Inactive__c field: Modified by Sudarshan K. 26th Feb 2016         
            if(isUpdate && ((emp.Research_Team__c <> oldMap.get(emp.id).Research_Team__c) || 
                            (emp.Active_Flag__c != true && oldMap.get(emp.id).Active_Flag__c != false))
                           ){
                    employeeIdsToUpdate.add(emp.id);               
            }
            
            //Employee record is added
            if(!isUpdate){
            	employeeIdsToUpdate.add(emp.id); 
            }
        }
        
        // query employee to get look up reference value of research team associated.
        // CONDITION MATCH : Employee is active and Employee has a matching active User record 
        // otherwise newlist won't have that employee record.
        newList = TeamShareManager.getActiveEmployeeList(employeeIdsToUpdate);
        
        
        // if there are no active employee or associated user then do nothing.
        if(newList.isEmpty()){
        	return;
        }
        
        
        
        // populate team ids in a set that is required for querying active and old team set.
        for(Research_Team__c rT : TeamShareManager.getResearchTeamList(researchTeamIds)){
        	researchTeamTeamIdMap.put(rT.id, rT.Team_Id__c);
        }
        
        
        // query team object and create a set of active teams with team ids.       
        for(Team__c team : TeamShareManager.getTeamList(researchTeamTeamIdMap.values())){
          if(team.isHidden__c == false){
          	activeTeamSet.add(team.TeamID__c);
          }  
          allTeamMap.put(team.TeamID__c, team.Id);
        }
        
        for(GPSEmployee__c emp : newList){        	
        	boolean isNewTeamActive = (emp.Research_Team__c == null ? false : activeTeamSet.contains(emp.Research_Team__r.Team_Id__c));
        	Id newTeamId = (emp.Research_Team__c == null ? null : allTeamMap.get(emp.Research_Team__r.Team_Id__c)); 
        	Id newEmpUser = emp.User__c;       	  
            // check if trigger is for update           
            if(isUpdate){
              GPSEmployee__c oldEmp = oldMap.get(emp.Id);
              Id oldTeamId = (oldEmp.Research_Team__c == null ? null : allTeamMap.get(researchTeamTeamIdMap.get(oldEmp.Research_Team__c)));
              Id oldEmpUser = oldEmp.User__c;
              
              //CONDIDTION MATCH if employee research team has set to null then remove previously system added permission for users
              if(newTeamId == null && newTeamId <> oldTeamId && oldEmpUser <> null){
              	userTeamMapToRemove.put(oldEmpUser, oldTeamId);
              
              // CONDITION MATCH: Employee has a non-null Research Team value, AND 
              // That Research Team has a matching active Team record	
              }else if(newTeamId <> null && newEmpUser <> null && isNewTeamActive) { 
                 if(oldEmpUser <> null && oldTeamId <> null)  userTeamMapToRemove.put(oldEmpUser, oldTeamId);
                 userTeamMapToInsert.put(newEmpUser, newTeamId);
              
              }else if(oldEmpUser <> null && oldTeamId <> null){              	              	              	
              	 userTeamMapToRemove.put(oldEmpUser, oldTeamId);
              	 //7/27/2012 UV: commented below because if team is not active then new team share should not be created.
                 //if(newTeamId <> null && newEmpUser <> null) userTeamMapToInsert.put(newEmpUser, newTeamId);
                 
              }              
              // for insert 
              // CONDITION MATCH: Employee has a non-null Research Team value, AND 
              // That Research Team has a matching active Team record 
            }else if(newEmpUser <> null && isNewTeamActive){            	 
                 userTeamMapToInsert.put(newEmpUser, newTeamId);
            }
        }
       if(!userTeamMapToRemove.isEmpty()) {
       	  // Remove any other previously system-added Team Sharing Permission (do not remove "manual overrides")
          TeamShareManager.removePreviouslySystemAddedPermissionForUsers(userTeamMapToRemove);
       }
       if(!userTeamMapToInsert.isEmpty()) {
       	  // Add Team sharing permission for successfully employee users.
          TeamShareManager.insertSystemAddedPermissionForUsersAndTeam(userTeamMapToInsert);
       }
       
  }
}