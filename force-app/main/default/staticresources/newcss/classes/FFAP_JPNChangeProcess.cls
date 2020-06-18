//
//
// 11/20/2013  RA: Created FFAP_JPNChangeProcess
//
//
public without sharing class FFAP_JPNChangeProcess {

    public JPN_Change__c jpnChange {get;set;}
    public Employee__c requestor {get;set;}
    public string emp_recordId {get;set;} //it would be Employee Record Id
    public list<SelectOption> lstRecordType {get;set;}
    public list<SelectOption> lstfaAccountOption {get;set;}
    public string selectedJPNId {get;set;}
    public map<id, FA_Account__c> mapFAAccount {get;set;}
    public list<FA_Account__c> newFaAccList {get;set;}
    public string jpnToDelete {get;set;}
    public boolean displayJPNUpdate {get;set;}
    private string newJPNRecordTypeId;
    public FA_Account_Association__c faAccAssociationTemp {get;set;}
    public boolean showFATable {get;set;}
    public boolean displayNewJPN {get;set;}
    public boolean displayModificationType {get;set;}
    //public list<FA_Account__c> faAccListNewJPN {get;set;}
    public List<FA_Account_Association__c> faAccAssList{get;set;} // need to implement as replacement of faAccListNewJPN
    public string sourceId {get;set;}
    public boolean allowRecordTypeChange {get;set;}
    public boolean displayGridRate {get;set;}
    public boolean displayTab {get;set;}
    public boolean displayDocumentGeneration {get;set;}
    
    public FFAP_JPNChangeProcess(ApexPages.StandardController stdController){
        emp_recordId = null;
        jpnChange = new JPN_Change__c();
        requestor = new Employee__c();
        newJPNRecordTypeId = '';
        selectedJPNId = '';
        map<id, FA_Account__c> mapFAAccount = new map<id, FA_Account__c>();
        newFaAccList = new list<FA_Account__c>();
        //faAccListNewJPN = new list<FA_Account__c>(); 
        jpnToDelete = '';
        displayJPNUpdate = false;
        displayNewJPN = false;
        displayModificationType = true;
        faAccAssociationTemp = new FA_Account_Association__c();
        showFATable = false;
        faAccAssList = new List<FA_Account_Association__c>();
        allowRecordTypeChange = true;
        displayGridRate = false;
        displayTab = false;
        displayDocumentGeneration = false;
        
        populateRecordTypeOptions();
        jpnChange.RecordTypeId = newJPNRecordTypeId;
        if(ApexPages.currentPage().getParameters().containsKey('id')){
            jpnChange.Id = ApexPages.currentPage().getParameters().get('id');
            sourceId = jpnChange.Id;
            list<JPN_Change__c> lst = FFAP_DataUtil.getJPNChangeDetail(new list<id> {jpnChange.Id});
            if(lst.size() > 0){
                jpnChange = lst[0];
                
                if(jpnChange.Is_Documents_Package_Generated__c){
                	displayDocumentGeneration = true;
                }
                /*
                for(FA_Account__c fa : FFAP_DataUtil.getFAAccountOnJPNChangeId(jpnChange.Id)){
                    if(fa.JPN_Change__r.RecordTypeId == newJPNRecordTypeId){
                        faAccListNewJPN.add(fa);
                    }else{
                        newFaAccList.add(fa);
                    }
                }*/
            }
            allowRecordTypeChange = false;
        }else if(ApexPages.currentPage().getParameters().containsKey('empId')){
            emp_recordId = ApexPages.currentPage().getParameters().get('empId');
            jpnChange.JPN_Change_Requestor__c = emp_recordId;
        }
        startJPNChangeProcess();
        displaySection();
        
        
    }
    
    // Action Fuction--------------------
    public void startJPNChangeProcess(){
    	emp_recordId = jpnChange.JPN_Change_Requestor__c;
        for(Employee__c emp : FFAP_DataUtil.getEmployeeDetailsOnId(new set<id> {emp_recordId})){
            requestor = emp;
        }
        if(sourceId == null || sourceId == ''){
            sourceId = emp_recordId;
        }
        
        populateActiveFAAccountForRequestor();
    }
    
    public void SaveChangeProcess(){
        try{
            if(jpnChange.JPN_Change_Requestor__c == null && (jpnChange.RecordTypeId == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please select Change Type value' ));
                return;
            }
            upsert jpnChange;
            sourceId = jpnChange.Id;
            for(FA_Account__c fa : newFaAccList){
                fa.JPN_Change__c = jpnChange.Id;
            }
            
            list<FA_Account__c> lstFA = new list<FA_Account__c>();
            for(FA_Account_Association__c faa : faAccAssList){
            	FA_Account__c fa = faa.FA_Account__r;
            	fa.JPN_Change__c = jpnChange.Id;
            	lstFA.add(fa);
            }
            /*for(FA_Account__c faOld : faAccListNewJPN){
                faOld.JPN_Change__c = jpnChange.Id;
            }*/
            if(newFaAccList.size() > 0)
                update newFaAccList;
            /*if(faAccListNewJPN.size() > 0)
                update faAccListNewJPN;
             */
            if(lstFA.size() > 0){
            	update lstFA;
            }   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'JPN Change Process Saved successfully.'));
            allowRecordTypeChange = false;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, ex.getMessage()));
        }
    }
    
    public void addToJPNChangeList(){
        FA_Account__c fa = mapFAAccount.get(selectedJPNId);
        for(FA_Account__c faOld : newFaAccList){
            string tempJPNName = 'M-'+fa.Name;
            if(tempJPNName.toLowerCase() == faOld.Name.toLowerCase()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Selected JPN is already processed for changes. Please select another JPN.'));
                return;
            }
        }
        if(fa != null){
            // New FA Account record created with new name
            FA_Account__c faNew = new FA_Account__c(Type__c = FFAP_DataUtil.FA_JPN_TYPE, Name = 'M-' + fa.Name, RecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.JPN_CHANGE_RECORDTYPE), 
                                                    Include_in_Agreement__c = true, Old_FA_Account__c = fa.Id, Retirement_Months__c = '60');
            insert faNew; 
            newFaAccList.add(faNew);
            
            List<FA_Account_Association__c> allFaAccountAssociationList = FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(new set<id> {fa.Id});
            List<FA_Account_Production_Period_Association__c> allFaAccPordPeriodAssociationList = FFAP_DataUtil.getFAAccProdPeriodAssociationOnJPNSet(new set<id> {fa.Id});
            for(FA_Account_Association__c faa : allFaAccountAssociationList){
            	if(faa.Financial_Advisor__r.Status__c != 'Active'){
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.FFAP_Terminated_FA));
            		return;
            	}
            }
            
            // New FA_Account Association Records created for specific new FA Account
            List<FA_Account_Association__c> allTempFaAccountAssociationList = new List<FA_Account_Association__c>();
            FA_Account_Association__c faTemp;
            Map<Id, FA_Account_Association__c> oldFAToNewFA = new Map<Id, FA_Account_Association__c>();
            for(FA_Account_Association__c faa : allFaAccountAssociationList){
                faTemp = faa.clone(false, true, false, false);
                faTemp.FA_Account__c = faNew.Id;
                faTemp.FA_Account__r = faNew;
                faTemp.Previous_FA_Split_Percent__c = faa.FA_Split_Percent__c;
                allTempFaAccountAssociationList.add(faTemp);
                oldFAToNewFA.put(faa.Id, faTemp);
            }
            if(!allTempFaAccountAssociationList.isEmpty()){
                insert allTempFaAccountAssociationList;
            }
            
            //Cloning of Production periods
	        List<Production_Period__c> allTempProductionPeriodList = new List<Production_Period__c>();
	        Production_Period__c ppTemp;
	        Map<Id, Production_Period__c> oldFAToNewPP = new Map<Id, Production_Period__c>();
	        for(FA_Account_Production_Period_Association__c faAccountProdPer : allFaAccPordPeriodAssociationList){          
	            if(!oldFAToNewPP.containsKey(faAccountProdPer.Production_Period__c)){
	                ppTemp = faAccountProdPer.Production_Period__r.clone(false, true, false, false);                
	                allTempProductionPeriodList.add(ppTemp);
	                oldFAToNewPP.put(faAccountProdPer.Production_Period__c, ppTemp);
	            }
	        }
	        if(!allTempProductionPeriodList.isEmpty()){
	            insert allTempProductionPeriodList;
	        }
            // New FA_Account Production Period Association Records created for new FA Account and their respective FA AccountAssociation records
            List<FA_Account_Production_Period_Association__c> allTempFaAccPordPeriodAssociationList = new List<FA_Account_Production_Period_Association__c>();
            FA_Account_Production_Period_Association__c faAccountProdPerTemp;
            for(FA_Account_Production_Period_Association__c faAccountProdPer : allFaAccPordPeriodAssociationList){          
                if(oldFAToNewFA.containsKey(faAccountProdPer.FA_Account_Association__c)){
                    faAccountProdPerTemp = faAccountProdPer.clone(false, true, false, false);
                    faAccountProdPerTemp.FA_Account_Association__c = oldFAToNewFA.get(faAccountProdPer.FA_Account_Association__c).Id;
                    if(oldFAToNewPP.containsKey(faAccountProdPer.Production_Period__c)){
                        faAccountProdPerTemp.Production_Period__c = oldFAToNewPP.get(faAccountProdPer.Production_Period__c).Id;
                    }
                    faAccountProdPerTemp.Prv_FFAP_Split_Percent__c = faAccountProdPerTemp.FFAP_Split_Percent__c;
                    allTempFaAccPordPeriodAssociationList.add(faAccountProdPerTemp);
                }
            }
            if(!allTempFaAccPordPeriodAssociationList.isEmpty()){
                insert allTempFaAccPordPeriodAssociationList;
            }
            
            // release memory
            allFaAccountAssociationList.clear();
            allFaAccPordPeriodAssociationList.clear();
            allTempFaAccountAssociationList.clear();
            oldFAToNewFA.clear();
            allTempFaAccPordPeriodAssociationList.clear();
            
            SaveChangeProcess();
            if(!ApexPages.hasMessages()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Selected JPN is added for changes.'));
            }
            allowRecordTypeChange = false;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Active JPN to complete this process.'));
        }
    }
    
    public void deleteTempJpn(){
        delete new FA_Account__c(Id = jpnToDelete);
        jpnToDelete = null;      
        populateActiveFAAccountForRequestor();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Selected JPN is deleted.'));
        allowRecordTypeChange = false;
    }
    
    public void recordTypeChange(){
        displaySection();
    }
    public void modificationTypeChange(){
        displaySection();
    }
    
    public void advisorTypeChange(){
    	displaySection();
    }
    
    public void addFA(){
        if(faAccAssociationTemp.Financial_Advisor__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select Advisor.'));
            return;
        }
        
        if(faAccAssociationTemp.Financial_Advisor__c == jpnChange.JPN_Change_Requestor__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'JPN Change Requestor can not be add as FA.'));
            return;
        }
        
        for(Employee__c emp : FFAP_DataUtil.getEmployeeDetailsOnId(new set<id> {faAccAssociationTemp.Financial_Advisor__c})){
            if(emp.Status__c != 'Active'){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.Label.FFAP_Terminated_FA));
                return;
            }
        }
        
        showFATable = true;
        //integer counter = faAccListNewJPN.size();
        integer counter = faAccAssList.size();
        FA_Account__c newFA = new FA_Account__c(Is_Request_to_Create_New_JPN__c = true, Type__c = FFAP_DataUtil.FA_JPN_TYPE, Name = 'M-' + requestor.Emp_Id__c + '-'+ counter, RecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.JPN_CHANGE_RECORDTYPE), 
                                        Include_in_Agreement__c = false, Retirement_Months__c = '60');
        insert newFA;
        //faAccListNewJPN.add(newFA);
        
        Employee__c advisorDetail;
        for(employee__c emp : FFAP_DataUtil.getEmployeeDetailsOnId(new set<id>{faAccAssociationTemp.Financial_Advisor__c})){
            advisorDetail = emp;
        }
        
        //faAccListNewJPN
        list<FA_Account_Association__c> lstFaAccAssociation = new list<FA_Account_Association__c>();
        // for Added Advisior
        
        faAccAssociationTemp = new FA_Account_Association__c(Financial_Advisor__c = advisorDetail.Id,
                                                               Financial_Advisor__r = advisorDetail,
                                                               FA_Account__c = newFA.Id,
                                                               FA_Account__r = newFA,
                                                               FA_Split_Percent__c = 50,
                                                               Is_New_Advisor__c = true);
        
        faAccAssList.add(faAccAssociationTemp);
        
        lstFaAccAssociation.Add(faAccAssociationTemp);
        // For Requestor
        lstFaAccAssociation.Add(new FA_Account_Association__c(Financial_Advisor__c = requestor.Id,
                                                               FA_Account__c = newFA.Id,
                                                               FA_Split_Percent__c = 50,
                                                               Is_New_Advisor__c = true));
        
        insert lstFaAccAssociation;
        faAccAssociationTemp = new FA_Account_Association__c();
        if(!ApexPages.hasMessages()){
            SaveChangeProcess();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Advisor added successfully.'));
        allowRecordTypeChange = false; 
    }
    //Methods----------------------------
    public void populateRecordTypeOptions(){
        lstRecordType = new list<SelectOption>();
        lstRecordType.add(new SelectOption(FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.NEW_JPN_RECORDTYPE), FFAP_DataUtil.NEW_JPN_RECORDTYPE));
        lstRecordType.add(new SelectOption(FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.MODIFICATION_RECORDTYPE), FFAP_DataUtil.MODIFICATION_RECORDTYPE));
        newJPNRecordTypeId = FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.NEW_JPN_RECORDTYPE);
    }
    
    public void populateActiveFAAccountForRequestor(){
        string faTempName = 'M-' + requestor.Emp_Id__c;
        
        lstfaAccountOption = new list<SelectOption>();
        mapFAAccount = new map<id, FA_Account__c>();
        newFaAccList.clear();
        //faAccListNewJPN.clear();
        faAccAssList.clear();
        Map<Id, String> jpnIdToNameMap = new Map<Id, String>();            
        
        for(FA_Account_Association__c faTemp : FFAP_DataUtil.getJPNFAAccAssociationOnEmpIds(new list<string>{requestor.Emp_Id__c})){            
            jpnIdToNameMap.put(faTemp.FA_Account__c, faTemp.FA_Account__r.Name);
        }
        if(!jpnIdToNameMap.isEmpty()){
            for(FA_Account_Association__c faa : FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(jpnIdToNameMap.keySet())){                
        
	            FA_Account__c fa = faa.FA_Account__r;
	            if(mapFAAccount.containsKey(fa.id)){
	            	continue;
	            }
	            
	            if(fa.RecordTypeId == FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.JPN_CHANGE_RECORDTYPE) && !fa.Name.startsWith(faTempName) && fa.JPN_Change__c == jpnChange.Id && !mapFAAccount.containsKey(fa.Id)){
	                newFaAccList.add(fa);
	            }else if(fa.RecordTypeId == FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.JPN_CHANGE_RECORDTYPE) && fa.Name.startsWith(faTempName) && fa.JPN_Change__c == jpnChange.Id && faa.Financial_Advisor__c != emp_recordId){
	            	/*if(!mapFAAccount.containsKey(fa.Id))
	                   faAccListNewJPN.add(fa);*/
	                faAccAssList.add(faa);
	            }else if(!mapFAAccount.containsKey(fa.Id) && fa.RecordTypeId == FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE)){
	                lstfaAccountOption.add(new SelectOption(fa.Id, fa.Name));
	            }
	            mapFAAccount.put(faa.FA_Account__r.Id, faa.FA_Account__r);
            }
        }
        system.debug('newFaAccList: '+ newFaAccList);
        //system.debug('faAccListNewJPN: '+ faAccListNewJPN);
        system.debug('faAccAssList: '+ faAccAssList);
        system.debug('lstfaAccountOption: '+ lstfaAccountOption);
    }
    
    public void displaySection(){
        system.debug('jpnChange: '+jpnChange);
        displayTab = false;
        displayGridRate = false;
        
        if(jpnChange.RecordTypeId == newJPNRecordTypeId){
            displayTab = true;
            displayJPNUpdate = false;
            displayNewJPN = true;
            displayModificationType = false;
            showFATable = true;
        }else if(jpnChange.RecordTypeId != newJPNRecordTypeId && jpnChange.RecordTypeId != null){
            displayTab = true;
            displayJPNUpdate = true;
            displayNewJPN = false;
            displayModificationType = true;
            showFATable = false;
            if(jpnChange.Advisor_Type__c != 'CMP' && jpnChange.Modification_Type__c == 'Split % Change'){
                displayGridRate = true;
	        }
        }
        
        if(jpnChange.Modification_Type__c == 'Termination of Contract'){
            displayJPNUpdate = false;
            displayNewJPN = false;
            displayTab = false;
            showFATable = false;
        }
    }
}