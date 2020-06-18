/** Batch class to check the updated Org Hierarchy records and process it to recalculate sharing rules
 for Severance and Release object based on the updated Cost center and other information  **/
global class OrgHierarchySharingRecalBatch implements Database.Batchable<sObject>{
    // member initialization
    // TODO -- put as static final
    public List<Coverage_Entitlement__c> coverEntMasterList;
    public List<String> empList;
    public List<Severance_And_Release__Share> shareRec = new List<Severance_And_Release__Share>();
    String queryOrgHier = 'SELECT TREE_Effective_Date__c,Effective_Status__c,JV_Department_Flag__c,Location__c,Region__c,Country_Code__c,Super_Division__c,Super_Division_Description__c,Division__c,Division_Description__c,Super_Department__c,Super_Department_Description__c,Department__c,Department_Description__c,Sub_Department__c,Sub_Department_Description__c,Sub_Department_2__c,Sub_Department_2_Description__c,Department_ID__c,Cost_Center_Description__c,Rollup_Cost_Center_JV_Name__c,Location_Description__c,Country_Description__c FROM Org_Hierarchy__c'; 
    String queryCoverEnt = 'SELECT HR_Name__c,HR_EmpID__c,(SELECT Coverage_Entitlement_Org_Code__c,Coverage_Entitlement_Org_Code_Derived__c,Coverage_Entitlement_Type__c,HR_EmpID__c FROM HR_Coverage_Orgs__r) FROM Coverage_Entitlement__c';
    // constructor 
    global OrgHierarchySharingRecalBatch(){
        //querying all the coverage entitlements
        coverEntMasterList = Database.query(queryCoverEnt);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        // TODO -- will we have this flag that will be updated after each batch?
        String whereClause = ' WHERE Is_Updated__c = true';
        queryOrgHier += whereClause;
        return Database.getQueryLocator(queryOrgHier);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope){
        // loop through the new data and find the org codes
        system.debug(' -- bc -- ' + bc);
        Map<String,String> orgCodeMap = new Map<String,String>();
        for(sObject eachObj: scope){
            Org_Hierarchy__c orgHirearchy = (Org_Hierarchy__c)eachObj;
            orgCodeMap.put(orgHirearchy.Super_Division__c,orgHirearchy.Super_Division_Description__c);
            orgCodeMap.put(orgHirearchy.Division__c,orgHirearchy.Division_Description__c);
            orgCodeMap.put(orgHirearchy.Super_Department__c,orgHirearchy.Super_Department_Description__c);
            orgCodeMap.put(orgHirearchy.Department__c,orgHirearchy.Department_Description__c);
			orgCodeMap.put(orgHirearchy.Sub_Department__c,orgHirearchy.Sub_Department_Description__c);
            orgCodeMap.put(orgHirearchy.Sub_Department_2__c,orgHirearchy.Sub_Department_2_Description__c);
            orgCodeMap.put(orgHirearchy.Department_ID__c,orgHirearchy.Cost_Center_Description__c);
        }
        system.debug(' -- orgCodeMap -- ' + orgCodeMap);
        system.debug(' -- coverEntMasterList -- ' + coverEntMasterList);
        // go over each coverage entitlement
        empList = new List<String>();
        for(Coverage_Entitlement__c eachEnt:  coverEntMasterList){
            system.debug(' -- eachEnt -- ' + eachEnt);
            for(Coverage_Entitlement_Org__c eachOrg :eachEnt.HR_Coverage_Orgs__r){
                system.debug(' -- eachOrg --' + eachOrg);
                if(orgCodeMap.keySet().contains(eachOrg.Coverage_Entitlement_Org_Code_Derived__c)){
                    empList.add(eachEnt.HR_Name__c);
                }
            }
        }
        system.debug(' -- empList -- ' + empList);
        List<Severance_And_Release__Share> sharingList = getAllUserDetailsFromSnRShare(empList);
        // update the _share object
    }
    public List<Severance_And_Release__Share> getAllUserDetailsFromSnRShare(List<String> listOfEmpIds){
        shareRec = [SELECT UserOrGroupId, RowCause, ParentId, LastModifiedDate, LastModifiedById, IsDeleted, Id, AccessLevel FROM Severance_And_Release__Share WHERE UserOrGroupId IN : listOfEmpIds];
        return shareRec;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}