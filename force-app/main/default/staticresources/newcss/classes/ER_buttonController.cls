public class ER_buttonController {
    public boolean state1 {get;set;}
    static final String ER_COMPLIANCE = 'ER_Compliance';
    static final String ER_HUMAN_RESOURCES = 'ER_Human_Resources';
    
    Id discRecordTypeId = Schema.SObjectType.Case__c.getRecordTypeInfosByName().get('Discipline').getRecordTypeId();
    Id hrRecordTypeId = Schema.SObjectType.Case__c.getRecordTypeInfosByName().get('HR').getRecordTypeId();
    
    public ER_buttonController(ApexPages.StandardController controller) {
    state1 =false;
    }
    
    public PageReference buttonRedirect(){
     
    Id loggedIndUserId = UserInfo.getUserId();
    List<PermissionSetAssignment> permSet = new List<PermissionSetAssignment>();
    permSet = [SELECT Id, Assignee.Name, PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id =: loggedIndUserId];
    Set<String> permSetAssgn = new Set<String>();
    
        for(PermissionSetAssignment psa: permset){
            permSetAssgn .add(psa.PermissionSet.Name);
        }
       
        if(((permSetAssgn .contains(ER_HUMAN_RESOURCES)) && (permSetAssgn .contains(ER_COMPLIANCE)))){
            
            System.debug('here 1');
            Schema.DescribeSObjectResult objr = Case__c.SObjectType.getDescribe();
            String genurl = '/'+objr .getKeyprefix()+'/e'+'?'+'nooverride'+'=1';   
            Pagereference pageRefer = new Pagereference(genurl );  
            return pageRefer ; 
       }
        
        
        else if(permSetAssgn .contains(ER_COMPLIANCE)){
        System.debug('here 2');
            Id id = ApexPages.CurrentPage().getParameters().get('id');
            Schema.DescribeSObjectResult r = Case__c.SObjectType.getDescribe();
            String discurl = '/'+r.getKeyprefix()+'/e'+'?'+'nooverride'+'=1&RecordType'+'='+discRecordTypeId ;                                                
            System.debug('discurl : ' + discurl );
        
            Pagereference pageRe = new Pagereference(discurl);
            return pageRe;
       
        }
    
        else if(permSetAssgn .contains(ER_HUMAN_RESOURCES)){
    System.debug('here 3');
            Id id = ApexPages.CurrentPage().getParameters().get('id');
            Schema.DescribeSObjectResult r = Case__c.SObjectType.getDescribe();
            String hrurl = '/'+r.getKeyprefix()+'/e'+'?'+'nooverride'+'=1&RecordType'+'='+hrRecordTypeId ;                                                
            System.debug('hrurl : ' + hrurl );
        
            PageReference pageRef = new PageReference(hrurl); 
           
            return pageRef ;
       
        }
     // state1 = true;    
      //throw new RecordNotfoundException('Hi--'+state1);
       
       
            Schema.DescribeSObjectResult objr = Case__c.SObjectType.getDescribe();
            String genurl = '/'+objr .getKeyprefix()+'/e'+'?'+'nooverride'+'=1';   
            Pagereference pageRefer = new Pagereference(genurl );  
            return pageRefer ;
    }
    
}