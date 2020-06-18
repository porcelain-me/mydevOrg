@isTest (SeeAllData = false) 
public class PP_TestData {
	   
    public static User getSystemAdminTempUser()
     {                                            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,Emp_Id__c='15ABC',   
        TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');        
        return tempUser;    
      
     }
      
     
    public static Employee__c insertManagerEmployee(){ 
    Employee__c empSource1 = new Employee__c (name = 'Test User1',Job_Country_Job__c='IND', Status__c='Active',emp_id__c = '15DEF', email__c='SystemAdministrator1@testorg.com',Officer__c='Y');
           insert empSource1;        
           return empSource1;
   } 
    
    public static Employee__c insertEmployee(Employee__c empSource1,User tempUser){ 
        Employee__c newEmployee = new Employee__c (Level_Dsc_Job__c='Vice President', Job_Country_Job__c='IND',Status__c='Active',name = 'Test User', emp_id__c = '15ABC',email__c='SystemAdministrator@testorg.com',Manager__c=empSource1.id,Officer__c='Y',User__c=userinfo.getUserId());
        insert newEmployee;        
        system.debug('------------Employee Details-----------------'+newEmployee);       
        return newEmployee;
       }
    	
    public static Building_Locations__c insertBuilding(){
    	Building_Locations__c BL = new Building_Locations__c(name = 'MyBuilding1');
        insert BL;
        system.debug('------------Building_Locations__c-----------------'+BL);
        return BL;        
    	}
    
    public static PR_Request__c insertPRRequest(Employee__c newEmployee,Building_Locations__c BL){
   			 PR_Request__c newPRRequest = new PR_Request__c();
             newPRRequest.Employee_Requestor_Name__c = newEmployee.id;
             newPRRequest.Request_Type__c='MS Office (Most common)';
             newPRRequest.Manager__c = newEmployee.id;
             newPRRequest.Employee_Requestee_Name__c = newEmployee.id;
             newPRRequest.Property_Owner__c='Self';
			 newPRRequest.Removal_Type__c='Permanent';
             newPRRequest.Removal_Date__c=Date.today();
             newPRRequest.Location111__c=BL.id;
             newPRRequest.Destination_Details__c = 'Home';
             newPRRequest.Removal_Purpose__c='Business Purpose';
             newPRRequest.CC_WatcherNames__c='Test User1';
             newPRRequest.CC_WatchList__c='first@morganstanley.com'; 
             newPRRequest.Approvers_List__c='testmee@morganstanley.com';
             insert newPRRequest;    
             system.debug('------------PRRequest-----------------'+newPRRequest); 
        	 return newPRRequest;
    }
    
    public static Property_Detail__c insertPD(PR_Request__c newPRRequest) {
        
         //Create Property Detail
             Property_Detail__c PD = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property1',Property_Name__c='Documents',Serial_No__c='123',Asset_Tag__c='123',Description__c='Desc',Boxes__c='1',Items__c='2',Pallets__c='3');
             insert PD;
             system.debug('------------Property Details-----------------'+PD); 
        	 return PD;
    }
    

    
}