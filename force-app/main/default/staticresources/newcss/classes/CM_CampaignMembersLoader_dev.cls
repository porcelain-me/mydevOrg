// 11/14/2011 RJ: ORIGINAL
//                Controller class to load campaign members in the system from csv file
// 
// 11/16/2011 UV : put all the error messages at the top of the class 
// 11/23/2011 RJ : Refactor/optimized the code to get away with time limit exceeded, too many scripts statements errors.
// 11/24/2011 RJ : Optimized code
// 12/27/2011 UV : updated the code to update campaign Members from CSV file (line# 530-630)
// 02/21/2012 RJ : updated the code to include changes related to 2 new enhancements for loading only campaign members/ only campaign team members
public class CM_CampaignMembersLoader_dev {
    public String successResult{get;set;}
    public String failedResult{get;set;}
    public Set<String> errMessageList{get;set;}
    public List<List<List<String>>> csvRows{get;set;}
    public List<List<String>> rows{get;set;}
    
     
    
    
    public Integer poolerIncrement{get;set;} 
    public boolean isUploaded{get;set;}
    
    public transient string nameFile{get;set;}
    public transient Blob contentFile{get;set;}  
      
    
    
    public List<List<csvWrapper>> csvUploadSuccessResult{get;set;}    
    public List<List<csvWrapper>> csvUploadFailedResult{get;set;}
   
   
     //Map is created to avoid error Cannot specify both an external ID reference System_Assigned_To__r and a salesforce id, System_Assigned_To__c: []
     Map<String,User> UserMSIDMap = new Map<String,User>();
       
   
   
   
    transient List<Campaign_Member__c> cmList;
    transient List<csvWrapper> csvWSuccessList;
    transient List<csvWrapper> csvWFailList; 
    //12/28/2011 UV :  change batch size from 500 to 400 to resolve too many scripts issue
    public static final Integer BATCH_SIZE = 400;
    //public transient Integer NUMBER_OF_COLUMNS = 12;
    public static final String SYSTEM_MULTIPLE_CONTACT_KEY_MESSAGE = 'TN Contact Key: more than one record found for external id field:';
    public static final String CUSTOM_MULTIPLE_CONTACT_KEY_MESSAGE = 'More than one contact record exists with the specified TN Contact Key';
    
    public static final String SYSTEM_ALREADY_CAMPAIGN_MESSAGE = 'duplicate value found: unknown duplicates value on record with id:';
    public static final String CUSTOM_ALREADY_CAMPAIGN_MESSAGE = 'Already a campaign member';
    
    
    public static final String NO_FILE_SELECTED_ERROR = Label.CM_NO_FILE_SELECTED_ERROR; 
    public static final String FILE_NOT_HAS_EXTENSION_ERROR = Label.CM_FILE_NOT_HAS_EXTENSION_ERROR;
    public static final String NOT_CSV_FILE_ERROR = Label.CM_NOT_CSV_FILE_ERROR;
    
    public static final String EXTERNAL_ID_NOT_POPULATED = Label.CM_EXTERNAL_ID_NOT_POPULATED;
    public static final String FORCE_CREATE_CMA_NOT_POPULATED = Label.CM_FORCE_CREATE_CMA_NOT_POPULATED;
    public static final String FORCE_CREATE_CTM_NOT_POPULATED = Label.CM_FORCE_CREATE_CTM_NOT_POPULATED;    
    
    public static final String STATUS_NOT_POPULATED = Label.CM_STATUS_NOT_POPULATED;
    public static final String ACCESS_LEVEL_NOT_POPULATED = Label.CM_ACCESS_LEVEL_NOT_POPULATED;
    public static final String MSID_NOT_POPULATED = Label.CM_MSID_NOT_POPULATED;
    public static final String ROLE_NOT_POPULATED = Label.CM_ROLE_NOT_POPULATED;
    public static final String ASSIGNED_BY_ADMIN_NOT_POPULATED = Label.CM_ASSIGNED_BY_ADMIN_NOT_POPULATED;
    
    public static final String INVALID_FORCE_CREATE_CMA = Label.CM_INVALID_FORCE_CREATE_CMA;
    public static final String INVALID_FORCE_CREATE_CTM = Label.CM_INVALID_FORCE_CREATE_CTM;
   
    public static final String INVALID_SYSTEM_ASSIGNED_BY_ADMIN = Label.CM_INVALID_SYSTEM_ASSIGNED_BY_ADMIN;
    public static final String INVALID_DECIMAL_VALUE = Label.CM_INVALID_DECIMAL_VALUE;
    public static final String TN_CONTACT_KEY_NOT_POPULATED = Label.CM_TN_CONTACT_KEY_NOT_POPULATED;    
    
    public static final String INVALID_VALUES = Label.CM_INVALID_VALUES;
    public static final String EXCEEDED_MAX_LIMIT_UPLOAD = Label.CM_EXCEEDED_MAX_LIMIT_UPLOAD;
    
    public static final String VIEWSTATE_EXCEPTION = Label.CM_VIEWSTATE_EXCEPTION;
    public static final String HEAPSIZE_EXCEPTION = Label.CM_HEAPSIZE_EXCEPTION;
    
    public static final Integer CONTENT_BATCH = 10000;
    
    private boolean isHeapSizeError = false;
    
    
     private static boolean isHeapSizeCrossed{
      get{        
        if(Limits.getHeapSize() < (Limits.getLimitHeapSize() - 20000)){
        //if(Limits.getHeapSize() < (3000000 - 20000)){
          return false;
        }else{
          return true;
        }
      }
    }
    
    private void initiateMembers(){
      successResult = '';
      failedResult = '';
      
        
      csvUploadSuccessResult = new List<List<csvWrapper>>();
      csvUploadFailedResult = new List<List<csvWrapper>>();
      
      cmList = new List<Campaign_Member__c>();
      csvWSuccessList = new List<csvWrapper>();
      csvWFailList = new List<csvWrapper>();
      
    
 
      
      csvRows = new List<List<List<String>>>();  
      rows = new List<List<String>>();
      
      errMessageList = new Set<String>();
    } 
    
    
    public CM_CampaignMembersLoader_dev(){
        initiateMembers();
        poolerIncrement = 0; 
        isUploaded = false;   
        
    }
    
    private void validateEmpty(String str, String exceptionMessage, csvWrapper cW){     
        if(str.trim() == ''){         
          cW.failureReason = cW.failureReason + exceptionMessage + '<br/> <br/> ';  
          cW.result = 'Fail';   
        }       
    }
    
    private void validateBoolean(String str, String exceptionMessage, csvWrapper cW){
        if(str.trim().toUpperCase() <> 'TRUE' && str.trim().toUpperCase() <> 'FALSE'){
        cW.failureReason = cW.failureReason + exceptionMessage + '<br/> <br/> ';  
        cW.result = 'Fail';  
      } 
    }
    
    private void validateDecimal(String str, String exceptionMessage, csvWrapper cW){
        Decimal dump;
        try {
            dump = DEcimal.valueOf(str.trim());
        } catch(Exception ex) {
            cW.failureReason = cW.failureReason + exceptionMessage + '<br/> <br/> ';  
            cW.result = 'Fail'; 
        } 
    }
    
    public PageReference validateFileExtension(){
        errMessageList = new Set<String>();
        csvUploadSuccessResult = new List<List<csvWrapper>>();
        CSVUploadFailedResult = new List<List<csvWrapper>>();
        
        
        if(nameFile == null){
           ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, NO_FILE_SELECTED_ERROR);
           ApexPages.addMessage(errormsg);
         return null;           
        }
        
        
        if(nameFile.lastIndexOf('.') == -1){
           ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, FILE_NOT_HAS_EXTENSION_ERROR );
           ApexPages.addMessage(errormsg);
           return null;            
        }
        
         if(nameFile.lastIndexOf('.') <> -1 && nameFile.substring(nameFile.lastIndexOf('.') + 1).toLowerCase() <> 'csv'){
           ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,NOT_CSV_FILE_ERROR );
           ApexPages.addMessage(errormsg);            
           return null;
         }
      
        return uploadAndCreateDataRows();
      
    }
    
    
    public void populateDataRows(Integer startIndx, Integer endIndx, String content, List<String> dRows){
         try{
                 boolean isEnded = false;
                 
                 //System.debug('RAHUL: endIndx:' + endIndx + '>' + 'contentLength:' + content.length());
                 if(endIndx > content.length()){
                    endIndx = content.length();
                    isEnded = true;         
                 }
                 
                 String content1 = content.substring(startIndx, endIndx - 1);
                 
                 if(content1.lastIndexOf('\n') != -1 && isEnded == false){               
                       content1 = content1.substring(0, content1.lastIndexOf('\n'));                       
               }
               
               
               startIndx =  startIndx + content1.length();
               endIndx = startIndx + endIndx;
              
               if(isHeapSizeCrossed){  
              isHeapSizeError = true;                    
              throw new CM_CustomException(HEAPSIZE_EXCEPTION, 'Heap(Memory)');                
           }  
                           
               if(dRows <> null){
                 
                 
                 while(content1.length() <> 0){
                     string line = '';
                     Integer eIndx = 0;
                     
                     if(content1.indexOf('\n') <> -1){
                        eIndx = content1.indexOf('\n');
                      
                     }else{
                          eIndx = content1.length() - 1;
                        
                     }
                     line = content1.substring(0, eIndx);
                     
                     dRows.add(line);
                      
                     content1 = content1.substring(eIndx + 1);
                     
                     
                 }
                 
                 if(isHeapSizeCrossed){  
                      isHeapSizeError = true;                    
                      throw new CM_CustomException(HEAPSIZE_EXCEPTION, 'Heap(Memory)');                
                 }          
               }           
                 if(isEnded == false){
                   populateDataRows(startIndx, endIndx, content, dRows);
                 }else{
                     return;
                 }
         }catch(Exception ex){
               errMessageList.add(ex.getMessage());
               return;
         }
    }
    
    
    public List<String> getDataRows(){
            String content = '';          
            
            transient List<String> dRows = new List<String>();
          
              try { 
                  content = contentFile.toString();
                  isHeapSizeError = false;              
                  populateDataRows(0, CONTENT_BATCH, content, dRows);  
                  
                  
                  
                  if(isHeapSizeError){               
                    return new List<String>();
                  }
                   
              } catch (System.ListException e) {
                  errMessageList.add(EXCEEDED_MAX_LIMIT_UPLOAD);
              }
              
              content = null;
              contentFile = null;
              
              return dRows;
             
          
    }
    
    
    public void parseDataRows(List<String> dataRows) {
       Integer num = 1;
      
       for(String line : dataRows) {
          // check for blank CSV lines (only commas)
          if (line.replaceAll(',','').trim().length() == 0) continue;
          
          String regexStr = ',(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))';
          
          //List<String> fields = line.split(',');
          List<String> fields = line.split(regexStr);
          System.debug('fields===>' + fields);
          
          //if(fields.size() < NUMBER_OF_COLUMNS) continue;
          
          
          List<String> cleanFields = new List<String>();
          
          String compositeField;
          Boolean makeCompositeField = false;
          for(String field : fields) {
              field = field.trim();
              if (field.startsWith('"') && field.endsWith('"')) {                 
                  cleanFields.add(field.replaceAll('""','"'));
              } else if (field.startsWith('"')) {
                  makeCompositeField = true;
                  compositeField = field;
              } else if (field.endsWith('"')) {
                  compositeField += ',' + field;                  
                  cleanFields.add(compositeField.replaceAll('""','"'));
                  makeCompositeField = false;
              } else if (makeCompositeField) {
                  compositeField +=  ',' + field;
              } else {                  
                  cleanFields.add(field.replaceAll('""','"'));
              }
          }
          
          if(num > 1){                  
            createCSVRows(cleanFields);
          }
          
          num++;
       }
        
       if(rows.size() > 0){
        csvRows.add(rows);
        rows = new List<List<String>>();   
      } 
      
      
      //dataRows = null;    
    }
    
    public void createCSVRows(List<String> inputvalues){
         rows.add(inputvalues);
         if(rows.size() >= BATCH_SIZE){                
             csvRows.add(rows);
             rows = new List<List<String>>();       
         }
    }  
    
   
    public PageReference uploadAndCreateDataRows(){         
      parseDataRows(getDataRows());      
      isUploaded = true;
      return null;
    }
    
    
    public PageReference runValidationAndInsert(){
        
        
        if(csvRows.size() > poolerIncrement){
            List<List<String>> lineRow = csvRows[poolerIncrement];
            createAndInsert(lineRow);           
            // To release memory and view state  
            csvRows[poolerIncrement] = new List<List<String>>();
            poolerIncrement++;
            
        }
        
        return null;
    }
    
    
    public PageReference createAndInsert(List<List<String>> lineRow){
      cmList = new List<Campaign_Member__c>();    
      csvWSuccessList = new List<csvWrapper>();
      csvWFailList = new List<csvWrapper>();
      
      List<Campaign_Member__c> cmListToCreateCMAs = new List<Campaign_Member__c>();
      List<Campaign_Member__c> cmListToCreateCTMs = new List<Campaign_Member__c>();
      List<Campaign_Member__c> cmListToUpdateCMs = new List<Campaign_Member__c>();
      
      Set<String> MSIDSet = new Set<String>();
      List<String> errMessages = new List<String>{'Attempted to add an entity', 'This entity is already a member of this campaign', 'Attempted to add a campaign member where either the member id','duplicate value found: unknown duplicates value on record with id','duplicate value found: Campaign_Contact_Key__c duplicates value on record with id'};
        
        
        for(List<String> inputvalues :  lineRow){
                   
            
                   csvWrapper sW = new csvWrapper();
                    // DESIRED COLUMN ORDER: 
                    // Campaign External ID, Contact TN Contact Key, System Assign To MSID, Status, Reason, Campaign Score,System Assigned By Admin, Force Create CTM, Force Create CMA, System Campaign Team Member Access Level, System Campaign Team Member Role  
                                  
                try {
                    String campaignExternalId = '',  contactTNContactKey = '', systemAssignedToMSID = '', status = ''
                    ,reason  = '', campaignScore  = '', systemAssignedByAdmin  = '', forceCreateCTM  = '', 
                    forceCreateCMA  = '', systemCTMAccessLevel  = '', systemCTMRole  = '';
                    
                    if(inputvalues.size() > 0) campaignExternalId = removeDoubleQuotesFromStartAndEnd(inputvalues[0].trim());
                    
                    if(inputvalues.size() > 1) contactTNContactKey = removeDoubleQuotesFromStartAndEnd(inputvalues[1].trim());
                    
                    if(inputvalues.size() > 2) systemAssignedToMSID = removeDoubleQuotesFromStartAndEnd(inputvalues[2].trim());
                    
                    if(inputvalues.size() > 3) status = removeDoubleQuotesFromStartAndEnd(inputvalues[3].trim());
                    
                    if(inputvalues.size() > 4) reason = removeDoubleQuotesFromStartAndEnd(inputvalues[4].trim());
                    
                    if(inputvalues.size() > 5) campaignScore = removeDoubleQuotesFromStartAndEnd(inputvalues[5].trim());
                    
                    if(inputvalues.size() > 6) systemAssignedByAdmin = removeDoubleQuotesFromStartAndEnd(inputvalues[6].trim());
                    
                    if(inputvalues.size() > 7) forceCreateCTM = removeDoubleQuotesFromStartAndEnd(inputvalues[7].trim());
                    
                    if(inputvalues.size() > 8) forceCreateCMA = removeDoubleQuotesFromStartAndEnd(inputvalues[8].trim());
                    
                    if(inputvalues.size() > 9) systemCTMAccessLevel = removeDoubleQuotesFromStartAndEnd(inputvalues[9].trim());
                    
                    if(inputvalues.size() > 10) systemCTMRole = removeDoubleQuotesFromStartAndEnd(inputvalues[10].trim());
                         
                    
                    
                                                       
                    validateEmpty(campaignExternalId,EXTERNAL_ID_NOT_POPULATED , sW);                  
                    sW.campaignExternalId = campaignExternalId;
                   
                   
                    if(contactTNContactKey.trim() == '' && systemAssignedToMSID.trim() == ''){
                      validateEmpty(contactTNContactKey, TN_CONTACT_KEY_NOT_POPULATED , sW);
                      validateEmpty(systemAssignedToMSID, MSID_NOT_POPULATED , sW);
                    }
                    
                    
                    //validateEmpty(contactTNContactKey, TN_CONTACT_KEY_NOT_POPULATED , sW);                  
                    sW.contactTNContactKey = contactTNContactKey;
                    
                                                            
                    //validateEmpty(systemAssignedToMSID, MSID_NOT_POPULATED , sW);
                    sW.systemAssignedToMSID = systemAssignedToMSID; 
                    
                    
                    if(sW.contactTNContactKey.trim() <> ''){
                      validateEmpty(status, STATUS_NOT_POPULATED , sW);
                      sW.status = status;
                                          
                      sW.reason = reason;
                                          
                      validateDecimal(campaignScore, INVALID_DECIMAL_VALUE,sW);
                      sW.campaignScore = campaignScore.trim() == '' ? '0' : campaignScore.trim();
                                          
                      
                      validateEmpty(systemAssignedByAdmin, ASSIGNED_BY_ADMIN_NOT_POPULATED , sW);
                      validateBoolean(systemAssignedByAdmin, INVALID_SYSTEM_ASSIGNED_BY_ADMIN , sW);
                      sW.systemAssignedByAdmin = systemAssignedByAdmin; 
                      
                    }else{
                      
                      sW.status = status;
                      sW.reason = reason;
                      sW.campaignScore = campaignScore;
                      sW.systemAssignedByAdmin = systemAssignedByAdmin;
                                            
                    }
                    
                    
                    validateEmpty(forceCreateCTM, FORCE_CREATE_CTM_NOT_POPULATED , sW);
                    validateBoolean(forceCreateCTM, INVALID_FORCE_CREATE_CTM , sW);                  
                    sW.forceCreateCTM = forceCreateCTM;
                                    
                    validateEmpty(forceCreateCMA, FORCE_CREATE_CMA_NOT_POPULATED, sW);
                    validateBoolean(forceCreateCMA, INVALID_FORCE_CREATE_CMA, sW);
                    sW.forceCreateCMA = forceCreateCMA;
                                    
                                     
                    if(sW.systemAssignedToMSID.trim() <> ''){                      
                      validateEmpty(systemCTMAccessLevel, ACCESS_LEVEL_NOT_POPULATED , sW);
                      sW.systemCTMAccessLevel = systemCTMAccessLevel;                     
                                                                          
                      validateEmpty(systemCTMRole, ROLE_NOT_POPULATED , sW);
                      sW.systemCTMRole = systemCTMRole;
                    }else{                                          
                      sW.systemCTMAccessLevel = systemCTMAccessLevel;
                      sW.systemCTMRole = systemCTMRole;
                    }
                    
                    
                    //validateEmpty(forceSubscribeParticipantToCampaign, FORCE_CREATE_SUBSCRIBE_NOT_POPULATED, sW);
                    //validateBoolean(forceSubscribeParticipantToCampaign, INVALID_FORCE_CREATE_SUBSCRIBE, sW);
                    //sW.forceSubscribeParticipantToCampaign = forceSubscribeParticipantToCampaign;
                                        
                   
                    
                    
                    
                  } catch(Exception ex) {
                    
                    sW.result = 'Fail';
                    sW.failureReason = sW.failureReason + ex.getMessage() + '<br/><br/>';
                    
                      
                  } 
                  
                  
                 
                  if(sW.result == 'Pass'){   
                    
                        Campaign_Member__c cm = new Campaign_Member__c();  
          
                        // for mappign campaign with external id
                        Campaign__c camp = new Campaign__c( External_Id__c = sW.campaignExternalId);
                        cm.Campaign__r = camp;
                        
                        // for mapping contact on tn contact key
                        if(sW.contactTNContactKey.trim() <> ''){
                        	system.debug('in contact'+sw);
                          GPSContact__c con = new GPSContact__c( TN_Contact_Key__c = sW.contactTNContactKey);
                          cm.GPSContact__r = con; 
                          //cm.Campaign_Contact_Key__c = sW.contactTNContactKey;
                        }
                        
                        
                        if(sW.contactTNContactKey.trim() == '' && sW.systemAssignedToMSID.trim() <> ''){
                          cm.Force_Create_CTM__c = true;
                        }else{
                          cm.Force_Create_CTM__c = sW.forceCreateCTM.trim().toUpperCase() == 'TRUE' ? true : false;
                        }
                                                
                        cm.Force_Create_CMA__c = sW.forceCreateCMA.trim().toUpperCase() == 'TRUE' ? true : false;
                        cm.System_Assigned_by_Admin__c = sW.systemAssignedByAdmin.trim().toUpperCase() == 'TRUE' ? true : false;
                        cm.Status__c = sW.status;
                        
                        /********Changes for QC-4881 by Sudarshan K. 18/08/2016**********/
                            if(sW.status.equalsIgnoreCase('Responded'))
                                cm.HasResponded__c = true;
                        /************End Code******/
                        cm.Reason__c = sW.reason;
                        Decimal campaignScore = 0;                        
                        try{
                           campaignScore = Decimal.valueOf(sW.campaignScore); 
                        }catch(Exception ex){
                           campaignScore = 0;
                        }  
                        cm.Campaign_Score__c = campaignScore;
                        //cm.Campaign_Score__c = sW.campaignScore == '' ? 0 : Decimal.valueOf(sW.campaignScore);
                        cm.System_Campaign_Team_Member_Access_Level__c = sW.systemCTMAccessLevel;
                        cm.System_Campaign_Team_Member_Role__c = sW.systemCTMRole;
                        //cm.Force_Subscribe_Participant_To_Campaign__c = sW.forceSubscribeParticipantToCampaign.trim().toUpperCase() == 'TRUE' ? true : false;
                        
                        if(sW.systemAssignedToMSID.trim() <> ''){
                          User usr = new User( Emp_Id__c = sW.systemAssignedToMSID);                  
                          cm.System_Assigned_To__r = usr; 
                        }
                        
                        system.debug('++++++++++++++cm.System_Assigned_To__r+++++++' + cm.System_Assigned_To__c);
                        cmList.add(cm);                               
                        csvWSuccessList.add(sW);
                       
                                        
                  }else{
                    
                    
                    csvWFailList.add(sW);
                   
                    
                 }
            
            
                    
            
            
        }
        
        csvUploadSuccessResult.add(csvWSuccessList);     
        csvUploadFailedResult.add(csvWFailList);                      
       
             try{       
                   Database.Saveresult[] lsr = Database.insert(cMList, false);
                       
                       List<csvWrapper> csvWList = csvUploadSuccessResult[csvUploadSuccessResult.size() - 1];
                       
                       for(Integer indx = csvWList.size() - 1; indx > -1; indx--){
                           if(!lsr[indx].isSuccess()){
                              Database.Error err = lsr[indx].getErrors()[0];
                              system.debug('in error'+err);
                              //errMessageList.add(err.getMessage());                 
                              
                              CM_CustomException.logWarningMessage('Unable to insert campaign member record due to following exception:' + err.getMessage());
                              
                              csvWrapper cW = csvWList[indx];
                              //12/27/2011 UV :  added this if condition to check if CM is already exists.
                              if(!err.getMessage().startsWith(errMessages[0]) && 
                              !err.getMessage().startsWith(errMessages[1]) &&
                              !err.getMessage().startsWith(errMessages[2]) &&
                              !err.getMessage().startsWith(errMessages[3])){
                                  
                                  // 01/13/2012 RJ: replace the system generated tn contact key error message with custom friendly message
                                  String errMessage = err.getMessage();                                                                    
                                  if(errMessage.indexOf(SYSTEM_MULTIPLE_CONTACT_KEY_MESSAGE) <> -1){                                    
                                    errMessage = errMessage.replace(SYSTEM_MULTIPLE_CONTACT_KEY_MESSAGE, CUSTOM_MULTIPLE_CONTACT_KEY_MESSAGE);
                                  }
                                 
                                  if(errMessage.indexOf(SYSTEM_ALREADY_CAMPAIGN_MESSAGE ) <> -1){                                    
                                    errMessage = errMessage.replace(SYSTEM_ALREADY_CAMPAIGN_MESSAGE , CUSTOM_ALREADY_CAMPAIGN_MESSAGE );
                                  }
                                  
                                  cW = csvWList.remove(indx);
                                  cW.result = 'Fail';
                                  cW.failureReason = cW.failureReason + errMessage + '<br/><br/>';   
                                  
                                  if(csvUploadFailedResult.size() > 0){
                                    List<csvWrapper> csvWFList = csvUploadFailedResult[csvUploadFailedResult.size() - 1];                                          
                                    csvWFList.add(cW); 
                                  }                            
                              }else{
                                //12/27/2011 UV : added to insert cma and ctm for these campaign members
                                
                                if(cMList[indx].GPSContact__r <> null){
                                  cmListToUpdateCMs.add(cMList[indx]);
                                }
                                
                                if(cMList[indx].System_Assigned_To__r <> null){
                                  cmListToCreateCTMs.add(cMList[indx]);                                 
                                  MSIDSet.add(cMList[indx].System_Assigned_To__r.Emp_Id__c.trim());
                                }
                                
                                if(cMList[indx].GPSContact__r <> null && cMList[indx].System_Assigned_To__r <> null){
                                  cmListToCreateCMAs.add(cMList[indx]);                                  
                                  MSIDSet.add(cMList[indx].System_Assigned_To__r.Emp_Id__c.trim());
                                }
                                
                              }
                              
                                                                                             
                           }               
                       } 
                       
              }catch(Exception ex){       
                    // Attempted to add an entity
                    // This entity is already a member of this campaign                    
                    errMessageList.add(ex.getMessage());          
              }  
        
             // 12/27/2011 UV : added to update the Campaign_Member__c and create new CTM/CMA for latest CMs Records in CSV.
              System.debug('=-====MSIDSet========'+ MSIDSet);
              populateMSIDUserIDMap(MSIDSet);
                
              if(!cmListToUpdateCMs.isEmpty()){  
              	System.debug('________________updatelist_________' + cmListToUpdateCMs);             
                updateCampaignMembers(cmListToUpdateCMs);
              }
              
              if(!cmListToCreateCMAs.isEmpty()){                
                CM_CampaignMemberAssignmentManager.insertDuplicateCampaignMemberAssignments(cmListToCreateCMAs);                
              }
              
              if(!cmListToCreateCTMs.isEmpty()){                
                System.debug('________________CTM LIST TO INSERT_________' + cmListToCreateCTMs);
                CM_CampaignTeamMemberManager.insertDuplicateCampaignMemberTeamMembers(cmListToCreateCTMs);
              }
        
       
        return null;
        
        
    }
    //12/26/2011 UV :  created this method to fill the map of Users with their MSIDs
    public void populateMSIDUserIDMap(Set<String> MSIDSet) {
        UserMSIDMap = new Map<String,User>();
        List<User> UserList = new List<User>();
        userList = [select id, Emp_Id__c from User where Emp_Id__c IN : MSIDSet];
        for(User usr : userList) {
            if(!UserMSIDMap.containsKey(usr.Emp_Id__c)) {
                UserMSIDMap.put(usr.Emp_Id__c, usr);
            }
        }
    }
    //12/23/2011 UV :  created this method to update the campaign Member
    public void updateCampaignMembers(List<Campaign_Member__c> cmListAlreadyExists) {
        set<String> contactIds = new Set<String>();
        Set<String> campaignIds = new Set<String>();
        List<Campaign_Member__c> updatedCampaignMemberList = new List<Campaign_Member__c>();
        Set<Id> cmIdSet = new Set<Id>();
        Map<String,Campaign_Member__c> cmMap = new Map<String,Campaign_Member__c>();
        for(Campaign_Member__c cM : cmListAlreadyExists) {
            campaignIds.add(cM.Campaign__r.External_Id__c.trim());
            contactIds.add(cM.GPSContact__r.TN_Contact_Key__c.trim());
        }
       
       List<Campaign_Member__c> cmList = CM_CampaignDataUtil.getCampaignMemberList(campaignIds,contactIds);                                                         
       for(Campaign_Member__c cm: cmList) {
         String key = cM.Campaign__r.External_Id__c.trim() + '|' + cM.GPSContact__r.TN_Contact_Key__c.trim();
         cmMap.put(key,cm);
       }
       boolean isUpdated = false;
       for(Integer indx = cmListAlreadyExists.size()-1; indx >= 0; indx--) {
         Campaign_Member__c cM = cmListAlreadyExists[indx];
         String key = cM.Campaign__r.External_Id__c.trim() + '|' + cM.GPSContact__r.TN_Contact_Key__c.trim();
         if(cmMap.containsKey(key)) {
            Campaign_Member__c oldCM = cmMap.get(key);
            if(cM.Status__c <> oldCM.Status__c) {
                oldCM.Status__c = cM.Status__c;
                isUpdated = true;
            }
            if(cM.Campaign_Score__c <> oldCM.Campaign_Score__c) {
                oldCM.Campaign_Score__c = cM.Campaign_Score__c;
                isUpdated = true;
            }
            if(cM.Force_Create_CMA__c <> oldCM.Force_Create_CMA__c) {
                oldCM.Force_Create_CMA__c = cM.Force_Create_CMA__c;
                isUpdated = true;
            }
            if(cM.Force_Create_CTM__c <> oldCM.Force_Create_CTM__c) {
                oldCM.Force_Create_CTM__c = cM.Force_Create_CTM__c;
                isUpdated = true;
            }
             
            if(cM.System_Assigned_by_Admin__c <> oldCM.System_Assigned_by_Admin__c) {
                oldCM.System_Assigned_by_Admin__c = cM.System_Assigned_by_Admin__c;
                isUpdated = true;
            } 
            if(cM.Reason__c <> oldCM.Reason__c) {
                oldCM.Reason__c = cM.Reason__c;
                isUpdated = true;
            }
            if(cM.System_Campaign_Team_Member_Role__c <> oldCM.System_Campaign_Team_Member_Role__c && oldCM.Force_Create_CTM__c) {
                oldCM.System_Campaign_Team_Member_Role__c = cM.System_Campaign_Team_Member_Role__c;
                isUpdated = true;
            }
            if(cM.System_Campaign_Team_Member_Access_Level__c <> oldCM.System_Campaign_Team_Member_Access_Level__c && oldCM.Force_Create_CTM__c) {
                oldCM.System_Campaign_Team_Member_Access_Level__c = cM.System_Campaign_Team_Member_Access_Level__c;
                isUpdated = true;
            }
            
            if(cM.System_Assigned_To__c <> null && (cM.System_Assigned_To__r.Emp_Id__c <> oldCM.System_Assigned_To__r.Emp_Id__c)) {
                System.debug(cM.System_Assigned_To__r.Emp_Id__c + '===============' + UserMSIDMap.get(cM.System_Assigned_To__r.Emp_Id__c));
                 //12/26/2011 UV :  updated this code to assigned updated user to campaign member get it from UserMSIDMap 
                 //User usr = new User( Emp_Id__c = cM.System_Assigned_To__r.Emp_Id__c);                  
                 oldCM.System_Assigned_To__c = (UserMSIDMap.get(cM.System_Assigned_To__r.Emp_Id__c.trim()) == null) ? null : UserMSIDMap.get(cM.System_Assigned_To__r.Emp_Id__c).Id; 
                 isUpdated = true;
            }
            
            
            if(isUpdated && !cmIdSet.contains(oldCM.Id)) {
                updatedCampaignMemberList.add(oldCM);
                cmIdSet.add(oldCM.Id);
            }
         }
        }
        if(!updatedCampaignMemberList.isEmpty()) {
            update updatedCampaignMemberList;
        }
    }
    
    public PageReference FinalLoad(){
        isUploaded = false;
        rows = new List<List<String>>();
        
        for(String msg : errMessageList){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, msg); 
            ApexPages.addMessage(errormsg);
        }
        System.debug('Heap Size:' + Limits.getHeapSize());
        
        
        return null;
    }
    
    
    
    
    
    
    public List<List<csvWrapper>> getUploadedCSVSuccessResult(){
         return csvUploadSuccessResult;
    }
   
    public List<List<csvWrapper>> getUploadedCSVFailedResult(){
       return csvUploadFailedResult;
    }
    
    
    public Pagereference CSVUploadFailedResultsCSV() {
        return Page.CM_CSVUploadFailedResultsExcel;
    }
    
    public Pagereference CSVUploadSuccessResultsCSV() {
        return Page.CM_CSVUploadSuccessResultsExcel;
    } 
    
    
    public String getErrorResultCSV() {       
        errMessageList = new Set<String>();
                
        if(failedResult == ''){
          String failedResultCSV = '"Failure Reason","Campaign External ID","Contact TN Contact Key","System Assign To MSID ","Status","Reason","Campaign Score","System Assigned By Admin","Force Create CTM","Force Create CMA","System Campaign Team Member Access Level","System Campaign Team Member Role"\n';
          
          for(Integer indx = 0; indx < csvUploadFailedResult.size(); indx++) {
             List<csvWrapper> lstcWWrap = csvUploadFailedResult[indx];
             for(csvWrapper cW : lstcWWrap) {                            
                failedResultCSV += '"' + cW.failureReason.replaceAll('<br/>', ' ') + '",';
                failedResultCSV += '"' + cW.campaignExternalId + '",';
                failedResultCSV += '"' + cW.contactTNContactKey + '",';
                failedResultCSV += '"' + cW.systemAssignedToMSID + '",';
                failedResultCSV += '"' + cW.status + '",';
                failedResultCSV += '"' + cW.reason + '",';
                failedResultCSV += '' + cW.campaignScore + ',';
                failedResultCSV += '' + cW.systemAssignedByAdmin + ',';
                failedResultCSV += '' + cW.forceCreateCTM + ',';
                failedResultCSV += '' + cW.forceCreateCMA + ',';              
                failedResultCSV += '"' + cW.systemCTMAccessLevel + '",';
                failedResultCSV += '"' + cW.systemCTMRole + '"\n';
                
            }            
            // release previously claimed memory
            csvUploadFailedResult[indx] = null;             
          }
          
          failedResultCSV = failedResultCSV.substring(0, failedResultCSV.lastIndexOf('\n'));          
          failedResult = failedResultCSV;
        }
        
        return failedResult;    
    }
    
    
    
   
    
    public String getSucessResultCSV() {
          errMessageList = new Set<String>();
          
          if(successResult == ''){
            
                String successResultCSV = '"Campaign External ID","Contact TN Contact Key","System Assign To MSID ","Status","Reason","Campaign Score","System Assigned By Admin","Force Create CTM","Force Create CMA","System Campaign Team Member Access Level","System Campaign Team Member Role"\n';
                
                for(Integer indx = 0; indx < csvUploadSuccessResult.size(); indx++) {
                    List<csvWrapper> lstcWWrap = csvUploadSuccessResult[indx];
                    for(csvWrapper cW : lstcWWrap) {
                        successResultCSV += '"' + cW.campaignExternalId + '",';
                        successResultCSV += '"' + cW.contactTNContactKey + '",';
                        successResultCSV += '"' + cW.systemAssignedToMSID + '",';
                        successResultCSV += '"' + cW.status + '",';
                        successResultCSV += '"' + cW.reason + '",';
                        successResultCSV += '' + cW.campaignScore + ',';
                        successResultCSV += '' + cW.systemAssignedByAdmin + ',';
                        successResultCSV += '' + cW.forceCreateCTM + ',';
                        successResultCSV += '' + cW.forceCreateCMA + ',';               
                        successResultCSV += '"' + cW.systemCTMAccessLevel + '",';
                        successResultCSV += '"' + cW.systemCTMRole + '"\n';                     
                    }
                    // release previously claimed memory
                    csvUploadSuccessResult[indx] = null;
                }               
                successResultCSV = successResultCSV.substring(0, successResultCSV.lastIndexOf('\n'));               
                successResult = successResultCSV;
        
          }
        return  successResult;    
    }
    
  
   
    public string removeDoubleQuotesFromStartAndEnd(String field1){  
       if(field1 <> null){                
         field1 = field1.startsWith('"') ? field1.substring(1) : field1;            
         field1 = field1.endsWith('"') ? field1.substring(0, field1.length() - 1) : field1;       
         return field1; 
       }else{
         return '';
       }    
    }  
    
    
    
   
  
  
    
    public class csvWrapper{
        public string campaignExternalId{get;set;}
        public string contactTNContactKey{get;set;}
        public string forceCreateCTM{get;set;}
        public string forceCreateCMA{get;set;}
        public string systemAssignedByAdmin{get;set;}
        public string status{get;set;}
        public string reason{get;set;}
        public string campaignScore{get;set;}
        public string systemCTMAccessLevel{get;set;}
        public string systemCTMRole{get;set;}
        public string systemAssignedToMSID{get;set;}
        
        //public string forceSubscribeParticipantToCampaign{get;set;}
        
        
        public string result{get;set;}
        public string failureReason{get;set;}
                
        public csvWrapper(){
            this.failureReason = 'Error: ';
            this.result = 'Pass';
        }
    }       
}