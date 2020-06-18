global class ContractEPASCardApprove {
        webService static String sendApprovalEmail(String id) {
                
       String res = null;
        try{
        Product_Request__c c = [select EPAScoreCardApprove__c,EPAScoreCardReject__c,Name ,owner.id from Product_Request__c where id=:id];
        c.EPAScoreCardApprove__c = true;
        c.EPAScoreCardReject__c =  false;
        Database.saveresult sr = database.update(c);
        
        if(sr.isSuccess())
        {
                sendEmailOfApprovalToRequestorApprover(c.owner.id, id);
                sendEmailOfApprovalToSF2SN(id);
                res=  'Email sent to SF2SN'; 
        }
        else
        {
            res = 'Some Error occured';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  mail.setToAddresses( new String[] { 'rakesh.singh1@morganstanley.com.test' } );
                  mail.setSaveAsActivity(false);
                  mail.setSubject('Error : EPA Scorecard : '+ id);
                  mail.setPlainTextBody(String.valueOf(sr.getErrors()));
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
         
         return res;
        }
        
        catch(Exception e)
        {
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  mail.setToAddresses( new String[] { 'rakesh.singh1@morganstanley.com.test' } );
                  mail.setSaveAsActivity(false);
                  mail.setSubject('Error : EPA Scorecard : '+ id);
                  mail.setPlainTextBody(String.valueOf(e));
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
             return 'Error occured ';     
        }
        
        }   
        public static void sendEmailOfApprovalToRequestorApprover(String requestedBy, String id)
        {
            
            Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
             email.setTargetObjectId(requestedBy);
         email.setCcAddresses( new String[] {'court.crane@morganstanley.com.test', 'Heath.Windcliff@morganstanley.com.test' } );
         email.setWhatId(id);
         Id templateId = [select id, name from EmailTemplate where developername = 'PR_EPAScorecard_Approved_email'].Id;
         email.setTemplateId(templateId);
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }   
        
       
         public static void sendEmailOfApprovalToSF2SN(String id)
        {
            Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
             MSET_Contact__c  c = [select id from MSET_Contact__c where FirstName__c = 'sfe2sn' and lastname__c = 'sfe2sn' limit 1];
             email.setTargetObjectId(c.id);
         email.setWhatId(id);
         Id templateId = [select id, name from EmailTemplate where developername = 'PR_EPAScorecard_Email_to_sfe2sn_approved'].Id;
         email.setTemplateId(templateId);
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }

}