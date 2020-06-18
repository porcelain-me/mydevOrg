/***************************************************************************************************************
*  EmailHelper -  this class handles email delivery processes
*
* JMC 1/5/17 - Created Class
****************************************************************************************************************/
public without sharing class EmailHelper {

    public static void SendIndividualEmail(String templateId, String whatId, List<String> toEmailAddresses, Contact c){

        // Construct the list of emails we want to send
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId(templateId);
        msg.setWhatId(whatId);
        msg.setToAddresses(toEmailAddresses);
        msg.saveAsActivity = false;
        
        // Send the emails in a transaction, then roll it back
        Savepoint sp = Database.setSavepoint();
            if(c.Id == null) {
                insert c;
            }
            msg.setTargetObjectId(c.id);
            lstMsgs.add(msg);
            
            Messaging.sendEmail(lstMsgs);
        Database.rollback(sp);
        
        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        for (Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(email.getToAddresses());
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject() + 'ProperEmailTest');
            emailToSend.saveAsActivity = false;
            lstMsgsToSend.add(emailToSend);
        }
        Messaging.sendEmail(lstMsgsToSend);
    }
}