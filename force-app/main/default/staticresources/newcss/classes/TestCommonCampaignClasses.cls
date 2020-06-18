@isTest
private class TestCommonCampaignClasses{

    static testmethod void CM_CustomExceptionTest(){
        Test.startTest();
            
            CM_CustomException obj = new CM_CustomException('Test Message', 'WARN');
                        
            CM_GENERALSETTINGS__c setting = new CM_GENERALSETTINGS__c(Default_Source_For_Exception__c = 'test');
            insert setting;
            
            CM_CustomException obj1 = new CM_CustomException('Test Message1', 'WARN', 'This is SF exception');
            
            CM_CustomException.logWarningMessage('Logging Messages');
            
            List<String> messages = new List<String>();
            messages.add('Test message1');
            messages.add('Test message2');
            
            CM_CustomException.logWarningMessage(messages);
            
        Test.stopTest();
    }
    
    static testmethod void CheckRecursiveTest(){
        Test.startTest();
        
            CheckRecursive obj = new CheckRecursive();
            
            CheckRecursive.runOnce();
            CheckRecursive.runOnce();
            
        Test.stopTest();
    }
    
    static testmethod void CM_JSDebuggerTest1(){
        Test.startTest();
            
            ApexPages.currentPage().getParameters().put('isDebug','true');
            CM_JSDebugger obj = new CM_JSDebugger();          
        
        Test.stopTest();
    }
    
    static testmethod void CM_JSDebuggerTest2(){
        Test.startTest();
            
            ApexPages.currentPage().getParameters().put('IsDebug','true');
            CM_JSDebugger obj = new CM_JSDebugger();           
        
        Test.stopTest();
    }
}