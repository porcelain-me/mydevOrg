trigger Case_update on Case (before insert,before update) {
   List<Contact> Ct = New List<Contact>();
   { 
 for (Case c : trigger.new)
    { if (trigger.isINSERT) 
     
      Contact ca = new Contact(LastName = c.Description,
                             email = c.ContactEmail);
     Insert Ct;
    
       }
}
}