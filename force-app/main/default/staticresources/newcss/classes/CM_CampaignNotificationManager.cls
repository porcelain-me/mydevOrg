// Orignal : PG 
// Date    : 10/24/2011
// 
// 10/31/2011 RJ: Reviewed the code.
//                Cosmetic code modifications suggested such as 1. move queries in CM_CampaignDataUtil.cls and provide custom setting error messages
// 11/08/2011 UV : Removed all queries to CM_CampaignDataUtil class.  
// 11/29/2011 UV : Updated this to resolved misdirect emails. (line #54-56)
// 11/30/2011 UV : Added a new boolean  parameter in the insertCampaignNotification() method. (line#19,65-66)
// 12/02/2011 UV  : update method insertCampaignNotification for cancel request.(line# 81-99) 
// 02/01/2012 RJ  : Modified to point the Campaign Notification url field to GPSRedirect page.
// 02/02/2012 RJ : Modified to add cid (related campaign id) parameter to the campaign notification url field.
public class CM_CampaignNotificationManager {

Static String CN_REQUEST_RECORD_TYPE;
Static String TASK_RECORDTYPE_NAME ;
Static String CN_REASSIGN_RECORD_TYPE;
Static String CODE_NAME;
Static String CAMPAIGN_URL;
// 02/01/2012  RJ: 
Static String GPSRedirect_URL;
Static final String CANCELED = 'Canceled';
Static final String CAMPAIGN_URL_KEY = '&cid=';
Static final String GOTOURL = 'http://email';

//Insert records into Campaign Notification upon Insert/updates on task object for Campaign.
// 11/30/2011 UV : Added a new boolean  parameter in the insertCampaignNotification() method.
public static void insertCampaignNotification(List<Task> insertedtasks, Boolean isForDelete){
    List<Campaign_Notification__c> cnnlst = new List<campaign_Notification__c>();
    List<Campaign_Notification__c> existingCNlstforCancelRequestTaskIds = new List<campaign_Notification__c>();
    Map<String,String> taskRecordTypes = new Map<String,String>();
    Map<String, String> tskIdList = new Map<String, String>();
    List<RecordType> rtypes = CM_CampaignDataUtil.getTaskActiveRecordTypes();
  
    
    
    CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
    CN_REQUEST_RECORD_TYPE = cMGS.CN_REQUEST_RECORD_TYPE__c ;
    TASK_RECORDTYPE_NAME  = cMGS.TASK_RECORDTYPE_NAME__c  ;
    CODE_NAME  = cMGS.APP_NAME__c;
    CAMPAIGN_URL = cMGS.CAMPAIGN_URL__c;
    // 02/01/2012  RJ: 
      GPSRedirect_URL = cMGS.GPSRedirect_URL__c;
   
    
    for(RecordType rt: rtypes){
        taskRecordTypes.put(rt.DeveloperName,rt.Id);
    }   

    set<id> CntctIdSet = new set<id>();
    for (task task1 : insertedtasks) {
      if (task1.GPS_Contact__c != null) {
        CntctIdSet.add(task1.GPS_Contact__c);
      }
       
    }   
 
   List<GPSContact__c > CntctLst = CM_CampaignDataUtil.getAccountIdsOfContacts(CntctIdSet);

  Map<Id,Id> CntctAcctMap = new Map<Id,Id>{};
  for(GPSContact__c  cnt: CntctLst){
    CntctAcctMap.put(cnt.id, cnt.GPSACCOUNT__c);
  }
  //adding Record type for CN
  RecordType cnRtype = CM_CampaignDataUtil.getRecordTypeOnObjectAndDeveloperName('Campaign_Notification__c', CN_REQUEST_RECORD_TYPE); 
  
  // build URL logic
  String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
 
  /* Commented by Sudarshan K. on 17th Feb 2016 while campaing Migration
  App__c app = CM_CampaignDataUtil.getAppIdOnCodeName(CODE_NAME);*/
  for(task t : insertedtasks){
     if(t.RecordTypeId==taskRecordTypes.get(Task_Recordtype_Name)){
     	
     	//If condition added  to check the Logged-in User
     	//Modified from this line : assigned_by__c = (Trigger.isInsert ? t.LastModifiedById : t.CreatedById),
     	//To: assigned_by__c = (Trigger.isInsert ? loggedInUserid : t.CreatedById),
     	list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	             cnnlst.add(new Campaign_Notification__c (  assigned_to__c = t.Ownerid, 
                                                  // 11/29/2011 UV : Updated this to resolved misdirect emails.
                                                  //assigned_by__c = (Trigger.isInsert ? t.CreatedById : t.LastModifiedById),  
                                                  assigned_by__c = (Trigger.isInsert ? loggedInUserid : t.CreatedById),
                                                  subject__c = t.subject,
                                                  Message__c = t.Description,
                                                  Campaign__c = t.WhatId,
                                                  GPSContact__c   = t.GPS_Contact__c,
                                                  GPSAccount__c = CntctAcctMap.get(t.GPS_Contact__c),
                                                  // 11/30/2011 UV :added a condition on the status.
                                                  Status__c  = isForDelete ? CANCELED : t.status,
                                                  Type__c    = t.Type,
                                                  Assignee_Feedback__c = t.Assignee_Feedback__c,
                                                  RecordTypeid = cnRtype.id,
                                                  // 02/01/2012  RJ:
                                                  //url__c     = fullFileURL + CAMPAIGN_URL + app.id ,
                                                  //url__c     = fullFileURL + GPSRedirect_URL + CAMPAIGN_URL + '<appid>' + CAMPAIGN_URL_KEY + t.WhatId,
                                                 // url__c     = fullFileURL + GPSRedirect_URL + GOTOURL + CAMPAIGN_URL_KEY + t.WhatId,
                                                  url__c     = fullFileURL +'/apex/campaigns?cid='+ t.WhatId,
                                                  TaskId__c = t.Id,
                                                  Due_date__c = t.ActivityDate));
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	             cnnlst.add(new Campaign_Notification__c (  assigned_to__c = t.Ownerid, 
                                                  // 11/29/2011 UV : Updated this to resolved misdirect emails.
                                                  //assigned_by__c = (Trigger.isInsert ? t.CreatedById : t.LastModifiedById),  
                                                  assigned_by__c = (Trigger.isInsert ? loggedInUserid : t.CreatedById),
                                                  subject__c = t.subject,
                                                  Message__c = t.Description,
                                                  Campaign__c = t.WhatId,
                                                  GPSContact__c   = t.GPS_Contact__c,
                                                  GPSAccount__c = CntctAcctMap.get(t.GPS_Contact__c),
                                                  // 11/30/2011 UV :added a condition on the status.
                                                  Status__c  = isForDelete ? CANCELED : t.status,
                                                  Type__c    = t.Type,
                                                  Assignee_Feedback__c = t.Assignee_Feedback__c,
                                                  RecordTypeid = cnRtype.id,
                                                  // 02/01/2012  RJ:
                                                  //url__c     = fullFileURL + CAMPAIGN_URL + app.id ,
                                                  //url__c     = fullFileURL + GPSRedirect_URL + CAMPAIGN_URL + '<appid>' + CAMPAIGN_URL_KEY + t.WhatId,
                                                 // url__c     = fullFileURL + GPSRedirect_URL + GOTOURL + CAMPAIGN_URL_KEY + t.WhatId,
                                                  url__c     = fullFileURL +'/apex/campaigns?cid='+ t.WhatId,
                                                  TaskId__c = t.Id,
                                                  Due_date__c = t.ActivityDate));
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	            cnnlst.add(new Campaign_Notification__c (  assigned_to__c = t.Ownerid, 
                                                  // 11/29/2011 UV : Updated this to resolved misdirect emails.
                                                  //assigned_by__c = (Trigger.isInsert ? t.CreatedById : t.LastModifiedById),  
                                                  assigned_by__c = (Trigger.isInsert ? loggedInUserid : t.CreatedById),
                                                  subject__c = t.subject,
                                                  Message__c = t.Description,
                                                  Campaign__c = t.WhatId,
                                                  GPSContact__c   = t.GPS_Contact__c,
                                                  GPSAccount__c = CntctAcctMap.get(t.GPS_Contact__c),
                                                  // 11/30/2011 UV :added a condition on the status.
                                                  Status__c  = isForDelete ? CANCELED : t.status,
                                                  Type__c    = t.Type,
                                                  Assignee_Feedback__c = t.Assignee_Feedback__c,
                                                  RecordTypeid = cnRtype.id,
                                                  // 02/01/2012  RJ:
                                                  //url__c     = fullFileURL + CAMPAIGN_URL + app.id ,
                                                  //url__c     = fullFileURL + GPSRedirect_URL + CAMPAIGN_URL + '<appid>' + CAMPAIGN_URL_KEY + t.WhatId,
                                                 // url__c     = fullFileURL + GPSRedirect_URL + GOTOURL + CAMPAIGN_URL_KEY + t.WhatId,
                                                  url__c     = fullFileURL +'/apex/campaigns?cid='+ t.WhatId,
                                                  TaskId__c = t.Id,
                                                  Due_date__c = t.ActivityDate));
	            
	     }
     	//
     	
       /*
       cnnlst.add(new Campaign_Notification__c (  assigned_to__c = t.Ownerid, 
                                                  // 11/29/2011 UV : Updated this to resolved misdirect emails.
                                                  //assigned_by__c = (Trigger.isInsert ? t.CreatedById : t.LastModifiedById),  
                                                  assigned_by__c = (Trigger.isInsert ? t.LastModifiedById : t.CreatedById),
                                                  subject__c = t.subject,
                                                  Message__c = t.Description,
                                                  Campaign__c = t.WhatId,
                                                  GPSContact__c   = t.GPS_Contact__c,
                                                  GPSAccount__c = CntctAcctMap.get(t.GPS_Contact__c),
                                                  // 11/30/2011 UV :added a condition on the status.
                                                  Status__c  = isForDelete ? CANCELED : t.status,
                                                  Type__c    = t.Type,
                                                  Assignee_Feedback__c = t.Assignee_Feedback__c,
                                                  RecordTypeid = cnRtype.id,
                                                  // 02/01/2012  RJ:
                                                  //url__c     = fullFileURL + CAMPAIGN_URL + app.id ,
                                                  //url__c     = fullFileURL + GPSRedirect_URL + CAMPAIGN_URL + '<appid>' + CAMPAIGN_URL_KEY + t.WhatId,
                                                 // url__c     = fullFileURL + GPSRedirect_URL + GOTOURL + CAMPAIGN_URL_KEY + t.WhatId,
                                                  url__c     = fullFileURL +'/apex/campaigns?cid='+ t.WhatId,
                                                  TaskId__c = t.Id,
                                                  Due_date__c = t.ActivityDate));
         */                                         
      //12/02/2011 UV : create List of TaskIds for cancel request.
      //if(isForDelete) {
        tskIdList.put(t.Id, t.Status);
      //}  
     }
  }
    
  if(tskIdList.size() > 0) {     
      existingCNlstforCancelRequestTaskIds = CM_CampaignDataUtil.getCampaignNotificationListOnTaskId(tskIdList.keySet());
      for(Campaign_Notification__c cn : existingCNlstforCancelRequestTaskIds) {
        cn.Status__c = isForDelete ? CANCELED : tskIdList.get(cn.taskId__c);
        cn.IsActive__c = false;
        cn.InActiveDate__c = date.today();
        
      }
      if(existingCNlstforCancelRequestTaskIds.size() > 0) {
        update existingCNlstforCancelRequestTaskIds;
      }
  }
  if (cnnlst.size() > 0) {
    insert cnnlst;
  }
   
}// end of insertCampaignNotification(List<Task> insertedtasks)  
 
//Insert records into Campaign Notification upon Member Reassignment.
public static void insertCampaignNotificationOnMemReassignment(id campaignId,id AssignedTo, Integer NoofCntcts){
  
  CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
  CN_REASSIGN_RECORD_TYPE = cMGS.CN_REASSIGN_RECORD_TYPE__c ;
  CAMPAIGN_URL = cMGS.CAMPAIGN_URL__c;
  CODE_NAME  = cMGS.APP_NAME__c;
  // 02/01/2012  RJ: 
  GPSRedirect_URL = cMGS.GPSRedirect_URL__c;
    
//adding Record type for CN
RecordType cnRtype = CM_CampaignDataUtil.getRecordTypeOnObjectAndDeveloperName('Campaign_NOtification__c', CN_REASSIGN_RECORD_TYPE);  

          
// build URL logic
   String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
    /*Commented by Sudarshan K. on 17th Feb 2016 While campaign Migration
    App__c app = CM_CampaignDataUtil.getAppIdOnCodeName(CODE_NAME);*/
  
    Campaign_Notification__c cn = new Campaign_Notification__c();   
     cn.assigned_to__c = AssignedTo;
     cn.assigned_by__c = UserInfo.getUserID();
     cn.Campaign__c = Campaignid;
     cn.RecordTypeid = cnRtype.id;
     // 02/01/2012  RJ:
     //cn.url__c     = fullFileURL + CAMPAIGN_URL + app.id;
     cn.url__c     = fullFileURL + GPSRedirect_URL + GOTOURL + CAMPAIGN_URL_KEY + Campaignid;
     cn.No_of_Contacts_Reassigned__c = NoofCntcts;
     cn.Due_date__c = datetime.now();     
         
     insert cn;
  }
}