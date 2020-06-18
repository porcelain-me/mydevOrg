//   09/30/2011 RJ: ORIGINAL 
//                  Common class for campaigns platform and smartlist application both
//                  As this class is common, we can make it as singleton class.
//  18/03/2016:Replaced Employee__c with GPSEmployee__c by Swapnd
//
public class Common_EmployeeHelper {
	// singleton instance
	private static Common_EmployeeHelper singleton_instance;
	private boolean isUserAnalyst{get;set;}
	// private constructor so that the class cannot be instanciated each time
	private Common_EmployeeHelper(){}	
	public static Common_EmployeeHelper getInstance(){
		  // static method to get the single instance of class
	  	if(singleton_instance == null){
	  		singleton_instance = new Common_EmployeeHelper();
	  	}
	  	return singleton_instance;
	}
	
  public boolean isUserAnalyst(){  	
  	 // instance method
  	 // This function checks that the current user is analyst or not
  	 if(isUserAnalyst == null){ 
  	 	//User currentUser = CM_DataUtil_WS.getCurrentUser();
	  	 User currentUser = CM_CampaignDataUtil.getCurrentLogUser();
	  	 //defaut value of isUserAnalyst
	  	 isUserAnalyst = false;
	  	 // get user employee
	  	 
	  	 //After Campaing Migration Instead of Active_Flag__c using Inactive__c, Division__c to Division_Dsc_Org__c field: Modified by Sudarshan K. 26th Feb 2016
	  	 List<GPSEmployee__c> empList = [Select e.Division__c, e.Is_Producer_Employee__c From GPSEmployee__c e 
	                              where e.Active_Flag__c = true and (e.User__c = : currentUser.Id or e.MS_ID__c =: currentUser.Emp_ID__c)];
	     
	     for(GPSEmployee__c emp : empList){
	     	  if(emp.Is_Producer_Employee__c == true && emp.Division__c == 'Research'){
	          isUserAnalyst = true;
	          break;          
	     	  }
	     }                      
  	 }
     return isUserAnalyst;   
  }// end of isUserAnalyst
}