public class MyContactListController { 
    @AuraEnabled
public static List<Contact> getContact() {
    List<Contact> contacts =
[SELECT Id, Name, MailingStreet, Phone, Email, LeadSource FROM Contact ];
//Add isAccessible() check
return contacts;
}

}