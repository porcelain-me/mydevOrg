public without sharing class FFAP_Conga_Redirector {
    public String packageType{get;set;}
    String empId;
    private Id agreementId;
    private Id jpnChangeId;
    public Id sourceId{get;set;}
    public boolean isCompleted{get;set;}
    public boolean isGenerated{get;set;}
    public boolean isError{get;set;}
    public boolean isStart{get;set;}
    public string successMsg{get;set;}

    public string commitmentEnvId {get;set;}
    List<FFAP_Document_Recipient__c> listDocRecipientToInsert;
    public set<string> ristrictedState;
    set<String> setDocumentNames = new set<String>();   
    map<String, primaryJPNAccountsForEmp> mapEmpIdAccounts = new map<String, primaryJPNAccountsForEmp>();
    /**/
    String accountIdsForConga = '';
    String primaryAccountIdsForConga = '';
    String jpnAccountIdsForConga = '';
    /**/
    FFAP_Agreement__c agreement;
    Employee__c emp;
    Integer totalTimeToCheckStatus;
    public Integer statusCheckInterval{get;set;}
    Integer documentCount{
        get{
            if(setDocumentNames != null){
                return setDocumentNames.size();
            }
            return 0;
        }
    } 
     
    list<FA_Account__c> lstFAAccount;
    
    
    
    
    //Constructor
    public FFAP_Conga_Redirector(){
    
        packageType = ApexPages.currentPage().getParameters().get('packageType');
        if(ApexPages.currentPage().getParameters().get('agreementId') != null){
            agreementId = (Id)ApexPages.currentPage().getParameters().get('agreementId');
            sourceId = agreementId;
        }else if(ApexPages.currentPage().getParameters().get('jpnChangeId') != null){
            jpnChangeId = (Id)ApexPages.currentPage().getParameters().get('jpnChangeId');
            sourceId = jpnChangeId;
        }
        if(ApexPages.currentPage().getParameters().get('empId') != null){
          empId = ApexPages.currentPage().getParameters().get('empId');
        }
        isCompleted = false;
        isError = false;
        isStart = false;
        isGenerated = false;
        successMsg = '';
        ristrictedState = new set<string>();
        Conga_General_Settings__c congaSetting = Conga_General_Settings__c.getInstance();
        accountIdsForConga = '';
        totalTimeToCheckStatus = 10;
        statusCheckInterval = 5;
        if(congaSetting <> null && congaSetting.Name <> null){
        //if(congaSetting <> null){
            if(congaSetting.Conga_Max_Response_Time__c <> null){
                totalTimeToCheckStatus = Integer.valueOf(congaSetting.Conga_Max_Response_Time__c);
            }
            if(congaSetting.Conga_Status_Check_Interval__c <> null){
                statusCheckInterval = Integer.valueOf(congaSetting.Conga_Status_Check_Interval__c);
            }
            totalTimeToCheckStatus -= statusCheckInterval;
        }
    }
    
    public pageReference goToSigning(){
            
        If (!isError){
            
            String url;
            
            /* on complete go to complete page */
            
            String retUrl = System.Label.DG_BaseUrl + '/apex/FFAP_DocSigner_Complete';
         
            if (commitmentEnvId != null){
                DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(commitmentEnvId,retUrl);
                url = g.getDocusignURLForSigning();
            }
            else  //default return url is in system label
                url = System.Label.DG_EmbeddedSigningReturnUrl;
            system.debug('URL is' + url);
            
            /* route the user to the document */
            PageReference page = new PageReference(url);
            page.setRedirect(true);
            return page;
        }
        else
            return null;
        
             
    }
         
    
    public void generateDocuments(){
        isCompleted = false;
        isError = false;
        isStart = false;
        successMsg = '';        
        if(packageType == FFAP_Datautil.COMMITMENT){
            
            generateDocumentForCommitment();
        }
        else if(packageType == FFAP_Datautil.RETIREMENT || packageType == FFAP_Datautil.DECEASED){
            system.debug('********** in retirement **********************');
            generateDocumentForRetirementPackage();
        }else if(packageType == FFAP_Datautil.MODIFICATION){
            generateDocumentForModification();
        }
        if(!isError && !isCompleted){
            isStart = true;
        }
    }
    
    /************************************************************************
    * MRM - 4/29/14 This class causes the conga document to be created
    *               The conga document will be used in the envelope
    * MRM - 6/27/14 Removed need for this
    *
    *********************   ****************************************************/
    public void generateCongaTemplates(){
        
        /* get conga to generate a template; template id, query id, doc name */
        
        system.debug('********************* workflow started:' + system.now());
        
    }   
    
    public void generateDocumentsOld(){
        system.debug('********** in retirement **********************');
        isCompleted = false;
        isError = false;
        isStart = false;
        successMsg = '';        
        if(packageType == FFAP_Datautil.COMMITMENT){
            generateDocumentForCommitmentOld();
        }else if(packageType == FFAP_Datautil.RETIREMENT || packageType == FFAP_Datautil.DECEASED){
            generateDocumentForRetirementPackage();
        }else if(packageType == FFAP_Datautil.MODIFICATION){
            generateDocumentForModification();
        }
        if(!isError && !isCompleted){
            isStart = true;
        } 
          
    }
    
    public void generateDocumentForCommitment(){        
        
        /* get the user msid*/
        User u = [select Emp_Id__c from user where id = :UserInfo.getUserId()];
        
        /* find the employee id for example 59XYZ */
        Employee__c e = [select emp_id__c from employee__c where Emp_ID__c = :  u.emp_id__c];
       
        /* if commitment agreement already exists take them back to it for signature
           or review
        */
        FFAP_DocusignAPI_AutoUtilities utilities = new FFAP_DocusignAPI_AutoUtilities(e.emp_id__c);
        string resultString = utilities.sentCommitmentAgreementForSignature(e.emp_id__c);
        /* MRM 12/29/14 dealing with declined */
        if(resultString == FFAP_DataUtil.SUCCESS || resultString == 'Previously Declined'){
            commitmentEnvId = utilities.embeddedEnvId;
            isCompleted = true;
            successMsg =  'Click continue to review and sign.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,successMsg));
        }else{ 
            if (resultString.contains('Commitment Agreement is already created')){
                isGenerated = true;
                commitmentEnvId = utilities.embeddedEnvId;
                successMsg =  'Commitment agreement previously requested. Click review to review/sign.';
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,successMsg));
            }
            else{
                List<String> errors = resultString.split('\n');
                logErrors(errors);
                for (String err:errors)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err));
            }
        }
        
    }
    
    public pageReference goToEmbeddedSigning_ForPreviousCommitment(){
        
        User u = [select  Emp_id__c  from User where id = :UserInfo.getUserId()];
        
        /* find the employee id for example 59XYZ */
        Employee__c e = [select emp_id__c from employee__c where emp_id__c = :  u.emp_id__c];
       
        List<FFAP_Agreement__c> aList = FFAP_DataUtil.getAgreementDetailsOnAdvisorId(e.emp_id__c);
        
        if (aList.size() > 0){
            commitmentEnvId = aList[0].Commitment_Agreement_Envelope_Id__c; 
            
        }
        
        return goToEmbeddedSigning_Commitment();
            
    }
    
    public pageReference goToEmbeddedSigning_Commitment(){

        String retUrl = 'http://fap';
        String url;
        
        if (commitmentEnvId != null){
            DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(commitmentEnvId,retUrl);
            url = g.getDocusignURLForSigning();
        }
        else  //default return url is in system label
            url = System.Label.DG_EmbeddedSigningReturnUrl;
            /* route the user to the document */
            
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    
    }
            
    private void generateDocumentForCommitmentOld(){    
        
        
    }
      
    private void generateDocumentForModification(){        
        string resultString;
        FFAP_Modification_Conga_Redirector utilities = new FFAP_Modification_Conga_Redirector(jpnChangeId);
        resultString = utilities.generateDocumentForModification();
        if(resultString == FFAP_DataUtil.SUCCESS){
            setDocumentNames = utilities.setDocumentNames;
        }else{
            isError = true;          
        }
    }
    
    private void generateDocumentForRetirementPackage(){
       
        string packageType_Temp = packageType;
        
        listDocRecipientToInsert = new list<FFAP_Document_Recipient__c>();
        emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);
        
        if(!validatePackage()){
            return;
        }
        
        if(emp.FFAP_Is_PWA__c && packageType == FFAP_Datautil.RETIREMENT){
            packageType_Temp = 'PWA'+packageType;
        }else if(emp.FFAP_Is_FA__c && packageType == FFAP_Datautil.RETIREMENT){
            packageType_Temp = 'FA'+packageType;
        }
        
        String generatedDocumentName = '';
        List<FFAP_CongaDetail__c> listCongaDetails = new List<FFAP_CongaDetail__c>();
        List<FA_Account_Association__c> listFAAccountAssociationForActiveFAs = getListOfActiveFA();
        
        map<id, Employee__c> faEmpIds = new map<id, Employee__c>();
        
        primaryJPNAccountsForEmp empAccounts;
        for(FA_Account_Association__c accAss : listFAAccountAssociationForActiveFAs){
            if(!mapEmpIdAccounts.containsKey(accAss.Emp_Id__c)){
                mapEmpIdAccounts.put(accAss.Emp_Id__c, new primaryJPNAccountsForEmp());
            }
            
            empAccounts = mapEmpIdAccounts.get(accAss.Emp_Id__c); 
            if(accAss.FA_Account__r.Name.startsWithIgnoreCase(empId + '-')){
                if(empAccounts.primaryAccountIds == ''){
                    empAccounts.primaryAccountIds = '\''+ accAss.FA_Account__c + '\'';
                }else{
                    empAccounts.primaryAccountIds += '|\''+ accAss.FA_Account__c + '\'';
                }
            }else if(accAss.FA_Account__r.Name.endsWithIgnoreCase('-' + empId)){
                if(accAss.FA_Account__r.Include_In_Agreement__c == true){
                    if(empAccounts.jpnAccountIds == ''){
                       empAccounts.jpnAccountIds = '\''+ accAss.FA_Account__c + '\'';
                    }else{
                       empAccounts.jpnAccountIds += '|\''+ accAss.FA_Account__c + '\'';
                    }                   
                }
            }   
            
            
            if(!faEmpIds.containsKey(accAss.Financial_Advisor__c)){
                faEmpIds.put(accAss.Financial_Advisor__c, accAss.Financial_Advisor__r);
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
        
        Set<String> statevalues = new Set<String>();
        String empJobState = null;
        String empState = null;        
        if(ApexPages.currentPage().getParameters().get('state') != null){
            List<String> states = ApexPages.currentPage().getParameters().get('state').split(',');
            if(states.size() > 0){
                empState = states.get(0);
            }
            if(states.size() > 1){
                empJobState = states.get(1);
            }
            statevalues.addAll(states); 
        }
        boolean sentToRetiree = false;
        for(FFAP_Conga_Template_Mapping__c mapping : FFAP_DataUtil.getFFAPCongaTemplateMappingOnPackageType(packageType_Temp)){
                generatedDocumentName = packageType_Temp + '_' + mapping.Name.replace(' ', '+') + '_' + empId;
                FFAP_CongaDetail__c congaDetail;
                if(Mapping.send_to_Active_FAs__c){                    
                    for(Employee__c empTemp : faEmpIds.values()){
                        logErrors(FFAP_CongaManager.validateEmployee(empTemp, 'Active FA', false));                                               
                        if(empTemp.Financial_Advisor_Number__c == null || empTemp.Financial_Advisor_Number__c == ''){
                            logError('Financial Advisor Number for Active FA '+ '(' + empTemp.Name + ' - ' + empTemp.Emp_Id__c + ')' + ' is not available');
                        }
                        branchManager = branchManagerRecords.get(empTemp.Conga_Branch_Manager__c);
                        if(branchManager == null){
                            logError('Branch Manager not found for Active FA ' + '(' + empTemp.Name + ' - ' + empTemp.Emp_Id__c + ')');
                        }else{
                            logErrors(FFAP_CongaManager.validateEmployee(branchManager, 'Branch Manager', false));
                        }
                        if(!isError){
                            //setProcessedFAIds.add(empTemp.Id);
                            generatedDocumentName = packageType_Temp + '_' + mapping.Name.replace(' ', '+') + '_' + empId + '_' + empTemp.Emp_Id__c;
                            listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, empTemp.Emp_Id__c, mapping));
                            // add to set of doc names
                            setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
                            createDocumentRecipientRecords(agreementId, empTemp, packageType, mapping, generatedDocumentName.replace('+', ' '));
                        }
                    }                    
                }else if(mapping.Send_To_States__c == 'all'){
                    
                    listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, empId, mapping));
                    // add to set of doc names
                    setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
                    createDocumentRecipientRecords(agreementId, emp, packageType, mapping, generatedDocumentName.replace('+', ' '));
                }else if((mapping.Send_To_States__c != null && 
                            ((empJobState <> null && empJobState <> '' && mapping.Send_To_States__c.contains(empJobState)) || 
                                (empState <> null && empState <> '' && mapping.Send_To_States__c.contains(empState))))){
                    sentToRetiree = true;
                    listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, empId, mapping));
                    // add to set of doc names
                    setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
                    createDocumentRecipientRecords(agreementId, emp, packageType, mapping, generatedDocumentName.replace('+', ' '));
                }else if(!sentToRetiree && mapping.Send_To_States__c == null){
                    listCongaDetails.add(createCongaDetailRecord(generatedDocumentName, empId, mapping));
                    // add to set of doc names
                    setDocumentNames.add(generatedDocumentName.replace('+', ' ') + '.doc');
                    createDocumentRecipientRecords(agreementId, emp, packageType, mapping, generatedDocumentName.replace('+', ' '));
                }                                              
        
        }
        
        agreement.Conga_State_Clause__c = '';
        agreement.Conga_HR_Name__c = Userinfo.getName();
 
        
        system.debug('=========' + statevalues);      
        for(State_Clause__c clause : FFAP_DataUtil.getStateClauseOnName(statevalues)){
            agreement.Conga_State_Clause__c +=  clause.FFAP_State_Clause__c;
            agreement.Conga_California_Specific_Clause__c = clause.FFAP_Clause_For_California__c;                   
        }
        if(isError){
            return;
        }
        
        try{
            if(packageType == FFAP_Datautil.DECEASED){
                agreement.Is_Deceased_Agreement_Generated__c = true;
            }else if(packageType == FFAP_Datautil.RETIREMENT){
                agreement.Is_Retirement_Agreement_Generated__c = true;
            }
            updateAgreementForProductionMonth(agreement);
            update agreement;
            system.debug('RA_Agreement: '+ agreement);
        }catch(exception ex){
            logError(ex.getMessage());
            system.debug(ex.getMessage());
            return;
        }
        
        if(!listCongaDetails.isEmpty()){
            boolean isCongaDetailInsert = false;
            try{
                insert listCongaDetails;
                isCongaDetailInsert = true;
                if(!listDocRecipientToInsert.isEmpty()){
                    insert listDocRecipientToInsert;
                }
                if(!lstFAAccount.isEmpty()) {
                    update lstFaAccount;
                }
            }catch(exception ex){
                logError(ex.getMessage());              
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PackageType + ' Package Documents are not available.'));
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
    
    // method to check status of document generation
    public void checkDocumentGenerationStatus(){
        totalTimeToCheckStatus -= statusCheckInterval;
        system.debug('8888888888' + setDocumentNames);
        Id parentId = (packageType == FFAP_Datautil.RETIREMENT || packageType == FFAP_Datautil.DECEASED) ? agreement.Id : jpnChangeId;
        
        Integer generatedDocCount = FFAP_DataUtil.getAttachmentCountOnParentIdAndDocName(parentId, setDocumentNames);
        if(generatedDocCount == documentCount){
            isCompleted = true;
            isStart = false;
            successMsg =  packageType+' Package documents created successfully.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,successMsg));
        }else if(totalTimeToCheckStatus <= 0){
            try{
                isError = true;
                isStart = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,generatedDocCount + ' of ' + documentCount + ' documents generated. There may be some delay in the process. Please check the Notes And Attachment Section after sometime. If still any document is missing, please contact system administrator.'));
                if(generatedDocCount <= 0){
                    if(packageType == FFAP_Datautil.RETIREMENT){
                        agreement.Is_Retirement_Agreement_Generated__c = false;
                        update agreement;
                        system.debug('in retirement');
                    }else if(packageType == FFAP_Datautil.DECEASED){
                        agreement.Is_Deceased_Agreement_Generated__c = false;
                        update agreement;
                    }else if(packageType == FFAP_DataUtil.MODIFICATION){
                        JPN_Change__c jpnChange = new JPN_Change__c(id=jpnChangeId, Is_Documents_Package_Generated__c = false);
                        update jpnChange;
                    }
                    
                }
            }catch(exception ex){               
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                //system.debug('in exception');
                //system.debug(ex.getMessage());
            }
        }
    }
    
    private void updateAgreementForProductionMonth(FFAP_Agreement__c agreemnt){
        
    }
    
    class primaryJPNAccountsForEmp{
        String primaryAccountIds{get;set;}
        String jpnAccountIds{get;set;}
        String empId{get;set;}
        
        primaryJPNAccountsForEmp(){
            primaryAccountIds = '';
            jpnAccountIds = '';
            empId = '';
        }
        
        primaryJPNAccountsForEmp(String primaryAccountIds, String jpnAccountIds, String empId){
            this.primaryAccountIds = primaryAccountIds;
            this.jpnAccountIds = jpnAccountIds;
            this.empId = empId;
        }
    }
    
    private boolean validatePackage(){
        logErrors(FFAP_CongaManager.validateEmployee(emp, 'Employee', false));        
        list<FFAP_Agreement__c> lstAgreement = FFAP_DataUtil.getAgreementDetailsOnAgreementId(agreementId);
        if(lstAgreement.size() > 0){
            agreement = lstAgreement[0];
        }else{          
            logError('Agreement does not exist');
            return false;
        }
        
        if(packageType == FFAP_Datautil.RETIREMENT && agreement.Is_Retirement_Agreement_Generated__c){          
            logError('Retirement Agreement is already generated.');
        }
        if(packageType == FFAP_Datautil.DECEASED && agreement.Is_Deceased_Agreement_Generated__c){          
            logError('Deceased Agreement is already generated.');
        }        
        
        employee__c tempEmp = emp <> null ? FFAP_CongaManager.returnCongaActiveManagerForCurrentEmployee(emp) : null;
        if(tempEmp == null){
            logError('Active Manager is not available for FA' + '(' + emp.Name + ' - ' + emp.Emp_Id__c + ').');
            return false;
        }
        agreement.Conga_Active_Manager__c = tempEmp.Id;
        agreement.Conga_Active_Manager__r = tempEmp;
        Id rdId =  agreement.Employee__r.Override_Regional_Director__c <> null ? agreement.Employee__r.Override_Regional_Director__c : agreement.Employee__r.Regional_Director__c;
        if(agreement.Conga_Active_Manager__c == Null || rdId == null){              
            logError('Employee\'s Branch Manager or Regional Director are not available.');
        }
        logErrors(FFAP_CongaManager.validateEmployee(agreement.Conga_Active_Manager__r, 'Branch Manager', false));         
        if(agreement.Employee__r.Override_Regional_Director__c <> null){
           logErrors(FFAP_CongaManager.validateEmployee(agreement.Employee__r.Override_Regional_Director__r, 'Regional Director', false));
        }
        if(agreement.Employee__r.Override_Regional_Director__c == null){
            logErrors(FFAP_CongaManager.validateEmployee(agreement.Employee__r.Regional_Director__r, 'Regional Director', false));
        }
        if(agreement.Conga_Active_Manager__r.Work_Phone__c == null || agreement.Conga_Active_Manager__r.Work_Phone__c == ''){
            logError('Phone Number for Manager ' + agreement.Conga_Active_Manager__r.Name + ' is not available');
        }
        if(agreement.Start_Date__c == null){
            logError('Agreement Start Date is not populated');
        }
        if(agreement.Termination_Date__c == null){
            logError('Termination Date is not populated');
        }
        if(agreement.Executers__c == null && packageType == FFAP_Datautil.DECEASED){
            logError('Executers are not populated');
        }
        
        if(isError){
            return false;
        }        
        return true;
    }
    
    private list<FA_Account_Association__c> getListOfActiveFA(){
        set<id> setAccountIds = new set<Id>();
        set<id> setAccountAssociationIds = new set<Id>();
        Integer counter = 0;
        lstFAAccount = new list<FA_Account__c>();
        for(FA_Account_Association__c accAss : FFAP_DataUtil.getFAAccAssociationOnAgreement(agreement.Employee__c)){
            system.debug('--------' + accAss.FA_Account__r.Name);
            lstFAAccount.Add(FFAP_CongaManager.createHTMLGrid(accAss.FA_Account__c, agreement.Employee__c));
            setAccountIds.Add(accAss.FA_Account__c);
            setAccountAssociationIds.Add(accAss.Id);
            system.debug('--------' + accAss.FA_Account__r.Name);
            system.debug('--------' + empId);
            if(accAss.FA_Account__r.Name.startsWithIgnoreCase(empId + '-')){
                if(primaryAccountIdsForConga == ''){
                    primaryAccountIdsForConga = '\''+ accAss.FA_Account__c + '\'';
                }
                if(accountIdsForConga == ''){
                    accountIdsForConga = '\''+ accAss.FA_Account__c + '\'';
                }else{
                   accountIdsForConga += '|\''+ accAss.FA_Account__c + '\'';
                }
            }else if(accAss.FA_Account__r.Name.endsWithIgnoreCase('-' + empId)){
                if(accAss.FA_Account__r.Include_In_Agreement__c == true){
                    if(jpnAccountIdsForConga == ''){
                       jpnAccountIdsForConga = '\''+ accAss.FA_Account__c + '\'';
                    }else{
                       jpnAccountIdsForConga += '|\''+ accAss.FA_Account__c + '\'';
                    }                   
                }
            }       
        }
        mapEmpIdAccounts.put(empId, new primaryJPNAccountsForEmp(primaryAccountIdsForConga, jpnAccountIdsForConga, empId));
        if(jpnAccountIdsForConga != ''){
            if(accountIdsForConga == ''){
                accountIdsForConga = jpnAccountIdsForConga;
            }else{
               accountIdsForConga += '|'+ jpnAccountIdsForConga;
            }
        }
        getMaxMinProdPrdForAgreement(setAccountAssociationIds);
        system.debug('---SET ACCOUNT IDS----' + setAccountIds);
        system.debug('-------' + accountIdsForConga);
        return FFAP_DataUtil.getFAAccAssociationOnFAAccNotInAgreementId(agreementId, setAccountIds);
    }
    
    private FFAP_CongaDetail__c createCongaDetailRecord(string generatedName, string empId, FFAP_Conga_Template_Mapping__c mapping){
        FFAP_CongaDetail__c congaDetail = new FFAP_CongaDetail__c();
        congaDetail.FFAP_Agreement__c = agreementId;
        if(mapping.Query_Id__c <> null){
            String tempQuery = mapping.Query_Id__c.replaceAll('#empId#', empId).replace('#accountIds#', accountIdsForConga);
            if(mapEmpIdAccounts.containsKey(empId)){
                if(mapEmpIdAccounts.get(empId).primaryAccountIds != null){
                    tempQuery = tempQuery.replace('#primaryAccountIds#', mapEmpIdAccounts.get(empId).primaryAccountIds);
                }else{
                    tempQuery = tempQuery.replace('#primaryAccountIds#', '');
                }
                if(mapEmpIdAccounts.get(empId).jpnAccountIds != null){
                    tempQuery = tempQuery.replace('#jpnAccountIds#', mapEmpIdAccounts.get(empId).jpnAccountIds);
                }else{
                    tempQuery = tempQuery.replace('#jpnAccountIds#','');
                }
            }else{
                tempQuery = tempQuery.replace('#primaryAccountIds#', '').replace('#jpnAccountIds#', '');
            }
            
            if(tempQuery.length() > 255){
                congaDetail.Param_QueryId__c = tempQuery.substring(0,250);
                congaDetail.Param_QueryId_1__c = tempQuery.substring(250,tempQuery.length());
            }else{
                congaDetail.Param_QueryId__c = tempQuery;
            }
        }
        system.debug('====' + congaDetail);
        congaDetail.Param_TemplateId__c = mapping.template_Id__c;
        congaDetail.Document_Name__c = generatedName;
        return congaDetail;
    }
    private void createDocumentRecipientRecords(String agreementId, Employee__c emp, String packageType, FFAP_Conga_Template_Mapping__c mapping, String generatedDocumentName){     
        Integer signingOrder = 1;
        generatedDocumentName = generatedDocumentName + '.doc';
                
        if(mapping.Send_To_FA__c || mapping.Send_To_PWA__c || mapping.send_To_Active_FAs__c){           
            listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, emp.Id, generatedDocumentName));
            SigningOrder++;
        }
        if(mapping.Send_To_Branch_Manager__c){
            if(mapping.send_To_Active_FAs__c && emp.Conga_Branch_Manager__c <> null){              
                listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, emp.Conga_Branch_Manager__c, generatedDocumentName));
                SigningOrder++;
            }else if(agreement.Conga_Active_Manager__c <> null){                
                listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, agreement.Conga_Active_Manager__c, generatedDocumentName));
                SigningOrder++;
            }
        }
        
        if(mapping.Is_Exhibit_section__c){
            if(mapping.Send_To_FA__c || mapping.Send_To_PWA__c){
                listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, emp.Id, generatedDocumentName));
                SigningOrder++;
                if(mapping.Send_To_Branch_Manager__c && agreement.Conga_Active_Manager__c <> null){
                    listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, agreement.Conga_Active_Manager__c, generatedDocumentName));
                    SigningOrder++;
                }
            }           
        }
        if(mapping.Send_To_Regional_Director__c){
            Id rdId = agreement.Employee__r.Override_Regional_Director__c <> null ? agreement.Employee__r.Override_Regional_Director__c : agreement.Employee__r.Regional_Director__c;
            if(rdId != null){                
                listDocRecipientToInsert.add(FFAP_CongaManager.returnDocuRecipient(agreementId, packageType, SigningOrder, rdId, generatedDocumentName));
                SigningOrder++;
            }           
        }
    }
    private void getMaxMinProdPrdForAgreement(set<id> setAccountAssociationIds){
        integer counter = 1;
        datetime endDate;
        datetime  startDate;
        set<string> setFA = new set<string>();
        system.debug('RA_AccountAssosciationId: '+ setAccountAssociationIds);
        for(FA_Account_Production_Period_Association__c fa : FFAP_DataUtil.getMinMaxProdPrdForEmp(setAccountAssociationIds)){
            if(fa.Production_Period__c == null){
                continue;
            }
            if(counter == 1){
                startDate = datetime.newinstance(Integer.valueOf(fa.Production_Period__r.Start_Year__c), Integer.valueOf(fa.Production_Period__r.Start_Month__c), 01);
            }
            counter++;
            datetime tempEndDate = datetime.newinstance(Integer.valueOf(fa.Production_Period__r.End_Year__c), Integer.valueOf(fa.Production_Period__r.End_Month__c), 01);
            
            if(!setFA.isEmpty() && !setFA.contains(fa.FA_Account_Association__r.FA_Account__r.Name)){
                if(tempEndDate != endDate){
                    endDate = null;
                    break;
                }
            }
            endDate = datetime.newinstance(Integer.valueOf(fa.Production_Period__r.End_Year__c), Integer.valueOf(fa.Production_Period__r.End_Month__c), 01);
            setFA.add(fa.FA_Account_Association__r.FA_Account__r.Name);
            
        }
        
        if(startDate != null){
            agreement.Conga_First_Production_Period__c = startDate.format('MMMM, yyyy');
        }
        if(endDate != null){
            agreement.Conga_Last_Production_Period__c = endDate.format('MMMM, yyyy');
        }
    }
    
}