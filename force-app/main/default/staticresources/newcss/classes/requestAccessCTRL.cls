public with sharing class requestAccessCTRL {

    public PageReference cancel() {
        return null;
    }




    public Request_Access__c req { get; set; }

    // Here initialize the book object
    public requestAccessCTRL () {
        req  = new Request_Access__c();
    }

    public PageReference addNewReq() { 
        insert req ; 
        return null; 
    }


}