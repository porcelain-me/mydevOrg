@isTest
private Class TestCommon_SessionHandlerDialog{
    
    static testmethod void sessionHandlerDialogTest(){
        Test.startTest();
            
            Apexpages.currentPage().getParameters().put('appId', 'test');
            
            Common_SessionHandlerDialog  sessionHandler = new Common_SessionHandlerDialog();
            
            T1C_CustomSettingsManager.setAllTriggerOn();
            
            Common_SessionHandlerSettings__c sessionMessages = new Common_SessionHandlerSettings__c(Error_Message__c  = 'This is an Error', Dialogue_Heading__c = 'Session Heading', Redirect_Url__c = 'https://test');
            insert sessionMessages;
            
            sessionHandler = new Common_SessionHandlerDialog();
            
        Test.stopTest();
    }
}