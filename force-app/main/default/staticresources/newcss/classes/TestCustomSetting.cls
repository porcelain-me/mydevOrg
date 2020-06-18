public class TestCustomSetting {

    static testmethod void tstCustomSettingScript(){
        insertCongaQueries();
        insertCongaTemplates();
        insertCustomSetting();
        insertOtherCustomSetting();
    }
    
    static void insertCongaQueries(){
        // Insert Conga Query Records

        List<APXT_CMQR__Conga_Merge_Query__c> listQuery = new list<APXT_CMQR__Conga_Merge_Query__c>();
        APXT_CMQR__Conga_Merge_Query__c query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'ProductionPeriod';
        query.APXT_CMQR__Query__c = 'SELECT Production_Period__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c FROM FA_Account_Production_Period_Association__c WHERE FA_Account_Association__c in (Select Id from FA_Account_Association__c where Emp_Id__c = \'{pv0}\') ORDER BY Production_Period__r.Coverage_Period_Temp__c ASC limit 1';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'Split_SingleFA';
        query.APXT_CMQR__Query__c = 'SELECT FA_Account_Association__c, Name, FA_Split_Percent__c, FFAP_Multiplier_Percent__c, FFAP_Split_Percent__c, Production_Period__c, Id, Remaining_Split_Percent_For_Active_FA__c, Split_Percent_Calculation_Type__c, Production_Period__r.End_Month__c, Production_Period__r.CONGA_Start_Duration__c, Production_Period__r.CONGA_End_Duration__c, Production_Period__r.End_Year__c, Production_Period__r.Multiplier_Percent__c, Production_Period__r.Id, Production_Period__r.Effective_Date__c, Production_Period__r.Transaction_Period__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c, FA_Account_Association__r.Advisor_Number__c, FA_Account_Association__r.Emp_Id__c, FA_Account_Association__r.FA_Account__c, FA_Account_Association__r.FA_Account_Name__c, FA_Account_Association__r.FA_Split_Percent__c, FA_Account_Association__r.FFAP_Agreement__c, FA_Account_Association__r.Financial_Advisor__c, FA_Account_Association__r.Name, FA_Account_Association__r.Id FROM FA_Account_Production_Period_Association__c WHERE FA_Account_Association__c in (Select Id from FA_Account_Association__c where Emp_Id__c=\'{pv0}\' and FA_Account__c IN ({pv1})) ORDER BY Production_Period__r.Coverage_Period_Temp__c ASC';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'Employee';
        query.APXT_CMQR__Query__c = 'SELECT Manager__c, Name, Override_Branch_Manager__c, Override_Regional_Director__c, Regional_Director__c, Override_Branch_Manager__r.Name, Regional_Director__r.Name, Manager__r.Name, Complex_Manager__c, Complex_Manager__r.Name, Override_Branch_Manager__r.Email__c, Financial_Advisor_Number__c, Override_Regional_Director__r.Name, Conga_Branch_Manager__c, Conga_Branch_Manager__r.Name FROM Employee__c WHERE Emp_ID__c = \'{pv0}\'';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'Split_AllFA';
        query.APXT_CMQR__Query__c = 'SELECT FA_Account_Association__c, Name, FA_Split_Percent__c, FFAP_Multiplier_Percent__c, FFAP_Split_Percent__c, Production_Period__c, Id, Remaining_Split_Percent_For_Active_FA__c, Split_Percent_Calculation_Type__c, Production_Period__r.End_Month__c, Production_Period__r.CONGA_Start_Duration__c, Production_Period__r.CONGA_End_Duration__c, Production_Period__r.End_Year__c, Production_Period__r.Multiplier_Percent__c, Production_Period__r.Id, Production_Period__r.Effective_Date__c, Production_Period__r.Transaction_Period__c, Production_Period__r.Start_Month__c, Production_Period__r.Start_Year__c, FA_Account_Association__r.Advisor_Number__c, FA_Account_Association__r.Emp_Id__c, FA_Account_Association__r.FA_Account__c, FA_Account_Association__r.FA_Account_Name__c, FA_Account_Association__r.FA_Split_Percent__c, FA_Account_Association__r.FFAP_Agreement__c, FA_Account_Association__r.Financial_Advisor__c, FA_Account_Association__r.Name, FA_Account_Association__r.Id FROM FA_Account_Production_Period_Association__c WHERE FA_Account_Association__c in (Select Id from FA_Account_Association__c where FA_Account__c in ({pv0})) ORDER BY Production_Period__r.Coverage_Period_Temp__c ASC, Production_Period__r.Transaction_Period__c, FA_Account_Association__r.Emp_Id__c';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'SignedDate';
        query.APXT_CMQR__Query__c = 'Select Financial_Advisor__r.CONGA_Branch_Manager_Name__c, Agreement_Signed_Date__c, Financial_Advisor__r.Name FROM FA_Account_Association__c where Emp_Id__c=\'{pv0}\' AND FA_Account__c IN ({pv1}) limit 1';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'UnEnhaced_Account';
        query.APXT_CMQR__Query__c = 'SELECT Conga_JPN_Advisor_Details__c, Name, HTML_Grid__c, Old_FA_Account__c, Old_FA_Account__r.Name FROM FA_Account__c WHERE Id IN ({pv0}) AND IsEnhancedOption__c = FALSE';
        listQuery.add(query);
        
        query = new APXT_CMQR__Conga_Merge_Query__c();
        query.APXT_CMQR__Name__c = 'Enhaced_Account';
        query.APXT_CMQR__Query__c = 'SELECT Conga_JPN_Advisor_Details__c, Name, HTML_Grid__c, Old_FA_Account__c, Old_FA_Account__r.Name FROM FA_Account__c WHERE Id IN ({pv0}) AND IsEnhancedOption__c = TRUE';
        listQuery.add(query);
        
        insert listQuery;
    }
    
    static void insertCongaTemplates(){
        // Insert list of Conga Template record for FFAP
        list<APXTConga4__Conga_Template__c> lst = new list<APXTConga4__Conga_Template__c>();
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 3b - FFAP BranchManagerMemo - 12 14 2009', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 3b - FFAP BranchManagerMemo - 12 14 2009',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 5 - FFAP Initial Client Letter rev 12 14 2009', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 5 - FFAP Initial Client Letter rev 12 14 2009',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample Summary - 4 9 2010', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample Summary - 4 9 2010',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 11 PWA Comp Memo 6 8 11', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 11 PWA Comp Memo 6 8 11',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample Initial Client Letter - 4 8 2010', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample Initial Client Letter - 4 8 2010',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample MemoToActiveFAs - 5 7 2010', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample MemoToActiveFAs - 5 7 2010',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample FFAP Agreement rev 4 11 13', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample FFAP Agreement rev 4 11 13',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample BranchManagerMemo - 4 9 2010', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample BranchManagerMemo - 4 9 2010',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 3a - FPWAP Memo to Active PWAs rev 4 25 2011', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 3a - FPWAP Memo to Active PWAs rev 4 25 2011',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13 sent to HR', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13 sent to HR',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 2a - FPWAP Agreement rev 4 25 2011 e', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 2a - FPWAP Agreement rev 4 25 2011 e',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Deceased FA Packet - FFAP - Sample Beneficiary side letter - 3 29 2010', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Deceased FA Packet - FFAP - Sample Beneficiary side letter - 3 29 2010',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 6 - FPWAP Initial Client Letter rev 4 25 2011', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 6 - FPWAP Initial Client Letter rev 4 25 2011',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 2b - FPWAP Agreement MA NH TN rev 4 25 2011 e', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 2b - FPWAP Agreement MA NH TN rev 4 25 2011 e',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Form 3b - FPWAP BranchManagerMemo - 6 8 11', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Form 3b - FPWAP BranchManagerMemo - 6 8 11',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 4 - FFAP Agreement - MA TN NH - REV 03.19.13', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 4 - FFAP Agreement - MA TN NH - REV 03.19.13',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 3a-FFAP MemoToActiveFAs - 12 14 2009', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 3a-FFAP MemoToActiveFAs - 12 14 2009',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document')); 
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'State Specific Statuses (For State of Residence or Employment if not New York)', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'State Specific Statuses (For State of Residence or Employment if not New York)',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document')); 
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'Sample Doc 8 - Summary', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'Sample Doc 8 - Summary',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        

        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FFAP Modification-Terminate Agreement rev 050213', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FFAP Modification-Terminate Agreement rev 050213',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FFAP Modification to Agreement - for Active FA Split modifications', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FFAP Modification to Agreement - for Active FA Split modifications',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FFAP Modification to Agreement - for modifications for Retiree', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FFAP Modification to Agreement - for modifications for Retiree',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FPWAP Modification-Terminate Agreement rev 112013', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FPWAP Modification-Terminate Agreement rev 112013',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FPWAP Modification to Active PWA Memo_Split Changes_rev 112013', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FPWAP Modification to Active PWA Memo_Split Changes_rev 112013',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FPWAP Modification to Agreement - for modifications for Retiree_rev 112013', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FPWAP Modification to Agreement - for modifications for Retiree_rev 112013',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'RFA Modification to Active FA Memo - Modify Existing Splits', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'RFA Modification to Active FA Memo - Modify Existing Splits',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'RFA Modification to Agreement - modifications for Retiree_112013', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'RFA Modification to Agreement - modifications for Retiree_112013',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'RFA Modification to RFA_Active FA Memo_Adding an FA', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'RFA Modification to RFA_Active FA Memo_Adding an FA',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'RFA Modification-Terminate Agreement rev 112013', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'RFA Modification-Terminate Agreement rev 112013',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FFAP Modication Adding New FA', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FFAP Modication Adding New FA',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        lst.add(new APXTConga4__Conga_Template__c(APXTConga4__Description__c = 'FPWAP Modification Adding New FA', APXTConga4__Label_Template_Use_Detail_Data__c = false, APXTConga4__Name__c = 'FPWAP Modification Adding New FA',  APXTConga4__Template_Group__c = 'FFAP Template', APXTConga4__Template_Type__c = 'Document'));
        
        insert lst;
                
    }
    
    static void insertCustomSetting(){
        // Insert custom setting for FFAP Template Mapping
        
        map<String,Id> mapQueryId = new map<String, Id>();
        for(APXT_CMQR__Conga_Merge_Query__c query : [Select APXT_CMQR__Name__c, Id from APXT_CMQR__Conga_Merge_Query__c]){
            mapQueryId.put(query.APXT_CMQR__Name__c, query.Id);
        }
        
        map<String,Id> templateMap = new map<String,Id>();
        for(APXTConga4__Conga_Template__c template : [Select Id, APXTConga4__Name__c From APXTConga4__Conga_Template__c]){
            templateMap.put(template.APXTConga4__Name__c, template.Id);
        }
        
        
        
        List<FFAP_Conga_Template_Mapping__c> listMapping = new list<FFAP_Conga_Template_Mapping__c>();
        FFAP_Conga_Template_Mapping__c mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '[FFADetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Sample Doc 4 - FFA Agreement rev 03 19 13 sent to HR';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = true;
        mapping.Name = 'FFA Doc Sent To HR';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '[FFADetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = true;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'MAINE,NEW HAMPSHIRE,TENNESSEE,MA,NH,TN';
        mapping.Template_Name__c = 'Sample Doc 4 - FFAP Agreement - MA TN NH - REV 03.19.13';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Name = 'FFA Doc Sent To HR_MA TN NH';
        mapping.Is_Exhibit_Section__c = true;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '[ENDetail]'+mapQueryId.get('Enhaced_Account')+'?pv0=#accountIds#,[NONENDetail]'+mapQueryId.get('UnEnhaced_Account')+'?pv0=#accountIds#';
        mapping.Send_To_Active_FAs__c =false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Sample Doc 8 - Summary';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Name = 'FFA Retirement Summary';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c =false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Sample Doc 5 - FFAP Initial Client Letter rev 12 14 2009';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Name = 'FFAP Initial Client Letter';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c =false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Sample Doc 3b - FFAP BranchManagerMemo - 12 14 2009';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Name = 'Retirement Agreement BranchManagerMemo';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'FARetirement';
        mapping.Query_Id__c = '[EmployeeDetail]' + mapQueryId.get('Employee') + '?pv0=#empId#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c =true;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Sample Doc 3a-FFAP MemoToActiveFAs - 12 14 2009';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Retirement Agreement MemoToActiveFAs';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c =false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample Beneficiary side letter - 3 29 2010';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA Beneficiary Side Letter';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '[EmployeeDetail]' + mapQueryId.get('Employee') + '?pv0=#empId#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample MemoToActiveFAs - 5 7 2010';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA - Memo To Active FAs';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample BranchManagerMemo - 4 9 2010';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA Branch Manager Memo';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample Initial Client Letter - 4 8 2010';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA Initial Client Letter';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '[FFADetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample FFAP Agreement rev 4 11 13';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA FFAP Agreement';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Deceased';
        mapping.Query_Id__c = '[ENDetail]'+mapQueryId.get('Enhaced_Account')+'?pv0=#accountIds#,[NONENDetail]'+mapQueryId.get('UnEnhaced_Account')+'?pv0=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Deceased FA Packet - FFAP - Sample Summary - 4 9 2010';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'Deceased FA Summary';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = true;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Form 3b - FPWAP BranchManagerMemo - 6 8 11';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'PWA Retirement Branch Manager Memo';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Form 6 - FPWAP Initial Client Letter rev 4 25 2011';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'PWA Retirement Initial Client Letter';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '[FFADetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = true;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = null;
        mapping.Template_Name__c = 'Form 2a - FPWAP Agreement rev 4 25 2011 e';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = true;
        mapping.Name = 'PWA Retirement Sent To PWA';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '[ENDetail]'+mapQueryId.get('Enhaced_Account')+'?pv0=#accountIds#,[NONENDetail]'+mapQueryId.get('UnEnhaced_Account')+'?pv0=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = false ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Form 11 PWA Comp Memo 6 8 11';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'PWA Retirement Summary';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '[EmployeeDetail]' + mapQueryId.get('Employee') + '?pv0=#empId#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'all';
        mapping.Template_Name__c = 'Form 3a - FPWAP Memo to Active PWAs rev 4 25 2011';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Is_Exhibit_Section__c = false;
        mapping.Name = 'PWA Retirement To Active PWAs';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'RFA Modification to Active FA Memo - Modify Existing Splits';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'RFA';
        mapping.Modification_Type__c = 'Split % Change,Active';
        mapping.Name = 'RFA Modification To Active FA';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FPWAP Modification to Agreement - for modifications for Retiree_rev 112013';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'PWA';
        mapping.Modification_Type__c = 'Split % Change';
        mapping.Name = 'FPWAP Modification for Retiree';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FPWAP Modification to Active PWA Memo_Split Changes_rev 112013';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'PWA';
        mapping.Modification_Type__c = 'Split % Change,Active';
        mapping.Name = 'FPWAP Modification to Active PWA';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FPWAP Modification-Terminate Agreement rev 112013';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'PWA';
        mapping.Modification_Type__c = 'Termination of Contract';
        mapping.Name = 'FPWAP Modification Terminate Agreement';
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification, New JPN';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FFAP Modication Adding New FA';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active,Split % Change';
        mapping.Name = 'FA Modification New FA';
        mapping.Send_To_New_FA__c = true;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification, New JPN';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'RFA Modification to RFA_Active FA Memo_Adding an FA';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'RFA';
        mapping.Modification_Type__c = 'Active,Split % Change';
        mapping.Name = 'RFA Modification Adding an FA';
        mapping.Send_To_New_FA__c = true;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification, New JPN';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FPWAP Modification Adding New FA';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'PWA';
        mapping.Modification_Type__c = 'Active,Split % Change';
        mapping.Name = 'FPWAP Modification Adding an FA';
        mapping.Send_To_New_FA__c = true;
        listMapping.add(mapping);   
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'PWARetirement';
        mapping.Query_Id__c = '[FFADetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[PrimaryDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#primaryAccountIds#,[JPNDetail]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#jpnAccountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = true;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = 'MAINE,NEW HAMPSHIRE,TENNESSEE,MA,NH,TN';
        mapping.Template_Name__c = 'Form 2b - FPWAP Agreement MA NH TN rev 4 25 2011 e';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Name = 'PWA Retirement To PWA_MA NH TN';
        mapping.Is_Exhibit_Section__c = true;
        listMapping.add(mapping);
        
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FFAP Modification-Terminate Agreement rev 050213';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Termination of Contract';
        mapping.Name = 'FFAP Modification Terminate Agreement';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#,[Employee]' + mapQueryId.get('Employee') + '?pv0=#empId#';
        mapping.Send_To_Active_FAs__c = true;
        mapping.Send_To_Branch_Manager__c = true ; 
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = false;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FFAP Modification to Agreement - for Active FA Split modifications';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Active,Split % Change';
        mapping.Name = 'FA Modification To Active FA';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'FFAP Modification to Agreement - for modifications for Retiree';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'FA';
        mapping.Modification_Type__c = 'Split % Change';
        mapping.Name = 'FA Modification To Retiree';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'RFA Modification-Terminate Agreement rev 112013';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'RFA';
        mapping.Modification_Type__c = 'Termination of Contract';
        mapping.Name = 'RFA Modification Terminate Agreement';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        mapping = new FFAP_Conga_Template_Mapping__c();
        mapping.isActive__c = true;
        mapping.Package_Type__c = 'Modification';
        mapping.Query_Id__c = '[SignedDate]' + mapQueryId.get('SignedDate') + '?pv0=#empId#~pv1=#accountIds#,[SplitPercent]' + mapQueryId.get('Split_SingleFA') + '?pv0=#empId#~pv1=#accountIds#';
        mapping.Send_To_Active_FAs__c = false;
        mapping.Send_To_Branch_Manager__c = true ;
        mapping.Send_To_FA__c = false;
        mapping.Send_To_PWA__c = false;
        mapping.Send_To_Regional_Director__c = false;
        mapping.Send_to_Retiring_FA__c = true;
        mapping.Send_To_States__c = '';
        mapping.Template_Name__c = 'RFA Modification to Agreement - modifications for Retiree_112013';
        mapping.Template_Id__c = templateMap.get(mapping.Template_Name__c);
        mapping.Advisor_Type__c = 'RFA';
        mapping.Modification_Type__c = 'Split % Change';
        mapping.Name = 'RFA Modification To Retiree';
        mapping.Is_Exhibit_Section__c = false;
        listMapping.add(mapping);
        
        insert listMapping;         
    }
    
    static void insertOtherCustomSetting(){
        // Insert List of FFAP Job Title custom setting record
        List<FFAP_JobTitles__c> lstFFAPJT = new list<FFAP_JobTitles__c>();
        // For Branch Manager
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='1', Is_Active__c = true, Job_Title_Code__c='600097', Job_Title_Desc__c='Branch Manager, Non-Producing', Type__c='Branch Manager'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='2', Is_Active__c = true, Job_Title_Code__c='600098', Job_Title_Desc__c='Branch Manager, Producing', Type__c='Branch Manager'));
        
        // For Financial Advisor
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='3', Is_Active__c = true, Job_Title_Code__c='600585', Job_Title_Desc__c='Financial Advsior', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='4', Is_Active__c = true, Job_Title_Code__c='600586', Job_Title_Desc__c='Financial Advisor (S)', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='5', Is_Active__c = true, Job_Title_Code__c='600588', Job_Title_Desc__c='Financial Advisor (T)', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='6', Is_Active__c = true, Job_Title_Code__c='603207', Job_Title_Desc__c='Financial Advisor, Financial A', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='7', Is_Active__c = true, Job_Title_Code__c='603208', Job_Title_Desc__c='Financial Advisor, Financial S', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='8', Is_Active__c = true, Job_Title_Code__c='600589', Job_Title_Desc__c='Financial Advisor, NRC', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='9', Is_Active__c = true, Job_Title_Code__c='603209', Job_Title_Desc__c='Financial Advisor, NRC, Sales', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='10', Is_Active__c = true, Job_Title_Code__c='600590', Job_Title_Desc__c='Financial Advisor, Optin', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='11', Is_Active__c = true, Job_Title_Code__c='603207', Job_Title_Desc__c='Financial Advisor, Optin (S)', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='12', Is_Active__c = true, Job_Title_Code__c='600563', Job_Title_Desc__c='FA Intermediate', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='13', Is_Active__c = true, Job_Title_Code__c='600564', Job_Title_Desc__c='FA Intermediate - Graystone', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='14', Is_Active__c = true, Job_Title_Code__c='600567', Job_Title_Desc__c='FA Intermediate, Non-Resdiential Client', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='15', Is_Active__c = true, Job_Title_Code__c='600568', Job_Title_Desc__c='FA Intermediate, Opt-In', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='16', Is_Active__c = true, Job_Title_Code__c='600567', Job_Title_Desc__c='FA Intermediate, NRC', Type__c='Financial Advsior'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='17', Is_Active__c = true, Job_Title_Code__c='600568', Job_Title_Desc__c='FA Intermediate, Optin', Type__c='Financial Advsior'));
        // For Private Wealth Advisor
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='18', Is_Active__c = true, Job_Title_Code__c='600836', Job_Title_Desc__c='Private Wealth Advisor', Type__c='Private Wealth Advisor'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='19', Is_Active__c = true, Job_Title_Code__c='603407', Job_Title_Desc__c='Private Wealth Advisor, Commis', Type__c='Private Wealth Advisor'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='20', Is_Active__c = true, Job_Title_Code__c='601337', Job_Title_Desc__c='Private Wealth Advisor, NC', Type__c='Private Wealth Advisor'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='21', Is_Active__c = true, Job_Title_Code__c='603408', Job_Title_Desc__c='Private Wealth Advisor, NC, No', Type__c='Private Wealth Advisor'));
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='22', Is_Active__c = true, Job_Title_Code__c='603409', Job_Title_Desc__c='Private Wealth Advisor, Non-Co', Type__c='Private Wealth Advisor'));
        // For Complex Manager
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='23', Is_Active__c = true, Job_Title_Code__c='600185', Job_Title_Desc__c='Complex Manager', Type__c='Complex Manager'));
        // For Regional Director
        lstFFAPJT.Add(new FFAP_JobTitles__c(Name='24', Is_Active__c = true, Job_Title_Code__c='600896', Job_Title_Desc__c='Regional Director', Type__c='Regional Director'));
        
        insert lstFFAPJT;
        
        // Insert FFAP Data Multiplier
        
        List<FFAP_Default_Multiplier__c> lstFFAPMultipler = new list<FFAP_Default_Multiplier__c>();
        lstFFAPMultipler.add(new FFAP_Default_Multiplier__c(Multiplier_1__c = 65, Multiplier_2__c = 70, Year__c = 1, Name = 'Year 1'));
        lstFFAPMultipler.add(new FFAP_Default_Multiplier__c(Multiplier_1__c = 55, Multiplier_2__c = 65, Year__c = 2, Name = 'Year 2'));
        lstFFAPMultipler.add(new FFAP_Default_Multiplier__c(Multiplier_1__c = 50, Multiplier_2__c = 55, Year__c = 3, Name = 'Year 3'));
        lstFFAPMultipler.add(new FFAP_Default_Multiplier__c(Multiplier_1__c = 45, Multiplier_2__c = 50, Year__c = 4, Name = 'Year 4'));
        lstFFAPMultipler.add(new FFAP_Default_Multiplier__c(Multiplier_1__c = 40, Multiplier_2__c = 45, Year__c = 5, Name = 'Year 5'));
        insert lstFFAPMultipler;
        
        //Insert Docusign Template Setting
        List<Docusign_Template_Setting__c> templates = new List<Docusign_Template_Setting__c>();
        templates.add(new Docusign_Template_Setting__c(Name = 'Default', FA_Template__c ='E38B228E-5477-45B2-83E6-D2629D2ACB6D', PWA_Template__c ='08FE2287-4F20-471C-83A7-68BDBB63AA38', Docusign_User_record_limit__c = 200, Docusign_Adminsitrator_Email__c = 'hrfrce-docusign-dev@morganstanley.com'));
        insert templates;
        
        Conga_General_Settings__c congaSetting = new Conga_General_Settings__c();
        congaSetting.Conga_Max_Response_Time__c = 15;
        congaSetting.Conga_Status_Check_Interval__c = 5;
        insert congaSetting;
    }
}