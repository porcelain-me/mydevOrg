public with sharing class RIF_OrgHierarchy_OrgLevelPDU {
    
    public Child_Project_Decisional_Unit__c childPDU {get;set;}
    public Child_Project_Decisional_Unit__c newChildPDU;
    public List<Child_Project_Decisional_Unit__c> childPDUList;
    public Project_Decisional_Unit__c allPDUs {get;set;}
    public String searchOrgH {get;set;}
    public Boolean showLookup {get;set;} 
    public String selectedOrgId {get;set;}
    public String orgHierCode {get;set;}
    public String selectedEmp {get;set;}
    //prepopulate all the picklist options
    public List<SelectOption> unitTypes{get{
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult fieldResult = Child_Project_Decisional_Unit__c.Decisional_Unit_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }set;}
    public String decisionalUnitType {get;set;}
    public String errorMessage {get;set;}
    public Boolean disableOrgText {get;set;}
    public Boolean isEdit {get;set;}
    public String pageRecID {get;set;}
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
    public Integer totalRecs {get;set;}
    public Boolean directSearch;
    
    public RIF_OrgHierarchy_OrgLevelPDU(ApexPages.StandardController con){
        childPDU = new Child_Project_Decisional_Unit__c();
        errorMessage = '';
        directSearch = false;
        
        pageRecID = ApexPages.currentPage().getParameters().get('Id');
        if(String.isBlank(pageRecID)){
            isEdit = false;
            disableOrgText = true;
            // commented these as a custom New button will be used
            //Child_Project_Decisional_Unit__c currentPageRec = (Child_Project_Decisional_Unit__c)con.getRecord();
            //idVal = currentPageRec.Project_Decisional_Unit__c;
            idVal = ApexPages.currentPage().getParameters().get('PDUId');
            if(!String.isBlank(idVal)){
                allPDUs = dataUtil.setPDUs(idVal);
            }
        }
        else{
            openedInEditMode(pageRecID);
        }
    }
    
    // perform below steps if the page is opened in edit mode
    public void openedInEditMode(String recId){
        isEdit = true;
        childPDU = dataUtil.setChildPDU(recId);
        allPDUs = dataUtil.setPDUs(childPDU.Project_Decisional_Unit__c);
        selectedOrgId = childPDU.Org_Hierarchy__c;
        orgHierCode = childPDU.Org_Hierarchy_Code__c;
        decisionalUnitType = childPDU.Decisional_Unit_Type__c;
    }
    
    // method to save the selected org PDU
    public PageReference saveOrgPDU(){
        // perform basic validations
        if(String.isEmpty(decisionalUnitType) || decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_DECI_UNIT));
            return null;
        }
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && String.isEmpty(orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODE));
            return null;
        }
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && !orgHierCode.contains(' - ')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_INV));
            return null;
        }
        if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && String.isEmpty(childPDU.Employee__c)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_EMP));
            return null;
        }
        if(!String.isEmpty(childPDU.Employee__c) && !String.isEmpty(orgHierCode)){
        	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_EMP_WITH_ORGHIER));
            return null;
        }
        // 3-Apr-2017 : JIRA#RIF-22 : Checks for employee level PDU
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && !RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(decisionalUnitType,orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODECHECK));
            return null;
        }
        // assign all the variables for saving
        Database.SaveResult[] successResults;
        childPDUList = new List<Child_Project_Decisional_Unit__c>();
        newChildPDU = new Child_Project_Decisional_Unit__c();
        
        newChildPDU.Project_Decisional_Unit__c = idVal;
        newChildPDU.Decisional_Unit_Type__c = decisionalUnitType;
        newChildPDU.Org_Hierarchy_Code__c = orgHierCode;
        newChildPDU.Employee__c = childPDU.Employee__c;
        childPDUList.add(newChildPDU);
        try{
            successResults = Database.insert(childPDUList, false);
        }
        catch(Exception exp){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()));
        }
        
        for(Integer i = 0 ; childPDUList.size() > i ; i++){
            Database.SaveResult result = successResults[i];
            Child_Project_Decisional_Unit__c eachRec = childPDUList[i];
            if(!result.isSuccess()){
                for(Database.Error err : result.getErrors()){
                    errorMessage += 'Error Details : ' + err.getMessage();
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err.getMessage()));
                    system.debug(' -- Error while inserting child PDU ' + err);
                }
            }
        }
        if(String.isBlank(errorMessage)){
            PageReference pf = new PageReference('/' + childPDUList[0].Id );
            return pf;
        }
        return null;
    }
    
    // method to update the org PDU 
    public PageReference updatePDUOrg(){
        // perform basic validations
        if(String.isEmpty(decisionalUnitType) || decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_DECI_UNIT));
            return null;
        }
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && String.isEmpty(orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODE));
            return null;
        }
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && !orgHierCode.contains(' - ')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_INV));
            return null;
        }
        if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && String.isEmpty(childPDU.Employee__c)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_EMP));
            return null;
        }
        if(!String.isEmpty(childPDU.Employee__c) && !String.isEmpty(orgHierCode)){
        	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_EMP_WITH_ORGHIER));
            return null;
        }
        // 3-Apr-2017 : JIRA#RIF-22 : Checks for employee level PDU
        if(!decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP) && !RIF_OrgHierarchy_DataUtil.validOrgCodeCheck(decisionalUnitType,orgHierCode)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_ORG_CODECHECK));
            return null;
        }
        
        Database.SaveResult[] successResults;
        childPDUList = new List<Child_Project_Decisional_Unit__c>();
        
        childPDU.Id = pageRecID;
        childPDU.Decisional_Unit_Type__c = decisionalUnitType;
        childPDU.Org_Hierarchy_Code__c = orgHierCode;
        childPDU.Employee__c = childPDU.Employee__c;
        childPDUList.add(childPDU);
        try{
            successResults = Database.update(childPDUList,false);
        }
        catch(Exception exp){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()));
        }
        for(Integer i = 0 ; childPDUList.size() > i ; i++){
            Database.SaveResult result = successResults[i];
            Child_Project_Decisional_Unit__c eachRec = childPDUList[i];
            if(!result.isSuccess()){
                for(Database.Error err : result.getErrors()){
                    errorMessage += 'Error Details : '+ err.getMessage();
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err.getMessage()));
                    system.debug(' -- Error while updating child PDU ' + err);
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
        if(!String.isEmpty(selectedOrgId) && !decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            String finalOrgHierString = dataUtil.orgHierStrFormatter(selectedOrgId,decisionalUnitType);
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
        
        if(String.isBlank(decisionalUnitType) || decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.NONE)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_NO_DECI));
            return null;
        }
        // 8-Nov-2016 : GM : Added validation for space and other special characters
        if(!String.isEmpty(searchOrgH) && !searchOrgH.isAlphanumericSpace()){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_SPACE_SPEC_CHAR));
            return null;
        }
        if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.EMP)){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_DECI_EMP));
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
            resultMap = dataUtil.searchOrgHierarchies(decisionalUnitType,orgHierCode);
            directSearch = false;
        }
        else{
            if(searchOrgH != null && searchOrgH.length() < 3){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, RIF_OrgHierarchy_Constants.ERR_3_CHARS));
                return null;
            }
            resultMap = dataUtil.searchOrgHierarchies(decisionalUnitType,searchOrgH);
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
                    if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                        superDivFlag = true;
                        tempOrg.Super_Division__c = String.valueOf(each.get('Super_Division__c'));
                        tempOrg.Super_Division_Description__c = String.valueOf(each.get('Super_Division_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                        divFlag = true;
                        tempOrg.Division__c = String.valueOf(each.get('Division__c'));
                        tempOrg.Division_Description__c = String.valueOf(each.get('Division_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                        supDeptFlag = true;
                        tempOrg.Super_Department__c = String.valueOf(each.get('Super_Department__c'));
                        tempOrg.Super_Department_Description__c = String.valueOf(each.get('Super_Department_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                        deptFlag = true;
                        tempOrg.Department__c = String.valueOf(each.get('Department__c'));
                        tempOrg.Department_Description__c = String.valueOf(each.get('Department_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                        subDeptFlag = true;
                        tempOrg.Sub_Department__c = String.valueOf(each.get('Sub_Department__c'));
                        tempOrg.Sub_Department_Description__c = String.valueOf(each.get('Sub_Department_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                        subDept2Flag = true;
                        tempOrg.Sub_Department_2__c = String.valueOf(each.get('Sub_Department_2__c'));
                        tempOrg.Sub_Department_2_Description__c = String.valueOf(each.get('Sub_Department_2_Description__c'));
                    }
                    else if(decisionalUnitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
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
        // perform immediate search if there is value in the org hierarchy code field
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
    // go back to the parent PDU
    public PageReference cancelMainPage(){
        PageReference pageRef = new PageReference('/' + idVal);
        return pageRef;
    }
    // go back to the parent PDU
    public PageReference cancelEditPage(){
        PageReference pageRef = new PageReference('/' + childPDU.Project_Decisional_Unit__c);
        return pageRef;
    }
}