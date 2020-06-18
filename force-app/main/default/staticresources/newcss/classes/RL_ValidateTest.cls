@isTest(SeeAllData=true)
public class RL_ValidateTest {
    
    public RL_ValidateTest()
    {
    system.debug('------------Test------------');
    }
     public static User getSystemAdminTempUser()
     {                                            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');      
        return tempUser;          
     }       
    static testmethod void validateTestRL0016()
    {
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
           
       Employee__c newEmployee = RL_testdata.createEmp();
       Reference_Letter__c   refLetter = RL_Testdata.createRefRL0016();
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       newLetter.Reference_Letter__c = refLetter.id;  
       newLetter.Address_by_Reference__c ='Name and Address';         
       newLetter.Conga_Employee_Gender__c = 'Female';        
       newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
       newLetter.Conga_Adj_Hire_Date__c = date.today();                        
       newLetter.Conga_Covenant_Date__c= date.today();                                   
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id;                            
       insert newLetter;              
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
       customcontroller.validateRequesteeStatus(newLetter, 'Active'); 
        //customcontroller.validateRequesteeStatus(newLetter, 'Terminated');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);         
        System.Test.stopTest();
       }        
     } 
    static testmethod void validateTestRL0017()
    {       
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
      
        Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0017();
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;  
        newLetter.Company_Address_Title__c = null;   
        newLetter.Address_by_Reference__c ='Name and Address';                        
        newLetter.For_Employee__c = newEmployee.id;   
       // newLetter.All_Employees__c = newEmployee.id;    
        newLetter.Requesting_Employee__c = newEmployee.id;                             
        insert newLetter;        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);         
        System.Test.stopTest();
       }        
    }
    
    static testmethod void validateTestRL0020()
    {
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
     
        Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0020();  
           
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;          
              
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
        newLetter.Conga_Adj_Hire_Date__c = date.today();                        
        newLetter.Conga_Covenant_Date__c= date.today();                                   
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;                         
        insert newLetter;   

        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    }  
    static testmethod void validateTestRL0019()
    {
        User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
      
        
       Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0019(); 
      
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id; 
        
        newLetter.Type_of_Visa__c = 'Business Visa';
        
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;     
        insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    static testmethod void validateTestRL0004()
    {
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();   
           Boolean errorMsg = false;
      
           Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0004();
      
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;  
        newLetter.Address_Letter_To__c = 'Specify Name/Address';
       
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;   
        insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    }
    static testmethod void validateTestRL0005()
    {
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
       Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0005();
       refLetter = [select id,name,Reference_Letter_Code__c from Reference_Letter__c where id =:refLetter.id LIMIT 1];
       system.debug('-------------------Reference Letter-----------------------'+refLetter); 
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;  
        newLetter.Address_Letter_To__c = 'Specify Name/Address';
        newLetter.Receipient_Name__c = '';
        newLetter.Recipient_Address__c = '';
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;    
        insert newLetter; 
        newLetter = [select id,Address_Letter_To__c from Reference_Letter_Request__c where id =:newLetter.id LIMIT 1];
       system.debug('-------------------Reference Letter-----------------------'+newLetter);    
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
     static testmethod void validateTestRL0001()
    {
        User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];       
       Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
       
       Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0001();    
      
           //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       newLetter.Include_Passport_Number__c = false;
       
       newLetter.Address_Letter_To__c = 'Specify Name/Address';
               
       newLetter.Reference_Letter__c = refLetter.id;    
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id;
       newLetter.INCLUDE_HOME_ADDRESS__c = true;   
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    
     static testmethod void validateTestRL0002()
    {
        User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
         Employee__c newEmployee = RL_testdata.createEmp();
        //newEmployee = [select id,Job_Country_Job__c from Employee__c where id = :newEmployee.id Limit 1];
        system.debug('--------------Job Country-------------'+newEmployee);   
       Reference_Letter__c   refLetter = RL_Testdata.createRefRL0002();
      
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       newLetter.Include_Passport_Number__c = true;
       newLetter.Passport_Issuing_Country__c = null;
       newLetter.Address_Letter_To__c = 'Specify Name/Address';
      
       newLetter.Date_of_Travel__c = Date.today();  
       newLetter.Return_Date__c = Date.today().addDays(-1);    
       newLetter.Reference_Letter__c = refLetter.id;    
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id;   
           
       insert newLetter;         
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    static testmethod void validateTestRL0009()
    {
        User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
              Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0009();   
       
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       newLetter.Reference_Letter__c = refLetter.id;    
       
       newLetter.Include_Family_Members__c = true;
       
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id; 
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    
    static testmethod void validateTestRL0015()
    {
      User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
       
         Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0015();  
               
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       newLetter.Reference_Letter__c = refLetter.id;    
       newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id; 
       newLetter.Include_Family_Members__c = true;
       
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    
    static testmethod void validateTestRL0006()
    {
       User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
      Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0006(); 
      
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       
       newLetter.Address_Letter_To__c = 'Specify Name/Address';
      
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id;     
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    } 
    
    static testmethod void validateTestRL0008()
    {
        User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
      
           Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0008();
       
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id;    
       newLetter.Reference_Letter__c = refLetter.id;  
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    }
    
    static testmethod void validateTestRL0010()
    {
      User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
       System.Test.startTest();    
       Employee__c newEmployee = RL_testdata.createEmp();
        Reference_Letter__c   refLetter = RL_Testdata.createRefRL0010();
    
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
       
       newLetter.Reference_Letter__c = refLetter.id;    
       newLetter.For_Employee__c = newEmployee.id;           
       newLetter.Requesting_Employee__c = newEmployee.id; 
       insert newLetter;         
        
        
        PageReference pageRef = Page.RL_Home;
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
        ApexPages.currentPage().getParameters().put('success',newLetter.id);
        ApexPages.currentPage().getParameters().put('id',newLetter.id);
        ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
        ApexPages.currentPage().getParameters().put('dev',newLetter.id);
        
        //Call RL_Validate Controller
        RL_Validate customController = new RL_Validate();   
        customcontroller.formatName('Test') ;
        customcontroller.resetFields(newLetter);
        customcontroller.validateRequesteeStatus(newLetter, 'Active');   
        customcontroller.validationsForEMEA(refLetter,newLetter);
        customcontroller.validationForAsiaLetters(refLetter, newLetter, newEmployee);   
      
           
       System.Test.stopTest();
    }    
    
    }
    
   static testmethod void validateTest_RL0010()
   {
   	
   	 User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
 		Employee__c newEmployee = RL_testdata.createEmp();
 		Reference_Letter__c   refLetter = RL_Testdata.createRefRL0006();
	       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
	       newLetter.Reference_Letter__c = refLetter.id;  
	       newLetter.Address_by_Reference__c ='Name and Address';         
	       newLetter.Conga_Employee_Gender__c = 'Female';        
	       newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
	       newLetter.Conga_Adj_Hire_Date__c = date.today();                        
	       newLetter.Conga_Covenant_Date__c= date.today();                                   
	       newLetter.For_Employee__c = newEmployee.id;           
	       newLetter.Requesting_Employee__c = newEmployee.id;  
	       newLetter.CONGA_JOB_COUNTRY_JOB__c = 'HKG';
	       newLetter.INCLUDE_CURRENT_BASE_SALARY__c = true; 
	       newLetter.BASE_ANNUAL_AMOUNT__c = '100';
	       newLetter.Base_Annual_Currency__c= 'HKD';
	       newLetter.Conga_Title__c = 'Mr';
	       newLetter.Conga_Last_Name__c = 'Zhu';
	       newLetter.INCLUDE_HOME_ADDRESS__c = true;
	       newLetter.INCLUDE_PASSPORT_NUMBER__c = true;
	       newLetter.PREVIOUS_YEAR_TRWD_AMOUNT__c = '50';
	       newLetter.PREVIOUS_YEAR_TRWD_CURRENCY__c = 'HKD';
	       newLetter.Prior_Comp_Year__c = '2016';
	       newLetter.US_Expert__c = true;
	                                
       insert newLetter;  
       		RL_Validate customController = new RL_Validate(); 
       		customController.buildTemplateText(newLetter);
 		            
       Reference_Letter__c   refLetter09 = RL_Testdata.createRefRL0009();
	       Reference_Letter_Request__c newLetter1 = new Reference_Letter_Request__c ();
	       newLetter1.Reference_Letter__c = refLetter09.id;  
	       newLetter1.Address_by_Reference__c ='Name and Address';         
	       newLetter1.Conga_Employee_Gender__c = 'Female';        
	       newLetter1.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
	       newLetter1.Conga_Adj_Hire_Date__c = date.today();                        
	       newLetter1.Conga_Covenant_Date__c= date.today();                                   
	       newLetter1.For_Employee__c = newEmployee.id;           
	       newLetter1.Requesting_Employee__c = newEmployee.id;  
	       newLetter1.CONGA_JOB_COUNTRY_JOB__c = 'HKG';
	       newLetter1.INCLUDE_CURRENT_BASE_SALARY__c = true; 
	       newLetter1.INCLUDE_HOME_ADDRESS__c = true;
	       newLetter1.BASE_ANNUAL_AMOUNT__c = '100';
	       newLetter1.Base_Annual_Currency__c= 'HKD';
	       newLetter1.Conga_Title__c = 'Mr';
	       newLetter1.Conga_Last_Name__c = 'Zhu';
	       newLetter1.INCLUDE_PASSPORT_NUMBER__c = true;
	       newLetter1.PREVIOUS_YEAR_TRWD_AMOUNT__c = '50';
	       newLetter1.PREVIOUS_YEAR_TRWD_CURRENCY__c = 'HKD';
	       newLetter1.Prior_Comp_Year__c = '2016';
	       newLetter1.US_Expert__c = true;
	       insert newLetter1;  
       		RL_Validate customController1 = new RL_Validate(); 
       		customController1.buildTemplateText(newLetter1);
        
       }
    }
    
    static testmethod void validateTest_RL0022()
   {
   	
   	 User u1 = getSystemAdminTempUser();
       System.runAs(u1) 
       {
 		Employee__c newEmployee = RL_testdata.createEmp();
 		  Reference_Letter__c refLetter0022 =new Reference_Letter__c();
           refLetter0022.name = 'Bank Account Opening letter';
           refLetter0022.Reference_Letter_Code__c ='RL0022';
           refLetter0022.Purpose_Description__c ='Bank account opening letter for all Hong Kong employees';
           refLetter0022.Employment_Status__c = 'Active'; 
           insert refLetter0022;
	       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
	       newLetter.Reference_Letter__c = refLetter0022.id;  
	       newLetter.Address_by_Reference__c ='Name and Address';         
	       newLetter.Conga_Employee_Gender__c = 'Female';        
	       newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
	       newLetter.Conga_Adj_Hire_Date__c = date.today();                        
	       newLetter.Conga_Covenant_Date__c= date.today();                                   
	       newLetter.For_Employee__c = newEmployee.id;           
	       newLetter.Requesting_Employee__c = newEmployee.id;  
	       newLetter.CONGA_JOB_COUNTRY_JOB__c = 'HKG';
	       newLetter.INCLUDE_CURRENT_BASE_SALARY__c = true; 
	       newLetter.BASE_ANNUAL_AMOUNT__c = '100';
	       newLetter.Base_Annual_Currency__c= 'HKD';
	       newLetter.Conga_Title__c = 'Mr';
	       newLetter.Conga_Last_Name__c = 'Zhu';
	       newLetter.INCLUDE_HOME_ADDRESS__c = true;
	       newLetter.INCLUDE_PASSPORT_NUMBER__c = true;
	       newLetter.PREVIOUS_YEAR_TRWD_AMOUNT__c = '50';
	       newLetter.PREVIOUS_YEAR_TRWD_CURRENCY__c = 'HKD';
	       newLetter.Prior_Comp_Year__c = '2016';
	       newLetter.US_Expert__c = true;
	                                
       insert newLetter;  
       		RL_Validate customController = new RL_Validate(); 
       		customController.buildTemplateText(newLetter);
       		
		   Reference_Letter__c   refLetter02 = RL_Testdata.createRefRL0002();
	       Reference_Letter_Request__c newLetter1 = new Reference_Letter_Request__c ();
	       newLetter1.Reference_Letter__c = refLetter02.id;  
	       newLetter1.Address_by_Reference__c ='Name and Address';         
	       newLetter1.Conga_Employee_Gender__c = 'Female';        
	       newLetter1.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
	       newLetter1.Conga_Adj_Hire_Date__c = date.today();                        
	       newLetter1.Conga_Covenant_Date__c= date.today();                                   
	       newLetter1.For_Employee__c = newEmployee.id;   
           newLetter1.CONGA_LEVEL_JOB__c = '40';
	       newLetter1.Requesting_Employee__c = newEmployee.id;  
	       newLetter1.CONGA_JOB_COUNTRY_JOB__c = 'JPN';
	       newLetter1.INCLUDE_CURRENT_BASE_SALARY__c = true; 
	       newLetter1.BASE_ANNUAL_AMOUNT__c = '100';
	       newLetter1.Base_Annual_Currency__c= 'USD';
	       newLetter1.Conga_Title__c = 'Mr';
	       newLetter1.Conga_Last_Name__c = 'MAJUMDAR';
	       newLetter1.INCLUDE_HOME_ADDRESS__c = true;
	       newLetter1.INCLUDE_PASSPORT_NUMBER__c = true;
	       newLetter1.PREVIOUS_YEAR_TRWD_AMOUNT__c = '50';
	       newLetter1.PREVIOUS_YEAR_TRWD_CURRENCY__c = 'USD';
	       newLetter1.Prior_Comp_Year__c = '2016';
	       newLetter1.US_Expert__c = true;
	                                
       insert newLetter1;  
       		RL_Validate customController1 = new RL_Validate(); 
       		customController1.buildTemplateText(newLetter1);
       	newLetter1.CONGA_JOB_COUNTRY_JOB__c = 'IND';
       	update newLetter1;
       	customController1.buildTemplateText(newLetter1);
        
       }
    }
    
    
   
    
    
}