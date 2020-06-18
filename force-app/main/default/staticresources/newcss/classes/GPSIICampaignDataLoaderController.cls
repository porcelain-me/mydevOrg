/******************************************************************************************************************************
 *
 *      @File           :       GPSIICampaignDataLoaderController.cls
 *      @Version        :       V1.0.0
 *      @Created        :       20th July 2016 by Sudarshan K.
 *      @Purpose        :       JIRA 4836
 *                                  Purpose is GPS Campaigns upload functionality.                   
 *                                                      
 *                                              
 *
 *      @Author         :       Capgemini (Sudarshan K)
 *      @Copyright      :       (c) Capgemini India Pvt. Ltd. 2016
 *
 *      @History        :  Jira- 4891, Add option to delete target List Members.
 *
 ********************************************************************************************************************************/
public class GPSIICampaignDataLoaderController {
    
    public String selectedUploadOption { get; set; }
    public String nameFile { get; set; }
    public transient Blob contentFile { get; set; }
    public transient String contentData{get; set;}
    public String csvFileName { get; set; }
    public List<List<String>> fileLines = new List<List<String>>();
    public Boolean isSuccessResult { get; set; }
    public String SuccessResultCSV { get; set; }
    public Boolean isErrorResult { get; set; }
    public String ErrorResultCSV { get; set; }
    public Integer processCounter { get; set; }
    public Boolean isBatchProcessing { get; set; }
    public Boolean hasError { get; set; }
    public Boolean hasBatchCompleted {get;set;}
    private String apexBatchId;
    private List<String> tempCSV;
    private GPS_Campaign_Data_Loader__c GPSCamDL;
    
    /******************Constants to read csv column****************************/
    private map<String,String> csvFileMap = new map<String, String>{
        'Candidate_Information__c' => 'Upsert Candidates',
        'Voter_Recommendation__c' => 'Upsert Voter Recommendations',
        'Voter_Recommendation__c_del' => 'Delete Voter Recommendations',
        'Exclusion__c' => 'Upsert Exclusions',
        'Candidate_Sector__c' => 'Upsert Candidate Sectors',
        'Target_List__c' => 'Upsert Target List',
        'Target_List_Member__c' => 'Upsert Target List Members',
        //Jira- 4891, Add option to delete target List Members. Added drop down option below.
        'Target_List_Member__c_del' => 'Delete Target List Members'
    };
    
    private map<String, map<String, String>> csvMapColumns = new map<String, map<String, String>>{
        'Candidate_Information__c' => new map<String, String>{
            'iiCampaign ID' => 'iiCampaign__c',
            'Candidate Name' => 'Candidate_Name__c',
            'Campaign MSID Key' => 'MSID__c',
            'Team' => 'Team__r.TeamID__c',
            'Team ID' => 'Team_ID__c',
            'Team Name' => 'Team_Name__c',
            'Additional Text' => 'Additional_Text__c',
            'Use Recommendations in Campaign' => 'Use_Recommendations_in_Campaign__c'
        },
        'Voter_Recommendation__c'=> new map<String, String>{
            'Candidate MSID Key' => 'Candidate_Information__r.MSID__c',
            'TN Contact Key' => 'GPSContact__r.TN_Contact_Key__c',
            'Unique VR Key' => 'Unique_VR_Key__c',
            'Why' => 'Why__c'
        },
        'Voter_Recommendation__c_del'=> new map<String, String>{
            'Id' => 'Id'
        },
        'Exclusion__c' => new map<String, String>{
            'iiCampaign' => 'iiCampaign__c',
            'TN ID' => 'GPSAccount__r.Trading_Name_ID__c',
            'Exclusion' => 'Exclusion__c'
        },
        'Candidate_Sector__c' => new map<String, String>{
            'II Sector' => 'iiSector__c',
            'Campaign MSID Key' => 'Candidate_Information__r.MSID__c'
        },
        'Target_List__c' => new map<String, String>{
            'iiCampaign' => 'iiCampaign__c',
            'MSID' => 'User__r.Emp_Id__c',
            'Campaign MSID Key' => 'MSID__c',
            'Authorized' => 'Authorized__c',
            'Sends Email' => 'Sends_Email__c',
            'Target List Tag' => 'Target_List_Tag__c',
            'II Sub Group' => 'Sub_Group__c'
        },
        'Target_List_Member__c' => new map<String, String>{
            'Campaign MSID Key' => 'Target_List__r.MSID__c',
            'TN Contact Key' => 'GPSContact__r.TN_Contact_Key__c',
            'Target List Member Key' => 'Target_List_Member_Key__c',
            'Removed Reason' => 'Removed_Reason__c',
            'Call Notes' => 'Call_Notes__c'
        },
        ////Jira- 4891, Add option to delete target List Members. Added the option below.
        'Target_List_Member__c_del'=> new map<String, String>{
            'Id' => 'Id'
        }
    };
 
  public GPSIICampaignDataLoaderController(){   
        String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(browserType != null && browserType.contains('MSIE')){
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        }
  }  
  
  private GPS_Campaign_Data_Loader__c CreateAttachemntWithRecords(){
    
    GPS_Campaign_Data_Loader__c obj = new GPS_Campaign_Data_Loader__c(Name = csvFileMap.get(selectedUploadOption) + ' - '+ UserInfo.getName(), Batch_Status__c = 'Pending', Requested_User__c = UserInfo.getUserId());
    insert obj; 
    return obj;
  }
    
   public List<SelectOption> getDataLoaderOperationType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- None --'));
        
        for(String key : csvFileMap.keySet()){
            options.add(new SelectOption(key, csvFileMap.get(key)));
        }
        return options;
   } 
    
    public PageReference ReadFile(){
        
        isBatchProcessing = false;
        hasError = false;
        
        if(String.isNotEmpty(contentData))
            contentFile = Blob.valueOf(contentData);
               
        if(String.isNotEmpty(selectedUploadOption) && csvMapColumns.containsKey(selectedUploadOption.trim())){
                        
            map<String, String> fieldmap = csvMapColumns.get(selectedUploadOption.trim());
            
            if(String.isEmpty(nameFile) && contentFile == null){
                
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select file type of .csv');
                ApexPages.addMessage(errormsg);
                return null;
                  
            }else if(contentFile.size() > 6000000){
                
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please reduce records for processing.');
                ApexPages.addMessage(errormsg);
                    
            }else{
                if(selectedUploadOption.trim().contains('__c_del')){
                    String objectdel =  selectedUploadOption.subStringBefore('_del');
                     createObject(objectdel.trim());
                }
                else{
                     createObject(selectedUploadOption.trim());
                }
            }
            
            String fileData = contentFile.toString();
            
            Integer eIndx = 0;
            if(fileData.length() > 0){
                                
                if(fileData.indexOf('\n') <> -1){
                    eIndx = fileData.indexOf('\n');
                    
                 }else{
                    
                    eIndx = fileData.length() - 1;
                 }
            }
            
            List<String> fieldNames = new List<String>{fileData.substring(0, eIndx)};
            
            fileData = fileData.substring(eIndx + 1);
            
            fieldNames = parseCSV(fieldNames)[0];
            
            set<String> fieldSet = new set<String>();
            SuccessResultCSV = 'Id';
            ErrorResultCSV = '';
            Integer counter = 0;
            for(String fld : fieldNames){
                
                fieldSet.add(fld.trim());
                SuccessResultCSV += ',"' + fld.trim() + '"';
                if(counter == 0){
                	ErrorResultCSV += fld.trim();
                	counter++;
                }else{
                	ErrorResultCSV += ',"' + fld.trim() + '"';	
                }
            }
            
            if(!fieldMap.keySet().containsAll(fieldSet)){
                Set<String> tempSet = new set<String>(fieldSet);
                tempSet.removeAll(fieldmap.keySet());
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Columns are not matching from CSV.\n'+tempSet);
                ApexPages.addMessage(errormsg);
            }
            
            if(ApexPages.hasMessages()){
                hasError = true;
                return null;
            }
                
            SuccessResultCSV += ',"' + 'Status' + '"\n"';
            ErrorResultCSV += ',"' + 'Status' + '"\n"';
            
            system.debug(fileData+' Success Result : '+SuccessResultCSV + ' Failed Result '+ErrorResultCSV);
            
            GPSCamDL = CreateAttachemntWithRecords();
            
            processCounter = 0; 
            isBatchProcessing = true;                       
            apexBatchId = Database.executeBatch(new GPSCampaignDLBatch(fileData, SuccessResultCSV, ErrorResultCSV, GPSCamDL.Id, fieldmap, fieldNames, selectedUploadOption));
            
            GPSCamDL.BatchJobId__c = apexBatchId;
            update GPSCamDL;
                
        }else{
            
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Select Operation type from dropdown.');
            hasError = true;       
            ApexPages.addMessage(errormsg);
        }
        
        return null;
    }
        
    public static sObject createObject(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        if (targetType == null) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Inbvalid Operation type');   
            ApexPages.addMessage(errormsg);
            return null;
        }
        
        // Instantiate an sObject with the type passed in as an argument
        //  at run time.
        return targetType.newSObject(); 
    }
    
     public pagereference exportCSVTemplate(){
        
        if(String.isNotEmpty(selectedUploadOption) && csvFileMap.containsKey(selectedUploadOption.trim())){    
           
            csvFileName = csvFileMap.get(selectedUploadOption.trim()).replace(' ','') + 'Template.csv';
           
        }else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Select Operation type from dropdown.');
               
            ApexPages.addMessage(errormsg);
            
            return null;
        } 
        
        return Page.IICamp_ExportCSVTemplate;
            
    }
    
    public string getformattoCSV(){
        
         String CSV = '';
         
        if(selectedUploadOption == 'Candidate_Information__c'){
            
            CSV +='iiCampaign ID","Candidate Name","Campaign MSID Key","Team","Team ID","Team Name","Additional Text","Use Recommendations in Campaign';
            
        }else if(selectedUploadOption == 'Voter_Recommendation__c'){
            
            CSV +='Candidate MSID Key","TN Contact Key","Unique VR Key","Why';
            
        }else if(selectedUploadOption == 'Exclusion__c'){
            
            CSV +='iiCampaign","TN ID","Exclusion';
            
        }else if(selectedUploadOption == 'Candidate_Sector__c'){
            
            CSV +='II Sector","Campaign MSID Key';
            
        }else if(selectedUploadOption == 'Target_List__c'){
            
            CSV +='iiCampaign","MSID","Campaign MSID Key","Authorized","Sends Email","Target List Tag","II Sub Group';
            
        }else if(selectedUploadOption == 'Target_List_Member__c'){
            
            CSV +='Campaign MSID Key","TN Contact Key","Target List Member Key","Removed Reason","Call Notes';
        }else{
            
            CSV += 'Id';
        } 
        
        return CSV;
    }
    
            
    public static List<List<String>> parseCSV(List<string> allRows){
        
        List<List<String>> allfields = new List<List<string>>();
        
        for(string row:allRows){
                
                //if (row.replaceAll(',','').trim().length() == 0) continue;
                
                String regexStr = ',(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))';
                
                List<String> columns = row.split(regexStr);
                
                system.debug('columns='+columns);
                
                transient List<String> cleanFields = new List<String>();
                
                String compositeField;
                
                Boolean makeCompositeField = false;
                
                for(String field : columns) {
                        
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
                allfields.add(cleanFields);
        }
        
        return allfields;          
        
    }
    
    public PageReference batchProcessCompletion(){
    
        checkRecordsStatusInBatch();
        
        processCounter = 0;
        isBatchProcessing = false;
        hasError = false;
        selectedUploadOption = '';
        isSuccessResult = false;
        isErrorResult = false;
        SuccessResultCSV = '';
        ErrorResultCSV = '';
        hasBatchCompleted = true;
                
        List<Attachment> lstAttach = [SELECT id, Name, Body FROM Attachment WHERE ParentId =: GPSCamDL.Id];
        
        if(!lstAttach.isEmpty()){
        
	        for(Attachment attach : lstAttach){
	            
	            if(attach.name.contains('SuccessRecords')){
	                SuccessResultCSV = attach.Id;
	                isSuccessResult = true;
	            }else if(attach.name.contains('FailedRecords')){
	                ErrorResultCSV = attach.Id;
	                isErrorResult = true;
	            }
	        }
        }
        
        return null;
    }
    
    public void checkRecordsStatusInBatch(){
        
        List<AsyncApexJob> apexJobs = [SELECT Id, JobType, ApexClassId, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob WHERE Id =: apexBatchId];
        
        if(!apexJobs.isEmpty()){
            
            if(apexJobs[0].Status == 'Queued' || apexJobs[0].Status == 'Preparing'){
                
                processCounter = 0;
                isBatchProcessing = true;
                
            }else if(apexJobs[0].Status == 'Processing'){
                
                Double tempVal = (Double)(apexJobs[0].JobItemsProcessed * 100) / apexJobs[0].TotalJobItems;
                processCounter = tempVal.intValue();
                isBatchProcessing = true;
                
            }else if(apexJobs[0].Status == 'Holding'){
                System.abortJob(apexJobs[0].Id);                
                processCounter = -1;
                isBatchProcessing = false;
                
            }
            else{
                processCounter = 100;
                isBatchProcessing = false;
                 
            }
            
            if(GPSCamDL.Batch_Status__c != apexJobs[0].Status && apexJobs[0].Status != 'Queued' && apexJobs[0].Status != 'Preparing' && apexJobs[0].Status != 'Holding'){
                GPSCamDL.Batch_Status__c = apexJobs[0].Status;
                update GPSCamDL;    
            }
            
        }else{
            processCounter = 100;   
            isBatchProcessing = false;
        }
        
    }
    
     public static void excludeTargetListMembers(Set<Id> CampaignIds, Set<Id> AccountIds, Set<string> setExclusions){
        
        List<Target_List_Member__c> listMembersToUpdate = new  List<Target_List_Member__c>();
        String keyCampAcc = '';
        Set<String> set_exclusions= new Set<String>();
        
        //Map to store set of Exclusions for a Combination of Campaign and Account
        Map<string,Set<string>> mapExclusions = new Map<string,Set<string>>();
    
        for(String strExc : setExclusions){
            //Split 'CampaignId_AccountId_ExclusionString' by '_'
            String[] strSplit = strExc.split('_');
            //Create Set Of Exclusions and add to Map (Key: CampaignId_AccountId)
            keyCampAcc = strSplit[0] + '_' + strSplit[1] ;
            set_exclusions = new Set<string>{strSplit[2]};
            if(mapExclusions.ContainsKey(keyCampAcc)){
                set_exclusions = mapExclusions.get(keyCampAcc);
                set_exclusions.add(strSplit[2]);
            }
            
            mapExclusions.put(keyCampAcc,set_exclusions);
            
        }
        
        //Retrieve All TargetListMembers to be Updated
        
        for(    List<Target_List_Member__c> listMembers : [Select t.Target_List__r.iiCampaign__c, t.Target_List__c, t.GPSContact__r.GPSAccount__c, t.GPSContact__c From Target_List_Member__c t
                                                    where Target_List__r.iiCampaign__c in :CampaignIds
                                                      and GPSContact__r.GPSAccount__c in :AccountIds]){
            
            System.debug('______________listMembers.size()__' + listMembers.size());
            for(Target_List_Member__c tlm : listMembers){
                keyCampAcc = tlm.Target_List__r.iiCampaign__c + '_' + tlm.GPSContact__r.GPSAccount__c;
                set_exclusions = mapExclusions.get(keyCampAcc);
                for(string reason : set_exclusions){
                    if(reason.toLowerCase() == 'contacts do not get email'){
                        tlm.Eligible_for_email__c = false;
                    }
                    else if(reason.toLowerCase() == 'exclude from campaign'){
                        tlm.Removed_Reason__c = 'Account does not vote in II Campaign';
                        tlm.Eligible_for_email__c = false;
                    }
                }
            }
            
            listMembersToUpdate.addAll(listMembers);
                
        }
        
        System.debug('__________________listMembersToUpdate.size()__' + listMembersToUpdate.size());
        update listMembersToUpdate;
        
        
     }                
}