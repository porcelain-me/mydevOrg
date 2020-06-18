/************************************************************************************
*
* 3/7/15 - Tests for core utilities
*
**************************************************************************************/
@isTest(seeAllData=true)
private class TESTCORE_UTILITIES {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	
        	OrgWideEmailAddress o = [Select  o.Address From OrgWideEmailAddress o
						where displayname = 'hrfrce-alerts'];
        	
        	String orgWideEmailId = CORE_UTILITIES.getOrgWideEmailAddressId('hrfce-alerts');
        	CORE_UTILITIES.systemEmailNotification(o.Id, 'mark.moser@morganstanley.com', 'plainTextBody', 'subject');
        	
        	Test.StopTest();
     
    }
}