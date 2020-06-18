@RestResource (urlMapping='/Test_Volunteer__c/*')
global class TestMyRestResource {

    @HttpGet
    global static String doGet(){
    
        String returnStr = 'No Data found';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<Test_Volunteer__c> lstVolunteer = [Select amount__c, name from Test_Volunteer__c limit 1];
        if( lstVolunteer != null && lstVolunteer.size() > 0) {
            system.debug(' Volunteer Name:'+lstVolunteer[0].name);
            if(lstVolunteer[0].amount__c != null) {
                returnStr = String.valueOf(lstVolunteer[0].amount__c);
                system.debug(' Volunteer returnStr:'+returnStr);
            }    
        }
        
        return returnStr;
    }
}