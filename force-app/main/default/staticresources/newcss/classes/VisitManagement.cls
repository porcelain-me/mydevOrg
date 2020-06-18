public class VisitManagement{

public list<Visitor_Signin__c> ChecdinList{get;set;}
public list<Visitor_Signin__c> InvitedList{get;set;}

public VisitManagement(){
ChecdinList=new list<Visitor_Signin__c>();
InvitedList=new list<Visitor_Signin__c>();
InvitedList=[select name,First_Name__c,Meeting_Name__c,Passport_Number__c,Locations__r.name,Host_Name__r.name from Visitor_Signin__c where Status__c='Invited' ];
ChecdinList=[select name,First_Name__c,Meeting_Name__c,Passport_Number__c,Locations__r.name,Host_Name__r.name from Visitor_Signin__c where Status__c='checked-in' ];
}




}