/*****************************************************************************************************
*
* This batch class is used to send reminder emails for reference letter requests stuck in the queues
*
* Change Log:
*
* 12/3/14 - MRM Create Class
* 24/04/2015 - Query modified to fetch all requests
*
*******************************************************************************************************/

global without sharing class RL_Reminder_SendEmails implements Database.Batchable<sObject> {
    
    // list is assigned values from existing record
    public List<Reference_Letter_Request__C> requestList {get; set;}
        
    // default implementation of start metod of batch interface
    global Database.QueryLocator start(Database.BatchableContext BC){
        /*String query = 'SELECT id, Status__C, SET_Q_EMAIL_Reminder_Name__c, Email_Requestor_Email__c, Reference_Letter_Code__c' +
                        ', Email_Q_Name__c, Email_OnBehalf_Email__c, set_q_email_cc__c, SET_Q_TEMPLATE_Reminder_Template__c' +
                        ', Conga_CC_Region_Org__c, Conga_Employee_Job_Country__c, Cong a_Employee_Department__c, Escalation__c' +
                        ' from REFERENCE_LETTER_REQUEST__C where Status__C=\'' + requestStatus + '\' AND name=\'' + requestId +'\'';*/
        String query = 'SELECT id, Status__C, SET_Q_EMAIL_Reminder_Name__c, Email_Requestor_Email__c, Reference_Letter_Code__c' +
                        ', Email_Q_Name__c, Email_OnBehalf_Email__c, set_q_email_cc__c, SET_Q_TEMPLATE_Reminder_Template__c' +
                        ', Conga_CC_Region_Org__c, Conga_Employee_Job_Country__c, Conga_Employee_Department__c, Escalation__c' +
                        ', Conga_Employee_Division_Dsc__c, Employee_Dept_Dsc__c, Urgent_HR_Request__c, Conga_Super_Division_Dsc_Org__c' +
                        ', Submitted_Approved_Date__c, Conga_Super_Depart_Dsc_Org__c, Job_Region_Code__c, Conga_Dept_Org__c,' +
                        ' Conga_Job_Country_Job__c, Conga_Super_Division__c, Conga_Division_Org__c, One_Step_Approval__c from REFERENCE_LETTER_REQUEST__C where (Status__C=\'Approval Step 1\' OR' +
                        ' Status__C=\'Approval Step 2\' OR Status__C=\'Rejected By HR Partner\' OR Status__C=\'Approval Step 3\'' +
                        ' OR Status__C=\'Approval Step 4\')';
        return Database.getQueryLocator(query);
    }
    
    
    /*
    * This callse the send email helper for a set of reference letter requests
    *
    */
    global void execute(Database.BatchableContext BC, List<Reference_Letter_Request__C> scope){
        
        RL_Reminder_SendEmailsHelper sendMail = new RL_Reminder_SendEmailsHelper();
        
        sendMail.setMailContent(scope);
    
    }
   
    
    // default implementation of stop metod of batch interface
    global void finish(Database.BatchableContext BC){
        
    }
}