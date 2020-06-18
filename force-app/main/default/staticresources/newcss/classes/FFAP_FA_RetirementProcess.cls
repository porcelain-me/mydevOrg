public without sharing class FFAP_FA_RetirementProcess {
    public Id faAgreementId{get; set;}  
    public FA_Account_Association__c faAccountAssociationTemp{get;set;}
    public Employee__c employee{get;set;}
    public FFAP_Agreement__c faAgreement{get;set;}
    public List<FAAccountAssociationsWrapper> faAccountAssociationList{get;set;}
    public List<FAAccountAssociationsWrapper> faAccountAssociationJPNList{get;set;}
    public string fa_Name {get;set;}
    public boolean isSaved{get;set;}
    private String empId;
    private Double tenure;  
    private Integer lastCounter;
    
    public boolean showFATable{get{
           if(faAccountAssociationList != null){
               return !faAccountAssociationList.isEmpty();
           }
           return false;
        }set;}
    public boolean showJpnTable{get{
           if(faAccountAssociationJPNList != null){
               return !faAccountAssociationJPNList.isEmpty();
           }
           return false;
        }set;}
    
    public Boolean showTabs{get; set;}  
    private Id agreementRecordTypeId;
    public String jpnToDelete{get;set;}
    
    //Constructor
    public FFAP_FA_RetirementProcess(ApexPages.StandardController stdController){
        this.showTabs = true;
        if(ApexPages.currentPage().getParameters().get('faaId') != NULL){
            faAgreementId = ApexPages.currentPage().getParameters().get('faaId');
        }
        if(ApexPages.currentPage().getParameters().get('empId') != NULL){
            empId = ApexPages.currentPage().getParameters().get('empId');
        }
        for(FFAP_Agreement__c faAgreementTemp : FFAP_DataUtil.getAgreementDetailsOnAgreementIds(new set<Id>{faAgreementId})){
            faAgreement = faAgreementTemp;
            break;
        }
        if(faAgreement == null){
            logError('No Agreement record found.');
            this.showTabs = false;
            return;
        }
        employee = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);      
        if(employee == null){
            logError(System.Label.FFAP_Employee_Not_Found);
            this.showTabs = false;
            return;
        }
        fa_Name = employee.Name;
        this.tenure = 0;
        if(employee.DOH_Recent__c == null){
            logError(System.Label.FFAP_Date_of_Hiring_is_null);
            this.showTabs = false;          
            return;
        }else{
          getYear(employee.DOH_Recent__c);
        }       
        this.agreementRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE);        
        faAccountAssociationTemp = new FA_Account_Association__c();
        this.showFATable = false;
        this.isSaved = false;   
        this.lastCounter = 0;
        populateFFALists();
    }   
    
     private Double getYear(Date dohDate){
        Integer months = dohDate.monthsBetween(System.TODAY()); 
        Double year = months / 12.0 ;
        this.tenure =  year;
        return year;
    }
    
    private void logError(String error){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
    }    
    
    public void addFA(){
        if(faAccountAssociationTemp.Financial_Advisor__c != null){
            if(faAccountAssociationTemp.Financial_Advisor__c == employee.Id){               
                logError(System.Label.FFAP_Retiring_FA);
                return;
            }
            for(Employee__c emp : FFAP_DataUtil.getEmployeeDetailsOnId(new Set<Id>{faAccountAssociationTemp.Financial_Advisor__c})){
                if(emp.Status__c != 'Active'){
                    logError(System.Label.FFAP_Terminated_FA);
                    return;
                }
                faAccountAssociationList.add(new FAAccountAssociationsWrapper(new FA_Account_Association__c(Financial_Advisor__c = emp.Id, FA_Split_Percent__c = 0), lastCounter + 1));
            }
            faAccountAssociationTemp.Financial_Advisor__c = null;
        }
        save();
    }
    
    private void save(){
        if(faAccountAssociationList.isEmpty()){         
            logError(System.Label.FFAP_NoFAforsave);
            return;
        }
        FA_Account__c faAccount;
        List<FA_Account__c> faAccList = new List<FA_Account__c>();
        for(FAAccountAssociationsWrapper faWrapper : faAccountAssociationList){       
          if(faWrapper.faAccountAssociation.Id == null){
              faAccList.add(new FA_Account__c(Type__c = FFAP_DataUtil.FA_JPN_TYPE, Name = empId + '-' + faWrapper.counter, RecordTypeId = agreementRecordTypeId, 
                              Retirement_Months__c = '60'));
          }
        }       
        if(!faAccList.isEmpty()){
          insert faAccList;
        }
        
        Map<String, FA_Account__c> faAccountMap = new Map<String, FA_Account__c>();
        for(FA_Account__c faTemp : faAccList){
            faAccountMap.put(faTemp.Name, faTemp);
        }
        FA_Account_Association__c faOrig;
        FA_Account_Association__c faNew;
        List<FA_Account_Association__c> insertFAAccountAssociations = new List<FA_Account_Association__c>();
        for(FAAccountAssociationsWrapper faWrapper : faAccountAssociationList){
            if(faWrapper.faAccountAssociation.Id == null){
                faOrig = new FA_Account_Association__c(FFAP_Agreement__c = faAgreementId, Financial_Advisor__c = employee.Id, FA_Split_Percent__c = 100 - faWrapper.faAccountAssociation.FA_Split_Percent__c);
                faOrig.Emp_Id__c = employee.Emp_Id__c;
                faOrig.Advisor_Number__c = employee.Financial_Advisor_Number__c;
                faNew = faWrapper.faAccountAssociation; 
                if(faAccountMap.containsKey(empId + '-' + faWrapper.counter)){
                 faOrig.FA_Account__c = faAccountMap.get(empId + '-' + faWrapper.counter).Id;
                 faNew.FA_Account__c = faAccountMap.get(empId + '-' + faWrapper.counter).Id;
                }
                insertFAAccountAssociations.add(faOrig);
                insertFAAccountAssociations.add(faNew);
            }
        }
        if(!insertFAAccountAssociations.isEmpty()){
            insert insertFAAccountAssociations;
            insertPPARecords(insertFAAccountAssociations);
        }
        /*FFAP_Agreement__c agreement = new FFAP_Agreement__c(Id = faAgreementId, FFAP_Retirement_Status__c = FFAP_DataUtil.RETIRED_STATUS);
        update agreement;*/
        populateFFALists();     
        isSaved = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, System.Label.FFAP_FA_Added_Successfully));
    }
    
    private void insertPPARecords(List<FA_Account_Association__c> insertFAAccountAssociations){
        List<FFAP_Default_Multiplier__c> splitPerList = FFAP_DataUtil.getDefaultSplits();
        List<FAPerBreakdownWrapper> faPBList = new List<FAPerBreakdownWrapper>();
        List<Production_Period__c> faPBListForInsert;
        FAPerBreakdownWrapper faPBwrapper;
        String nextYear = NULL;
        Double multiplierPer = 0.0;
        Production_Period__c tempFAPB = new Production_Period__c(Start_Month__c = '01', Start_Year__c = System.Today().year() + 1 + '');
        for(FFAP_Default_Multiplier__c split : splitPerList){
            if(this.tenure < 20){
                multiplierPer = split.Multiplier_1__c;
            }else if(this.tenure >= 20){
                multiplierPer = split.Multiplier_2__c;
            }
            if(nextYear != NULL){
              faPBwrapper = new FAPerBreakdownWrapper(multiplierPer, nextYear, tempFAPB.Start_Month__c);
            }else{
              faPBwrapper = new FAPerBreakdownWrapper(multiplierPer, tempFAPB.Start_Year__c, tempFAPB.Start_Month__c);             
            }
            faPBList.add(faPBwrapper);
            nextYear = faPBwrapper.nextYear;
        }
        splitPerList.clear();
        faPBListForInsert = createFAPBRecords(faPBList);
        
        if(!faPBListForInsert.isEmpty()){
            insert faPBListForInsert;
            List<FA_Account_Production_Period_Association__c> faPPAList = new List<FA_Account_Production_Period_Association__c>();
            FA_Account_Production_Period_Association__c tempfaPPA;
            for(Production_Period__c pp : faPBListForInsert){
                for(FA_Account_Association__c fa : insertFAAccountAssociations){
                    if(this.employee.Id == fa.Financial_Advisor__c){
                        tempfaPPA = new FA_Account_Production_Period_Association__c(FA_Account_Association__c = fa.Id, Production_Period__c= pp.Id, Split_Percent_Calculation_Type__c= 'Manual');
                        tempfaPPA.FFAP_Split_Percent__c = pp.Multiplier_Percent__c;
                        tempfaPPA.Remaining_Split_Percent_For_Active_FA__c = 100 - pp.Multiplier_Percent__c;
                    }else{
                        tempfaPPA = new FA_Account_Production_Period_Association__c(FA_Account_Association__c = fa.Id, Production_Period__c= pp.Id, Split_Percent_Calculation_Type__c= 'Manual');
                        tempfaPPA.FFAP_Split_Percent__c = 100 - pp.Multiplier_Percent__c;
                        tempfaPPA.Remaining_Split_Percent_For_Active_FA__c = pp.Multiplier_Percent__c;
                    }
                    faPPAList.add(tempfaPPA);
                }
            } 
            if(!faPPAList.isEmpty()){
                insert faPPAList;
            }
        }        
    }
    
    private List<Production_Period__c> createFAPBRecords(List<FAPerBreakdownWrapper> faPBWrapperList){
        List<Production_Period__c> faPBList = new List<Production_Period__c>();
        Production_Period__c faPP;
        for(FAPerBreakdownWrapper faPB : faPBWrapperList){
            faPP = new Production_Period__c(Multiplier_Percent__c = faPB.multiplierPer);
            faPP.Start_Year__c = faPB.startYear;
            faPP.Start_Month__c = faPB.startMonth;
            faPP.End_Year__c = faPB.endYear;
            faPP.End_Month__c = faPB.endMonth;
            faPBList.add(faPP);
        }
        return faPBList;
    }
    
    public void deleteTempJpn(){        
        delete new FA_Account__c(Id = jpnToDelete);
        jpnToDelete = null;      
        populateFFALists();
    }
    
    public void saveJPN(){      
        saveFAAccounts(faAccountAssociationJPNList);
    }
    
    public void savePrimary(){
        saveFAAccounts(faAccountAssociationList);
    } 
    
    private void saveFAAccounts(List<FAAccountAssociationsWrapper> faaList){
        List<FA_Account__c> faList = new List<FA_Account__c>();
        Set<Id> faIdSet = new Set<Id>();
        for(FAAccountAssociationsWrapper faWrapper : faaList){
            if(!faIdSet.contains(faWrapper.faAccountAssociation.FA_Account__c)){
              faList.add(faWrapper.faAccountAssociation.FA_Account__r);
              faIdSet.add(faWrapper.faAccountAssociation.FA_Account__c);
            }
        }        
        //to update agreement for enhanced JPN option
        if(!faList.isEmpty()){
            boolean isallJPNEnhanced = true;
            boolean isOneJPNEnhanced = false;
            String enhancedJPNs = '';
            for(FA_Account__c fa : faList){
                if(fa.Include_in_Agreement__c == false){
                    continue;
                }
                if(isOneJPNEnhanced == false && fa.IsEnhancedOption__c == true){
                    isOneJPNEnhanced = true;
                }
                if(fa.IsEnhancedOption__c == false){
                    isallJPNEnhanced = false;
                }
                if(fa.IsEnhancedOption__c == true){
                    enhancedJPNs += fa.Old_FA_Account__r.Name + ',';
                }
            }
            if(isOneJPNEnhanced == true && faAgreement.JPNEnhancedGridRate__c == null){
                logError('Grid Rate is mandatory.');
                return;
            }
            if(enhancedJPNs != ''){
                enhancedJPNs = enhancedJPNs.subString(0, enhancedJPNs.length() - 1);
            }
            faAgreement.Conga_Enhanced_JPNs__c = enhancedJPNs;
            faAgreement.Conga_IsAllJPN_Enhanced__c = false;
            faAgreement.Conga_IsJPNIndividual_Options__c = false;
            faAgreement.Conga_IsSomeJPN_Enhanced__c = false;            
            if(faAccountAssociationList.isEmpty()){
                if(isOneJPNEnhanced == true && isallJPNEnhanced == true){
                    faAgreement.Conga_IsAllJPN_Enhanced__c = true;
                }else if(isallJPNEnhanced == false){
                    faAgreement.Conga_IsJPNIndividual_Options__c = true;
                }
            }else{
                faAgreement.Conga_IsSomeJPN_Enhanced__c = true;
            }
            update faAgreement;
           update faList;
        }
        populateFFALists();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, System.Label.FFAP_FA_Updated));  
    }
    
    public void populateFFALists(){
        this.faAccountAssociationList = new List<FAAccountAssociationsWrapper>();
        this.faAccountAssociationJPNList = new List<FAAccountAssociationsWrapper>();
        Set<Id> recordIds = new Set<Id>();
        Map<Id, String> jpnIdToNameMap = new Map<Id, String>();            
        for(FA_Account_Association__c faTemp : FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(empId, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.AGREEMENT_RECORDTYPE)){            
            jpnIdToNameMap.put(faTemp.FA_Account__c, faTemp.FA_Account__r.Name);
        }
        System.debug(jpnIdToNameMap.keySet());
        System.debug(jpnIdToNameMap);
        Integer counter = 0;
        Set<String> primaryTempJPNSet = new Set<String>();
        if(!jpnIdToNameMap.isEmpty()){
            for(FA_Account_Association__c faTemp : FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(jpnIdToNameMap.keySet())){                
                System.debug(faTemp);
                if(faTemp.Financial_Advisor__c != employee.Id){
                    if(faTemp.FA_Account__r.Name.startsWithIgnoreCase(empId + '-')){
                        if(!primaryTempJPNSet.contains(faTemp.FA_Account__r.Name)){
                            primaryTempJPNSet.add(faTemp.FA_Account__r.Name);
                            counter = Integer.valueof(faTemp.FA_Account__r.Name.replace(empId + '-', ''));
                            faAccountAssociationList.add(new FAAccountAssociationsWrapper(faTemp, counter));
                        }
                    }
                }else{
                    if(faTemp.FA_Account__r.Name.endsWithIgnoreCase('-' + empId)){
                        faAccountAssociationJPNList.add(new FAAccountAssociationsWrapper(faTemp, faAccountAssociationJPNList.size() + 1));
                    }
                }
            }
        }
        lastCounter = counter;            
    }
    
    public void switchTab(){        
        ApexPages.getMessages().clear();
    }
    
    public class FAAccountAssociationsWrapper{
        public FA_Account_Association__c faAccountAssociation{get;set;}
        public Integer counter{get; set;}       
        public FAAccountAssociationsWrapper(FA_Account_Association__c faAccountAssociation, Integer counter){
            this.faAccountAssociation = faAccountAssociation;
            this.counter = counter;
        }       
    }
    
    public class FAPerBreakdownWrapper{
        public Double multiplierPer{get; set;}
        public String startYear{get; set;}
        public String startMonth{get; set;}
        public String endYear{get; set;}
        public String endMonth{get; set;}
        public String nextYear{get; set;}
        public FAPerBreakdownWrapper(Double multiplierPer, String year, String month){
            this.multiplierPer = multiplierPer;
            this.startYear = year;
            this.startMonth = month;
            this.endYear = year;
            this.endMonth = month;
            setEndValues();
        }
        private void setEndValues(){            
            try{
                Integer month = Integer.valueof(this.startMonth);
                Integer year = Integer.valueof(this.startYear);
                if(month - 1 > 0){
                    if(month - 1 > 9){
                        this.endMonth = String.valueOf(month - 1);
                    }else{
                        this.endMonth = '0'+String.valueOf(month - 1);
                    }
                    this.endYear = String.valueOf(year + 1);
                }else{
                    this.endMonth = '12';
                    this.endYear = String.valueOf(year);
                }
                this.nextYear = String.valueOf(year + 1);
            }catch(Exception ex){                
            }  
        }         
    }    
}