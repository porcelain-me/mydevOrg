public with sharing class ManageCampaignEntitlementsController
{
 
    String CampaignAdminPermissionSet = 'Campaign_Admin';
    String CampaignPermissionSet = 'GPS_Campaign_Permission_Set';
    String iiCampaignAdminPermissionSet = 'IICampaign_Admin';
    String iiCampaignPermissionSet = 'IICampaign_Permission_Set';
    String iiFanClubAdminPermissionSet = 'IIFanClub_Admin';
    String iiFanClubPermissionSet = 'IIFanClub_Permission_Set';
    String LoginAsPermissionSet = 'Login_As_Permission_Set';
    
    List<String> PermissionSetNames = new List<String>{CampaignAdminPermissionSet, CampaignPermissionSet, iiCampaignAdminPermissionSet, iiCampaignPermissionSet, iiFanClubAdminPermissionSet, iiFanClubPermissionSet, LoginAsPermissionSet};
    
    public PageReference Save() {
    
        List<PermissionSetAssignment> permisionSetAssignmentsToDelete = new List<PermissionSetAssignment>();
        
        for(CampaignPermissionSetAssignment cpsa: lstUserPermissionSetAssignment)
        {
            List<PermissionSetAssignment> lstPermissionSetAssignment = [select Id from PermissionSetAssignment where Assignee.Emp_ID__c = :cpsa.userMSID and PermissionSet.Name in :permissionSetNames];
            System.debug('*#*#:'+lstPermissionSetAssignment);
            permisionSetAssignmentsToDelete.addAll(lstPermissionSetAssignment);
        }
        
        delete permisionSetAssignmentsToDelete;
        
        List<PermissionSet> lstPermissionSet = [select Id, Name from PermissionSet where Name in :permissionSetNames];
        
        Map<String,String> mapPermissionSet = new Map<String,String>();
        
        for(PermissionSet ps:lstPermissionSet)
        {
            mapPermissionSet.put(ps.Name,ps.Id);    
        }

        List<PermissionSetAssignment> lstPermissionSetAssignment = new List<PermissionSetAssignment>();        
        
        for(CampaignPermissionSetAssignment cpsa: lstUserPermissionSetAssignment)
        {

            User u = new User(Emp_Id__c = cpsa.userMSID);
            
            if(cpsa.isCampaignAdmin)
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(CampaignAdminPermissionSet))); 
            if(cpsa.hasCampaignsAccess)
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(CampaignPermissionSet))); 
            if(cpsa.isiiCampaignAdmin)                
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(iiCampaignAdminPermissionSet)));             
            if(cpsa.hasiiCampaignAccess)    
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(iiCampaignPermissionSet))); 
            if(cpsa.isiiFanClubAdmin ) 
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(iiFanClubAdminPermissionSet ))); 
            if(cpsa.hasiiFanClubAccess ) 
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(iiFanClubPermissionSet))); 
            if(cpsa.hasLoginAsAccess )     
                lstPermissionSetAssignment.add(new PermissionSetAssignment(Assignee = u, PermissionSetId = mapPermissionSet.get(LoginAsPermissionSet)));
        }
            
        try
        {
            upsert lstPermissionSetAssignment;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Changes saved succesfully'));
        }    
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occurred when saving the changes.'+ ex.getMessage()));
        }    
        
        return null;
    }

    public List<User> users { get; set; }
    public String searchtoken { get; set; }
    public List<CampaignPermissionSetAssignment> lstUserPermissionSetAssignment { get; set; }


    public ManageCampaignEntitlementsController()
    {
        users= new List<User>();
        
    }

    public PageReference SearchUser()
    {
        lstUserPermissionSetAssignment = new List<CampaignPermissionSetAssignment>();
        
        String search;
        search = '%' + searchtoken + '%';
        users=[select Id, Name, Emp_Id__c, isActive from User where isActive=true and Profile.Name = 'All MS Employee' and (Name like :search or Emp_ID__c like :search or Short_Id__c like :search)];
        
        Map<Id,User> mapUsers = new Map<Id,User>();
        
        for(User u:users)
        {
            mapUsers.put(u.Id,u);
        }
        
        List<PermissionSetAssignment> lstPermissionSetAssignment = new List<PermissionSetAssignment>();
        Map<String, List<String>> mapPermissionSetAssignment = new Map<String, List<String>>();
        
        lstPermissionSetAssignment = [select AssigneeId, PermissionSet.Name from PermissionSetAssignment where AssigneeId in :mapUsers.keySet() and PermissionSet.Name in :permissionSetNames];
         
        for(PermissionSetAssignment psa:lstPermissionSetAssignment)
        {
        
            if(mapPermissionSetAssignment.get(psa.AssigneeId) != null)
            {
                List<String> permissionSets = mapPermissionSetAssignment.get(psa.AssigneeId);
                permissionSets.add(psa.PermissionSet.Name);
                mapPermissionSetAssignment.put(psa.AssigneeId,permissionSets);
            }
            else
            {
                List<String> permissionSets = new List<String>();
                permissionSets.add(psa.PermissionSet.Name);
                mapPermissionSetAssignment.put(psa.AssigneeId,permissionSets);
            }
        }
        
        for(String user: mapUsers.keyset())
        {
            CampaignPermissionSetAssignment cpsa = new CampaignPermissionSetAssignment();
        
            cpsa.userName = mapUsers.get(user).Name;
            cpsa.userMSID = mapUsers.get(user).Emp_Id__c;
            
            if(mapPermissionSetAssignment.get(user) != null){
                for(String permissionset: mapPermissionSetAssignment.get(user)){
                    if(permissionset == 'Campaign_Admin')
                        cpsa.isCampaignAdmin = true;
                    else if(permissionset == 'Campaign_Permission_Set')    
                        cpsa.hasCampaignsAccess = true;
                    else if(permissionset == 'IICampaign_Admin')    
                        cpsa.isiiCampaignAdmin = true;
                    else if(permissionset == 'IICampaign_Permission_Set')    
                        cpsa.hasiiCampaignAccess = true;
                    else if(permissionset == 'IIFanClub_Admin')    
                        cpsa.isiiFanClubAdmin = true;    
                    else if(permissionset == 'IIFanClub_Permission_Set')    
                        cpsa.hasiiFanClubAccess = true;
                    else if(permissionset == 'Login_As_Permission_Set')    
                        cpsa.hasLoginAsAccess = true;                 
                }                
            }
            lstUserPermissionSetAssignment .add(cpsa);
        }
        
        return null;
    }
        
    public class CampaignPermissionSetAssignment
    {
        public String userName {get; set;}
        public String userMSID {get; set;}
        public boolean isCampaignAdmin {get; set;}
        public boolean isiiCampaignAdmin {get; set;}
        public boolean isiiFanClubAdmin {get; set;}
        public boolean hasCampaignsAccess {get; set;}
        public boolean hasiiCampaignAccess {get; set;}
        public boolean hasiiFanClubAccess {get; set;}
        public boolean hasLoginAsAccess {get; set;}
    }
}