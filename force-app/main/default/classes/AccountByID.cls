public class AccountByID {
    @AuraEnabled
    public static Account AccById(Id accountid) {
        if(accountid == null) {
            return [SELECT ID,  Name, Type, Industry from Account LIMIT 1];
        }
        else{
            return [SELECT Id, Name, Type, Industry from Account where ID = :accountid];
        }     
    }
    
}