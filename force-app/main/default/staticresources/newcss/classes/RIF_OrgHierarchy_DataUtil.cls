/*** Data Util class for Org Hierarchy
 * All SOQLs and DMLs will be performed by this class
***/
public class RIF_OrgHierarchy_DataUtil {
    public String orgType,queryType,divType,finalOrgHierStr,keyword,searchParam = '';
    public List<Org_Hierarchy__c> orgHLst;
    public Map<String,Org_Hierarchy__c> orgHierMap;
    public Project_Decisional_Unit__c allPDUs;
    public Child_Project_Decisional_Unit__c childPDU;
    public Coverage_Entitlement__c entitlements;
    public Coverage_Entitlement_Org__c orgRecDet;
    public static Integer totalRecs {get;set;}
    
    // search from the keyword received from the user on the Org Hierarchy object
    public Map<String,Org_Hierarchy__c> searchOrgHierarchies(String unitType,String searchStr){
        keyword = searchStr.trim();
        searchParam = '%' + keyword + '%'; 
        orgHLst = new List<Org_Hierarchy__c>();
        orgHierMap = new Map<String,Org_Hierarchy__c>();
        
        if(!String.isBlank(keyword) && !unitType.equals(RIF_OrgHierarchy_Constants.NONE)){
            if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                divType = ' Super_Division__c, Super_Division_Description__c ';
                queryType = ' Super_Division__c LIKE :  searchParam  OR Super_Division_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                divType = ' Division__c, Division_Description__c ';
                queryType = ' Division__c LIKE :  searchParam  OR Division_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                divType = ' Super_Department__c, Super_Department_Description__c ';
                queryType = ' Super_Department__c LIKE : searchParam  OR Super_Department_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                divType = ' Department__c, Department_Description__c ';
                queryType = ' Department__c LIKE : searchParam OR Department_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                divType = ' Sub_Department__c, Sub_Department_Description__c ';
                queryType = ' Sub_Department__c LIKE :  searchParam  OR Sub_Department_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                divType = ' Sub_Department_2__c, Sub_Department_2_Description__c ';
                queryType = ' Sub_Department_2__c LIKE : searchParam OR Sub_Department_2_Description__c LIKE : searchParam ';
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
                divType = ' Super_Division__c,Super_Division_Description__c,Division__c, Division_Description__c,Department_ID__c, Cost_Center_Description__c ';
                queryType = ' Department_ID__c LIKE : searchParam OR Cost_Center_Description__c LIKE : searchParam ';
            } 
            if(!String.isBlank(queryType) && !String.isBlank(divType)) {
                String query = 'SELECT Id,Effective_Status__c,' + divType +'FROM Org_Hierarchy__c WHERE' + queryType ; 
                system.debug(' -- query -- ' + query);
                List<Org_Hierarchy__c> results = Database.query(query);
                system.debug(' -- results size() -- ' + results.size());
                
                if(results != null && !results.isEmpty()){
                    for(Org_Hierarchy__c each : results){
                        // get only the records that have effective_status as true
                        if(each.Effective_Status__c == true){
                            if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                                orgHierMap.put(each.Super_Division__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                                orgHierMap.put(each.Division__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                                orgHierMap.put(each.Super_Department__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                                orgHierMap.put(each.Department__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                                orgHierMap.put(each.Sub_Department__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                                orgHierMap.put(each.Sub_Department_2__c, each);
                            }
                            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
                                orgHierMap.put(each.Department_ID__c, each);
                            }
                        }
                    }
                }
            }
        } 
            return orgHierMap;
    }

    // method to insert the selected org, from the lookup box
    public String orgHierStrFormatter(String selectedOrgId, String unitType){
        if(!String.isEmpty(selectedOrgId)){
            Org_Hierarchy__c selcOrgRec = [SELECT Name,Super_Division__c,Super_Division_Description__c,Division__c,Division_Description__c,Super_Department__c,Super_Department_Description__c,Department__c,Department_Description__c,Sub_Department__c,Sub_Department_Description__c,Sub_Department_2__c,Sub_Department_2_Description__c,Department_ID__c,Cost_Center_Description__c FROM org_hierarchy__c WHERE Id =: selectedOrgId LIMIT 1];
            if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                finalOrgHierStr = selcOrgRec.Super_Division__c + ' - ' + selcOrgRec.Super_Division_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                finalOrgHierStr = selcOrgRec.Division__c + ' - ' + selcOrgRec.Division_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                finalOrgHierStr = selcOrgRec.Super_Department__c + ' - ' + selcOrgRec.Super_Department_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                finalOrgHierStr = selcOrgRec.Department__c + ' - ' + selcOrgRec.Department_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                finalOrgHierStr = selcOrgRec.Sub_Department__c + ' - ' + selcOrgRec.Sub_Department_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                finalOrgHierStr = selcOrgRec.Sub_Department_2__c + ' - ' + selcOrgRec.Sub_Department_2_Description__c ;
            }
            else if(unitType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
                finalOrgHierStr = selcOrgRec.Department_ID__c + ' - ' + selcOrgRec.Cost_Center_Description__c ;
            }
        }
        return finalOrgHierStr;
    }
    
     // method to set the PDU details on the page
    public Project_Decisional_Unit__c setPDUs(String idOfRec){
        allPDUs = [SELECT Name,Decisional_Unit_Name__c,Employee__c,HR_Signatory__c,Project__c FROM Project_Decisional_Unit__c WHERE Id =: idOfRec];
        return allPDUs;
    }
    
    //method to set the org level PDU details on the page
    public Child_Project_Decisional_Unit__c setChildPDU(String idOfRec){
        childPDU = [SELECT Id,Name,Project_Decisional_Unit__c,Employee__c,Decisional_Unit_Type__c,Org_Hierarchy_Code__c,Org_Hierarchy__c FROM Child_Project_Decisional_Unit__c WHERE ID =: idOfRec LIMIT 1];
        return childPDU;
    }
    
    // method to set the entitlement details on the page
    public Coverage_Entitlement__c setEntitlements(String idOfRec){
        entitlements = [SELECT name, HR_EmpID__c, HR_Name__c FROM Coverage_Entitlement__c WHERE id =: idOfRec];
        return entitlements;
    }
    
    public Coverage_Entitlement_Org__c setEntitlementOrgs(String recId){
        orgRecDet = [SELECT Id,Name,Coverage_Entitlement__c,Coverage_Entitlement_Type__c,Org_Hierarchy_Code__c,Org_Hierarchy__c FROM Coverage_Entitlement_Org__c WHERE ID =: recId LIMIT 1];
        return orgRecDet;
    }
    
    // check if the org hierarchy code is valid or not,
    // first check if the string contains ' - ' chars, then extract the seperate org codes and org desc,
    // and then finally check if the unity type is missing or not
    public static Boolean validOrgCodeCheck(String deptType, String codeString){
        Boolean returnFlag = false;
        String qryStr,qryFields,qryType,orgCode,orgDesc = '';
        
        if(!codeString.contains(' - ')){
            return false;
        }
        else{
            orgCode = codeString.substringBefore(' - ');
            orgDesc = codeString.substringAfter(' - ');
            if(String.isEmpty(orgCode) || String.isEmpty(orgDesc)){
                return false;
            }
        }
        if(!String.isEmpty(deptType)){
            if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DIV)){
                qryFields = ' Super_Division__c, Super_Division_Description__c ';
                qryType = ' Super_Division__c = :  orgCode  AND Super_Division_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DIV)){
                qryFields = ' Division__c, Division_Description__c ';
                qryType = ' Division__c = :  orgCode  AND Division_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUP_DEPT)){
                qryFields = ' Super_Department__c, Super_Department_Description__c ';
                qryType = ' Super_Department__c = : orgCode  AND Super_Department_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.DEPT)){
                qryFields = ' Department__c, Department_Description__c ';
                qryType = ' Department__c = : orgCode AND Department_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT)){
                qryFields = ' Sub_Department__c, Sub_Department_Description__c ';
                qryType = ' Sub_Department__c = :  orgCode  AND Sub_Department_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.SUB_DEPT_2)){
                qryFields = ' Sub_Department_2__c, Sub_Department_2_Description__c ';
                qryType = ' Sub_Department_2__c = : orgCode AND Sub_Department_2_Description__c = : orgDesc ';
            }
            else if(deptType.equalsIgnoreCase(RIF_OrgHierarchy_Constants.COST_CEN)){
                qryFields = ' Department_ID__c, Cost_Center_Description__c ';
                qryType = ' Department_ID__c = : orgCode AND Cost_Center_Description__c = : orgDesc ';
            } 
            qryStr = 'SELECT' + qryFields + 'FROM Org_Hierarchy__c WHERE' + qryType;
            List<Org_Hierarchy__c> orgRes = Database.query(qryStr);
            if(!orgRes.isEmpty()){
                return true;
            }
        }
        return false;
    }
}