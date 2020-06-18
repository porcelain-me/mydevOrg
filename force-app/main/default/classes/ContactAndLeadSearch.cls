public class ContactAndLeadSearch {

    
    public static List<List< SObject>> searchContactsAndLeads(String s){
     List<List<sObject>> searchList = [FIND 'Smith' IN ALL FIELDS 
                   RETURNING Lead(LastName),Contact(FirstName,LastName,Department)];
Lead[] searchLeads = (Lead[])searchList[0];
Contact[] searchContacts = (Contact[])searchList[1];
System.debug('Found the following Leads.');
for (Lead a : searchLeads) {
    System.debug(a.LastName);
}
System.debug('Found the following contacts.');
for (Contact c : searchContacts) {
    System.debug(c.LastName + ', ' + c.FirstName);
}   return searchlist;
    }
    }