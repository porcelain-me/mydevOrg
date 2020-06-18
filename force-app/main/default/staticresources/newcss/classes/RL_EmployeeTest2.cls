@isTest(SeeAllData=true)
public class RL_EmployeeTest2 {
    
    public RL_EmployeeTest2() {
        system.debug('------------Test------------');
    } 
    //RL0001 
    public static testmethod void testMethod001() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        // User tempUser = [select name from user where name = 'Avinash Munaga'];
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL001();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
        
    }
    
    public static testmethod void testMethod002() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL002();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod003() {
        /* Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL003();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag();  
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod004() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL004();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod005() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL005();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod006() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL006();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag();
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod007() {
        /* Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL007();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod008() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
            */
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL008();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
                sap.setLayoutFlag(); 
                sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod009() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL009();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag(); 
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod011() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL011();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();
	            sap.save();   
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod013() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL013();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();  
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod015() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL015();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag(); 
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod016() {
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL016();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag(); 
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod017() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL017();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod019() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL019();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod020() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL020();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();  
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void testMethod021() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL021();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            sap.setLayoutFlag();
	            sap.save();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void flagmethod1() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL021();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
            	sap.setFlag1();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void flagmethod2() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        User tempUser =  RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {  
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL021();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('dev',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            
            System.Test.startTest();
            	sap.setFlag2();
            System.Test.stopTest();
        }
    }
    
    public static testmethod void Exception() {
        /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
			*/
        // User tempUser = [select name from user where name = 'ANDREW DUNNIGAN' LIMIT 1];  
        User tempUser = RL_TestData.getSystemAdminTempUser();
        system.runas(tempUser) {
            System.Test.startTest();  
            
            Reference_Letter_Request__c newRLR= RL_TestData.sampleData();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('exception',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('uat',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            sap.FlagToIncludedBasSalaryRentApp();   
            sap.setFlag1();
            //sap.setFlag2();    
            System.Test.stopTest();
        }
    }
    
    //Other Methods
    public static testmethod void Othermethods() {
        
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {    
            
            Reference_Letter_Request__c newRLR= RL_TestData.createRefLetterRL001();
            
            PageReference pageRef = Page.RL_Home;
            system.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('successLoad',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('qa',newRLR.id);
            
            //Call RL_Employee Controller
            RL_Employee customController = new RL_Employee();
            system.Test.startTest(); 
	            customcontroller.save();   
	            customcontroller.AddMore();
	            customcontroller.AddMore1();
	            customcontroller.cancel();
	            customcontroller.getIncludeBaseSalary();
	            //customcontroller.setFlag1();
	            //customcontroller.setFlag2();
	            customcontroller.showRecipientDetails();
	            customcontroller.setFlagToNameRelationship();
	            customcontroller.FlagToTheRecipientBelow();
	            customcontroller.FlagToIncludedInThisCoverNote();
	            customcontroller.FlagToIncludedBasSalaryRentApp();
	            customcontroller.includeBaseSalary();
	            customcontroller.showRecipient();
	            customcontroller.setDurationFlag();
	            customcontroller.setLayoutFlag();
	            customcontroller.showInvitingOrg();
	            customcontroller.setJourneyFLag();
	            customcontroller.setNationalityFlag();
	            customcontroller.setAddresseFlag();
	            customcontroller.setPassportFlag();
	            // customcontroller.setRecipientFlag();
	            customcontroller.showLetterSelection();
	            
	            customcontroller.reDirect();
	            customcontroller.newRequest();
	            customcontroller.exit();
	            customcontroller.cancel();
	            customcontroller.getAvailableLetters();
	            customcontroller.getRequestFor();
	            customcontroller.getEmployees();
	            customcontroller.setEmployeeRequest();
	            customcontroller.getReferenceLetterList();
	            //customcontroller.getGroups();
	            //customcontroller.validateEMEAHR();       
	            customcontroller.FlagToBusinessVisaIsPassPortNo();   
            system.test.stopTest();
        }
    }
    
    public static testmethod void PreHired() {
        
        User tempUser = RL_TestData.getSystemAdminTempUser();  
        system.runas(tempUser) {
            
            Reference_Letter_Request__c newRLR = RL_TestData.createRefLetterRL005();
            
            PageReference pageRef = Page.RL_Home;
            System.Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(newRLR);
            ApexPages.currentPage().getParameters().put('success',newRLR.id);
            ApexPages.currentPage().getParameters().put('id',newRLR.id);
            ApexPages.currentPage().getParameters().put('exception',newRLR.id);
            ApexPages.currentPage().getParameters().put('visaLetterAsia',newRLR.id);
            ApexPages.currentPage().getParameters().put('uat',newRLR.id);
            
            RL_Employee sap = new RL_Employee();
            System.Test.startTest();
	            //sap.save();
	            //sap.setFlag1();
	            sap.setFlag2();
            System.Test.stopTest();
        }
    }
}