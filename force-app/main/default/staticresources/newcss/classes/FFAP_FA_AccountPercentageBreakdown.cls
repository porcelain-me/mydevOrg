//
//
// 10/2/2013 RA: created for editing FFAP_FA_AccountPercentageBreakdown
//
//
public without sharing class FFAP_FA_AccountPercentageBreakdown {

    public string jpnNumber{get;set;}
    public map<string, FFAP_PercentageBreakdown> mapCoverage_PrecentageBreakDown {get;set;}
    public string deletedMarkedCoveragePeriod {get;set;}
    public string deletedEmpId {get;set;}
    public integer advisorRowSpan {get;set;}
    public map<string, FFAP_AccountDetails> mapEmpIdEmpDetail {get;set;}
    public list<FFAP_AccountDetails> lstFAAccountDetail {get;set;}
    public list<string> lstEmpIds {get;set;}
    public string statusMsg {get;set;}
    public string statusMsgAdvisor {get;set;} 
    private string faAccountId;
    private list<FA_Account_Association__c> lstDelFAAccountDetail;
    public string showManageAdvisor {get;set;}
    private string changeRequestor;
    public boolean isJPNChangeProcess {get;set;}
    public boolean isJPNChangeModificationProcess {get;set;}
    public boolean isJPNChangeProcessForCMP {get;set;}
    public boolean isFASplitReadOnly {get;set;} 
    public boolean isRetirementJPN {get;set;}
    public string currEmpId;
    public decimal ffapMultiplier {get;set;}
    public string curKey {get;set;}
    
    public FFAP_FA_AccountPercentageBreakdown(){
    	faAccountId = ApexPages.currentPage().getParameters().get('JPN');
    	
    	if(ApexPages.currentPage().getParameters().containsKey('showAdvisors')){
    		showManageAdvisor = ApexPages.currentPage().getParameters().get('showAdvisors');
    	}
        changeRequestor = null;
        isJPNChangeProcess = false;
        isJPNChangeProcessForCMP = false;
        isFASplitReadOnly  = false;
        isRetirementJPN = false;
        isJPNChangeModificationProcess = false;
        currEmpId = null;
    	if(ApexPages.currentPage().getParameters().containsKey('changeRequestor')){
            changeRequestor = ApexPages.currentPage().getParameters().get('changeRequestor');
            if(changeRequestor != '')
                isJPNChangeProcess = true;
        }
        
        
    	if(faAccountId != null && faAccountId != ''){
    		prepareEmpIdEmpDetailMap();
    		prepareFFAPPercentageBreakDownList();
    		if(mapCoverage_PrecentageBreakDown.size() == 0){
    			addRow();
    		}
    	}
    	
    	if(ApexPages.currentPage().getParameters().containsKey('changeFor')){
            string changeFor = ApexPages.currentPage().getParameters().get('changeFor');
            if(changeFor == 'CMP'){
                isJPNChangeProcessForCMP = true;
            }else if(changeFor == 'Retirement_Primary'){
                isFASplitReadOnly  = true;
                currEmpId = jpnNumber.split('-')[0];
                if(!mapEmpIdEmpDetail.isEmpty() && mapEmpIdEmpDetail.containsKey(currEmpId))
                    mapEmpIdEmpDetail.get(currEmpId).empStatus = 'FFA';
            }else if(changeFor == 'Retirement_JPN'){
                isRetirementJPN = true;
                currEmpId = jpnNumber.split('-')[1];
                if(!mapEmpIdEmpDetail.isEmpty() && mapEmpIdEmpDetail.containsKey(currEmpId))
                    mapEmpIdEmpDetail.get(currEmpId).empStatus = 'FFA';
            }
        }
        
    	system.debug('mapCoverage_PrecentageBreakDown :'+ mapCoverage_PrecentageBreakDown);
    	
    	statusMsg = '';
    	statusMsgAdvisor = '';
    	deletedMarkedCoveragePeriod = '';
    	deletedEmpId = '';
    	
    	lstDelFAAccountDetail = new list<FA_Account_Association__c>();
    	
    	ffapMultiplier = 0;
    	curKey = '';
    }
    
    private void prepareEmpIdEmpDetailMap(){
    	mapEmpIdEmpDetail = new map<string, FFAP_AccountDetails>();
    	lstFAAccountDetail = new list<FFAP_AccountDetails>();
    	lstEmpIds = new list<string>();
        for(FA_Account_Association__c faAcc : FFAP_DataUtil.getFAAccAssociationOnJPN(faAccountId)){
    		if(FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.MODIFICATION_RECORDTYPE) == faAcc.FA_Account__r.JPN_Change__r.RecordTypeId){
    			isJPNChangeModificationProcess = true;
    		}
    		if(!mapEmpIdEmpDetail.containsKey(faAcc.Emp_Id__c)){
    			mapEmpIdEmpDetail.put(faAcc.Emp_Id__c, new FFAP_AccountDetails(faAcc, 0, null));
    			lstFAAccountDetail.add(new FFAP_AccountDetails(faAcc, 0, null));
    			lstEmpIds.add(faAcc.Emp_Id__c);
    			jpnNumber = faAcc.FA_Account__r.Name;
    		}
    	}
    	
    	if(currEmpId != null && mapEmpIdEmpDetail.containsKey(currEmpId)){
    	   mapEmpIdEmpDetail.get(currEmpId).empStatus = 'FFA';
    	}
    	
    	system.debug('lstFAAccountDetail: '+ lstFAAccountDetail);
    	
    }
 
    private void prepareFFAPPercentageBreakDownList(){
    	mapCoverage_PrecentageBreakDown = new map<string, FFAP_PercentageBreakdown>();
    	FFAP_PercentageBreakdown fapb; 
    	for(FA_Account_Production_Period_Association__c fa : FFAP_DataUtil.getFAAccProdPeriodAssociationOnJPN(faAccountId)){
    		system.debug('FA_Account_Production_Period_Association__c: '+ fa);
    		if(mapCoverage_PrecentageBreakDown.containsKey(fa.Production_Period__r.Coverage_Period_Temp__c)){
    			fapb = mapCoverage_PrecentageBreakDown.get(fa.Production_Period__r.Coverage_Period_Temp__c);
    			
    			if(fapb.faEmpIdDetail.containsKey(fa.FA_Account_Association__r.Emp_Id__c)){
	                FFAP_AccountDetails faAccDetail = new FFAP_AccountDetails(fa.FA_Account_Association__r, fa.FFAP_Split_Percent__c, fa);
	                fapb.faEmpIdDetail.put(fa.FA_Account_Association__r.Emp_Id__c, faAccDetail);
	            }
	        }else{
    			fapb = new FFAP_PercentageBreakdown();
    			populatePercentageBreakDownList(fa, fapb);
    			mapCoverage_PrecentageBreakDown.put(fa.Production_Period__r.Coverage_Period_Temp__c, fapb);
    		}
    	}
    	system.debug('mapCoverage_PrecentageBreakDown: '+ mapCoverage_PrecentageBreakDown);
    	
    	advisorRowSpan = mapEmpIdEmpDetail.size();
    }
    
    public void updateRetireeFFAPSplit(){
    	if(currEmpId == null){
    		return;
    	}
    	
    	if(curKey != null && ffapMultiplier != 0 && isRetirementJPN){
    		FFAP_PercentageBreakdown fapb = mapCoverage_PrecentageBreakDown.get(curKey);
    		FFAP_AccountDetails ffapAccDetail = fapb.faEmpIdDetail.get(currEmpId);
    	
    	    fapb.productionPeriod.Multiplier_Percent__c = ffapMultiplier;
            double faSplit =  roundDouble(ffapAccDetail.faAccAssociation.FA_Split_Percent__c, 2);
            double ffapSplit = roundDouble((faSplit * ffapMultiplier)/100, 2);
            ffapAccDetail.ffapSplitPercent = ffapSplit;
    	}
    }
    
    private Double roundDouble(Decimal value, Integer places){
    	Decimal power = 10;
    	power = power.pow(places);
		Decimal roundedValue = value * power;
		roundedValue = roundedValue.round();
		roundedValue = roundedValue / power;
		System.debug(roundedValue);
		return roundedValue;
    }
    
    public void populatePercentageBreakDownList(FA_Account_Production_Period_Association__c fa, FFAP_PercentageBreakdown fapb){
    	
        if(fa != null){
        	if(fa.Production_Period__r.End_Month__c.length() == 1)
        	   fa.Production_Period__r.End_Month__c = '0'+fa.Production_Period__r.End_Month__c;
        	if(fa.Production_Period__r.Start_Month__c.length() == 1)
               fa.Production_Period__r.Start_Month__c = '0'+fa.Production_Period__r.Start_Month__c;
            
            fapb.productionPeriod = fa.Production_Period__r;
            fapb.faEmpIdDetail.putAll(mapEmpIdEmpDetail);
            if(fapb.faEmpIdDetail.containsKey(fa.FA_Account_Association__r.Emp_Id__c)){
                FFAP_AccountDetails faAccDetail = new FFAP_AccountDetails(fa.FA_Account_Association__r, fa.FFAP_Split_Percent__c, fa);
                fapb.faEmpIdDetail.put(fa.FA_Account_Association__r.Emp_Id__c, faAccDetail);
            }
        }
        fapb.rowIndex = string.valueOf(mapCoverage_PrecentageBreakDown.size());
    }
    
    public void deleteRow(){
    	if(mapCoverage_PrecentageBreakDown.containsKey(deletedMarkedCoveragePeriod)){
    		if(mapCoverage_PrecentageBreakDown.get(deletedMarkedCoveragePeriod).productionPeriod.Id == null){
    			mapCoverage_PrecentageBreakDown.remove(deletedMarkedCoveragePeriod);
    		}else{
    	       mapCoverage_PrecentageBreakDown.get(deletedMarkedCoveragePeriod).isDeleted = true;
    		}	
    	}
    	
    }
    
    public void addRow(){
    	FFAP_PercentageBreakdown lastFAPB;
    	if(curKey != null && mapCoverage_PrecentageBreakDown.containsKey(curKey)){
            lastFAPB = mapCoverage_PrecentageBreakDown.get(curKey);
    	}
    	system.debug('lastFAPB: '+ lastFAPB);
    	string startMonth = '01';
    	string endMonth = '12';
    	integer startYear = Date.today().year();
    	integer endYear = Date.today().year();
    	
    	if(lastFAPB != null){
    		integer curEndMonth = 12;
    		integer curStartMonth = 1;
    		integer curStartYear = Date.today().year();
            integer curEndYear = Date.today().year();
            if(lastFAPB.ProductionPeriod.End_Month__c != null){
    	       endMonth = lastFAPB.ProductionPeriod.End_Month__c;
    	       curEndMonth = Integer.valueof(lastFAPB.ProductionPeriod.End_Month__c);
    	       if(curEndMonth < 10)
    	           endMonth = '0'+ curEndMonth;
            }
            if(lastFAPB.ProductionPeriod.Start_Month__c != null){
                curEndMonth = integer.valueOf(lastFAPB.ProductionPeriod.End_Month__c);
            	curStartMonth = integer.valueOf(lastFAPB.ProductionPeriod.Start_Month__c);
            	
            	if(curEndMonth < 12){
            		startMonth = string.valueOf(curEndMonth + 1);
            		if(curEndMonth < 10)
            		  startMonth = '0'+ string.valueOf(curEndMonth + 1); 
            	}
            }
            if(lastFAPB.ProductionPeriod.End_Year__c != null){
                curEndYear = Integer.valueof(lastFAPB.ProductionPeriod.End_Year__c);
                endYear = curEndYear + 1;
            }
            if(lastFAPB.ProductionPeriod.Start_Year__c != null){
            	curStartYear = Integer.valueof(lastFAPB.ProductionPeriod.Start_Year__c);
            	if(curEndMonth < 12){
            		if(curStartYear == curEndYear)
                        startYear = curStartYear;
                    else
                        startYear = curEndYear; 
                }else{
                	startYear = curEndYear + 1;
                }
            }
            
            
    	}
    	
    	
    	FFAP_PercentageBreakdown newFAPB = new FFAP_PercentageBreakdown();
    	//newFAPB.rowIndex = string.valueOf(mapCoverage_PrecentageBreakDown.size()) + 1;
    	newFAPB.rowIndex = string.valueOf(startYear)+'/'+string.valueOf(startMonth)+ ' - '+ string.valueOf(endYear)+ '/' + string.valueOf(endMonth);
        newFAPB.faEmpIdDetail = new map<string, FFAP_AccountDetails>();
        newFAPB.productionPeriod = new Production_Period__c(RecordTypeId = getProdPrdRecordType('Standard'), 
                                                            Start_Month__c = string.valueOf(startMonth),
                                                            Start_Year__c = string.valueOf(startYear),
                                                            End_Month__c = string.valueOf(endMonth),
                                                            End_Year__c = string.valueOf(endYear));
        if(isJPNChangeProcessForCMP){
            newFAPB.productionPeriod = new Production_Period__c(RecordTypeId = getProdPrdRecordType('JPN CMP Change'), 
                                                            Start_Month__c = string.valueOf(startMonth),
                                                            Start_Year__c = string.valueOf(startYear),
                                                            End_Month__c = string.valueOf(endMonth),
                                                            End_Year__c = string.valueOf(endYear));	
        }
        
        newFAPB.isDeleted = false;
        
        for(string strKey : mapEmpIdEmpDetail.keySet()){
        	FA_Account_Association__c fa = mapEmpIdEmpDetail.get(strKey).faAccAssociation;
        	decimal faSplit = mapEmpIdEmpDetail.get(strKey).faAccAssociation.FA_Split_Percent__c;
        	FFAP_AccountDetails ffapAcc = new FFAP_AccountDetails(
        	                                       new FA_Account_Association__c(id = fa.Id, 
                                                                               Emp_Id__c = strKey, 
                                                                               FA_Account__c = faAccountId, 
                                                                               FA_Split_Percent__c = fa.FA_Split_Percent__c)
                                                   , 0
                                                   , null);
        	newFAPB.faEmpIdDetail.put(strKey, ffapAcc);
        }
        
        mapCoverage_PrecentageBreakDown.put('N' + newFAPB.rowIndex, newFAPB);
    }
    
    public void deleteAdvisor(){
    	integer counter =0;
        for(FFAP_AccountDetails ffapAccDetail : lstFAAccountDetail){
            if(ffapAccDetail.empId == deletedEmpId){
                ffapAccDetail.isDeleted = true;
                if(ffapAccDetail.faAccAssociation.Id != null)
                    lstDelFAAccountDetail.add(ffapAccDetail.faAccAssociation);
                break;
            }
            counter++;
        }
        if(counter < lstFAAccountDetail.size())
            lstFAAccountDetail.remove(counter);
    }
    
    public void addAdvisorRow(){
    	//new FA_Account_Association__c instance with dummy empId
    	lstFAAccountDetail.add(new FFAP_AccountDetails(new FA_Account_Association__c(Emp_Id__c = string.valueOf(lstFAAccountDetail.size()), 
    	                                                   FA_Account__c = faAccountId,
    	                                                   FA_Split_Percent__c = 0), 
    	                           0, 
    	                           null));
    }
    
    
    public void saveAdvisor(){
    	set<id> empRecordIds = new set<Id>();
        boolean isError = false;
    	list<FA_Account_Association__c> lstFAAccAssociationDelete = new list<FA_Account_Association__c>();
    	list<FA_Account_Association__c> lstFAAccAssociationUpsert = new list<FA_Account_Association__c>();
    	
    	for(FFAP_AccountDetails ffapAccDetail: lstFAAccountDetail){
    		if(!empRecordIds.contains(ffapAccDetail.faAccAssociation.Financial_Advisor__c) && !ffapAccDetail.isDeleted)
                empRecordIds.add(ffapAccDetail.faAccAssociation.Financial_Advisor__c);
            else if(!ffapAccDetail.isDeleted){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Manage Advisor Error: Finacial Advisor is already exist for this JPN Number.'));
                isError = true;
                break;
            }
    	}
    	
    	map<id, Employee__c> empBatch = new map<id, Employee__c>(FFAP_DataUtil.getEmployeeDetailsOnId(empRecordIds));
    	
    	for(FFAP_AccountDetails ffapAccDetail: lstFAAccountDetail){
    		if(!(ffapAccDetail.faAccAssociation.Id != null && ffapAccDetail.isDeleted)){
            	if(ffapAccDetail.faAccAssociation.Id == null){
            	   if(empBatch.get(ffapAccDetail.faAccAssociation.Financial_Advisor__c).Status__c != 'Active'){
            	   	   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, empBatch.get(ffapAccDetail.faAccAssociation.Financial_Advisor__c).Name + ': '+ System.Label.FFAP_Terminated_FA));
            	   	   isError = true;
            	   }	
            	   ffapAccDetail.faAccAssociation.Is_New_Advisor__c = true;
            	   ffapAccDetail.faAccAssociation.Previous_FA_Split_Percent__c = ffapAccDetail.faAccAssociation.FA_Split_Percent__c;
            	}
    			lstFAAccAssociationUpsert.add(ffapAccDetail.faAccAssociation);
    		}
    	}
    	if(lstFAAccAssociationUpsert.size() < 2 && !isError){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Manage Advisor Error: Atleast two finacial advisors are required.'));
            isError = true;
    	}
    	statusMsg = '';
    	statusMsgAdvisor = '';
    	if(isError)
    	   return;
    	
    	system.debug('lstFAAccAssociationUpsert: '+ lstFAAccAssociationUpsert);
    	Savepoint sp = database.setSavepoint();
    	try{
    	   delete lstDelFAAccountDetail;
    	   lstDelFAAccountDetail.clear();
    	   JPNChangeProcess(lstFAAccAssociationUpsert);
    	   upsert lstFAAccAssociationUpsert;
    	   
    	}catch(Exception ex){
    		exceptionHandler('Manage Advisor Error: ' + ex.getMessage(), sp, isError);
    		return;
    	}
    	
    	list<FA_Account_Production_Period_Association__c> lstFAPPA = new list<FA_Account_Production_Period_Association__c>();
    	for( FFAP_PercentageBreakdown ffap: mapCoverage_PrecentageBreakDown.values()){
    		if(ffap.productionPeriod != null && ffap.productionPeriod.Id != null){
	    		for(FA_Account_Association__c fa : lstFAAccAssociationUpsert){
	    			if(string.valueOf(fa.Emp_Id__c).length() < 4){
	    				if(isJPNChangeProcessForCMP){
	    				   lstFAPPA.add(new FA_Account_Production_Period_Association__c(FA_Account_Association__c = fa.Id,
	    				                                                              Production_Period__c = ffap.productionPeriod.Id,
	    				                                                              FFAP_Split_Percent__c = 0,
	    				                                                              RecordTypeId = getFAAccountProdPrdAssociationRecordType('JPN CMP Change')));
	    				}else{
	    					lstFAPPA.add(new FA_Account_Production_Period_Association__c(FA_Account_Association__c = fa.Id,
                                                                                      Production_Period__c = ffap.productionPeriod.Id,
                                                                                      FFAP_Split_Percent__c = 0,
                                                                                      RecordTypeId = getFAAccountProdPrdAssociationRecordType('Standard')));
	    				}
	    			}
	    		}
    		}
    	}
    	
    	try{
           if(lstFAPPA.size() > 0) upsert lstFAPPA;
        }catch(Exception ex){
        	exceptionHandler('Manage Advisor Error: ' + ex.getMessage(), sp, isError);
            return;
        }
    	
    	prepareEmpIdEmpDetailMap();
        prepareFFAPPercentageBreakDownList();
        if(mapCoverage_PrecentageBreakDown.size() == 0){
            addRow();
        }
        if(!isError)
            statusMsgAdvisor = 'Advisor details saved.';
    }
    
    public void cancelAddAdvisor(){
    	prepareEmpIdEmpDetailMap();
    }
    
    
    
    public void saveDetails(){
    	list<Production_Period__c> lstProdPrdToUpsert = new list<Production_Period__c>();
    	list<Production_Period__c> lstProdPrdToDelete = new list<Production_Period__c>();
    	map<string, FA_Account_Association__c> mapFAAccAssociation = new map<string, FA_Account_Association__c>();
    	list<FA_Account_Production_Period_Association__c> lstFAAccProdAssociation = new list<FA_Account_Production_Period_Association__c>();
    	
    	if(mapCoverage_PrecentageBreakDown.size() == 0){
    		statusMsg = 'No records to save.';
    		return;
    	}
    	
    	for(string coverage : mapCoverage_PrecentageBreakDown.keySet()){
    		if(mapCoverage_PrecentageBreakDown.get(coverage).isDeleted){
    		  lstProdPrdToDelete.add(mapCoverage_PrecentageBreakDown.get(coverage).productionPeriod);
    		}else{
    			Production_Period__c prodPrd = mapCoverage_PrecentageBreakDown.get(coverage).productionPeriod;
    			if(isJPNChangeProcessForCMP){
    				prodPrd.RecordTypeId = getProdPrdRecordType('JPN CMP Change');
    			}else{
    				prodPrd.RecordTypeId = getProdPrdRecordType('Standard');
    			}
    			lstProdPrdToUpsert.add(mapCoverage_PrecentageBreakDown.get(coverage).productionPeriod);
    		}
    		for(string empId : mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.keySet()){
    			if(!mapFAAccAssociation.containsKey(empId)){
    				FFAP_AccountDetails ffapAccDetail = mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.get(empId);
    				if(!ffapAccDetail.isDeleted){
    					mapFAAccAssociation.put(empId, ffapAccDetail.faAccAssociation);
    				}
    			}
    		}
    	}
        
        //JPNChangeProcess(mapFAAccAssociation);
        
    	Savepoint sp = Database.setSavepoint();
    	statusMsg = '';
    	statusMsgAdvisor = '';
        boolean isError = false;
    	try{
    		system.debug('Production Period Delete: '+ lstProdPrdToDelete);
    		system.debug('Production Period Insert: '+ lstProdPrdToUpsert);
    		system.debug('FA_Account_Association__c : '+ mapFAAccAssociation.values());
    		if(lstProdPrdToDelete.size() > 0)delete lstProdPrdToDelete;
    		if(lstProdPrdToUpsert.size() > 0)upsert lstProdPrdToUpsert;
    		if(mapFAAccAssociation.size() > 0)upsert mapFAAccAssociation.values();    		
        }
    	catch(Exception ex){
    		exceptionHandler('Percenatge Breakdown Error: ' + ex.getMessage(), sp, isError);
    	}
    	for(string coverage : mapCoverage_PrecentageBreakDown.keySet()){
    		Id productionPrdId;
    		if(!mapCoverage_PrecentageBreakDown.get(coverage).isDeleted){
    			productionPrdId = mapCoverage_PrecentageBreakDown.get(coverage).productionPeriod.Id;
    		}
    		else{
    			continue;
    		}
    		system.debug('mapCoverage_PrecentageBreakDown: '+ mapCoverage_PrecentageBreakDown);
    		for(string empId : mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.keySet()){
    			FFAP_AccountDetails ffapAccDetail = mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.get(empId);
                FA_Account_Association__c faAccAssociation = mapFAAccAssociation.get(empId);
                FA_Account_Production_Period_Association__c fappa = ffapAccDetail.faProdPeriodAssociation;
                fappa.FA_Account_Association__c = faAccAssociation.Id;
                fappa.Production_Period__c = productionPrdId;
                fappa.FFAP_Split_Percent__c = ffapAccDetail.ffapSplitPercent;
                //fappa.Id = ffapAccDetail.faProdPeriodAssociationId;
                if(isJPNChangeModificationProcess && fappa.Prv_FFAP_Split_Percent__c != null && fappa.FFAP_Split_Percent__c <> fappa.Prv_FFAP_Split_Percent__c){
                	faAccAssociation.Is_FA_Split_Modified__c = true;
                }
                fappa.Remaining_Split_Percent_For_Active_FA__c = 0;
                fappa.RecordTypeId = isJPNChangeProcessForCMP? getFAAccountProdPrdAssociationRecordType('JPN CMP Change') : getFAAccountProdPrdAssociationRecordType('Standard');
                for(string empId_Temp : mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.keySet()){
                	if(empId != empId_Temp){
                		system.debug('fappa.Remaining_Split_Percent_For_Active_FA__c:' + fappa.Remaining_Split_Percent_For_Active_FA__c);
                		//system.debug('accDetail.ffapSplitPercent: '+ accDetail.ffapSplitPercent+ ' for empId: '+ empId_Temp);
                	   FFAP_AccountDetails accDetail = mapCoverage_PrecentageBreakDown.get(coverage).faEmpIdDetail.get(empId_Temp);
                	   if(ffapAccDetail.empStatus == 'Active'){
                	       fappa.Remaining_Split_Percent_For_Active_FA__c = fappa.Remaining_Split_Percent_For_Active_FA__c + accDetail.ffapSplitPercent; 
                	       system.debug('accDetail.ffapSplitPercent: '+ accDetail.ffapSplitPercent+ ' for empId: '+ empId_Temp);
                	   }
                	}
                }
                
                lstFAAccProdAssociation.add(fappa);
            }
    	}
    	
    	try{
    		system.debug('Production Period with Account Association : '+ lstFAAccProdAssociation);
    		if(lstFAAccProdAssociation.size() > 0)upsert lstFAAccProdAssociation;
    		if(mapFAAccAssociation.size() > 0)upsert mapFAAccAssociation.values();
    	}
    	catch(exception ex){
    		exceptionHandler('Percenatge Breakdown Error: ' + ex.getMessage(), sp, isError);
    	}
    	if(!isError){
    		prepareEmpIdEmpDetailMap();
            prepareFFAPPercentageBreakDownList();
            statusMsg = 'Percentage Breakdown details saved.';
    	}
    }
    
    public void saveAndReturn(){
    	saveDetails();
    }
    
    public void JPNChangeProcess(list<FA_Account_Association__c> lstFAAccAssociation){
    	if(changeRequestor != null && changeRequestor != ''){
    		for(FA_Account_Association__c fac : lstFAAccAssociation){
    			if(fac.Emp_Id__c != changeRequestor){
	    			if(fac.Previous_FA_Split_Percent__c != fac.FA_Split_Percent__c){
	    				fac.Is_FA_Split_Modified__c = true;
	    			}
    			}
    		}
    	}
    }
    
    public string getFAAccountProdPrdAssociationRecordType(string recordTypeName){
        Map<String, Schema.RecordTypeInfo> recordTypes = FA_Account_Production_Period_Association__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        return recordTypes.get(recordTypeName).getRecordTypeId();
    }
    
    public string getProdPrdRecordType(string recordTypeName){
        Map<String, Schema.RecordTypeInfo> recordTypes = Production_Period__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        return recordTypes.get(recordTypeName).getRecordTypeId();
    }
    
    public void exceptionHandler(string errMsg, Savepoint sp, boolean isError){
    	database.rollback(sp);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
        isError = true;
    }
    
    public class FFAP_PercentageBreakdown{
    	public map<string, FFAP_AccountDetails> faEmpIdDetail {get;set;}
    	public Production_Period__c productionPeriod {get;set;}
    	public string rowIndex {get;set;}
        public boolean isDeleted {get;set;}
    	
    	public FFAP_PercentageBreakdown(){
    	    faEmpIdDetail = new map<string, FFAP_AccountDetails>();
            productionPeriod = new Production_Period__c();
            isDeleted = false;
    	}
    }
    
    public class FFAP_AccountDetails{
    	public string faProdPeriodAssociationId {get;set;}
        public string empId {get;set;}
        public string empName {get;set;}
        public decimal ffapSplitPercent {get;set;}
        public FA_Account_Association__c faAccAssociation {get;set;}
        public boolean isDeleted {get;set;}
        public string empStatus {get;set;}
        public boolean isNew {get;set;}
        public string empRecordId {get;set;}
        private FA_Account_Production_Period_Association__c faProdPeriodAssociation;
        
        public FFAP_AccountDetails(FA_Account_Association__c fa, decimal ffapSplitPercent, FA_Account_Production_Period_Association__c faAccProdPrddAssociation){
        	if(faAccProdPrddAssociation != null){
        	   faProdPeriodAssociationId = faAccProdPrddAssociation.Id;
        	   faProdPeriodAssociation = faAccProdPrddAssociation;
        	}
            else{
               faProdPeriodAssociationId = null;
               faProdPeriodAssociation = new FA_Account_Production_Period_Association__c();
            }
            empId = fa.Emp_Id__c;
            empName = fa.Financial_Advisor__r.First_Name__c + ' ' + fa.Financial_Advisor__r.Last_Name__c;
            empStatus = fa.Financial_Advisor__r.Status__c;
            empRecordId = fa.Financial_Advisor__c; 
            this.ffapSplitPercent = ffapSplitPercent;
            faAccAssociation = fa;
            isDeleted = false;
            isNew = false;
        }
    }
}