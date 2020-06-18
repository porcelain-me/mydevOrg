/**
 *
 * Test class for reminder emails sent for Xsell application
 * Created on 18/03/2016 by Avinash Munaga
 */
@isTest
public with sharing class XS_SendEmails_TestClass {
    
    static testMethod void testEmailNotification(){
        System.runAs(RL_TestData.getSystemAdminTempUser()){
            XS_SendEmails xs = new XS_SendEmails();
            
            test.startTest();
            
            // assign value to variable
            xs.submissionList = null;
            
            // call methods in send emails class
            List<Cross_Sell__c> xSellList = xs.getXSellList();
            List<Cross_Sell_Parties_Involved__c> partiesList = xs.getPartiesList();
            
            xs.setMailContent(xSellList);
            //Database.executeBatch(xs);
            
            test.stopTest();
            
        }
    }
    
    private static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testMethod void testScheduler(){
    
        System.runAs(RL_TestData.getSystemAdminTempUser()){
            
            test.startTest();
            
            String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new XS_ScheduleReminderEmail());
            test.stopTest();
            
        }
    }
}