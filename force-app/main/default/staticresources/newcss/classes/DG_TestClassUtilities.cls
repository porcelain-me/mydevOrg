// 
// (c) 2014 Appirio, Inc. 
//
// Description : Utility class for creating data in test classes.
//
// 09 Jan 2014 Rahul Agrawal Original
//
public without sharing class DG_TestClassUtilities {
    public static User getSystemAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser1', email='TU' + DateTime.now().format('MMddyyhhmmss') + '1@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing1',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '1@morganstanley.com');
  
        return tempUser;
    }
    
    public static User getDGTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
    public static void setAllTriggerOn(Id userId) { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();        
        if(dSwitch != null && dSwitch.Id != null){
            delete dSwitch;
        }      
        dSwitch = new Trigger_Switch__c(Name = 'Default', SetupOwnerId=userId);
        
        dSwitch.Is_DG_DocusignSentForSignature_Off__c = false;
        dSwitch.Is_DG_ListEmployee_Off__c = false;
        dSwitch.Is_DG_ListTemplate_Off__c = false;
        insert dSwitch;
    }
    
    public static User createSystemDataDGUser(){
        User dgUser;
        User sysUser = getSystemAdminTempUser();
        System.runAs(sysUser){
            dgUser = getDGTempUser();
            insert dgUser;
            setAllTriggerOn(dgUser.Id);            
        }
        return dgUser;
    }
    public static list<Employee__c> createBulkEmployee(integer startCount, integer endCount){
        List<Employee__c> lstEmp = new list<Employee__c>();
        Employee__c emp;
        if((endCount - startCount) > 10000){
            endCount = startCount + 9999;
        }
        for(integer i=startCount; i < endCount; i++){
            emp = new Employee__c(Name = 'Test Employee_' + i, 
                                          emp_Id__c = 'Y_' + i, 
                                          Email__c ='TE' + i + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                          First_Name__c = 'Test',
                                          Last_Name__c = 'Employee_' + i,
                                          DocuSign_GUID__c = 'DG_' + i,
                                          Status__c = 'Active', 
                                          Login_Id_Directory__c = 'te' + i);
            lstEmp.add(emp);
        }
        return lstEmp;
    }
    
    public static List__c createListRecord(string listName){
        return new List__c(Document_Display_Name__c ='test' , name = listName, Email_Subject__c = 'Test Subject [First Name]', Email_Body__c = 'Test Email Body [Name]');
    }
    
    public static list<List_Employee__c> createListEmployee(id listId, list<Employee__c> employeeList, String Status){
        list<List_Employee__c> listEmpList = new list<List_Employee__c>();
        List_Employee__c empList;
        for(Employee__c emp : employeeList){
            empList = new List_Employee__c(List__c = listId, Employee__c = emp.Id, Status__c = status);
            listEmpList.add(empList);
            if(listEmpList.size() == 10000)
              break;
        }
        return listEmpList;
    }
    
    public static Template__c createTemplateRecord(){
        return new Template__c(Title__c = 'test Title');
    }
    
    public static List_Template__c createListTemplateRecord(id ListId, Id templateId){
        return new List_Template__c(List__c = listId, Template__c = templateId);
    }
    
    public static dsfs__DocuSign_Status__c createDocusignStatusRecord(Id lstEmpId){
        dsfs__DocuSign_Status__c docStatus = new dsfs__DocuSign_Status__c(dsfs__DocuSign_Envelope_ID__c ='TESTENVELOPEID', List_Employee__c = lstEmpId);
        return docStatus;
    }
    public static Bulk_Docusign_Settings__c createBulkDocusignSettingRecord(){
        Bulk_Docusign_Settings__c bulkDocusignSetting = new Bulk_Docusign_Settings__c(Name = 'Default');
        return bulkDocusignSetting;
    }
    
     public static Docusign_Branding_Setting__c createBrandDocusignSettingRecord(){
        Docusign_Branding_Setting__c brandDocusignSetting = new Docusign_Branding_Setting__c(Name = 'TESTAPPLICATION', Dcosuign_Brand_Id__c = 'ec8f15a8-03ec-432a-a454-5f0da34a1f10');
        return brandDocusignSetting;
    }
    
    public static Employee_Acknowledgement_Settings__c createEmployeeAcknowledgementSettingRecord(){
        Employee_Acknowledgement_Settings__c empAck = new Employee_Acknowledgement_Settings__c(Name = 'Default');
        empAck.Profile_Name__c = 'All MS Employee';
        empAck.Org_Type__c = 'dev';
        empAck.Permission_Set_Name__c = 'Employee_Acknowledgement_Admin_Platform_License';
        return empAck;
        
        // Populate Employee Acknowledgement Settings
    }
    
    public static Attachment createAttachmentRecord(Id parentId){
        return new Attachment(Name = 'test doc', body = blob.valueOf('test document body'), parentId = parentId); 
    }
    
    public static List_Employee_Template__c createListEmployeeTemplateRecord(List_Employee__c listEmp, Template__c template){
        return new List_Employee_Template__c(List_Employee__c = listEmp.Id, Template__c = template.Id);
    }
}