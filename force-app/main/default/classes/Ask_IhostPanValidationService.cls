//Created by Centelon to validate the Customers based upon Pan and DOB before onboarding in ihost

@RestResource(urlMapping='/PanValidation/*')
global with sharing class Ask_IhostPanValidationService {
    @HttpGet
    global static void getLeadByPanId() {
        RestRequest request = RestContext.request;
        // grab the panNo from the end of the URL
        string errorMsg = '';
        string isPanExist = '';
        string status = '';
        String panNo = RestContext.request.params.get('pan');
        String dob = RestContext.request.params.get('dob');
        Date BirthDate ;
        try {
            BirthDate = date.parse(dob);
            }
        catch (Exception e) {}
        
        
       
                /* 
        String panNo = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        String dob = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+2);
        system.debug('dob'+dob);
        system.debug('pan'+panNo);
        */
        system.debug('panNo'+panNo);
        system.debug('dob'+dob);
        if ((panNo != Null && panNo != '') && (BirthDate != Null)){
            status = 'Success';
        }
        else {
            status = 'Failure';
            errorMsg = 'Pan or DOB format is wrong.';
        }
        If(status != 'Failure'){ 
        List<Lead> result =  [SELECT Id, PAN__c,Birth_Date__c FROM Lead
                              WHERE PAN__c = :panNo and Birth_Date__c = :BirthDate];
        If (result != null && result.size() > 0 ){
            errorMsg =' Client with this Pan Number already exist in system.';
            isPanExist = '1';
        }
        else{
            errorMsg ='Client with This Pan Number does not exist in system.';
            isPanExist = '0';
        }
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{ "Status" : "'+status+'", "ispanExist" : "'+isPanExist+'","msg" : "'+errorMsg+'" }');
        //return str;
    }
}