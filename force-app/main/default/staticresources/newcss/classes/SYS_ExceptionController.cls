/******************************************************************************************
* System Exception Controller   
*
* ChangeLog:
*
*   6/11/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/
public with sharing class SYS_ExceptionController {

	 public string e {get;set;}
	 public User u {get;set;}
	 public String timeX {get;set;} 
	 public String devInfo {get;set;}
	 
	 public SYS_ExceptionController() {
	 
	 	e = ApexPages.currentPage().getParameters().get('e');
	 	devInfo = ApexPages.currentPage().getParameters().get('devInfo');
	 	
	 	u = [select name from User where id = :userInfo.getUserId()];
	 	
	 	DateTime now = system.now();
	 	timeX = now.format();
	 	 
	 }
	 
	 /*********************************************************************************************
	 * NOTIFY - This sends and email to the hrfrce alterts group with an exception the user saw
	 *********************************************************************************************/
	 public void notify(){
	 	
	 	CORE_UTILITIES.systemEmailNotification(
        		 		  CORE_UTILITIES.getOrgWideEmailAddressId('hrfrce-alerts') //from
        				, 'hrfrce-alerts@morganstanley.com'  //to
        				, 'User: ' + u.name + '(' + userInfo.getUserId() + ')' + '\n' +
        				'Date/Time: ' + timeX + '\n\n' + 'Exception: ' + e  + '\n\n' + //body 
        				'Developer Info: ' + devInfo + '\n\n'
        				, System.Label.ORG_ENVIRONMENT + ' - Exception Notification' //subject
        				);
	 
	 }
	 
	 
}