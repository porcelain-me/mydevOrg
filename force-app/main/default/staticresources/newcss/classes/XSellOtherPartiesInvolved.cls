public with sharing class XSellOtherPartiesInvolved {
    
    public Cross_Sell_Parties_Involved__c partyWrapper{get;set;}
    
    ApexPages.StandardSetController controller;
    
    public list<Cross_Sell_Parties_Involved__c> listPartiesInvolved{get;set;}
    
    public list<Employee__c> partyList{get;set;}
    public List<String> parties{get;set;}
    public Boolean partyPagePopup{get;set;}
    
    public List<partiesWrapper> wrapperList {get;set;}
    public Integer pos{get;set;}
    
    public String party {get;set;}
    public String partyName {get;set;}
    public string partySearch{get;set;}
    
    public boolean partyPopup{get;set;}
    
    public XSellOtherPartiesInvolved(ApexPages.StandardSetController controller) {
        this.wrapperList = new List<partiesWrapper>();
        this.controller = controller;
        // this.position = 0;
        listPartiesInvolved = new list<Cross_Sell_Parties_Involved__c>();
        
        Cross_Sell_Parties_Involved__c XSellParty1 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty1);
        
        /* Cross_Sell_Parties_Involved__c XSellParty2 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty2);
        
        Cross_Sell_Parties_Involved__c XSellParty3 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty3);
        
        Cross_Sell_Parties_Involved__c XSellParty4 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty4);
        */
        parties = new list<String>(listPartiesInvolved.size());
        try{
            partyList = [select Id, Name,first_name__c, Last_name__c,Business_Title__c,
                     citizenship_country__c from Employee__c limit 1];
        } catch(Exception e) {
            
        }
        /* for(Integer i=0;i<4; i++){
                wrapperList.add(new partiesWrapper());
        }*/
        
    }
    
    // public list<Cross_Sell_Parties_Involved__c> listPartiesInvolved{get;set;} 
    
    public XSellOtherPartiesInvolved(ApexPages.StandardController controller) {
        listPartiesInvolved = new list<Cross_Sell_Parties_Involved__c>();
        
        Cross_Sell_Parties_Involved__c XSellParty1 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty1);
        
        /* Cross_Sell_Parties_Involved__c XSellParty2 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty2);
        
        Cross_Sell_Parties_Involved__c XSellParty3 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty3);
        
        Cross_Sell_Parties_Involved__c XSellParty4 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty4);
        */
        try{
            partyList = [select Id, Name,first_name__c, Last_name__c,Business_Title__c,
                     citizenship_country__c from Employee__c limit 1];
        } catch(Exception e) {
            
        }
    }
    
    public Pagereference AddMoreParties() {
        Cross_Sell_Parties_Involved__c XSellParty1 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty1);
        
        Cross_Sell_Parties_Involved__c XSellParty2 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty2);
        
        Cross_Sell_Parties_Involved__c XSellParty3 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty3);
        
        Cross_Sell_Parties_Involved__c XSellParty4 = new Cross_Sell_Parties_Involved__c();
        listPartiesInvolved.add(XSellParty4);
        
        return null;
    }
    
    public PageReference SaveData() {
        system.debug('<');
        //try{
            for(Cross_Sell_Parties_Involved__c XSellParty: listPartiesInvolved) {
                XSellParty.Cross_Sell__c = ApexPages.CurrentPage().getParameters().get('XSellId');
            }
            
            list<Cross_Sell_Parties_Involved__c> XSellPartyList1 = new list<Cross_Sell_Parties_Involved__c>();
            for(Cross_Sell_Parties_Involved__c XSellParty: listPartiesInvolved) {
                if(XSellParty.Role__c != null) {
                    XSellPartyList1.add(XSellParty);
                }
            }
            
            system.debug('@@@@@@@@@'+XSellPartyList1);
            insert XSellPartyList1;
            //controller.save();
            return (new PageReference('/Apex/xs_opportunityEditP?id=' + ApexPages.CurrentPage().getParameters().get('XSellId')+ '&tab=Home'));
      //  } Catch(Exception e) {
       //   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
       //     ApexPages.addMessage(myMsg);
         //   return null;
       // }
        
    }
    
    public PageReference cancelData() {
        return (new PageReference('/apex/XS_OpportunityEditP?id='
                                  + ApexPages.CurrentPage().getParameters().get('XSellId')
                                  + '&tab=Home'));
    }
    
    public pagereference closewindow() {
        partyPopup = false;
        return null;  
        
    }
    
    /******************************************************************************************
    * SEARCH    
    *
    *******************************************************************************************/
    public PageReference searchParty(){
        system.debug('position is: '+pos);
        
        partyPopup = true;
        
        return null;
    }
    
    public PageReference filterPartySearch() {
        
        try{
            if(partySearch != null) {
                partyList.clear();
                string query = 'select id, name, first_name__c, Last_name__c,Business_Title__c,'
                    + 'citizenship_country__c  from Employee__c where Name like \'%'
                    + partySearch + '%\' OR Emp_Id__C = \'%' + partySearch + '%\' limit 10';
                partyList = Database.query(query);
            }
        } catch(Exception e) {
            
        }
        return null;
    }
    
    // Inner Class
    public class partiesWrapper{
        
        public String partyName{get;set;}
        
        public XSellOtherPartiesInvolved otherparty;
        public partiesWrapper(){
            partyName = '';
            otherparty.partyWrapper = new Cross_Sell_Parties_Involved__c();
        }
    }
    
    public void doNothing(){}
}