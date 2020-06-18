/**
 * FileName : TeamPulldownController
 * *************************************Modification Log***********************************************
 * 12 Jan 2015 : Smita S : Jira 4490 Put a check on team object
 *
 *
**/ 
public with sharing class TeamsPulldownController {
    private List<SelectOption> teams = new List<SelectOption>();
    private String selectedTeam;
    private String showReports='none';
    private String showSetup='none';
    private String username;
    // Commented by Swapnd on 18-feb-2016 for Campaign Migration
   // public List<GPS_Tab__c> gpsTabs {get; set;}
    public String selectedRegion {get; set;}
      // Commented by Swapnd on 18-feb-2016 for Campaign Migration
   // public List<Quicklink__c> quicklinks {get; set;}
    
    private String teamId = System.currentPageReference().getParameters().get('teamId');
    
    public String getTeamId() {
        return teamId;
    }
    
    public String getUsername(){
        User usr = [select Username from User where Id=:UserInfo.getUserId()];
        
        return usr.Username;    
    }
    public String getShowReports(){
        return showReports; 
    }
    public String getShowSetup(){
        return showSetup;   
    }
    /* Grab all of the team objects to which this user is entitled
       and check to see if the user is a sysadmin or a power user 
       and allow the user to see the setup/reports buttons based on this
     */
    public TeamsPulldownController(){ } 
    public TeamsPulldownController(Id usrId){
        //Id usrId = UserInfo.getUserId();
        boolean isAdminProfiles = false;
        User usr = [select Profile.Name From User where Id=:usrId];
        String teamId;
        String regionId;
        List<Team__c> teamObjects = new List<Team__c>();
        
        if(usr.Profile.Name =='System Administrator Classic' || usr.Profile.Name =='System Administrator'){
            showReports='';
            showSetup=''; 
            isAdminProfiles = true;
        }
        if(usr.Profile.Name=='All MS Employee'){
            showReports='';
        }
        
        /***************JIRA-4815 by Sudarshan K. on 4th May 2016*******************************************/
        map<Id, Team__c> mapTeam = new map<Id, Team__c>([select Id, TeamID__c, Name, Team_Region__c from Team__c  where Name <> NULL order by Name asc]);
        
        list<PermissionSetAssignment> listPermision = new list<PermissionSetAssignment>();
        listPermision = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id =:usrId];
        
        for(PermissionSetAssignment usrper : listPermision){
            if(usrper.PermissionSet.Name == 'IIFanClub_Admin'){
                isAdminProfiles = true;     
                break;
            }   
        }
        if(isAdminProfiles){
            teamObjects = mapTeam.values();
        }else{
            
            for(Team__Share tshare : [SELECT Id, ParentId FROM Team__Share WHERE IsDeleted = false AND UserOrGroupId =: usrId]){
                teamObjects.add(mapTeam.get(tshare.ParentId));
            }
        }
        /*******************************************End Code********************************************/
        //12 Jan 2015 : Smita S : Jira 4490 Put a check on team object
        System.debug('teamObject.size()*****'+teamObjects.size());
        if(teamObjects.size()>0){
       
            for(Team__c team:teamObjects){
                teams.add(new SelectOption(team.Id+';'+team.TeamID__c, team.Name)); 
            }
            
            if(teams.size()>0){
                selectedTeam = teams[0].getValue();
                system.debug('----selectedTeam-----'+selectedTeam);
                List<String> teamids = teams[0].getValue().split(';');
                teamId =teamids[0];
                List<Team__c> region = [select Name, Team_Region__c, Team_Region__r.Name from Team__c where Id=:teamId];
                if(region!=null && region.size()>0){
                    regionId=region[0].Team_Region__c;
                    selectedRegion = region[0].Team_Region__r.Name;
                } else {
                    regionId = [select Id from Region__c where Name = 'North America'].Id;
                }
                //// Commented by Swapnd on 18-feb-2016 for Campaign Migration
               /* gpsTabs = [select Tab_URL__c, Tab_Name__c, Region__c, Page_Name__c, Order__c from GPS_Tab__c where Region__c =: regionId order by Order__c asc];*/
            }
              // Commented by Swapnd on 18-feb-2016 for Campaign Migration
           // quicklinks = [select Report_Name__c, Report_URL__c from Quicklink__c];
        }  
    }
     
    // The teams for the VF page teams dropdown
    public List<SelectOption> getTeams(){
        return teams;
    }
    // This will be the selected team on the VF page dropdown
    public String getSelectedTeam(){
        return selectedTeam;    
    }
    
    public void setSelectedTeam(String selectedTeam){
        this.selectedTeam = selectedTeam;   
    }
}