public with sharing class FoodsController {

    public String LoggedInUser { get; set; }
    public String userName{get;set;}
    public Boolean orderCount{get;set;}
    public List<Food_Order__c> ordersList {get;set;}
    public Food_Order__c foodOr {get;set;}
    
    Id loggedInUserId = UserInfo.getUserId();
    Id loggedInProfileId = UserInfo.getProfileId();
 
 public FoodsController (){
 
         ordersList= [Select Id,Name,Food_Name__c,Location__c,Pick_Up_Date_Time__c,Region__c,Requestor_Name__c,Submitted_By__c from Food_Order__c ORDER BY Name DESC  limit 10];
 }
 
 
    public pageReference create(){
        PageReference p = new PageReference('/apex/Foods_orderCreate');
        p.setRedirect(true);
        return p; 
        
        
    }
    
     public PageReference deleteOrders(){
         return null;
         }
}