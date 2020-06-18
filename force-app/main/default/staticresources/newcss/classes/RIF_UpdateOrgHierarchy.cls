global class RIF_UpdateOrgHierarchy implements Database.Batchable<SObject>{
    
    private final String  query;
    
    global RIF_UpdateOrgHierarchy (String q){
    System.debug('***************Querry*********'+q);
       query=q;
   
    }
    
    
/*********************** Start Method of the Batch Class*********/    
    global Database.QueryLocator start(Database.BatchableContext bc){
         System.debug('***************Querry*********'+query);
        return Database.getQueryLocator(query);
    }
    
    
/********************Execute Method of the Batch Class*******/
    global void execute(Database.BatchableContext bc, List<Coverage_Entitlement_Org__c> scope){
        
        List<Coverage_Entitlement_Org__c> UpdatedOrg = new List<Coverage_Entitlement_Org__c>();
        
        for(Coverage_Entitlement_Org__c obj : scope){
        
            if(obj.Coverage_Entitlement_Org_Code__c != null){ 
                
                System.debug(obj.Coverage_Entitlement_Org_Code__c);
                
                if(String.isBlank(obj.Org_Hierarchy_Code__c)){
                
                    obj.Org_Hierarchy_Code__c = obj.Coverage_Entitlement_Org_Code__r.name ;
                    UpdatedOrg.add(obj);
                    System.debug(obj.Org_Hierarchy_Code__c);
                    
                }   
                
            }
        }
        
        
        
        
        if(UpdatedOrg!=null && !UpdatedOrg.isEmpty())
        update UpdatedOrg;    
    }  
    
/*********************************Finish Method of the Batch Class ************/

    global void finish(Database.BatchableContext bc){
    }    
}