public class EmailClass {

    public string inputValue {get;set;} 
    public string inputValue1 {get;set;} 
    public string inputValue2 {get;set;} 
    public string inputValue3 {get;set;} 
    public pagereference emailsender(){
 Messaging.reserveSingleEmailCapacity(2);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

String[] toAddresses = new String[] {'saurabh.pandey@morganstanley.com'}; 
String[] ccAddresses = new String[] {'thetechnie@gmail.com'};
  

mail.setToAddresses(toAddresses);
mail.setCcAddresses(ccAddresses);

mail.setReplyTo('saurabh.pandey@morganstanley.com');

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

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        system.debug('mail is'+mail);
    return null;
    }
    
}