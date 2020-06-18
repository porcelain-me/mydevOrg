/*********************************************************************************
*
*Change Log:
* 04/2/14 - MRM Created class to support manager review and approval of signatures
**********************************************************************************/
public with sharing class FFAP_Mgr_Approval {
    
    User u;
    String sfBaseUrl = string.valueOf(URL.getSalesforceBaseUrl());
    public Boolean recordsFoundP {get;set;}
    public Boolean recordsFoundC {get;set;}
    
    private String sortDirection = 'ASC';  
    private String sortExp = 'dsfs__Date_Sent__c';  
    
    public List<dsfs__Docusign_Recipient_Status__c> pList {get;set;}
    public List<dsfs__Docusign_Recipient_Status__c> cList {get;set;}
    
    public String envId {get;set;}
    public FFAP_Mgr_Approval(){     
         
            
        u = [select email from user where id = :UserInfo.getUserId()];
        
        cList = new List<dsfs__Docusign_Recipient_Status__c>();
        pList = new List<dsfs__Docusign_Recipient_Status__c>();
        
        buildListP();
        buildListC();
    }
    
    
    public void buildListP(){
        
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        
        String query = 'Select '; 
        query +=        'dsfs__Date_Sent__c ';
        query +=        ',dsfs__Parent_Status_Record__c ';
        query +=        ',dsfs__Parent_Status_Record__r.FFAP_Record__r.employee__r.name ';
        query +=        ',dsfs__Envelope_Id__c ';
        query +=        ',dsfs__Parent_Status_Record__r.FFAP_Record__r.name ';
        query +=        ',dsfs__Parent_Status_Record__r.dsfs__Subject__c '; 
        query +=        'From dsfs__DocuSign_Recipient_Status__c ';
        query +=        'where dsfs__DocuSign_Recipient_Email__c = '+'\''+String.escapeSingleQuotes(u.email)+'\'';
        query +=        'and dsfs__Recipient_Status__c in' + '(' + '\'' + 'Sent' + '\'' + ',' + '\'' + 'Delivered' + '\'' + ') ';
        query +=        'and dsfs__DocuSign_Routing_Order__c > 1 ';
        query +=    'order by  ' + sortFullExp;     
                
        system.debug('query is:' + query);
            
        pList = Database.query(query);
        
        if (pList.size() > 0)
            recordsFoundP = true;
        
    }
    
    public void buildListc(){
        
        cList = [Select 
                     dsfs__Date_Signed__c
                    ,dsfs__Parent_Status_Record__c
                    ,dsfs__Parent_Status_Record__r.FFAP_Record__r.employee__r.name
                    ,dsfs__Envelope_Id__c
                    ,dsfs__Parent_Status_Record__r.FFAP_Record__r.name
                    ,dsfs__Parent_Status_Record__r.dsfs__Subject__c
                From dsfs__DocuSign_Recipient_Status__c 
                where dsfs__DocuSign_Recipient_Email__c = :u.email
                and dsfs__Recipient_Status__c in ('Completed') 
                and dsfs__DocuSign_Routing_Order__c > 1
                ];      
                
        if (cList.size() > 0)
            recordsFoundC = true;
        
    }
     
     
    public String sortExpression   
    {     get     {        return sortExp;     }    
          set     {       //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)    
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';    
            else  
                sortDirection = 'ASC';       sortExp = value;     }  
    } 
    
    public String getSortDirection() {    //if not column is selected  
        if (sortExpression == null || sortExpression == '')         
            return 'ASC';    
        else     
            return sortDirection; } 
                
    public void setSortDirection(String value) { 
            sortDirection = value; 
    }  
    
    public pageReference goToSigning(){
         
        system.debug('envid:' + envId);
            
        String url;
        
        String retUrl =  System.Label.DG_BaseUrl +  '/apex/FFAP_Mgr_Approval';
        
        if (envId != null){
            DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(envId,retUrl);
            url = g.getDocusignURLForSigning();
        }
        else  //default return url is in system label
            url = System.Label.DG_EmbeddedSigningReturnUrl;
        system.debug('URL is' + url);
            
        /* route the user to the document */
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
             
    }
    
    public pageReference goToFAP(){
        
        
        String retUrl = 'http://fap';
        
            
        /* route the user to the document */
        PageReference page = new PageReference(retUrl);
        page.setRedirect(true);
        return page;
        
             
    }
}