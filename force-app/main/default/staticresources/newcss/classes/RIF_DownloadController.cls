public with sharing class RIF_DownloadController {
	
	public Project__c p {get;set;}
	List<Attachment> aList;
    List<Attachment> aList1;
	public List<Attachment> pList {get;set;}
	public String status {get;set;} 
	
	public Integer recordNbr {get;set;}
	public Boolean run{get;set;}
	
	public Integer totalToProcess {get;set;} 
	Set<ID> processedSet = new Set<ID>();
	
	Set<ID> aSet = new Set<ID>();
	
	private List<Id> selectedSnR;
	private String ProjectID;
	
	private List<String> queryFilter;
	private String docs;
	private String version;
    public Boolean hasAgeDisc;
    Map<String,List<Attachment>> mapodSNRIDAttahment;
    private String pduID;   //MSN: RIF#54 Changes 16 March 18
    private Integer selectedSNRsSize ; //MSN: RIF#54 Changes 
    public RIF_DownloadController(ApexPages.StandardController controller) {
    	aList1 = new List<Attachment>();
    	status = 'Preparing to download...please wait!';
        
        run = true;
        hasAgeDisc = false;
        recordNbr = 0;
        List<Severance_And_Release__c> sList = new List<Severance_And_Release__c>();
        
        Project__c proj = (Project__c)controller.getRecord();
    	projectID = proj.Id;
    	selectedSNRsSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('selectedIDSize'));  //MSN: RIF#54 Changes 
        selectedSnR = new List<Id>();
    	Id sr;
        //MSN: RIF#54 Changed i<= 10 to   i <= selectedSNRsSize
    	for(Integer i=1; i <= selectedSNRsSize; i++) {
    		sr = ApexPages.currentPage().getParameters().get('snr' + i);
    		if(sr != null)
    			selectedSnR.add(sr);
    	}
    	
    	queryFilter = new List<String>();
        pduID =  ApexPages.currentPage().getParameters().get('pduID');   //MSN: RIF#54 Changes 16 March 18 
    	
    	docs = ApexPages.currentPage().getParameters().get('documents');
        
        List<String> tempList = new List<String>();
        List<String> descList = new List<String>();
    	if(docs != '' && docs != 'All;' && docs != null) {
            tempList = docs.split(';');
        } else if(docs == 'All;') {
            tempList = new List<String>{'Separation Summary','Exec Comp Overview','Important Contacts',
                    'Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH',
                    'Lifeworks','Exhibit A'};
        }
        
        if(tempList != null) {
            for(String temp: tempList) {
                queryFilter.add('%' + temp + '%');
                if(temp =='Separation Summary' || temp =='Release Agreement')
                    descList.add(temp);
            }
        }
        // 3-Jul-17 : JIRA#RIF-95 : Add 'Age Disclosures' to the download list
        Set<String> ageDiscSet = new Set<String>(tempList);
        if(ageDiscSet != null && !ageDiscSet.isEmpty() && ageDiscSet.contains('Age Disclosure')){
            hasAgeDisc = true;
        }
        
    	version = ApexPages.currentPage().getParameters().get('version');
    	
    	System.debug('queryFilter - ' + queryFilter);
        system.debug(' -- projectID-- ' + projectID);
        if(projectID != null) {
            /* MSN: RIF#54 Changes 16 March 18 -Starts */
            if(pduID == 'All')
            {
                selectedSnR = new List<Id>();
            }
            /* MSN: RIF#54 Changes 16 March 18 - Ends*/
            if((selectedSnR != null && selectedSnR.size() > 0) || (String.isNotBlank(pduID) && pduID != 'All') ) /* MSN: RIF#54 Changes Added || 16 March 18 */
            {
                sList = [select id from severance_and_release__c where (Id IN :selectedSnR or Decisional_Unit__c =:pduID) and Status__c = 'Selected'];  /* MSN: RIF#54 Changes 16 March 18 Added OR & AND Condition in Query*/
                selectedSnR = new List<Id>();
            } 
            else{
                List<Severance_and_Release__c> selectedSNRsList = [select id,Status__c from severance_and_release__c where project__c = :projectID];
                for(Severance_and_Release__c eachSNR : selectedSNRsList){
                    if(eachSNR.Status__c == 'Selected'){
                        sList.add(eachSNR);
                    }
                }
            }
        } else {
            sList = new List<Severance_And_Release__c>();
        }
        system.debug(' -- sList -- ' + sList);
        Set<ID> sSet = new Set<ID>();
        if(!sList.isEmpty()){
            for(Severance_And_Release__c s:sList){
                sSet.add(s.id);
            }
        }else{
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR,'No SnR records found/selected for this project or, SnRs Severance Status equals Not Selected'));
            run = false;
            status = 'Process halted. You can close this window.';
        }

           mapodSNRIDAttahment = new  Map<String,List<Attachment>>();
		
        if(!sSet.isEmpty()){
            if(version == 'Draft') {
                aList1 = [SELECT Id, Name, ParentId FROM Attachment where ParentId IN :sSet AND 
                         Name LIKE :queryFilter AND Name LIKE '%Draft%'];
            } else if(version == 'Final') {
                aList =[ SELECT Id, Name, ParentId,description FROM Attachment where ParentId IN :sSet AND 
                         (Name LIKE :queryFilter OR description =:descList )AND (NOT Name LIKE '%DRAFT%') order by createddate desc ];
                //MSN:14th Feb 2017 RIF#47 Changes - Starts
                if(aList!=null && !aList.isEmpty())
                {
                    for(Attachment a : alist)
                    {
                        if(!mapodSNRIDAttahment.containsKey(a.parentID))
                        {
                            mapodSNRIDAttahment.put(a.parentID, new List<Attachment>{a});
                        }
                        else
                        {
                            List<Attachment> attachment = mapodSNRIDAttahment.get(a.parentID);
                            attachment.add(a);
                            mapodSNRIDAttahment.put(a.parentID, attachment);
                        }
                    }
                    
                    for(String snrId:mapodSNRIDAttahment.keySet())
                    {
                        List<Attachment> attchmntList = mapodSNRIDAttahment.get(snrId);
                        Integer count=0;
                        List<Attachment> userUploadedRel = new List<Attachment>();
                        List<Attachment> systemUploadedRel = new List<Attachment>();
                         List<Attachment> userUploadedSep = new List<Attachment>();
                        List<Attachment> systemUploadedSep = new List<Attachment>();
                        for(Attachment att :attchmntList )	
                        {
                            if(att.Name.containsIgnoreCase('Release Agreement') || att.Description =='Release Agreement')
                            {  
                                if(att.Description =='Release Agreement')
                                {
                                    userUploadedRel.add(att);
                                }
                                else
                                {
                                    systemUploadedRel.add(att);
                                }
                            }
                            else if(att.Name.containsIgnoreCase('Separation Summary') || att.Description =='Separation Summary')
                            {
                                if(att.Description =='Separation Summary')
                                {
                                    userUploadedSep.add(att);
                                }
                                else
                                {
                                    systemUploadedSep.add(att);
                                }
                            }
                            else
                            {
                                aList1.add(att);
                            }
                        }
                        if(!userUploadedRel.isEmpty())
                            aList1.add(userUploadedRel[0]);
                        else
                        {
                            if(!systemUploadedRel.isEmpty())
                            	aList1.add(systemUploadedRel[0]);
                        }
                        if(!userUploadedSep.isEmpty())
                            aList1.add(userUploadedSep[0]);
                        else
                        {
                            if(!systemUploadedSep.isEmpty())
                            	aList1.add(systemUploadedSep[0]);
                        }      
                    }
                }
                //MSN:14th Feb 2017 RIF#47 Changes - Ends
            }
            // 3-Jul-17 : JIRA#RIF-95 : Add 'Age Disclosures' to the download list
            // if any of the selected SNRs have any age disclosures add it to the download list
            if(hasAgeDisc){
                // 31-Oct-17 : ALM#1987 : THe document count is doubled when Age Disclosure from PDU is selected for downloads
                // added the LIKE clause in a string to escape '_' character
                String likeClause = '%Age\\_Disclosure%';
                List<Attachment> ageDiscAttachments  = [SELECT Id, Name, ParentId FROM Attachment where ParentId IN :sSet AND 
                         Name LIKE : likeClause];
                if(ageDiscAttachments != null && !ageDiscAttachments.isEmpty()){
                    aList1.addAll(ageDiscAttachments);
                }
            }
            
            for (Attachment a:aList1) {
                aSet.add(a.Id);
                selectedSnR.add(a.ParentId);
            }
            totalToProcess = aList1.size();
        }
    }
   
    
    public pageReference processDownloads(){
    	
    	status='Running...please wait!';
    	system.debug('record number is:' +  recordNbr);
    	
    	 if (recordNbr >= totalToProcess){
    	 	plist = new List<Attachment>();
    	 	run=false;
    	 	status='Process complete! - Please wait until no activity before closing window.';
    	 	return null;
    	}
    	 	
    	 pList = [select id,name,parentId  From Attachment where id in :aSet limit 50];
    	  
    	 recordNbr = recordNbr + pList.size();
    	 
    	 system.debug('plist size is: ' + plist.size());
    	  
    	 for (Attachment a:plist)
    	  	aSet.remove(a.Id);
    	 
    	  
    	 return null;
    	
    }
     
    //create config records
    public void createConfigRecords(){
        RIF_Print_Project_Config__c configRecord = new RIF_Print_Project_Config__c();
        configRecord.Project__c = projectID;
        
        List<Severance_and_Release__c> updatedSRList= new List<Severance_and_Release__c>();
        
        String srIDs = '';
        if(selectedSnR != null && selectedSnR.size() > 0){
	        for(Severance_and_Release__c sr: [SELECT Id, Name, Document_Download_Status__c FROM 
	        															Severance_and_Release__c WHERE Id IN :selectedSnR]){
	            srIDs += sr.Id + ';';
				
                                                                            
				if(sr.Document_Download_Status__c != 'Downloaded') {
					sr.Document_Download_Status__c = 'Downloaded';
		            updatedSRList.add(sr);
				}
	        }
        }
        String docNames = 'All';
        /*for(String docName: selectedDocs){
            docNames += docName + ';';
        }
        */
        srIDs = srIDs.removeEnd(';');
        docNames = docNames.removeEnd(';');
        
        configRecord.SRIDs__c = srIDs;
        configRecord.User__c = UserInfo.getUserId();
        // configRecord.DocNames__c = docNames;
        configRecord.DocNames__c = docs;
        configRecord.Doc_Version__c = version;
        insert configRecord;
        
        System.debug('###configRecord####'+configRecord);
        
        if(updatedSRList != null && updatedSRList.size() > 0)
            update updatedSRList;
    }

}