// 11/22/2013 : MG : ORIGINAL
// Description : Class for Conga Redirector for Modification process
public class FFAP_Modification_Conga_Redirector {
	private Id modificationRecordId;
	private Employee__c requester;
	private JPN_Change__c jpnChange;
	public set<String> setDocumentNames = new set<String>();
	private list<FFAP_Document_Recipient__c> listDocRecipientToInsert;
	private list<FFAP_CongaDetail__c> listCongaDetails = new list<FFAP_CongaDetail__c>();
	private boolean isError;
	Map<String, set<Id>> advisorToFAmap = new  Map<String, set<Id>>();
	public FFAP_Modification_Conga_Redirector(Id modificationRecordId){		
		this.modificationRecordId = modificationRecordId;
		isError = false;
	}
	
	public string generateDocumentForModification(){
		String resultString = FFAP_DataUtil.SUCCESS;
		validateData();
        if(!apexpages.hasMessages(ApexPages.Severity.ERROR)){ 
        	fetchFAAccounts();
        }
        if(apexpages.hasMessages(ApexPages.Severity.ERROR)){
        	return 'Error in data';
        }
		return FFAP_DataUtil.SUCCESS;
	}
	private String fetchFAAccounts(){
		String resultString = '';
		List<FA_Account_Association__c> faaList = FFAP_DataUtil.getFAAccAssociationOnJpnChangeId(jpnChange.Id);
		map<id, Employee__c> faEmpIds = new map<id, Employee__c>();
		for(FA_Account_Association__c fa : faaList){
			if(fa.Financial_Advisor__r.Financial_Advisor_Number__c == null || fa.Financial_Advisor__r.Financial_Advisor_Number__c == ''){
				logError('Financial Advisor Number for advisor ' + '(' + fa.Financial_Advisor__r.Name + ' - ' + fa.Financial_Advisor__r.Emp_Id__c + ')' + ' is not available');
			}
			
			logErrors(FFAP_CongaManager.validateEmployee(fa.Financial_Advisor__r, 'Advisor', false));			
			
            if(FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.MODIFICATION_RECORDTYPE) == jpnChange.RecordTypeId && jpnChange.Advisor_Type__c == 'PWA' 
                                                            && fa.Is_New_Advisor__c == false){
            	if(fa.Agreement_Signed_Date__c == null){
	                logError('Agreement Signed Date for ' + fa.Emp_Id__c + ' is not available for Account# ' + fa.FA_Account__r.Name);
	            }else if(fa.Financial_Advisor__c == requester.Id){
	                jpnChange.CONGA_Requester_Signed_Date__c = fa.Agreement_Signed_Date__c;
	            }
            }

			if(!advisorToFAmap.containsKey(fa.Emp_Id__c)){
				advisorToFAmap.put(fa.Emp_Id__c, new Set<Id>());
			}
			advisorToFAmap.get(fa.Emp_Id__c).add(fa.FA_Account__c);
			if(!faEmpIds.containsKey(fa.Financial_Advisor__c)){
                faEmpIds.put(fa.Financial_Advisor__c, fa.Financial_Advisor__r);
            }
		}
		set<Id> bmIds = new Set<Id>();
        Id branMIds;
        for(Employee__c empTemp : faEmpIds.values()){
           branMIds =  FFAP_CongaManager.returnCongaBranchManagerForCurrentEmployee(empTemp);                         
           bmIds.add(branMIds);
           empTemp.Conga_Branch_Manager__c = branMIds;                     
        }
        update faEmpIds.values();
        Map<Id, Employee__c> branchManagerRecords = new Map<Id, Employee__c>();
        if(!bmIds.isEmpty()){           
            branchManagerRecords = new Map<Id, Employee__c>(FFAP_DataUtil.getEmployeeDetailsOnId(bmIds));            
        }
        Employee__c branchManager; 
        
		system.debug('========'+advisorToFAmap);
		String generatedDocumentName = '';
        List<FFAP_CongaDetail__c> listCongaDetails = new List<FFAP_CongaDetail__c>();
        listDocRecipientToInsert = new list<FFAP_Document_Recipient__c>();
        
        for(FFAP_Conga_Template_Mapping__c mapping : FFAP_DataUtil.getFFAPCongaTemplatesOnAdvisorType(jpnChange.Advisor_Type__c)){        	
        	if(mapping.Modification_Type__c.contains(jpnChange.Modification_Type__c) && mapping.Package_Type__c.contains(jpnChange.RecordType.Name)){
	        	generatedDocumentName = jpnChange.Advisor_Type__c + '_' + jpnChange.RecordType.Name + '_' + mapping.Name.replace(' ', '+') + '_' + jpnChange.JPN_Change_Requestor__r.Emp_Id__c;
	            if(mapping.Send_to_Retiring_FA__c){
	            	setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
	            	createDocumentRecipientRecords(jpnChange.Id, requester, mapping, generatedDocumentName.replace('+', ' '));
	            	if(jpnChange.modification_Type__c == 'Termination of Contract'){
		    			listCongaDetails.add(createCongaDetailRecord_terminated(generatedDocumentName, requester.emp_Id__c, mapping));
	            	}else if(advisorToFAmap.containsKey(requester.emp_Id__c) && jpnChange.modification_Type__c == 'Split % Change'){
		    			listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, requester.emp_Id__c, mapping));
	            	}
	            }else if(mapping.Send_To_New_FA__c || mapping.Send_To_Active_FAs__c){
	            	set<String> processedFAIds = new set<String>();
	            	for(FA_Account_Association__c accAss : faaList){
	            		if(jpnChange.Modification_Type__c == 'Split % Change' && accAss.Financial_Advisor__c == requester.Id){
	            			continue;
	            		}	            		
	                    logErrors(FFAP_CongaManager.validateEmployee(accAss.Financial_Advisor__r, 'Active FA', false));
                        branchManager = branchManagerRecords.get(faEmpIds.get(accAss.Financial_Advisor__c).Conga_Branch_Manager__c);
                        if(branchManager == null){
                            logError('Branch Manager not found for Active FA ' + '(' + accAss.Financial_Advisor__r.Name + ' - ' + accAss.Emp_Id__c + ')');
                        }else{
                            logErrors(FFAP_CongaManager.validateEmployee(branchManager, 'Branch Manager', false));
                        }	
		                if(!processedFAIds.contains(accAss.Emp_Id__c) && !isError){		                	
		                	generatedDocumentName = jpnChange.Advisor_Type__c + '_' + jpnChange.RecordType.Name + '_' + mapping.Name.replace(' ', '+') + '_' + jpnChange.JPN_Change_Requestor__r.Emp_Id__c;
		                	if(!generatedDocumentName.contains(accAss.Emp_Id__c)){
		                		generatedDocumentName += '_' + accAss.Emp_Id__c;
		                	}
		                	
		                	if(mapping.Send_To_New_FA__c){
		                		if(accAss.Is_New_Advisor__c){
		                			processedFAIds.add(accAss.Emp_Id__c);
		                			setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
		                			createDocumentRecipientRecords(jpnChange.Id, faEmpIds.get(accAss.Financial_Advisor__c), mapping, generatedDocumentName.replace('+', ' '));
		                			listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, accAss.emp_Id__c, mapping));
		                		}
		                	}else if(mapping.Send_To_Active_FAs__c){
		                		if(accAss.Is_FA_Split_Modified__c && !accAss.Is_New_Advisor__c){
				                	processedFAIds.add(accAss.Emp_Id__c);
				                	setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
				                	listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, accAss.emp_Id__c, mapping));
				                	createDocumentRecipientRecords(jpnChange.Id, faEmpIds.get(accAss.Financial_Advisor__c), mapping, generatedDocumentName.replace('+', ' '));
		                		}
		                	}
		                }		            
	            	}
	            }
        	}            
        }
        if(isError){
        	return '';
        }
        system.debug('---------' + setDocumentNames);
        if(!listCongaDetails.isEmpty()){
            boolean isCongaDetailInsert = false;
            try{
            	jpnChange.Is_Documents_Package_Generated__c = true;            
            	update jpnChange;
                insert listCongaDetails;
                isCongaDetailInsert = true;
                if(!listDocRecipientToInsert.isEmpty()){
                    insert listDocRecipientToInsert;                    
                }
            }catch(exception ex){                
                ApexPages.addMessages(ex);
                return '';
            }
        }else{
        	
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, jpnChange.RecordType.Name + ' Package Documents are not available because no changes were made to any advisor\'s FA Split% for any JPN'));
            return '';
        }
        
        return FFAP_DataUtil.SUCCESS; 
	}
	
	private void createDocumentRecipientRecords(String jpnChangeId, Employee__c emp, FFAP_Conga_Template_Mapping__c mapping, String generatedDocumentName){
		Integer signingOrder = 1;
        generatedDocumentName = generatedDocumentName + '.doc';
        if(mapping.send_To_Active_FAs__c || mapping.Send_To_New_FA__c){            
            listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(jpnChangeId, jpnChange.RecordType.Name, SigningOrder, emp.Id, generatedDocumentName));
            SigningOrder++;
        }
        
        if((mapping.send_To_Active_FAs__c || mapping.Send_To_New_FA__c) && mapping.Send_To_Branch_Manager__c && emp.Conga_Branch_Manager__c <> null){    
        	listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(jpnChangeId, jpnChange.RecordType.Name, SigningOrder, emp.Conga_Branch_Manager__c, generatedDocumentName));
            SigningOrder++;
        }
        if(mapping.Send_to_Retiring_FA__c){            
            listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(jpnChangeId, jpnChange.RecordType.Name, SigningOrder, emp.Id, generatedDocumentName));
            SigningOrder++;
        }
        
        if(mapping.Send_to_Retiring_FA__c && mapping.Send_To_Branch_Manager__c && jpnChange.Conga_Branch_Manager__c <> null){
            listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(jpnChangeId, jpnChange.RecordType.Name, SigningOrder, jpnChange.Conga_Branch_Manager__c, generatedDocumentName));
            SigningOrder++;
        }
        
        if(mapping.Send_To_Regional_Director__c){
            Id rdId = requester.Override_Regional_Director__c <> null ? requester.Override_Regional_Director__c : requester.Regional_Director__c;
            if(rdId != null){ 
	            listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(jpnChangeId, jpnChange.RecordType.Name, SigningOrder, rdId, generatedDocumentName));
	            SigningOrder++;
            }
        }
	}
	
	private FFAP_CongaDetail__c createCongaDetailRecord(string generatedName, string empId, FFAP_Conga_Template_Mapping__c mapping){
        FFAP_CongaDetail__c congaDetail = new FFAP_CongaDetail__c();
        congaDetail.FFAP_JPN_Change__c = jpnChange.Id;
        String accountIds = '';
        system.debug('========'+advisorToFAmap.get(empId));
        if(advisorToFAmap.containskey(empId)){
        	for(Id accountId : advisorToFAmap.get(empId)){
	        	if(accountIds == ''){
	        		accountIds = '\'' + accountId + '\'';
	        	}else{
	        		accountIds += '|\'' + accountId + '\'';
	        	}
	        }
        }
        
        String empIds = '\'' + empId + '\'|\'' +  requester.Emp_ID__c + '\'';
        if(mapping.Query_Id__c <> null){
            String tempQuery = mapping.Query_Id__c.replaceAll('#empId#', empId).replace('#accountIds#', accountIds).replaceAll('#empIds#', empIds).replaceAll('#requesterId#',requester.Id).replaceAll('#recordTypeId#', FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE));
	    	
	    	if(tempQuery.length() > 255){
	    		congaDetail.Param_QueryId__c = tempQuery.substring(0,250);
	    		congaDetail.Param_QueryId_1__c = tempQuery.substring(250,tempQuery.length());
	    	}else{
	    		congaDetail.Param_QueryId__c = tempQuery;
	    	}
        }
        congaDetail.Param_TemplateId__c = mapping.template_Id__c;
        congaDetail.Document_Name__c = generatedName;
        return congaDetail;
    }
    
    private FFAP_CongaDetail__c createCongaDetailRecord_terminated(string generatedName, string empId, FFAP_Conga_Template_Mapping__c mapping){
        FFAP_CongaDetail__c congaDetail = new FFAP_CongaDetail__c();
        congaDetail.FFAP_JPN_Change__c = jpnChange.Id;
        String accountIds = '';
        //system.debug('========'+advisorToFAmap.get(empId));
        system.debug('---------' + empId);
    	for(FA_Account_Association__c accAss : FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(empId, 'JPN', 'Active')){
        	if(accountIds == ''){
        		accountIds = '\'' + accAss.FA_Account__c + '\'';
        	}else{
        		accountIds += '|\'' + accAss.FA_Account__c + '\'';
        	}
        }
        
        system.debug('---ACCOUNT IDS------' + accountIds);
        String empIds = '\'' + empId + '\'|\'' +  requester.Emp_ID__c + '\'';
        if(mapping.Query_Id__c <> null){
            String tempQuery = mapping.Query_Id__c.replaceAll('#empId#', empId).replace('#accountIds#', accountIds).replaceAll('#empIds#', empIds).replaceAll('#requesterId#',requester.Id).replaceAll('#recordTypeId#', FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE));
	    	
	    	if(tempQuery.length() > 255){
	    		congaDetail.Param_QueryId__c = tempQuery.substring(0,250);
	    		congaDetail.Param_QueryId_1__c = tempQuery.substring(250,tempQuery.length());
	    	}else{
	    		congaDetail.Param_QueryId__c = tempQuery;
	    	}
        }
        congaDetail.Param_TemplateId__c = mapping.template_Id__c;
        congaDetail.Document_Name__c = generatedName;
        return congaDetail;
    }
    
	private void validateData(){
		List<JPN_Change__c> jpChangeList = FFAP_DataUtil.getJPNChangeDetailForConga(new list<id>{modificationRecordId});
        if(jpChangeList.isEmpty()){
        	logError('JPN Change record not found.');
        }else{
        	jpnChange = jpChangeList.get(0);
        }
        if(jpnChange.Is_Documents_Package_Generated__c){
        	logError('Document Package has already been generated.');
        }
        
        logErrors(FFAP_CongaManager.validateEmployee(jpnChange.JPN_Change_Requestor__r, 'Requestor', false));        
        if(jpnChange.Advisor_Type__c == null){
        	logError('JPN Change Advisor Type not found.');
        }else if(jpnChange.Modification_Type__c == null){
            logError('JPN Change Modification Type not found.');
        }
        
        requester = FFAP_DataUtil.getEmployeeDetailsOnId(jpnChange.JPN_Change_Requestor__c);
        
        Employee__c tempEmp = requester <> null ? FFAP_CongaManager.returnCongaActiveManagerForCurrentEmployee(requester) : null;
        if(tempEMP == null){
        	logError('Active Manager is not available for FA' + '(' + requester.Name + ' - ' + requester.Emp_Id__c + ').');
        	return;
        }
        jpnChange.Conga_Branch_Manager__c = tempEmp.Id;
        jpnChange.Conga_Branch_Manager__r = tempEmp;
        
        Id rdId =  requester.Override_Regional_Director__c <> null ? requester.Override_Regional_Director__c : requester.Regional_Director__c;
        if(jpnChange.Conga_Branch_Manager__c == Null || rdId == null){              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employee\'s Branch Manager or Regional Director are not available.'));
        }
        
        logErrors(FFAP_CongaManager.validateEmployee(jpnChange.Conga_Branch_Manager__r, 'Branch Manager', false));    
        
        if(requester.Override_Regional_Director__c <> null){
        	logErrors(FFAP_CongaManager.validateEmployee(requester.Override_Regional_Director__r, 'Regional Director', false));
        }else if(requester.Override_Regional_Director__c == null){
        	logErrors(FFAP_CongaManager.validateEmployee(requester.Regional_Director__r, 'Regional Director', false));
        }        
	}
	private void logErrors(List<String> errors){        
        for(String error : errors){
            logError(error);
        }
    }
    
    public void logError(String error){
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
    }
}