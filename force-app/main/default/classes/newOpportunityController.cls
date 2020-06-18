public class newOpportunityController {

  
   Account account;
   Contact contact;
   Opportunity opportunity;
   OpportunityContactRole role;


  
   public Account getAccount() {
      if(account == null) account = new Account();
      return account;
   }

   public Contact getContact() {
      if(contact == null) contact = new Contact();
      return contact;
   }

   public Opportunity getOpportunity() {
      if(opportunity == null) opportunity = new Opportunity();
      return opportunity;
   }

   public OpportunityContactRole getRole() {
      if(role == null) role = new OpportunityContactRole();
      return role;
   }


  
   public PageReference step1() {
      return Page.opptyStep1;
   }

   public PageReference step2() {
      return Page.opptyStep2;
   }

   public PageReference step3() {
      return Page.opptyStep3;
   }


   
    public PageReference cancel() {
                        PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
                        opportunityPage.setRedirect(true);
                        return Page.opptyStep1 ; 
    }

   
   public PageReference save() {

     
      account.phone = contact.phone;
      insert account;

     
      contact.accountId = account.id;
      insert contact;

     
      opportunity.accountId = account.id;
      insert opportunity;

      // Creates the junction contact role between the opportunity
      // and the contact.
      role.opportunityId = opportunity.id;
      role.contactId = contact.id;
      insert role;

      // Finally, send the user to the std detail page for 
      // the new opportunity .


      PageReference opptyPage = new ApexPages.StandardController(opportunity).view();
      opptyPage.setRedirect(true);

      return opptyPage;
   }

}

/*
 /// First, reserve email capacity for the current Apex transaction to ensure
// that we won't exceed our daily email limits when sending email after
// the current transaction is committed.
Messaging.reserveSingleEmailCapacity(2);

// Processes and actions involved in the Apex transaction occur next,
// which conclude with sending a single email.

// Now create a new single email message object
// that will send out a single email to the addresses in the To, CC & BCC list.
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

// Strings to hold the email addresses to which you are sending the email.
String[] toAddresses = new String[] {'saurabh_pandey@syntelinc.com'}; 
String[] ccAddresses = new String[] {'sumeet_sangle@syntelinc.com'};
  

// Assign the addresses for the To and CC lists to the mail object.
mail.setToAddresses(toAddresses);
mail.setCcAddresses(ccAddresses);

// Specify the address used when the recipients reply to the email. 
mail.setReplyTo('support@acme.com');

// Specify the name used as the display name.
mail.setSenderDisplayName('Salesforce Support');

// Specify the subject line for your email address.
mail.setSubject('New Case Created : ' + case.Id);

// Set to True if you want to BCC yourself on the email.
mail.setBccSender(false);

// Optionally append the salesforce.com email signature to the email.
// The email address of the user executing the Apex Code will be used.
mail.setUseSignature(false);

// Specify the text content of the email.
mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');

mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
     'To view your case <a href=https://***yourInstance***.salesforce.com/'+case.Id+'>click here.</a>');
system.debug('mailbody'+mail);
// Send the email you have created.
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
system.debug('mailsent'+mail);
*/