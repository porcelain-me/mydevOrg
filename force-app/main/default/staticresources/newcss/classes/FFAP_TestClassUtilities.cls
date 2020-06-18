public without sharing class FFAP_TestClassUtilities {

    public static User getSystemAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser1', email='TU' + DateTime.now().format('MMddyyhhmmss') + '1@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing1',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '1@morganstanley.com');
   
        return tempUser;
    }
    
    public static User getFFAPTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='FFAP User'];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
     public static void setAllTriggerOn(Id userId) { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();        
        if(dSwitch != null && dSwitch.Id != null){
            delete dSwitch;
        }      
        dSwitch = new Trigger_Switch__c(Name = 'Default', SetupOwnerId=userId);
        
        dSwitch.Is_FAAP_Agreement_Off__c = false; 
        dSwitch.Is_FFAP_PopulateFADataBatch_Off__c = false;
        dSwitch.Is_FFAP_UpdateEmployeeHierarchy_Off__c = false;
        dSwitch.Is_FFAP_DocusignUserCreation_Off__c = false;
        dSwitch.Is_EmployeeTrigger_Off__c = false;
        dSwitch.Is_FFAP_FA_Account_Association_Off__c = false;
        insert dSwitch;
    }
    
    public static User createSystemDataFFAPUser(){
        User ffapUser;
        User sysUser = getSystemAdminTempUser();
        System.runAs(sysUser){
            ffapUser = getFFAPTempUser();
            insert ffapUser;
            setAllTriggerOn(ffapUser.Id);            
        }
        return ffapUser;
    }
    
    public static void createFFAPDefaultMultipliers(){
        List<FFAP_Default_Multiplier__c> multipliers = new List<FFAP_Default_Multiplier__c>();
        multipliers.add(new FFAP_Default_Multiplier__c(Name='Year 1', Year__c=1, Multiplier_1__c=65.0, Multiplier_2__c=70.0));
        multipliers.add(new FFAP_Default_Multiplier__c(Name='Year 2', Year__c=2, Multiplier_1__c=55.0, Multiplier_2__c=65.0));
        multipliers.add(new FFAP_Default_Multiplier__c(Name='Year 3', Year__c=3, Multiplier_1__c=50.0, Multiplier_2__c=55.0));
        multipliers.add(new FFAP_Default_Multiplier__c(Name='Year 4', Year__c=4, Multiplier_1__c=45.0, Multiplier_2__c=50.0));
        multipliers.add(new FFAP_Default_Multiplier__c(Name='Year 5', Year__c=5, Multiplier_1__c=40.0, Multiplier_2__c=45.0));
        insert multipliers;     
    }
    
    public static void createDocusignTemplate(){
        List<Docusign_Template_Setting__c> templates = new List<Docusign_Template_Setting__c>();
        //templates.add(new Docusign_Template_Setting__c(Name = 'Default', FA_Template__c ='', PWA_Template__c ='', Docusign_User_record_limit__c = 200, Super_Division_code__c = '10910'));
        Docusign_Template_Setting__c docTemplate = new Docusign_Template_Setting__c(Name = 'Default', FA_Template__c ='TESTFATEMPLATE', PWA_Template__c ='TESTPWATEMPLATE');
        docTemplate.Docusign_User_record_limit__c = 1;
        docTemplate.Docusign_Adminsitrator_Email__c = 'test@ms.com';
        templates.add(docTemplate);
        insert templates;
    }
    
    public static void createCongaGeneralSettings(){
        List<Conga_General_Settings__c> settings = new List<Conga_General_Settings__c>();
        settings.add(new Conga_General_Settings__c(Conga_Max_Response_Time__c = 0, Conga_Status_Check_Interval__c = 5));
        insert settings;
    }
    
    /*public static void createBatchSettings(){
        List<Batch_Settings__c> settings = new List<Batch_Settings__c>();
        settings.add(new Batch_Settings__c(batch_manager_email__c = 'xyz@xyz.com'));
        insert settings;
    }*/
    public static void createFFAPJobTitle(){
        // Insert List of FFAP Job Title custom setting record
        List<FFAP_JobTitles__c> lstFFAPJT = new list<FFAP_JobTitles__c>();
        // For Branch Manager
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='1', Is_Active__c = true, Job_Title_Code__c='600097', Job_Title_Desc__c='Branch Manager', Type__c='Branch Manager'));      
        // For Financial Advisor
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='3', Is_Active__c = true, Job_Title_Code__c='600585', Job_Title_Desc__c='Financial Advisor', Type__c='Financial Advisor'));        
        // For Private Wealth Advisor
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='18', Is_Active__c = true, Job_Title_Code__c='600836', Job_Title_Desc__c='Private Wealth Advisor', Type__c='Private Wealth Advisor'));     
        // For Complex Manager
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='23', Is_Active__c = true, Job_Title_Code__c='600185', Job_Title_Desc__c='Complex Manager', Type__c='Complex Manager'));
        // For Regional Director
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='24', Is_Active__c = true, Job_Title_Code__c='600896', Job_Title_Desc__c='Regional Director', Type__c='Regional Director'));
        
        insert lstFFAPJT;
    }
    
    public static void createStateClause(){
        List<State_Clause__c> listStateClause = new List<State_Clause__c>();

        listStateClause.add(new State_Clause__c(Name = 'NEBRASKA',
                            FFAP_State_Clause__c = 'Nebraska Fair Employment Practices Act, as amended, Nebraska Equal Pay Act, as amended',
                            FFAP_Clause_For_California__c = '', Is_Active__c = true));                        
        insert listStateClause; 
    }
    
    public static void createCongaTemplateMapping(){
        List<FFAP_Conga_Template_Mapping__c> listMapping = new list<FFAP_Conga_Template_Mapping__c>();
        FFAP_Conga_Template_Mapping__c mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13 sent to HR';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        
        mapping.Name = 'FFA Doc Sent To HR';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        
        mapping.Name = 'FFA Doc';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c =false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Sample Doc 8 - Summary';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        
        mapping.Name = 'FFA Retirement Summary';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'NEBRASKA';
        mapping.Template_Name__c = 'Sample Doc 4 - FFAP Agreement - MA TN NH - REV 03.19.13';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        
        mapping.Name = 'FFA Doc Sent To HR_MA TN NH';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = FFAP_DataUtil.NEW_JPN_RECORDTYPE;
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        mapping.Send_To_New_FA__c = true;
        
        mapping.Name = 'FFAP JPN Change';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = FFAP_DataUtil.NEW_JPN_RECORDTYPE;
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        mapping.Send_To_New_FA__c = true;
        
        mapping.Name = 'FFAP JPN Change1';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = FFAP_DataUtil.NEW_JPN_RECORDTYPE;
        mapping.Query_Id__c = 'TESTQUERYID';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13';
        mapping.Template_Id__c = 'TESTTEMPLATEID';
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active';
        mapping.Send_To_New_FA__c = false;
        
        mapping.Name = 'FFAP JPN Change2';
        listMapping.add(mapping);
        
        insert listMapping;
    }
    
    public static void createDocusignRecord(){
        dsfs__DocuSignAccountConfiguration__c accountConfig = new dsfs__DocuSignAccountConfiguration__c(dsfs__AccountId__c ='TESTACCOUNTID', dsfs__DSProSFUsername__c = 'TESTUSERID', dsfs__DSProSFPassword__c = 'TESTPASSWORD');
        accountConfig.dsfs__EmailBody__c = 'TEST EMAIL BODY.';
        insert accountConfig;
    }
    
    public static dsfs__DocuSign_Status__c createDocusignStatusRecord(String empId, Id agreementId){
        dsfs__DocuSign_Status__c docStatus = new dsfs__DocuSign_Status__c(dsfs__DocuSign_Envelope_ID__c ='TESTENVELOPEID', Employee_Id__c = empId, FFAP_Record__c = agreementId);
        return docStatus;
    }
    public static Employee__c createTestEmployee(Integer indx, String empId, String jobTitleCode, String department, String costcenter, String subDepartment){
        Employee__c emp = new Employee__c(Name = 'Test Employee_' + indx, 
                                          emp_Id__c = empId, jobcode_job__c = jobTitleCode,
                                          Job_Country_Job__c = 'USA', MS_MSSB__c = 'MS', 
                                          Level_Dsc_Job__c = 'Job Level desc' + indx, Covenant_Date__c = Date.today(), 
                                          Level_Job__c = 'Job Level' + indx, FFAP_Is_FA__c = true,
                                          Super_Division__c= 'Super Division',
                                          Super_Depart_Org__c ='Super Department' + indx,
                                          Subdept_Org__c = subDepartment,
                                          Division_Org__c = 'Division' + indx, DocuSign_GUID__c = 'docusign-account-' + indx,
                                          Dept_Org__c = department, Status__c = 'Active',
                                          Sub_Depart2_Org__c = 'Sub Department 2' + indx,
                                          Email__c ='TE' + indx + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                          Financial_Advisor_Number__c = 'indx-'+indx,
                                          Work_Phone__c = '3232' + indx,
                                          Cost_Center__c = costcenter);
        return emp;
    }
    
    public static FFAP_Agreement__c createAgreement(Id empId){
        return new FFAP_Agreement__c(Employee__c = empId, Executers__c = 'TestExecutors', Start_Date__c = System.today().addDays(-5));
    }
    
    public static FA_Account__c createPrimaryFAAccount(String jpnNumber, Id recordTypeId){
        return createFAAccount(jpnNumber, recordTypeId, FFAP_DataUtil.FA_Primary_TYPE);
    }
    
    public static FA_Account__c createJPNFAAccount(String jpnNumber, Id recordTypeId){
        return createFAAccount(jpnNumber, recordTypeId, FFAP_DataUtil.FA_JPN_TYPE);
    }
    
    public static FA_Account__c createFAAccount(String jpnNumber, Id recordTypeId, String jpnType){
        return new FA_Account__c(Name = jpnNumber, RecordTypeId = recordTypeId, Type__c = jpnType, InActive__c = false, Include_In_Agreement__c = true);
    }
    
    public static FA_Account_Association__c createFAAccountAssociation(Id empId, Id faId){
        return createFAAccountAssociation(empId, faId, 100.0);
    }
    public static FA_Account_Association__c createFAAccountAssociation(Id empId, Id faId, Decimal splitPer){
        return new FA_Account_Association__c(Financial_Advisor__c = empId, FA_Account__c = faId, FA_Split_Percent__c = splitPer);
    }
    
    public static List<Production_Period__c> createProductionPeriod(Integer ppCount){
        return createProductionPeriod(ppCount, 70.0);
    }
    
    public static List<Production_Period__c> createProductionPeriod(Integer ppCount, Decimal multiplierPer){
        List<Production_Period__c> faPBList = new List<Production_Period__c>();
        String year;
        for(Integer counter = 1; counter <= ppCount; counter++){
            year = System.Today().year() + 1 + '';
            faPBList.add(new Production_Period__c(Multiplier_Percent__c = multiplierPer, Start_Year__c = year, Start_Month__c = '1', End_Year__c = year, End_Month__c = '12'));
        }
        return faPBList;        
    }
    public static List<FA_Account_Production_Period_Association__c> createProductionPeriodAssociation(List<Production_Period__c> faPBList, List<FA_Account_Association__c> faList){
        List<FA_Account_Production_Period_Association__c> faPPAList = new List<FA_Account_Production_Period_Association__c>();
        FA_Account_Production_Period_Association__c tempfaPPA;
        for(Production_Period__c pp : faPBList){
            for(FA_Account_Association__c fa : faList){                
                tempfaPPA = new FA_Account_Production_Period_Association__c(FA_Account_Association__c = fa.Id, Production_Period__c= pp.Id, FFAP_Split_Percent__c = fa.FA_Split_Percent__c, Split_Percent_Calculation_Type__c= 'Manual');
                faPPAList.add(tempfaPPA);
            }
        } 
        return faPPAList;        
    }
    public static Staging_FA_Account__c createStagingFA(String faNumber, String faType, String jpnNumber, String empId, Decimal splitPer){
        return new Staging_FA_Account__c(FA__c = faNumber, FA_Type__c = faType, JPN__c = jpnNumber, MSID__c = empId, MSID_Split__c = splitPer);
    }
    public static Staging_FA_Account__c createPrimaryStagingFA(String faNumber, String jpnNumber, String empId){
        return createStagingFA(faNumber, FFAP_DataUtil.FA_Primary_TYPE, jpnNumber, empId, 100.0);
    }
    public static Staging_FA_Account__c createJPNStagingFA(String faNumber, String jpnNumber, String empId, Decimal splitPer){
        return createStagingFA(faNumber, FFAP_DataUtil.FA_JPN_TYPE, jpnNumber, empId, splitPer);
    }
    public static FFAP_Document_Recipient__c createDocRecipient(String name, Id sourceId, Id empId, Integer signOrder){
        String objectAPIName = sourceId.getSObjectType().getDescribe().getName();
        FFAP_Document_Recipient__c docRec = createDocRecipientPrivate(name, empId, signOrder);
        if(objectAPIName == 'FFAP_Agreement__c'){
           docRec.FFAP_Agreement__c = sourceId;
        }else if(objectAPIName == 'JPN_Change__c'){
            docRec.JPN_Change__c = sourceId;
        }
        return docRec;
    }
    
    private static FFAP_Document_Recipient__c createDocRecipientPrivate(String name, Id empId, Integer signOrder){
        return new FFAP_Document_Recipient__c(Name = name, Recipient__c = empId, Signing_Order__c = signOrder, Package_Type__c = 'TESTPACKAGE');
    }
    public static Attachment createAttachment(String name, Id parentId){
        return new Attachment(Name = name, Body = blob.valueOf('test file content'), ParentId = parentId);
    }
    
    public static JPN_Change__c createJPNChange(String advisorType, Id recordTypeId, Id empRecordId){
        return new JPN_Change__c(Advisor_Type__c = advisorType,
                                Has_Process_Completed__c = false,
                                Is_Documents_Package_Generated__c = false,
                                Is_Sent_for_Signature__c = false,
                                JPN_Change_Requestor__c = empRecordId,
                                Modification_Type__c = 'Active',
                                RecordTypeId = recordTypeId);
    }
}