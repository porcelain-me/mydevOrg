public with sharing class AccountController {
    @AuraEnabled 
    
    public static List<account> getAccounts() {
    return [SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone
    FROM Account ORDER BY createdDate ASC];
  }
        
    
    
}