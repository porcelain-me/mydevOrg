@isTest(SeeAllData=true)

public class RL_Employee_InitTest {

    public static User getSystemAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator' LIMIT 1];
       
       /* User tempUser = new User(alias = 'RLTest', email='RL' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='RLTest' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
        System.debug('---------Test User---------'+tempUser);*/
        User tempUser = [select name from user where Profile.Name = 'System Administrator' and isActive = true LIMIT 1 ];
      
        return tempUser; 
    }
    
    public static testmethod void test1()
     {
        
         //User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
         Employee__c emp = [select id, user__c from employee__c where Job_Country_Job__c  ='HKG' and emp_id__c = '95BYG' and status__c = 'Active' and user__r.isActive = true limit 1];
                  Employee__c emp1 = [select id, user__c from employee__c where Job_Region_Code__c  ='EU' and status__c = 'Active' and user__r.isActive = true limit 1];
                  Employee__c emp2 = [select id, user__c from employee__c where Job_Region_Code__c  ='NA' and status__c = 'Active' and user__r.isActive = true limit 1];

         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];      
       system.debug('--------------------u1--------------'+u1.name);
       */      
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' LIMIT 1];
       
       
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Employee_Init validate1 = new RL_Employee_Init();
             Employee__c newEmployee1 = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='EU' LIMIT 1];
       
       
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Employee_Init validate2 = new RL_Employee_Init();
             Employee__c newEmployee2 = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NA' LIMIT 1];
       
       
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Employee_Init validate = new RL_Employee_Init();
        //validate.validationsForEMEA(rL, newLetter);
        //validate.resetFields(newLetter  );
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
    public static testmethod void test2()
     {
        
         //User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
         Employee__c emp = [select id, user__c from employee__c where Job_Region_Code__c  ='EU' and status__c = 'Active' and user__r.isActive = true limit 1];
         
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];      
       system.debug('--------------------u1--------------'+u1.name);
       */      
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' LIMIT 1];
       
       
      
      
              
       
       
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Employee_Init validate = new RL_Employee_Init();
        //validate.validationsForEMEA(rL, newLetter);
        //validate.resetFields(newLetter  );
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
    
    public static testmethod void test3()
     {
        
         //User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
         Employee__c emp = [select id, user__c from employee__c where Job_Region_Code__c  ='NA' and status__c = 'Active' and user__r.isActive = true limit 1];
         
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];      
       system.debug('--------------------u1--------------'+u1.name);
       */      
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' LIMIT 1];
       
       
      
      
              
       
       
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Employee_Init validate = new RL_Employee_Init();
        //validate.validationsForEMEA(rL, newLetter);
        //validate.resetFields(newLetter  );
        validate.emailNotification();
        validate.goHome();
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
    
}