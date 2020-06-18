public with sharing class RequestAccess {

Request_Access__c req;

 public PageReference save() {

       
        insert req;
         PageReference acctPage = new ApexPages.StandardController(req).view();

        acctPage.setRedirect(true);

        return acctPage;


}
}