/*** 24-Sep-2016 : Defect#1743 : Org Hierarchy related changes
Batch class to reassign the existing Coverage Entitlements to new Org Hierarchy fields.
This will be a ONE time run
**/
global class RIF_OrgHierarchy_CovEntReassignBATCH implements Database.Batchable<SObject>{
    public static String query = 'SELECT Id,Org_Hierarchy_Code__c,Coverage_Entitlement_Org_Code__r.Name,Coverage_Entitlement_Org_Code__r.Code_Type__c,Coverage_Entitlement_Org_Code__r.Code__c,Coverage_Entitlement_Org_Code__r.Description__c FROM Coverage_Entitlement_Org__c WHERE (Org_Hierarchy_Code__c = null OR Org_Hierarchy_Code__c = \'\') AND Coverage_Entitlement_Org_Code__c != null';
    public static Map<String,Map<String,String>> allOrgHier = new Map<String,Map<String,String>>();
    
    global Database.QueryLocator start(Database.BatchableContext c){ 
        // get all org hierarchy data
        
        String orgHierQuery = 'SELECT Id,Effective_Status__c, Super_Division__c, Super_Division_Description__c, Division__c, Division_Description__c, Super_Department__c, Super_Department_Description__c, Department__c, Department_Description__c, Sub_Department__c, Sub_Department_Description__c, Sub_Department_2__c, Sub_Department_2_Description__c, Department_ID__c, Cost_Center_Description__c, Rollup_Cost_Center_JV_Name__c, Location_Description__c, Country_Description__c FROM org_hierarchy__c WHERE Effective_Status__c = true';    
        List<Org_Hierarchy__c> results = Database.query(orgHierQuery);
        
        for(Org_Hierarchy__c eachOrgHier : results){
            if(eachOrgHier.Super_Division__c != ''){
                
            }
        }
        
        
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext c, List<Coverage_Entitlement_Org__c> objects) {
        List<Org_Codes__c> orgCodesList = new List<Org_Codes__c>();
        Set<String> allOrgCodes = new Set<String>();
        Map<String,Map<String,String>> orgCodesMap = new Map<String,Map<String,String>>();
        
        for(Coverage_Entitlement_Org__c each : objects){
            Map<String,String> tempMap = new Map<String,String>();
            tempMap.put(each.Coverage_Entitlement_Org_Code__r.Code__c,each.Coverage_Entitlement_Org_Code__r.Description__c);
            orgCodesMap.put(each.Id,tempMap);
        }
        // send the map to get the corresponding org hierarchy mapping
        //getOrgHierarchyDetails(orgCodesMap);
    }
    /*
public Map<String,Map<String,String>> getOrgHierarchyDetails(Map<String,Map<String,String>> orgCodesMap){
String theQuery = ''
} 
*/
    global void finish(Database.BatchableContext c) {
        // do nothing
    }
}