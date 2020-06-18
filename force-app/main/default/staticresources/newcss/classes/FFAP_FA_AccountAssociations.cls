public class FFAP_FA_AccountAssociations {
	public string sourceId{get; set;}
    private String empId;
    public List<FAAccountAssociationsWrapper> faAccountAssociationList{get;set;}
    public string fa_Type {get;set;}
    public string fa_Name {get;set;}
    public map<string, List<FA_Account_Association__c>> mapFAAccountType{get; set;}
    public boolean isEditTempJPN{get;set;}
    
    public FFAP_FA_AccountAssociations(ApexPages.StandardController stdController) {
    	if(ApexPages.currentPage().getParameters().get('faaId') != NULL){
    		sourceId = ApexPages.currentPage().getParameters().get('faaId');
    	}
    	if(ApexPages.currentPage().getParameters().get('empId') != NULL){
            empId = ApexPages.currentPage().getParameters().get('empId');
        }
        fa_Type = FFAP_DataUtil.FA_Primary_TYPE;
        faAccountAssociationList = new list<FAAccountAssociationsWrapper>(); 
        isEditTempJPN = false;
        getEmployeeDetails();
        
        getFAAccountAssociations();
        
        pupolateFFAList(fa_Type);
    }
    
    public void getEmployeeDetails(){
    	Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);
    	fa_Name = emp <> null ? emp.Name : '';
    	if(sourceId == null){
    		sourceId = emp.Id;
    	} 
    }
        
    public void getFAAccountAssociations(){
    	mapFAAccountType = new map<string, List<FA_Account_Association__c>>();
    	string faType = '';
    	mapFAAccountType.put(FFAP_DataUtil.FA_Primary_TYPE, new list<FA_Account_Association__c>());
    	mapFAAccountType.put(FFAP_DataUtil.FA_JPN_TYPE, new list<FA_Account_Association__c>());
    	mapFAAccountType.put(FFAP_DataUtil.FA_OTHER_TYPE, new list<FA_Account_Association__c>());
    	for(FA_Account_Association__c faa : FFAP_DataUtil.getFAAccAssociationListonOnEmpId(empId)){
    		if(faa.FA_Account__r.Type__c == FFAP_DataUtil.FA_Primary_TYPE && faa.FA_Account__r.RecordType.Name == FFAP_DataUtil.ACTIVE_RECORDTYPE){
    			faType = FFAP_DataUtil.FA_Primary_TYPE;
    		}else if(faa.FA_Account__r.Type__c == FFAP_DataUtil.FA_JPN_TYPE && faa.FA_Account__r.RecordType.Name == FFAP_DataUtil.ACTIVE_RECORDTYPE){
                faType = FFAP_DataUtil.FA_JPN_TYPE;
            }else{
            	faType = FFAP_DataUtil.FA_OTHER_TYPE;
            }
            
    		if(mapFAAccountType.containsKey(faType) && !faa.FA_Account__r.InActive__c){
                mapFAAccountType.get(faType).add(faa);
            }else{
                mapFAAccountType.get(FFAP_DataUtil.FA_OTHER_TYPE).add(faa);
            } 
    	}    	
    	system.debug('------------------' + mapFAAccountType);
    }
    
    public void pupolateFFAList(string faType){
    	faAccountAssociationList.clear();
    	isEditTempJPN = false;
    	if(mapFAAccountType.containsKey(faType)){
	    	for(FA_Account_Association__c fa : mapFAAccountType.get(faType)){
	    		faAccountAssociationList.add(new FAAccountAssociationsWrapper(fa));
	    		if(fa.FA_Account__r.Temp_FA_Account__c == null){
	    			isEditTempJPN = true;
	    		}
	    	}
    	}
    }    
    
    public void switchTab(){
    	ApexPages.getMessages().clear();
    	System.debug('Jitendra -> ' + fa_Type);
    	pupolateFFAList(fa_Type);
    }
    
    public void saveTempJPNNumbers(){
    	list<FA_Account__c> listAccountToUpsert = new list<FA_Account__c>();
        //map<Id, Id> oldToNewFAAccount = new map<Id, Id>();
        set<Id> oldAccounts = new Set<Id>();
        set<Id> newAccounts = new Set<Id>();
     	for(FAAccountAssociationsWrapper accountAssociationWrapper : faAccountAssociationList){
    		if(accountAssociationWrapper.faAccountAssociation.FA_Account__r.Temp_FA_Account__c <> null && accountAssociationWrapper.oldValue == null){
    			listAccountToUpsert.add(accountAssociationWrapper.faAccountAssociation.FA_Account__r);
    			oldAccounts.add(accountAssociationWrapper.faAccountAssociation.FA_Account__r.Temp_FA_Account__c);
    			newAccounts.add(accountAssociationWrapper.faAccountAssociation.FA_Account__c);    			
    		}
    	}
    	
    	if(!listAccountToUpsert.isEmpty()){
    		upsert listAccountToUpsert;
    	}
    	
    	//List<FA_Account_Association__c> oldFaAccountAssociationList = FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(oldAccounts);
    	List<FA_Account_Association__c> newFaAccountAssociationList = FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(newAccounts);
        List<FA_Account_Production_Period_Association__c> allOldFaAccPordPeriodAssociationList = FFAP_DataUtil.getFAAccProdPeriodAssociationOnJPNSet(oldAccounts);
        List<FA_Account_Association__c> allTempFaAccountAssociationList = new List<FA_Account_Association__c>();
        FA_Account_Association__c faTemp;
        Map<Id, Id> oldFAToNewFA = new Map<Id, Id>();
        
        for(FA_Account_Association__c fa : newFaAccountAssociationList){
        	oldFAToNewFA.put(fa.Financial_Advisor__c, fa.Id);
        }
        
        //Cloning of Production periods
        List<Production_Period__c> allTempProductionPeriodList = new List<Production_Period__c>();
        Production_Period__c ppTemp;
        Map<Id, Production_Period__c> oldFAToNewPP = new Map<Id, Production_Period__c>();
        for(FA_Account_Production_Period_Association__c faAccountProdPer : allOldFaAccPordPeriodAssociationList){          
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
        for(FA_Account_Production_Period_Association__c faAccountProdPer : allOldFaAccPordPeriodAssociationList){          
            if(oldFAToNewFA.containsKey(faAccountProdPer.FA_Account_Association__r.Financial_Advisor__c)){
                faAccountProdPerTemp = faAccountProdPer.clone(false, true, false, false);
                faAccountProdPerTemp.FA_Account_Association__c = oldFAToNewFA.get(faAccountProdPer.FA_Account_Association__r.Financial_Advisor__c);
                if(oldFAToNewPP.containsKey(faAccountProdPer.Production_Period__c)){
                    faAccountProdPerTemp.Production_Period__c = oldFAToNewPP.get(faAccountProdPer.Production_Period__c).Id;
                }
                allTempFaAccPordPeriodAssociationList.add(faAccountProdPerTemp);
            }
        }
        if(!allTempFaAccPordPeriodAssociationList.isEmpty()){
            insert allTempFaAccPordPeriodAssociationList;
        }
        
        
    	
    	list<FA_Account_Association__c> faAccAssociationList = FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(empId, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.ACTIVE_RECORDTYPE);
    	mapFAAccountType.put(FFAP_DataUtil.FA_JPN_TYPE, faAccAssociationList);
    	pupolateFFAList(FFAP_DataUtil.FA_JPN_TYPE);
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, System.Label.FFAP_FA_Updated));
    } 
    
    public class FAAccountAssociationsWrapper{
    	public FA_Account_Association__c faAccountAssociation{get; set;}
    	public String oldValue{get; set;}
    	public FAAccountAssociationsWrapper(FA_Account_Association__c fa){
    		this.faAccountAssociation = fa;
    		this.oldValue = fa.FA_Account__r.Temp_FA_Account__c;
    	}	
    }
}