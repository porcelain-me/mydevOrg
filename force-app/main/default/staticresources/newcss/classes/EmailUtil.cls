// 
// (c) 2009 Appirio, Inc.
//
// A Email Utility contains method to create and send mail messages
//
// 04 May 2010    Rahul Jain       Original
//
//
public class EmailUtil {


   public static void sendSingleEmail(string toAddress,Id targetObjectId,boolean saveAsActivity,
   string htmlbody,string textbody,string subject,string fromAddress){
    
        Messaging.SingleEmailMessage mail = getSingleEmail(toAddress,targetObjectId,saveAsActivity,
        htmlbody,textbody,subject,fromAddress);
                
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    
   }
   
   
   public static Messaging.SingleEmailMessage getSingleEmail(string toAddress,Id targetObjectId,boolean saveAsActivity,
   string htmlbody,string textbody,string subject,string fromAddress){
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if(htmlbody != null)
        mail.setHtmlBody(htmlbody);
        
        if(textbody != null)
        mail.setPlainTextBody(textbody);
        
        if(toAddress != null){
          List<String> toAddresses= new List<String>();
          toAddresses.add(toAddress);    
          mail.setToAddresses(toAddresses);
        }
        
        mail.setSubject(subject);
        
        if(targetObjectId != null)
        mail.setTargetObjectId(targetObjectId);
        
        if(saveAsActivity != false)
        mail.saveAsActivity = saveAsActivity;
        
        if(fromAddress != null)
        mail.setReplyTo(fromAddress);
        
                
        return mail;        
                    
   }
   
   public static void sendBulkEmail(List<Messaging.SingleEmailMessage> emailList){
       Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
   }
 
}