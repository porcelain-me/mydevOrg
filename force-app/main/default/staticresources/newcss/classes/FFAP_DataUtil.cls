/*
// 09/27/2013: RA: Created for FFAP APP
// 10/15/2013 : MG : Added a new mwthod getFAAccAssociationListonOnAdvisorIds()
*/   
public without sharing class FFAP_DataUtil {
    //---- Constants -----
    public static final string FA_Primary_TYPE = 'Primary';
    public static final string FA_JPN_TYPE = 'JPN';
    public static final string FA_OTHER_TYPE = 'Other';
    public static final string ACTIVE_RECORDTYPE = 'Active';
    public static final string INACTIVE_RECORDTYPE = 'In Active';
    public static final string AGREEMENT_RECORDTYPE = 'Agreement';
    public static final string RETIRED_STATUS = 'Retired';
    public static final string SUCCESS = 'Success';
    public static final String RETIREMENT = 'Retirement';
    public static final String DECEASED = 'Deceased';
    public static final String COMMITMENT = 'Commitment';
    public static final String MODIFICATION = 'Modification';
    public static final String EMAIL_SUBJECT_START = 'Create Agreement-';
    public static final string NEW_JPN_RECORDTYPE = 'New JPN';
    public static final string MODIFICATION_RECORDTYPE = 'Modification';
    public static final string JPN_CHANGE_RECORDTYPE = 'JPN Change';
    public static Map<String, Schema.RecordTypeInfo> faRecordTypes = FA_Account__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    public static Map<String, Schema.RecordTypeInfo> jpnChangeRecordTypes = JPN_Change__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    //---- Methods -----
    //Employee Queries
    public static Employee__c getEmployeeDetailsOnEmpId(String empId){
        List<Employee__c> listEmp = [SELECT Id, First_Name__c, Last_Name__c, Name, Emp_Id__c, DOH_Recent__c, FFAP_Is_PWA__c, FFAP_Is_FA__c, Override_Branch_Manager__c,
                                        Manager__c, Complex_Manager__c, Regional_Director__c, Status__c, Financial_Advisor_Number__c,
                                        Override_Regional_Director__c, Job_State_Job__c, State_Home_Dsc_Home__c, State_Home__c, Email__c, DocuSign_GUID__c
                                     FROM Employee__c 
                                     WHERE Emp_Id__c = :empId];
        if(!listEmp.isEmpty()){
            return listEmp[0];
        }
        return null;
    }
    
    public static Employee__c getEmployeeDetailsOnId(Id empId){
        List<Employee__c> listEmp = [SELECT Id, First_Name__c, Last_Name__c, Name, Emp_Id__c, DOH_Recent__c, FFAP_Is_PWA__c, FFAP_Is_FA__c, Override_Branch_Manager__c,
                                        Manager__c, Complex_Manager__c, Regional_Director__c, Status__c, Financial_Advisor_Number__c, Override_Regional_Director__r.Status__c,
                                        Override_Regional_Director__c, Job_State_Job__c, State_Home_Dsc_Home__c, State_Home__c, Email__c, Regional_Director__r.Email__c,
                                        Override_Regional_Director__r.Email__c, DocuSign_GUID__c, Override_Regional_Director__r.Name, Work_Phone__c, 
                                        Regional_Director__r.Name, Regional_Director__r.Status__c, Override_Regional_Director__r.Emp_Id__c, Regional_Director__r.Emp_Id__c
                                     FROM Employee__c 
                                     WHERE Id = :empId];
        if(!listEmp.isEmpty()){
            return listEmp[0];
        }
        return null;
    }
    
    public static List<Employee__c> getEmployeesOnEmpId(Set<String> empIds){
        List<Employee__c> listEmp = [SELECT Id, First_Name__c, Last_Name__c, Name, Emp_Id__c, DOH_Recent__c, Financial_Advisor_Number__c FROM Employee__c WHERE Emp_Id__c IN :empIds];
        return listEmp;
    }
    
    public static list<Employee__c> getEmployeeDetailsOnId(Set<Id> empRecordIds){
        return [SELECT Id, Name, First_Name__c, Last_Name__c, Emp_Id__c, Email__c, DOH_Recent__c, Status__c, DocuSign_GUID__c, Work_Phone__c
                    FROM Employee__c 
                    WHERE Id IN :empRecordIds];
    }
    
    //RecordType logic
    public static Id getFAAccountRecordTypeId(String recordTypeName){
        return faRecordTypes.get(recordTypeName).getRecordTypeId();
    }
    
    //RecordType logic
    public static Id getJPNChangeRecordTypeId(String recordTypeName){
        return jpnChangeRecordTypes.get(recordTypeName).getRecordTypeId();
    }
    
    //FFAP Agreement
    public static list<FFAP_Agreement__c> getAgreementDetailsOnAgreementIds(set<Id> agreementIds){
        return [Select Employee__c, Emp_Id__c, JPNEnhancedGridRate__c from FFAP_Agreement__c where Id IN : agreementIds];
    }
    
    public static map<Id,FFAP_Agreement__c> getAgreementDetailsOnEmpRecordId(set<String> empIds){
        map<Id, FFAP_Agreement__c> mapEmpIdAgreement = new map<Id, FFAP_Agreement__c>();
        for(FFAP_Agreement__c faAgreement : [Select Employee__c, Emp_Id__c from FFAP_Agreement__c where Employee__c IN : empIds]){
            mapEmpIdAgreement.put(faAgreement.Employee__c, faAgreement);
        }
        return mapEmpIdAgreement;
    }
    
    public static list<FFAP_Agreement__c> getFFAPAgreementOnEmpRecordIds(set<String> empIds){
        return getAgreementDetailsOnEmpRecordId(empIds).values();
    }
    
    public static list<FFAP_Agreement__c> getAgreementDetailsOnAdvisorId(String empId){
        return [Select Employee__c, Employee__r.Name, Employee__r.Email__c, Employee__r.Status__c, Name, 
                        Emp_Id__c, commitment_status__c ,Start_Date__c, Is_Commitment_Agreement_Generated__c, Commitment_Agreement_Envelope_Id__c
                from FFAP_Agreement__c where Emp_Id__c = : empId];
    }
    
    public static list<FFAP_Agreement__c> getAgreementDetailsOnAgreementId(Id agreementId){
        return [SELECT Id, Emp_Id__c, Is_Commitment_Agreement_Generated__c, Is_Commitment_Agreement_Signed__c, Conga_Active_Manager__c, Conga_Active_Manager__r.Email__c, 
                        Employee__r.Email__c, Employee__r.Override_Regional_Director__c,Employee__r.Override_Regional_Director__r.Email__c, Employee__r.Regional_Director__c, 
                        Employee__r.Regional_Director__r.Email__c, Is_Retirement_Agreement_Generated__c, Is_Deceased_Agreement_Generated__c, Employee__r.Regional_Director__r.Id,
                        Production_Month_60__c, Production_Month_Less_60__c, Employee__r.Regional_Director__r.Name,  Employee__r.Name, Employee__r.Emp_Id__c,
                        Employee__r.Override_Regional_Director__r.Name, Employee__r.Regional_Director__r.Emp_Id__c,
                        Employee__r.Override_Regional_Director__r.Emp_Id__c, CONGA_LOS__c, Start_Date__c , Conga_Manager_Phone__c, Executers__c,
                        Employee__r.Regional_Director__r.Status__c, Employee__r.Override_Regional_Director__r.Status__c, Employee__r.Status__c, Termination_Date__c, 
                        Conga_Production_Months__c, Conga_First_Production_Period__c, Conga_Last_Production_Period__c, 
                        Conga_IsJPNIndividual_Options__c, Conga_IsSomeJPN_Enhanced__c, Conga_Enhanced_JPNs__c, Conga_IsAllJPN_Enhanced__c 
                FROM FFAP_Agreement__c 
                WHERE Id = :agreementId];
    }
    
    //FA Account Association    
    public static list<FA_Account_Association__c> getFAAccAssociationListonOnEmpId(String emp_Id){
        return [SELECT Id, Advisor_Number__c, Emp_Id__c, FA_Account__c, FA_Split_Percent__c, FA_Account__r.Type__c, FA_Account__r.Name, FA_Account__r.InActive__c, 
                          FA_Account__r.RecordTypeId, FA_Account__r.RecordType.Name, FA_Account__r.Temp_FA_Account__c, FA_Account__r.Temp_FA_Account__r.Name
                        FROM FA_Account_Association__c
                        WHERE Emp_Id__c = :emp_Id];
    }   
    
    public static list<FA_Account_Association__c> getFAAccAssociationListOnEmpIdAccType(String emp_Id, String faType, String recordTypeName){
        return [SELECT Id, Advisor_Number__c, Emp_Id__c, FA_Account__c, FA_Split_Percent__c, FA_Account__r.Type__c, FA_Account__r.Name, FA_Account__r.InActive__c, 
                    FA_Account__r.RecordTypeId, FA_Account__r.RecordType.Name, FA_Account__r.Temp_FA_Account__c, FA_Account__r.Temp_FA_Account__r.Name,
                    Financial_Advisor__c, FFAP_Agreement__c, FA_Account__r.Retirement_Months__c
                    FROM FA_Account_Association__c
                    WHERE Emp_Id__c = :emp_Id 
                    AND FA_Account__r.Type__c = :faType 
                    AND FA_Account__r.RecordTypeId = :getFAAccountRecordTypeId(recordTypeName)];        
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationListOnFAAccountId(set<Id> faAccounts){
        return [SELECT Id, Advisor_Number__c, Emp_Id__c, FA_Account__c, FA_Split_Percent__c, FA_Account__r.Type__c, FA_Account__r.Name, FA_Account__r.InActive__c, 
                    Financial_Advisor__c, FFAP_Agreement__c, FA_Account__r.Include_in_Agreement__c, FA_Account__r.JPN_Change__c, FA_Account__r.Old_FA_Account__r.Name,
                    FA_Account__r.Is_Request_to_Create_New_JPN__c, FA_Account__r.Retirement_Months__c, Financial_Advisor__r.Status__c, Financial_Advisor__r.Name,
                    FA_Account__r.RecordTypeId, FA_Account__r.IsEnhancedOption__c
                    FROM FA_Account_Association__c
                    WHERE FA_Account__c IN :faAccounts
                    order BY CreatedDate];        
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationOnJPN(Id faAccountId){
        return [select Id, Emp_Id__c, Financial_Advisor__r.First_Name__c, Financial_Advisor__r.Last_Name__c, Financial_Advisor__r.Status__c,
                    Financial_Advisor__r.Financial_Advisor_Number__c, FA_Account__c, FFAP_Agreement__c, FA_Split_Percent__c, FA_Account__r.Name, FA_Account__r.JPN_Change__c,
                    FA_Account__r.JPN_Change__r.JPN_Change_Requestor__c, Is_FA_Split_Modified__c, Previous_FA_Split_Percent__c,
                    Agreement_Signed_Date__c, FA_Account__r.JPN_Change__r.RecordTypeId, FA_Account__r.JPN_Change__r.Advisor_Type__c,
                    Is_New_Advisor__c
                from FA_Account_Association__c
                where FA_Account__c = : faAccountId
                order by createdDate];
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationListOnFAAccountIds(Set<Id> faIdExists){
        return [SELECT Id, Emp_Id__c, Financial_Advisor__c, FA_Account__c, FA_Account__r.Name 
                                                               FROM FA_Account_Association__c WHERE FA_Account__c IN :faIdExists];
    } 
    
    public static list<FA_Account_Association__c> getFAAccAssociationListOnId(Set<Id> recordIds, Id advisorId){
        return [SELECT Id, FA_Account__r.Name, Advisor_Number__c, Financial_Advisor__c 
                  FROM FA_Account_Association__c 
                  WHERE Id in : recordIds 
                  AND Financial_Advisor__c != :advisorId];      
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationListonOnAdvisorIds(set<String> advisorIds){
        return [Select Id, Financial_Advisor__c 
                from FA_Account_Association__c 
                where Financial_Advisor__c in : advisorIds 
                and FFAP_Agreement__c = null];
    }
    
    public static list<FA_Account_Association__c> getJPNFAAccAssociationOnEmpIds(list<string> empIds){
        return [select Id, Emp_Id__c, Financial_Advisor__c, FA_Account__c, FFAP_Agreement__c, FA_Split_Percent__c, FA_Account__r.Name, 
                        FA_Account__r.id, FA_Account__r.InActive__c, FA_Account__r.Include_in_Agreement__c,
                        FA_Account__r.Is_Request_to_Create_New_JPN__c, FA_Account__r.Type__c, FA_Account__r.RecordTypeId,
                        FA_Account__r.JPN_Change__c
                from FA_Account_Association__c
                where FA_Account__r.Type__c = 'JPN'
                    and Emp_Id__c in : empIds
                order by FA_Account__r.Name, Emp_Id__c];
    }
    
    public static list<FA_Account_Association__c> getJPNFAAccAssociationOnEmpIdsForJPNChange(list<string> empIds, string jpnChangeRecordId){
        return [select Id, Emp_Id__c, Financial_Advisor__c, FA_Account__c, FFAP_Agreement__c, FA_Split_Percent__c, FA_Account__r.Name, 
                        FA_Account__r.id, FA_Account__r.InActive__c, FA_Account__r.Include_in_Agreement__c,
                        FA_Account__r.Is_Request_to_Create_New_JPN__c, FA_Account__r.Type__c, FA_Account__r.RecordTypeId,
                        FA_Account__r.JPN_Change__c
                from FA_Account_Association__c
                where FA_Account__r.Type__c = 'JPN'
                    and FA_Account__r.JPN_Change__c = :jpnChangeRecordId
                    and Emp_Id__c in : empIds
                order by FA_Account__r.Name, Emp_Id__c];
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationOnAgreement(Id employeeId){
        return [SELECT FA_Account__c, FA_Account__r.Name , FA_Account__r.Include_In_Agreement__c
                FROM FA_Account_Association__c 
                WHERE Financial_Advisor__c = :employeeId
                AND FA_Account__r.Type__c = :FA_JPN_TYPE 
                AND FA_Account__r.RecordTypeId = :getFAAccountRecordTypeId(AGREEMENT_RECORDTYPE)];
    }
    
    public static list<FA_Account_Association__c> getFAAccAssociationOnFAAccNotInAgreementId(Id agreementId, set<id> setAccountIds){
        return [Select Emp_Id__c, FFAP_Agreement__r.Employee__c,Financial_Advisor__r.Email__c, Financial_Advisor__r.DocuSign_GUID__c,
                        Financial_Advisor__c, Financial_Advisor__r.Name, FA_Account__c, FA_Account__r.Name, FA_Account__r.Include_In_Agreement__c, 
                        Financial_Advisor__r.Financial_Advisor_Number__c, Financial_Advisor__r.Override_Branch_Manager__c, 
                        Financial_Advisor__r.Emp_Id__c, Financial_Advisor__r.Status__c, Financial_Advisor__r.Conga_Branch_Manager__c,
                        Financial_Advisor__r.Manager__c, Financial_Advisor__r.Complex_Manager__c, 
                        Financial_Advisor__r.Regional_Director__c, Financial_Advisor__r.Override_Regional_Director__c
                        from FA_Account_Association__c 
                        where FFAP_Agreement__c != :agreementId 
                        AND Fa_Account__c in :setAccountIds and Financial_Advisor__r.status__c = 'Active'];
    }
    public static list<FA_Account_Association__c> getFAAccAssociationOnJpnChangeId(Id jpnChangeId){
    return [Select Id, Agreement_Signed_Date__c, FA_Account__c, FA_Account__r.Name, Is_New_Advisor__c, Emp_Id__c,
                    Is_FA_Split_Modified__c, Financial_Advisor__c, Financial_Advisor__r.Name, Financial_Advisor__r.Emp_Id__c,
                    Financial_Advisor__r.Email__c, Financial_Advisor__r.Status__c, 
                    Financial_Advisor__r.DocuSign_GUID__c, Financial_Advisor__r.Financial_Advisor_Number__c,
                    Financial_Advisor__r.Override_Branch_Manager__c, Financial_Advisor__r.Conga_Branch_Manager__c,
                        Financial_Advisor__r.Manager__c, Financial_Advisor__r.Complex_Manager__c, 
                        Financial_Advisor__r.Regional_Director__c, Financial_Advisor__r.Override_Regional_Director__c
                  from FA_Account_Association__c
                  where FA_Account__r.JPN_Change__c = :jpnChangeId 
                  AND Financial_Advisor__r.Status__c = 'Active'
                  AND (Is_FA_Split_Modified__c = true or Is_New_Advisor__c = true)];
    }
    public static list<AggregateResult> getCountForProductionMonthDurationOnAgreementId(string agreementId){
        string agreementRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE);
        return [select count(id), FA_Account__r.Retirement_Months__c RT
                      from FA_Account_Association__c 
                      where FFAP_Agreement__c =:agreementId 
                          AND FA_Account__r.RecordTypeId = : agreementRecordTypeId
                      group by FA_Account__r.Retirement_Months__c];
    }
    
    //FA Account Production Period Association
    public static list<FA_Account_Production_Period_Association__c> getFAAccProdPeriodAssociationOnJPNSet(set<Id> faAccounts){
        return [select Id, FA_Account_Association__c, FFAP_Split_Percent__c, Split_Percent_Calculation_Type__c, Remaining_Split_Percent_For_Active_FA__c, 
                FA_Account_Association__r.Financial_Advisor__c, Production_Period__c, Production_Period__r.Id, Production_Period__r.End_Month__c,
                Production_Period__r.End_Year__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c, Production_Period__r.Multiplier_Percent__c, 
                    Production_Period__r.Transaction_Period__c, Production_Period__r.Effective_Date__c, Production_Period__r.RecordTypeId 
                from FA_Account_Production_Period_Association__c
                where FA_Account_Association__r.FA_Account__c IN : faAccounts];
    }    
    
    public static list<FA_Account_Production_Period_Association__c> getFAAccProdPeriodAssociationOnJPN(Id faAccountId){
        return [select Id, Production_Period__c, Production_Period__r.Id, Production_Period__r.Coverage_Period_Temp__c, Production_Period__r.End_Month__c, Production_Period__r.Coverage_Period__c, 
                    Production_Period__r.End_Year__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c, Production_Period__r.Multiplier_Percent__c, 
                    Production_Period__r.Transaction_Period__c, Production_Period__r.Effective_Date__c, Production_Period__r.RecordTypeId,
                    FA_Account_Association__c, FA_Account_Association__r.Id, FA_Account_Association__r.Emp_Id__c, FA_Account_Association__r.Financial_Advisor__r.First_Name__c, 
                    FA_Account_Association__r.Financial_Advisor__r.Last_Name__c, FA_Account_Association__r.Financial_Advisor__r.Status__c,
                    FA_Account_Association__r.FA_Account__c, FA_Account_Association__r.FFAP_Agreement__c, FA_Account_Association__r.FA_Split_Percent__c,
                    FA_Account_Association__r.Is_FA_Split_Modified__c, Remaining_Split_Percent_For_Active_FA__c, FFAP_Split_Percent__c, RecordTypeId, 
                    Prv_FFAP_Split_Percent__c                  
                from FA_Account_Production_Period_Association__c
                where FA_Account_Association__r.FA_Account__c = : faAccountId];
    }
    
    public static list<FA_Account_Production_Period_Association__c> getMinMaxProdPrdForEmp(set<id> setAccountAssociationIds){
        return [select FA_Account_Association__r.FA_Account__r.Name, Production_Period__c, Production_Period__r.Coverage_Period_Temp__c, Production_Period__r.End_Month__c, 
                        Production_Period__r.End_Year__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c
                from FA_Account_Production_Period_Association__c
                where FA_Account_Association__c in :setAccountAssociationIds
                order by FA_Account_Association__r.FA_Account__r.Name, Production_Period__r.Coverage_Period_Temp__c];
    }
    
    /*public static list<FA_Account_Production_Period_Association__c> getMinMaxProdPrdForEmp(set<id> setAccountAssociationIds){
        return [select Id, Production_Period__r.Coverage_Period_Temp__c, Production_Period__r.End_Month__c, Production_Period__r.End_Year__c, 
                           Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c                  
                from FA_Account_Production_Period_Association__c
                where FA_Account_Association__c in :setAccountAssociationIds
                order by Production_Period__r.Coverage_Period_Temp__c];
    }*/
    
    public static list<FA_Account_Production_Period_Association__c> getFAAccProdPeriodAssociationOnJPNForHTML(Id faAccountId){
        return [select Id, Production_Period__c, Production_Period__r.Coverage_Period_Temp__c, Production_Period__r.End_Month__c,
                    Production_Period__r.End_Year__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c,  
                    Production_Period__r.Transaction_Period__c, Production_Period__r.Effective_Date__c,
                    FA_Account_Association__c, FA_Account_Association__r.Emp_Id__c, FA_Account_Association__r.Financial_Advisor__r.First_Name__c, 
                    FA_Account_Association__r.Financial_Advisor__r.Last_Name__c, FA_Account_Association__r.Financial_Advisor__r.Status__c,
                    FA_Account_Association__r.Financial_Advisor__c, FA_Account_Association__r.Financial_Advisor__r.Financial_Advisor_Number__c,
                    FFAP_Split_Percent__c, FA_Split_Percent__c, FFAP_Multiplier_Percent__c                 
                from FA_Account_Production_Period_Association__c
                where FA_Account_Association__r.FA_Account__c = : faAccountId
                order by Production_Period__r.Coverage_Period_Temp__c];
    }
    
    //FFAP Default Multiplier
    public static List<FFAP_Default_Multiplier__c> getDefaultSplits(){
        return [SELECT Year__c, Multiplier_1__c, Multiplier_2__c FROM FFAP_Default_Multiplier__c order by Year__c];
    }
    
    //Attachment
    public static list<Attachment> getAttachmentsOnParentIdAndDocName(Id parentId, Set<String> documentNames){
        return [SELECT Id, Body, Name FROM Attachment 
                                            WHERE ParentId = :parentId AND Name IN :documentNames order by LastModifiedDate desc];
    }
    
    
    public static Integer getAttachmentCountOnParentIdAndDocName(Id parentId, Set<String> documentNames){
        return [SELECT count() FROM Attachment 
                                            WHERE ParentId = :parentId AND Name IN :documentNames];
    }
    
    //FFAP Document Recipient
    public static list<FFAP_Document_Recipient__c> getFFAPDocRecipientsOnSourceIdAndPackage(Id sourceId, String packageName){
        return [SELECT Id, Name, Docusign_Status__c, Recipient__c, Signing_Order__c 
                    FROM FFAP_Document_Recipient__c 
                    WHERE (FFAP_Agreement__c = :sourceId OR JPN_Change__c = :sourceId ) 
                    AND Package_Type__c = :packageName AND Docusign_Status__c = 'Created' 
                    order by Name, Signing_Order__c];
    }
    
    public static Integer getFFAPDocRecipientCountOnSourceIdAndPackage(Id sourceId, String packageName){
        return [SELECT count() FROM FFAP_Document_Recipient__c WHERE (FFAP_Agreement__c = :sourceId OR JPN_Change__c = :sourceId) AND Package_Type__c = :packageName limit 1];
    }
    
    //DocuSignAccountConfiguration
    public static dsfs__DocuSignAccountConfiguration__c getDocuSignAccountConfigurations(){
        list<dsfs__DocuSignAccountConfiguration__c> accountConfigList = [SELECT dsfs__EmailBody__c, dsfs__EmailSubject__c, dsfs__DSProSFPassword__c, dsfs__DSProSFUsername__c, 
                                                                dsfs__AccountId__c 
                                                                FROM dsfs__DocuSignAccountConfiguration__c limit 1];
        if(!accountConfigList.isEmpty()){
            return accountConfigList[0];
        }
        return null;
    }
    
    //DocuSignStatus
    public static list<dsfs__DocuSign_Status__c> getDocusignStatus(String envId){
        return [SELECT Id, FFAP_Record__c from dsfs__DocuSign_Status__c WHERE dsfs__DocuSign_Envelope_ID__c = :envId AND FFAP_Record__c = null limit 1];
    }
    //State Clause
    public static list<State_Clause__c> getStateClauseOnName(Set<String> statevalues){      
        system.debug('******' + stateValues);
        return [Select Id, FFAP_State_Clause__c, FFAP_Clause_For_California__c
                                        from State_Clause__c 
                                        where Postal_Code__c IN :statevalues
                                        AND is_active__c = true];
    }
    
    //FFAP Conga Template Mapping
    public static list<FFAP_Conga_Template_Mapping__c> getFFAPCongaTemplateMappingOnPackageType(string packageType){
        return [Select Template_Id__c, Send_To_Active_FAs__c, Send_To_PWA__c, Name, Send_To_FA__c, Is_Exhibit_section__c,
                                                                Send_To_Branch_Manager__c, Send_To_Regional_Director__c, Query_Id__c, Send_To_States__c 
                                                                from FFAP_Conga_Template_Mapping__c 
                                                                where Package_Type__c=:packageType
                                                                    and isActive__c = true 
                                                                order by Send_To_States__c NULLS LAST];
    }
    public static list<FFAP_Conga_Template_Mapping__c> getFFAPCongaTemplatesOnAdvisorType(String advisorType){
        return [Select Template_Id__c, Send_To_Active_FAs__c, Send_To_PWA__c, Name, Send_To_FA__c, Send_to_Retiring_FA__c, Send_To_New_FA__c, Package_Type__c, 
                                                                Send_To_Branch_Manager__c, Send_To_Regional_Director__c, Query_Id__c, Send_To_States__c, Modification_Type__c  
                                                                from FFAP_Conga_Template_Mapping__c 
                                                                where Advisor_Type__c = :advisorType
                                                                AND isActive__c = true];
    }
    //FA Account
    public static list<FA_Account__c> getActiveFAAccountsOnActiveDate(DateTime activeDate, String recordTypeName){
        return [SELECT Id, Name, InActive__c, RecordTypeId 
                                       FROM FA_Account__c 
                                       WHERE Last_Active_Date__c <> :activeDate 
                                       AND InActive__c = false
                                       AND RecordTypeId = :getFAAccountRecordTypeId(recordTypeName)
                                       limit 9999];
    }
    
    // JPN Change Process
     public static list<JPN_Change__c> getJPNChangeDetail(list<id> jpnChangeRecordId){
        return [select id, RecordTypeId, RecordType.Name, Advisor_Type__c, Has_Process_Completed__c, Is_Documents_Package_Generated__c, Is_Sent_for_Signature__c, 
                       JPN_Change_Requestor__c, Modification_Type__c, JPN_Change_Requestor__r.Emp_Id__c, Grid_Rate__c
                from JPN_Change__c
                where id in :jpnChangeRecordId];
    }
    
    public static list<JPN_Change__c> getJPNChangeDetailForConga(list<id> jpnChangeRecordId){
        return [Select Id, Advisor_Type__c, Grid_Rate__c, JPN_Change_Requestor__c, JPN_Change_Requestor__r.Email__c, Modification_Type__c, RecordTypeId,
                                              RecordType.Name, JPN_Change_Requestor__r.Emp_Id__c, JPN_Change_Requestor__r.Status__c,
                                              JPN_Change_Requestor__r.Name, Is_Documents_Package_Generated__c 
                From JPN_Change__c
                where id in :jpnChangeRecordId];
    }
    
    public static list<FA_Account__c> getFAAccountOnJPNChangeId(string jpnChangeId){
        return [select id, Name, Is_Request_to_Create_New_JPN__c, InActive__c, Include_in_Agreement__c, Type__c, JPN_Change__r.RecordTypeId, Retirement_Months__c  
                   from FA_Account__c 
                   where JPN_Change__c =: jpnChangeId];
    }
}