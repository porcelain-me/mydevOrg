public without sharing class FFAP_FA_RetirementProcessStart {
    public Id faAgreementId{get; set;}
    private Map<Id, String> jpnIdToNameMap;
    private String empId;
    private Id agreementRecordTypeId;
    private boolean doCreateJPNRecords;
    public boolean isError{get;set;}
    //Constructor
    public FFAP_FA_RetirementProcessStart(ApexPages.StandardController stdController){
        if(ApexPages.currentPage().getParameters().get('faaId') != NULL){
            this.faAgreementId = ApexPages.currentPage().getParameters().get('faaId');
        }
        if(ApexPages.currentPage().getParameters().get('empId') != NULL){
            this.empId = ApexPages.currentPage().getParameters().get('empId');
        }
        isError = false;
        for(FFAP_Agreement__c faAgreement : FFAP_DataUtil.getAgreementDetailsOnAgreementId(faAgreementId)){
        	if(!faAgreement.Is_Commitment_Agreement_Generated__c){
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Commitment Agreement is not generated.'));
	            this.isError = true;
	            return;
        	}else if(!faAgreement.Is_Commitment_Agreement_Signed__c){
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Commitment Agreement is generated but not signed.'));
                this.isError = true;
                return;
        	}
            break;
        }
        List<FA_Account_Association__c> faAccAssociationAgreementTypeList = 
                    FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(empId, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.AGREEMENT_RECORDTYPE);
        
        this.doCreateJPNRecords = false;
        if(!faAccAssociationAgreementTypeList.isEmpty()){
        	for(FA_Account_Association__c faTemp : faAccAssociationAgreementTypeList){
        		if(faTemp.FA_Account__r.Name.endsWithIgnoreCase('-' + empId)){
                    this.doCreateJPNRecords = false;
                    return;
                }
        	}        	
        }        
	    loadData();    
    }
    private void loadData(){
        this.agreementRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE);
        this.jpnIdToNameMap = new Map<Id, String>();
        for(FA_Account_Association__c fa : FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(empId, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.ACTIVE_RECORDTYPE)){
           this.jpnIdToNameMap.put(fa.FA_Account__c, fa.FA_Account__r.Name);
        }
        if(!this.jpnIdToNameMap.isEmpty()){
            this.doCreateJPNRecords = true;          
        }else{
        	this.doCreateJPNRecords = false;
        }
    }
    public void pageAction(){
    	if(!this.doCreateJPNRecords){
    		return;
    	}
    	Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);
    	List<FA_Account__c> faAccounts = new List<FA_Account__c>();
    	String jpn;
    	FA_Account__c faAccountTemp;
    	for(Id faAccountId : jpnIdToNameMap.keySet()){
    		jpn = jpnIdToNameMap.get(faAccountId);
    		faAccountTemp = new FA_Account__c(Type__c = FFAP_DataUtil.FA_JPN_TYPE, RecordTypeId = agreementRecordTypeId, Include_in_Agreement__c = true, Old_FA_Account__c = faAccountId, 
    		      Retirement_Months__c = '60');
    		faAccountTemp.Name = jpn + '-' + empId;
    		faAccounts.add(faAccountTemp);
    	}
    	if(!faAccounts.isEmpty()){
    		insert faAccounts;
    	}
    	Map<String, Id> jpnNameToIdMap = new Map<String, Id>();
    	for(FA_Account__c faAccount : faAccounts){
    		jpnNameToIdMap.put(faAccount.Name, faAccount.Id);
    	}
    	List<FA_Account_Association__c> allFaAccountAssociationList = FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(jpnIdToNameMap.keySet());
        List<FA_Account_Production_Period_Association__c> allFaAccPordPeriodAssociationList = FFAP_DataUtil.getFAAccProdPeriodAssociationOnJPNSet(jpnIdToNameMap.keySet());
        
        //Cloning of Account Associations
        List<FA_Account_Association__c> allTempFaAccountAssociationList = new List<FA_Account_Association__c>();        
        FA_Account_Association__c faTemp; 
        Map<Id, FA_Account_Association__c> oldFAToNewFA = new Map<Id, FA_Account_Association__c>();        
        for(FA_Account_Association__c fa : allFaAccountAssociationList){
            faTemp = fa.clone(false, true, false, false);
            faTemp.FA_Account__c = jpnNameToIdMap.get(fa.FA_Account__r.Name + '-' + empId);
            allTempFaAccountAssociationList.add(faTemp);            
            oldFAToNewFA.put(fa.Id, faTemp);
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
        //Cloning of Production period associations
        List<FA_Account_Production_Period_Association__c> allTempFaAccPordPeriodAssociationList = new List<FA_Account_Production_Period_Association__c>();
        FA_Account_Production_Period_Association__c faAccountProdPerTemp;
        for(FA_Account_Production_Period_Association__c faAccountProdPer : allFaAccPordPeriodAssociationList){          
            if(oldFAToNewFA.containsKey(faAccountProdPer.FA_Account_Association__c)){
                faAccountProdPerTemp = faAccountProdPer.clone(false, true, false, false);
                faAccountProdPerTemp.FA_Account_Association__c = oldFAToNewFA.get(faAccountProdPer.FA_Account_Association__c).Id;
                if(oldFAToNewPP.containsKey(faAccountProdPer.Production_Period__c)){
                    faAccountProdPerTemp.Production_Period__c = oldFAToNewPP.get(faAccountProdPer.Production_Period__c).Id;
                }
                allTempFaAccPordPeriodAssociationList.add(faAccountProdPerTemp);
            }
        }
        if(!allTempFaAccPordPeriodAssociationList.isEmpty()){
            insert allTempFaAccPordPeriodAssociationList;
        }        
    }    
    public PageReference getredirectUrl(){
    	PageReference pg = Page.FFAP_FA_RetirementProcess;
    	pg.setRedirect(true); 
        pg.getParameters().put('faaId', faAgreementId);
        pg.getParameters().put('empId', empId);        
        return pg;
    }   
}