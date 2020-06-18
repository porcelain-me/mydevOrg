public class ER_PINewButtonController{
    
    static final String ER_COMPLIANCE = 'ER_Compliance';
    static final String ER_HUMAN_RESOURCES = 'ER_Human_Resources';
    
    //Id discRecordTypeId = Schema.SObjectType.Parties_Involved__c.getRecordTypeInfosByName().get('Compliance_Parties_Involved').getRecordTypeId();
    //Id hrRecordTypeId = Schema.SObjectType.Parties_Involved__c.getRecordTypeInfosByName().get('HR_Parties_Involved').getRecordTypeId();
    
    public ER_PINewButtonController(ApexPages.StandardController controller) {
    }
    
    public pagereference buttonRedirect(){
     
    Id loggedIndUserId = UserInfo.getUserId();
    List<PermissionSetAssignment> permSet = new List<PermissionSetAssignment>();
    permSet = [SELECT Id, Assignee.Name, PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id =: loggedIndUserId];
    Set<String> permSetAssgn = new Set<String>();
    
        for(PermissionSetAssignment psa: permset){
        permSetAssgn .add(psa.PermissionSet.Name);
        }
  
        if(permSetAssgn .contains(ER_COMPLIANCE)){
       
        PageReference pageRef = PAGE.ER_CreateEditPartiesInvolved;     
        return pageRef ;
       
        }
    
        else if(permSetAssgn .contains(ER_HUMAN_RESOURCES)){
    
        PageReference pageRef = PAGE.ER_CreateEditPartiesInvolved;   
        return pageRef ;
        
        }
        
       Schema.DescribeSObjectResult gen = Parties_Involved__c.SObjectType.getDescribe();
       string genUrl= '/'+gen.getKeyprefix()+'/e';                                                
       system.debug('genUrl: ' + genUrl);
        
       PageReference genPageRef = new PageReference(genUrl);     
       return genPageRef;  
    }
    
   
}