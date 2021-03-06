public with sharing class RIF_OrgHierarchy_CovEnt{
    
    public Coverage_Entitlement_Org__c covEntlt{get;set;}
    public List<Coverage_Entitlement_Org__c> covEntltList;
    public String searchOrgH {get;set;}
    public Boolean showLookup {get;set;} 
    public String selectedOrgId {get;set;}
    public String orgHierCode {get;set;}
    //prepopulate all the picklist options
    public List<SelectOption> entTypes{get{
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult fieldResult = Coverage_Entitlement_Org__c.Coverage_Entitlement_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }set;}
    public String entitlementType {get;set;}
    public Boolean disableOrgText {get;set;}
    public Boolean isEdit {get;set;}
    public String errorMessage {get;set;}
    public String pageRecID {get;set;}
    public Coverage_Entitlement__c entitlements {get;set;}
    public Coverage_Entitlement_Org__c orgRecDet;
    public List<Org_Hierarchy__c> orgHLst{get;set;}
    public String idVal = '';
    public Boolean orgSearchFlag {get;set;}
    public Boolean superDivFlag {get;set;}
    public Boolean divFlag {get;set;}
    public Boolean supDeptFlag {get;set;}
    public Boolean deptFlag {get;set;}
    public Boolean subDeptFlag {get;set;}
    public Boolean subDept2Flag {get;set;}
    public Boolean costCenterFlag {get;set;}
    public RIF_OrgHierarchy_DataUtil dataUtil = new RIF_OrgHierarchy_DataUtil();
    public Boolean directSearch;
    public Integer totalRecs {get;set;}
    
    public RIF_OrgHierarchy_CovEnt(ApexPages.StandardController con) {
        covEntlt  = new Coverage_Entitlement_Org__c();
        errorMessage = '';
        directSearch = false; 
        
        pageRecID = ApexPages.currentPage().getParameters().get('Id');
        if(String.isBlank(pageRecID)){
            isEdit = false;
            disableOrgText = true;
            Coverage_Entitlement_Org__c currentPageRec = (Coverage_Entitlement_Org__c)con.getRecord();
            idVal = currentPageRec.Coverage_Entitlement__c;
            if(!String.isBlank(idVal))
                entitlements = dataUtil.setEntitlements(idVal);
        }
        else{
            openedInEditMode(pageRecID);
        }
    }
    
    // perform below steps if the page is opened in edit mode
    public void openedInEditMode(String recId){
        isEdit = true;
        disableOrgText = false;
        orgRecDet  = dataUtil.setEntitlementOrgs(recId);
        entitlements = dataUtil.setEntitlements(orgRecDet.Coverage_Entitlement__c);
        selectedOrgId = orgRecDet.Org_Hierarchy__c;
        orgHierCode = orgRecDet.Org_Hierarchy_Code__c;
        entitlementType = orgRecDet.Coverage_Entitlement_Type__c;
    }
    
    // method to save the selected coverage entitlement  
    public PageReference saveOrgEntitlement(){
        // perform basic validations
        if(String.isEmpty(entitlementType) || entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ENT_TYP));
            return null;
        }
        if(String.isEmpty(orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODE));
            return null;
        }
        if(!orgHierCode.contains(' - ')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_INV));
            return null;
        }
        if(!RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(entitlementType,orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODECHECK1));
            return null;
        }
        // assign all the variables for saving
        Database.SaveResult[] successResults;
        covEntltList  = new List<Coverage_Entitlement_Org__c>();
        
        covEntlt.Coverage_Entitlement__c = idVal;
        covEntlt.Coverage_Entitlement_Type__c = entitlementType;
        covEntlt.Org_Hierarchy_Code__c = orgHierCode;
        covEntltList.add(covEntlt);
        try{
            successResults = Database.insert(covEntltList, false);
        }
        catch(Exception exp){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()));
        }
        for(Integer i = 0 ; covEntltList.size() > i ; i++){
            Database.SaveResult result = successResults[i];
            Coverage_Entitlement_Org__c eachRec = covEntltList[i];
            if(!result.isSuccess()){
                for(Database.Error err : result.getErrors()){
                    errorMessage += 'Error Details : ' + err.getMessage();
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err.getMessage()));
                    system.debug(' -- Error while inserting coverage entl. ' + err);
                }
            }
        }
        if(String.isBlank(errorMessage)){
            PageReference pf = new PageReference('/' + covEntlt.Id );
            return pf;
        }
        return null;
    }
    
    // method to update the coverage entitlement 
    public PageReference updateOrgEntitlement(){
        // perform basic validations
        if(String.isEmpty(entitlementType) || entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ENT_TYP));
            return null;
        }
        if(String.isEmpty(orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODE));
            return null;
        }
        if(!orgHierCode.contains(' - ')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_INV));
            return null;
        }
        if(!RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(entitlementType,orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODECHECK1));
            return null;
        }
        // assign all the variables for saving
        Database.SaveResult[] successResults;
        covEntltList  = new List<Coverage_Entitlement_Org__c>();
        covEntlt  = new Coverage_Entitlement_Org__c();
        
        covEntlt.Id = pageRecID;
        covEntlt.Coverage_Entitlement_Type__c = entitlementType;
        covEntlt.Org_Hierarchy_Code__c = orgHierCode;
        covEntltList.add(covEntlt);
        
        try{
            successResults = Database.update(covEntltList,false);
        }
        catch(Exception exp){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()));
        }
        for(Integer i = 0 ; covEntltList.size() > i ; i++){
            Database.SaveResult result = successResults[i];
            Coverage_Entitlement_Org__c eachRec = covEntltList[i];
            if(!result.isSuccess()){
                for(Database.Error err : result.getErrors()){
                    errorMessage += 'Error Details : '+ err.getMessage();
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err.getMessage()));
                    system.debug(' -- Error while updating coverage entitlement ' + err);
                }
            }
        }
        if(String.isBlank(errorMessage)){
            PageReference pf = new PageReference('/' + pageRecID );
            return pf;
        }
        return null;
    }
    
    // method to insert the selected org, from the lookup box
    public void insertSelectedOrg(){
        showLookup = false;
        if(!String.isEmpty(selectedOrgId) && !entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            String finalOrgHierString = dataUtil.orgHierStrFormatter(selectedOrgId,entitlementType);
            orgHierCode = finalOrgHierString;
        }
    }
    
    public PageReference searchOrgCode(){
        orgSearchFlag = false;
        superDivFlag  = false;
        divFlag  = false;
        supDeptFlag  = false;
        deptFlag  = false;
        subDeptFlag  = false;
        subDept2Flag  = false;
        costCenterFlag  = false;
        Integer counter = 0; // counter to make sure that we display only 100 records on the UI
        totalRecs = 0;
        
        if(String.isBlank(entitlementType) || entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_NO_ENT));
            return null;
        }
        // 8-Nov-2016 : GM : Added validation for space and other special characters
        if(!String.isEmpty(searchOrgH) && !searchOrgH.isAlphanumericSpace()){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_SPACE_SPEC_CHAR));
            return null;
        }
        // Get all the search results from the entered keyword
        Map<String,Org_Hierarchy__c> resultMap;
        // check if the search keyword was directly put in the lookup text box
        if(directSearch){
            searchOrgH = orgHierCode;
            // 8-Nov-2016 : GM : Added validation for space and other special characters
            if(!String.isEmpty(orgHierCode) && !isEdit && !orgHierCode.isAlphanumericSpace()){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_SPACE_SPEC_CHAR));
                directSearch = false;
                return null;
            }
            if(orgHierCode != null && orgHierCode.length() < 3){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_3_CHARS));
                directSearch = false;
                return null;
            }
            if(orgHierCode.contains(' - ')){
                orgHierCode = orgHierCode.substringBefore(' - ');
            }
            resultMap = dataUtil.searchOrgHierarchies(entitlementType,orgHierCode);
            directSearch = false;
        }
        else{
            if(searchOrgH != null && searchOrgH.length() < 3){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_3_CHARS));
                return null;
            }
            resultMap = dataUtil.searchOrgHierarchies(entitlementType,searchOrgH);
        }
        orgHLst = new List<Org_Hierarchy__c>();
        
        if(!resultMap.isEmpty()){
            orgSearchFlag = true;
            // assign all the returned values from the map to a list which will be sorted
            List<Org_Hierarchy__c> orgHierList = new List<Org_Hierarchy__c>(resultMap.values());
            orgHierList.sort();
            for(Org_Hierarchy__c each : orgHierList){
                if(counter < 100){
                    Org_Hierarchy__c tempOrg = new Org_Hierarchy__c();
                    tempOrg.Id = each.Id;
                    if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                        superDivFlag = true;
                        tempOrg.Super_Division__c = String.valueOf(each.get('Super_Division__c'));
                        tempOrg.Super_Division_Description__c = String.valueOf(each.get('Super_Division_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                        divFlag = true;
                        tempOrg.Division__c = String.valueOf(each.get('Division__c'));
                        tempOrg.Division_Description__c = String.valueOf(each.get('Division_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                        supDeptFlag = true;
                        tempOrg.Super_Department__c = String.valueOf(each.get('Super_Department__c'));
                        tempOrg.Super_Department_Description__c = String.valueOf(each.get('Super_Department_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                        deptFlag = true;
                        tempOrg.Department__c = String.valueOf(each.get('Department__c'));
                        tempOrg.Department_Description__c = String.valueOf(each.get('Department_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                        subDeptFlag = true;
                        tempOrg.Sub_Department__c = String.valueOf(each.get('Sub_Department__c'));
                        tempOrg.Sub_Department_Description__c = String.valueOf(each.get('Sub_Department_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                        subDept2Flag = true;
                        tempOrg.Sub_Department_2__c = String.valueOf(each.get('Sub_Department_2__c'));
                        tempOrg.Sub_Department_2_Description__c = String.valueOf(each.get('Sub_Department_2_Description__c'));
                    }
                    else if(entitlementType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
                        costCenterFlag = true;
                        tempOrg.Super_Division__c = String.valueOf(each.get('Super_Division__c'));
                        tempOrg.Super_Division_Description__c = String.valueOf(each.get('Super_Division_Description__c'));
                        tempOrg.Division__c = String.valueOf(each.get('Division__c'));
                        tempOrg.Division_Description__c = String.valueOf(each.get('Division_Description__c'));
                        tempOrg.Department_ID__c = String.valueOf(each.get('Department_ID__c'));
                        tempOrg.Cost_Center_Description__c = String.valueOf(each.get('Cost_Center_Description__c'));
                    }
                    orgHLst.add(tempOrg);
                    counter++;
                }
            }
            totalRecs = counter;
            if(orgHLst == null || orgHLst.isEmpty()){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_NO_RES));
                return null;
            }
        }
        else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_NO_RES));
            return null;
        }
        return null;
    }
    
    public PageReference showOrgPopup(){
        // perform immediate search if there is value in the org code hierarchy field
        if(!String.isEmpty(orgHierCode)){
            directSearch = true;
            searchOrgCode();
        }
        showLookup = true;
        return null;
    }
    
    public PageReference cancelOrgPopup(){
        // reset all the flags and strings
        showLookup = false;
        searchOrgH = '';
        orgHierCode = '';
        orgSearchFlag = false;
        superDivFlag  = false;
        divFlag  = false;
        supDeptFlag  = false;
        deptFlag  = false;
        subDeptFlag  = false;
        subDept2Flag  = false;
        costCenterFlag  = false;
        return null;
    }
    
    public PageReference cancelMainPage(){
        PageReference pageRef = new PageReference('/' + idVal);
        return pageRef;
    }
    
    public PageReference cancelEditPage(){
        PageReference pageRef = new PageReference('/' + orgRecDet.Coverage_Entitlement__c );
        return pageRef;
    }
}