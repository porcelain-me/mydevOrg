@isTest(seealldata=true)
private class GenericHistoryComponentControllerTest {

 static testmethod void myGenericHistoryComponentController() {
     Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  insert tempUser;
       
       //create controller
GenericHistoryComponentController controller = new GenericHistoryComponentController();
     
     controller.recordLimit=100;
  
    
 List<Employee__c> empList = new List<Employee__c>();
            Employee__c emp = [SELECT Id,name, CreatedDate, CreatedById,Email__c,Emp_ID__c, LastModifiedDate, LastModifiedById  FROM Employee__c LIMIT 1];
            
     test.startTest();
      GenericHistoryComponentController.objectHistoryLine generichiscontro = new GenericHistoryComponentController.objectHistoryLine();
      generichiscontro.theDate= 'test';
         generichiscontro.who= 'test';
         generichiscontro.userId  =tempUser.id;
        generichiscontro.action = 'test';
     
       controller.myObject=emp;
        controller.getObjectHistory();
   //controller.objectHistoryLine();
     GenericHistoryComponentController.returnFieldLabel(emp.Email__c);
  test.stopTest();

 }
}