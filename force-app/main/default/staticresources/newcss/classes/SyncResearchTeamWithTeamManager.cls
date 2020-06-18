// 07/06/2012 : MG : Manager class for SyncResearchTeamWithTeam trigger

public class SyncResearchTeamWithTeamManager {
    /** LOGIC IMPLEMENTED
     
      Fire trigger when:
              (Active Research Team is created OR modified) AND (Active Research Team “Team Function” Field = INDUSTRY OR ECONOMICS OR STRATEGY)
      A) IF Active Research Team has matching Active Team:
              Copy over all appropriate Research Team values (name, region, team lead, etc) to Team Record
              Run Team Sharing updates (copy existing / add new / remove old)
      B) IF Active Research Team does not have matching active Team:
             Create new corresponding Team Record
             Copy over all appropriate Research Team values (name, region, team lead, etc) to Team Record
             Run Team Sharing updates (copy existing / add new / remove old)
             
      When to Automatically Delete Team Records:
             Never delete a Team.  However, If a Research Team’s TEAM STATUS is marked as “Closed”, mark the corresponding Team’s TEAM STATUS to “Closed”
             Note: Team Object’s TEAM STATUS does not currently have “Closed” as a picklist value.  This should be added.
    
    
    **/
    /** USE CASE
            1. Scenario >>  New Research Team is added – no matching Team record
               Team Action >> Add new Team and copy over values from Research Team.
               Team Sharing Permission Actions >> Add all Team Sharing permissions based on Research Team / Employee linked data/values 
        
        
            2. Scenario >> Research Team name (non-ID metadata) is updated – matching Team record
               Team Action >> Copy modified Research Team values to Team record
               Team Sharing Permission Actions >> None 
               
            3. Scenario >> Research Team name is updated – no matching Team record
               Team Action >> Add new Team and copy over values from Research Team.
               Team Sharing Permission Actions >> Add all Team Sharing permissions based on Research Team / Employee linked data/values 
                  
    **/
    static final String INDUSTRY = 'INDUSTRY';
    static final String ECONOMICS = 'ECONOMICS';
    static final String STRATEGY = 'STRATEGY';

    public static void syncTeams(Map<Id,Research_Team__c> newMap, Map<Id,Research_Team__c> oldMap, boolean isUpdate){
        // properties and variable definition
        Set<String> regionNameSet = new Set<String>();
        map<Id,Id> mapUserIdTeamIdToRemoveTeamShare = new map<Id,Id>(); 
        map<Id,Id> mapUserIdTeamIdToInsertTeamShare = new map<Id,Id>(); 
        map<String,Team__c> activeTeamIdTeamMap = new map<String,Team__c>();
        map<String,Team__c> allTeamIdTeamMap = new map<String,Team__c>();
        map<String,List<Id>> mapTeamIdActiveUserId = new map<String,List<Id>>(); 
        map<String,List<Id>> mapOldTeamIdAllUserId = new map<String,list<Id>>();
        list<String> allTeamIds = new list<String>();
        map<String, Research_Team__c> mapActiveTeamIdResearchTeams = new map<String, Research_Team__c>();
        list<Team__c> teamsToInsertUpdate = new list<Team__c>();  
        map<String,Id> regionIdMap = new map<String,Id>();
        
        // process only active research teams with team function either 'Industry' or 'Economics' or 'Strategy'.
        for(Research_Team__c rt : newMap.values() ) {
        	String newTeamId = rt.Team_Id__c;
        	String oldTeamId = isUpdate ? oldMap.get(rt.id).Team_Id__c : null;
        	String newTeamFunction = rt.Team_Function__c == null ? '' : rt.Team_Function__c.toLowerCase();
        	boolean newTeamActive = rt.Active_Flag__c;
        	String newRegionName = rt.Team_Region_Name__c;

            if(newTeamId <> null && newTeamActive == true                                         
                                          && (newTeamFunction == INDUSTRY.toLowerCase() || 
                                            newTeamFunction == ECONOMICS.toLowerCase() || 
                                            newTeamFunction == STRATEGY.toLowerCase() )) {
                if(newTeamId <> null) allTeamIds.add(newTeamId);
                if(oldTeamId <> null) allTeamIds.add(oldTeamId);
                mapActiveTeamIdResearchTeams.put(newTeamId,rt);
                if(newRegionName <> null) regionNameSet.add(rt.Team_Region_Name__c.toLowerCase());                
            }
        }
        if(mapActiveTeamIdResearchTeams.isEmpty()){
            return;	
        }
        // create Map of region name and Id.
        // Team has look up of Region. SO region Id needed.
        for(Region__c region : TeamShareManager.getRegionList(regionNameSet)){
           regionIdMap.put(region.Name.toLowerCase(),region.Id);
        }   
                                         
        // get all the existing teams and create map of team's team id and team.
        // create map of all teams 
        // create map of all active teams 
        for(Team__c t : TeamShareManager.getTeamList(allTeamIds)){
            String teamId = t.TeamID__c;
            boolean teamActive = !t.isHidden__c;
            allTeamIdTeamMap.put(teamId,t);
            if(mapActiveTeamIdResearchTeams.containsKey(teamId) && teamActive == true){
                activeTeamIdTeamMap.put(teamId,t); 
            }
        }
        SyncResearchTeamWithTeamManager.copyResearchTeamsValuesIntoTeam(mapActiveTeamIdResearchTeams.values(), activeTeamIdTeamMap, 
                                                                                   teamsToInsertUpdate, regionIdMap);
        
        // If teams are being updated, team share records for the related child employees need to be deleted or inserted.
        if(isUpdate) {
            for(GPSEmployee__c emp : TeamShareManager.getActiveEmployeeListOnResearchTeams(mapActiveTeamIdResearchTeams.values()) ){
                String empResearchTeamId = emp.Research_Team__r.Team_Id__c;
                String empResearchOldTeamId = oldMap.get(emp.Research_Team__c).Team_Id__c;
                Id empUserId = emp.User__c;
                if(empUserId <> null && empResearchTeamId <> null ){
	                // create map of new team ids to insert team shares
                    if(mapTeamIdActiveUserId.containsKey(empResearchTeamId)) {
                       mapTeamIdActiveUserId.get(empResearchTeamId).add(empUserId);
                    }
                    else {
                       mapTeamIdActiveUserId.put(empResearchTeamId,new List<Id>{empUserId});
                    }
	                // create map of oldTeamIds to remove team shares
	                if(mapOldTeamIdAllUserId.containsKey(empResearchOldTeamId)) {
                        mapOldTeamIdAllUserId.get(empResearchOldTeamId).add(empUserId);
                    }
                    else {
                        mapOldTeamIdAllUserId.put(empResearchOldTeamId,new List<Id>{empUserId});
                    }
                }
            }  
            for(String teamId : allTeamIdTeamMap.keySet()){
            	// create map to remove all the existing team shares
                if(mapOldTeamIdAllUserId.containsKey(teamId)) {
                    for(Id userId : mapOldTeamIdAllUserId.get(teamId)){
                       mapUserIdTeamIdToRemoveTeamShare.put(userId,allTeamIdTeamMap.get(teamId).Id);
                    }
                }
            }
            for(team__c t : teamsToInsertUpdate){
            	String teamId = t.TeamID__c;
            	// create map to insert new team shares for newly created or updated teams.
                if(mapTeamIdActiveUserId.containsKey(teamId)){
                    for(Id userId : mapTeamIdActiveUserId.get(teamId)){
                        mapUserIdTeamIdToInsertTeamShare.put(userId,t.Id);
                    }
                }
            }
        }
        // call TeamShareManager.removePreviouslySystemAddedPermissionForUsers to remove previously added team shares
        if(!mapUserIdTeamIdToInsertTeamShare.isEmpty()){
            TeamShareManager.removePreviouslySystemAddedPermissionForUsers(mapUserIdTeamIdToRemoveTeamShare);
        }
        // call TeamShareManager.insertSystemAddedPermissionForUsersAndTeam to create team share records
        if(!mapUserIdTeamIdToInsertTeamShare.isEmpty()){
            TeamShareManager.insertSystemAddedPermissionForUsersAndTeam(mapUserIdTeamIdToInsertTeamShare);
        }
    }
    
    
    public static void copyResearchTeamsValuesIntoTeam(List<Research_Team__c> activeResearchTeams, 
                     map<String,Team__c> activeTeamIdTeamMap, list<Team__c> teamsToInsertUpdate,
                     map<String,Id> regionIdMap){    	
    	// process all active research teams to create/update teams.
        for(Research_Team__c rt : activeResearchTeams){
            Team__c t ;
            String regionId ;
            boolean isIndustry = false ;
            String researchTeamFunction = rt.Team_Function__c <> null ? rt.Team_Function__c.toLowerCase() : null;
            String teamRegionName = rt.Team_Region_Name__c <> null ? rt.Team_Region_Name__c : null ;
            String teamId = rt.Team_Id__c <> null ? rt.Team_Id__c : null ;
            
            if(researchTeamFunction <> null && researchTeamFunction == INDUSTRY.toLowerCase()){
               isIndustry = true;
            }
            if(teamRegionName <> null && regionIdMap.containsKey(teamRegionName.toLowerCase())) {
               regionId  = regionIdMap.get(teamRegionName.toLowerCase());
            }
            if(teamId <> null && activeTeamIdTeamMap.containsKey(teamId)){
                // team exists. copy research team values into team.
                t = TeamShareManager.copyResearchTeamsValuesIntoTeam(rt,activeTeamIdTeamMap.get(teamId), regionId, isIndustry);
            }
            else {
               // team does not exist. create new Team record and copy research team values into team.
               t = new Team__c();
               t = TeamShareManager.copyResearchTeamsValuesIntoTeam(rt,t,regionId,isIndustry);
            }
            if(t <> null){
                teamsToInsertUpdate.add(t); 
            }
        }
        // insert or update team list into database
        if(!teamsToInsertUpdate.isEmpty()){
            TeamShareManager.insertAndUpdateTeams(teamsToInsertUpdate);
        }
    }
}