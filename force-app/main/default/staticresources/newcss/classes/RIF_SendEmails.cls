/*****************************************************************************************************
*
* This batch class is used to send reminder emails for S&R submissions
*
* Change Log:
*
* 15/04/2016 - Created by Avinash
*
*******************************************************************************************************/

global with sharing class RIF_SendEmails implements Database.Batchable<sObject> {
    
    // default implementation of start metod of batch interface
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT id, Name, HR_Contact_Email__c, Owner.id, Owner.email,HR_Contact_Override_Email__c FROM' 
                            + ' Severance_And_Release__c WHERE Status__c = \'Selected\''
                            + ' AND Communicated__c = False AND Communication_Date__c < TODAY' 
                            + ' AND Project__r.Status__c = \'Active\'' 
            				+ ' AND Historical_Data_Load__c = false';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Severance_And_Release__c> scope){
        // System.debug('Scheduled class ' + scope);
        RIF_SendEmails sendMail = new RIF_SendEmails();
        sendMail.setMailContent(scope);
    }
   
    
    // default implementation of stop metod of batch interface
    global void finish(Database.BatchableContext BC){
        
    }

    
    public void setMailContent(List<Severance_And_Release__c> snrList) {
        Contact c;
        
        List<EmailTemplate> emailList;
        String orgEmail = null;
        String orgEmailId = null;
        
        // values in this list will be deleted after sending emails
        List<contact> contactList = new List<Contact>();
        
        try {
            
            for(OrgWideEmailAddress owe : RIF_DataUtil.getOrgWideEmaillAddresses(System.Label.RIF_Orgwide_Email)) {
                orgEmail = owe.Address;
                orgEmailId = owe.id;
            }
            
            //Insert the contact one time for the set of requests
            c = new Contact(firstname = '**test**', lastname = '**test**', email = orgEmail);
            insert c;
            
            // add insert contact to this list
            contactList.add(c);
            
            // Details of the present ORG - Values are DEV, QA, UAT, PROD
            String env = System.Label.ORG_ENVIRONMENT.toLowerCase();
            
            emailList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name = 'RIF'];
            Map<String, String> emailMap = new Map<String, String>();
            for (EmailTemplate e : emailList){
                String V=e.id;
                emailMap.put(e.developername,v.substring(0,15));
            }
        
            List<String> emailToAddresses = new List<String>();
            
            // Create object for Email Message
            Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
            
            // list to add email objects
            List<Messaging.Singleemailmessage> emailSendList = new List<Messaging.SingleEmailMessage>();
            system.debug('reminder email - ' + emailSendList.size());
            
            for(Severance_And_Release__c snr : snrList) {
                //System.debug('Snr--'+snr.ID);
                emailToAddresses = new List<String>();   //Added by Mayur on 14 Apr
                // 18-May-17 : In case we have a HR Contact Override value, consider that person's email id
                if(snr.HR_Contact_Override_Email__c != null)
                    emailToAddresses.add(snr.HR_Contact_Override_Email__c);
                else
                    emailToAddresses.add(snr.HR_Contact_Email__c);
                //emailToAddresses.add(snr.HR_Contact_Email__c);
                emailToAddresses.add(snr.owner.email);
                
                //if (!env.contains('prod')) {  //if not production then send to group email for testing purposes
                if(!env.equalsIgnoreCase('prod')){
                    emailToAddresses = new List<String>();
                } else {
                    
                    if(emailToaddresses.size() > 0) {
                        String emailOfContact = emailToaddresses.get(0);
                        c = new Contact(firstname = '**test**', lastname = '**test**', email = emailOfContact);
                        insert c;
                        
                        String removed = emailToaddresses.remove(0);
                        System.debug('removed element : ' + removed);
                        System.debug('List size after deletion: ' + emailToaddresses.size());
                    }
                }
                
                // initialize email object
                email = new Messaging.singleEmailMessage();
                
                email.setToAddresses(emailToAddresses);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(c.id);
                email.setOrgWideEmailAddressId(orgEmailId);
                email.setWhatId(snr.id);
                email.setTemplateId(emailMap.get('Send_Remoinder_HR_Contact_And_Last_Modified_By'));
                //System.debug('Email--'+email);
                // add email object to list to send the list of mails at once
                if (email != null)
                    emailSendList.add(email);
            }
            
            //send the list one time
            if (emailSendList.size() > 0) {
                System.debug('emailSendList.size(): ' + emailSendList.size());
                Messaging.sendEmail(emailSendList,true);
            }
            
        } catch(Exception e) {
            
        } finally {
            if(contactList.size() > 0) {
                for(Contact item: contactList)
                    delete item;
            }
        }
    }

}