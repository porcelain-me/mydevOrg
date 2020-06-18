// Adding @isTest notation as this class is not used

@isTest
public with sharing class XSellOptyNotes {
    
    public String Notes{get;set;}
    
    private string XSellId;
    
    public XSellOptyNotes (){
        XSellId=ApexPages.CurrentPage().getParameters().get('XSellId');
    }
    
    public PageReference CancelNotes() {
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id=' + XSellId  + '&tab=Home');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference SaveNotes() {
        
        try{
            Cross_Sell_Opty_Notes__c OptyNotes = new Cross_Sell_Opty_Notes__c();
            //Cross_Sell__c xs = new Cross_Sell__c();
            
            OptyNotes.Notes__c = Notes;
            OptyNotes.Cross_Sell__c = XSellId;
            insert OptyNotes;
            
            Cross_Sell__c xs= [select id, name,Notes_By_Delegates__c from Cross_Sell__c  where id=:XSellId];
            
            xs.Notes_By_Delegates__c = OptyNotes.Cross_Sell__c;
            update xs;
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        PageReference p = new PageReference('/apex/xs_opportunityEditP?id=' + XSellId + '&tab=Home');
        p.setRedirect(true);
        return p;
    }
}