public class CampaignHeadermenuController {

public list<PermissionSetAssignment> listPermision{get; set;}
public Boolean campaigntab{get;set;}
public Boolean iifanclub{get;set;}
public Boolean iicampaign{get;set;}
public Boolean setup{get;set;}
public Boolean loginas{get;set;}
public Boolean adminhome{get;set;}
public Boolean searchutility{get;set;}
public string oboUser{get; set;}
public Boolean MSDesktopMode {get;set;}

/**********Login-As custom functionality by Sudarshan K. 3rd May 2016 Start Code******/
public boolean isDiffUserLogin { get; set; }  
public String loggedInUserId;
public User loggedInUser { get; set; }
/************************End Code***********************************/

public CampaignHeadermenuController()
{   
     campaigntab = false;
     iifanclub = false;
     iicampaign = false;
     setup = false;
     loginas = false;
     adminhome = false;
     searchutility=false;
     MSDesktopMode=false;
      /**********Login-As custom functionality by Sudarshan K. 3rd May 2016 Start Code******/
      loggedInUser = new User();
        if(ApexPages.currentPage().getParameters().get('UId') != null){
            loggedInUserId = ApexPages.currentPage().getParameters().get('UId');
            System.debug('*#*#LoggedInUserId:'+loggedInUserId);
            List<User> lstUser = [SELECT Id, Emp_Id__c, FirstName, Preferred_Name__c, LastName, ProfileId FROM User WHERE IsActive = true AND Id = :loggedInUserId];
            if(!lstUser.isEmpty()){
                loggedInUserId = lstUser[0].Id;
                loggedInUser = lstUser[0];
                isDiffUserLogin = true;
                System.debug('*#*#1LoggedInUserId:'+loggedInUserId);
                System.debug('*#*#1isDiffUserLogin:'+isDiffUserLogin);
            }else{
                loggedInUserId = Userinfo.getUserId();
                isDiffUserLogin = false;
                System.debug('*#*#2LoggedInUserId:'+loggedInUserId);
                System.debug('*#*#2isDiffUserLogin:'+isDiffUserLogin);
            }
        }else{
            loggedInUserId = Userinfo.getUserId();
            isDiffUserLogin = false;
            System.debug('*#*#3LoggedInUserId:'+loggedInUserId);
            System.debug('*#*#3isDiffUserLogin:'+isDiffUserLogin);
        }   
        
        /********************************End Code******************************************/
        
        if(ApexPages.currentPage().getParameters().get('showheadertabs')!=null){
        	if( ApexPages.currentPage().getParameters().get('showheadertabs') == 'false')
        		MSDesktopMode = true;
        }
        
        
    String Name = [Select profile.Name from User where id=:userinfo.getuserid()].profile.Name;
    if((Name == 'System Administrator Classic' || Name =='System Administrator') && !isDiffUserLogin){
         campaigntab = true;
         iifanclub = true;
         iicampaign = true;
         setup = true;
         loginas = true;
         adminhome = true;
         searchutility=true;
    }
    
    System.debug('*#*#4LoggedInUserId:'+loggedInUserId);
    System.debug('*#*#4isDiffUserLogin:'+isDiffUserLogin);
    
    listPermision = new list<PermissionSetAssignment>();
    listPermision = [select PermissionSet.Name from PermissionSetAssignment where Assignee.Id =:loggedInUserId order by PermissionSet.Name];
   
    for(PermissionSetAssignment ps: listPermision){
        if(ps.PermissionSet.Name == 'GPS_Campaign_Permission_Set'){
            campaigntab = true;
        }
        else if(ps.PermissionSet.Name == 'IIFanClub_Permission_Set'){
            iifanclub = true;
        }
        else if(ps.PermissionSet.Name == 'IICampaign_Permission_Set'){
            iicampaign = true;
        }
        else if((ps.PermissionSet.Name == 'Campaign_Admin'||ps.PermissionSet.Name == 'IICampaign_Admin'||ps.PermissionSet.Name == 'IIFanClub_Admin') && !isDiffUserLogin){
        	System.debug('*#*#Setup is true');
            setup = true;
            if(ps.PermissionSet.Name == 'IICampaign_Admin'||ps.PermissionSet.Name == 'IIFanClub_Admin'){
	    		searchutility=true;
            }
        }        
        else if(ps.PermissionSet.Name == 'Login_As_Permission_Set' && !isDiffUserLogin){
            loginas = true;
        }
 
    }
    
}

public PageReference tabRedirect(){
    
    String pageName = ApexPages.currentPage().getParameters().get('pagename');  
    
    if(pageName == 'IICampaigns'){
        PageReference pageRef = new PageReference('/apex/myiilist');
            if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
            if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
        return pageRef;
    }else if(pageName == 'IIFanClub'){
        PageReference pageRef = new PageReference('/apex/iifanclub');
            if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
            if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
        return pageRef;
    }else if(pageName == 'GPSCampaigns'){
        PageReference pageRef = new PageReference('/apex/campaigns');
            if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
			if(MSDesktopMode)
               	pageRef.getParameters().put('showheadertabs', 'false');                
        return pageRef;
    }else if(pageName == 'LoginAsView' && !isDiffUserLogin){        
        PageReference pageRef = new PageReference('/apex/CampaignUserLoginAsView');
        if(MSDesktopMode)
               	pageRef.getParameters().put('showheadertabs', 'false');
        return pageRef;
    }else if(pageName == 'Setup' && !isDiffUserLogin){
        PageReference pageRef = new PageReference('/apex/SFDCSetup');
        return pageRef;
    }else if(pageName=='searchutility' && !isDiffUserLogin){
    	PageReference pageRef = new PageReference('/apex/searchutility');
    	if(MSDesktopMode)
               	pageRef.getParameters().put('showheadertabs', 'false');
        return pageRef;
    }
    
    return null;
}

public PageReference redirect(){
        
        
    /*************************Start Code By Sudarshan K. 6th May 2016 to sync GPS Employee ************************************
    User usr = [SELECT Id, Name, Emp_Id__c FROM User WHERE Id =: loggedInUserId LIMIT 1];
    List<GPSEmployee__c> lstEmp = [SELECT Id, MS_ID__c, User__c FROM GPSEmployee__c WHERE User__c =: usr.Id OR MS_ID__c =: usr.Emp_Id__c LIMIT 1];
    if(lstEmp.isEmpty()){
        GPSEmployee__c emp = new GPSEmployee__c(Name = usr.Name, User__c = usr.Id);
        insert emp;
    }else if(lstEmp[0].User__c == null){
        lstEmp[0].User__c = usr.Id;
        lstEmp[0].MS_ID__c = usr.Emp_Id__c;
        update lstEmp[0];
    }
    
    ************************************End Code**************************************************/
    
        if(adminhome && !isDiffUserLogin){
            PageReference pageRef = new PageReference('/apex/campaigns');
                if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
                if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
            return pageRef;
        }
        else if(campaigntab ){
            PageReference pageRef = new PageReference('/apex/campaigns');
                if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
                if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
            return pageRef;
        }
        else if(iifanclub){
            PageReference pageRef = new PageReference('/apex/iifanclub');
                if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
                if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
            return pageRef;
        }
        else if(iicampaign){
             PageReference pageRef = new PageReference('/apex/myiilist');
                if(isDiffUserLogin)
                pageRef.getParameters().put('UId', loggedInUserId);
               if(MSDesktopMode)
                	pageRef.getParameters().put('showheadertabs', 'false');
             return pageRef;
        }
        else if(loginas && !isDiffUserLogin){
            //PageReference pageRef = new PageReference('/apex/CampaignLoginAsView');
            PageReference pageRef = new PageReference('/apex/CampaignUserLoginAsView');
            return pageRef;
        }
        else if(setup && !isDiffUserLogin){
            PageReference pageRef = new PageReference('/apex/SFDCSetup');
            return pageRef;
        //If another logged-in user don't have any tab access then context user will auto redirected to his login-as page    
        }else if(isDiffUserLogin){
        	PageReference pageRef = new PageReference('/apex/CampaignUserLoginAsView');
            return pageRef;
            
        }else{
            PageReference pageRef = new PageReference('/');
                
            return pageRef;
        }
}

public PageReference removeRecordGPSCampaignLogIn(){
        list<GPSCampaignsLoginAs__c> loggedUserList =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =:UserInfo.getUserId() and Login_As_User__c=:oboUser limit 1];
        if(loggedUserList.size() > 0){
        	loggedUserList[0].Login_As_User__c = '';
			update loggedUserList;
        }
       
        PageReference pr = new PageReference('/apex/CampaignUserLoginAsView');
        if(MSDesktopMode)
               	pr.getParameters().put('showheadertabs', 'false');
        pr.setRedirect(true);
        return pr;
}

}