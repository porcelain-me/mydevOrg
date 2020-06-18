public with sharing class AccountController1 {
@AuraEnabled
public static List<Account> getAccounts() {
List<Account> Accounts =
[Select Id,Name,AccountNumber,Description FROM Account];
//Add isAccessible() check
return Accounts;
}
}