/**
 *
 * Test class for reminder emails sent for RIF application
 * Created on 10/06/2016 by Avinash Munaga
 */

@isTest(SEEALLDATA=TRUE)
public with sharing class RIF_SendEmails_Test {
	
	public static String CRON_EXP = '0 0 0 15 3 ? 2032';
	/*
	static testMethod void testScheduler(){
		System.runAs(RIF_TestClassUtilities.getTempUser()){
			
			test.startTest();
			
			String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new RIF_ScheduleReminderMail_SnR());
			
			test.stopTest();
			
		}
	}
    */
    static testMethod void testBatch(){
		System.runAs(RIF_TestClassUtilities.getTempUser()){
            
            /*List<Severance_And_Release__c> srList = [SELECT id, name, HR_Contact_Email__c, Owner.id, 
                            Owner.email FROM Severance_And_Release__c WHERE Status__c = 'Selected'
                           	AND Communicated__c = False AND Communication_Date__c < TODAY AND 
                            Project__r.Status__c = 'Active']; */
            User thisUser = RIF_TestClassUtilities.getALLMSUser();
        	insert thisUser;
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(448,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            insert emp;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(448, rt.Id );
            proj.Status__c = 'Active';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(448, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            RecordType rtSNR = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
            snr.Communicated__c = false;
            insert snr;
            List<Severance_And_Release__c> srList = new List<Severance_And_Release__c>();
            srList.add(snr);
            
			RIF_SendEmails rif = new RIF_SendEmails();
			
			test.startTest();
			
            Database.QueryLocator ql = rif.start(null);
            rif.execute(null,srList);
            rif.Finish(null);
            
			rif.setMailContent(srList);
			
			test.stopTest();
			
		}
	}

}