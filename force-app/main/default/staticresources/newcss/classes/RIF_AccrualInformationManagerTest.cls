// 07/10/2013 : MANISHA GUPTA : ORIGINAL
// Description : Test class for RIF_AccrualInformation trigger and RIF_AccrualInformationManager class 
@isTest
private class RIF_AccrualInformationManagerTest {

    static testMethod void testCheckAndUpdateDeltaFields(){
        
        User tempUser = getTempUser();
        system.runAs(tempUser){
            list<String> listEmpIds = new list<String>{'Test#1', 'Test#2', 'Test#3', 'Test#4', 'Test#5', 'Test#6'};
        
            List<Accrual_Information__c> listExistingAccInfo = new List<Accrual_Information__c>();
            listExistingAccInfo.add(createTestAccrualInfo(listEmpIds[0], userInfo.getUserId()));
            insert listExistingAccInfo;
            Test.StartTest();
            List<Accrual_Information__c> listNewAccInfo = new list<Accrual_Information__c>();
            
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[0], userInfo.getUserId()));
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[1], userInfo.getUserId()));
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[2], userInfo.getUserId()));
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[3], userInfo.getUserId()));
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[4], userInfo.getUserId()));
            listNewAccInfo.add(createTestAccrualInfo(listEmpIds[5], userInfo.getUserId()));
            
            insert listNewAccInfo;
            
            for(Accrual_Information__c accInfo : [SELECT EMP_ID__c, Is_Delta_Change__c, Delta_Additional_Severance__c, Delta_Basic_Severance__c, 
                                                            Delta_enhanced_severance_lcl__c, Delta_Buy_Out_Of_Termination__c, Delta_Ex_Gracia_Cash_Payment__c, 
                                                            Delta_Notice_Amount__c, Delta_Additional_Notice__c, Delta_pay_in_lieu_of_ben_lcl__c, Delta_Benefits__c, Delta_Pension_Contribution__c, 
                                                            Delta_Social_Insurance__c, Delta_Statutory_Redundancy_Pay__c, Delta_Termination_Bonus__c 
                                                            FROM Accrual_Information__c 
                                                            Where Id in : listNewAccInfo]){
                                                                
                if(accInfo.Emp_Id__c == listEmpIds[0]){
                    system.assert(accInfo.Is_Delta_Change__c == true);
                    system.assert(accInfo.Delta_Additional_Severance__c == '1000');
                    system.assert(accInfo.Delta_Basic_Severance__c == '1000');
                    system.assert(accInfo.Delta_enhanced_severance_lcl__c == '1000');
                    system.assert(accInfo.Delta_Benefits__c == '1000');
                    system.assert(accInfo.Delta_Notice_Amount__c == '1000');
                    system.assert(accInfo.Delta_Additional_Notice__c == '1000');
                    system.assert(accInfo.Delta_pay_in_lieu_of_ben_lcl__c == '1000');
                    system.assert(accInfo.Delta_Buy_Out_Of_Termination__c == '1000');
                    system.assert(accInfo.Delta_Ex_Gracia_Cash_Payment__c == '1000');
                    system.assert(accInfo.Delta_Pension_Contribution__c == '1000');
                    system.assert(accInfo.Delta_Social_Insurance__c == '1000');
                    system.assert(accInfo.Delta_Statutory_Redundancy_Pay__c == '1000');
                    system.assert(accInfo.Delta_Termination_Bonus__c == '1000');
                }else{
                    system.assert(accInfo.Is_Delta_Change__c == false);
                }
            } 
                                                                        
            
            Test.stopTest();
        }
        
    }
    
    private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
    private static Accrual_Information__c createTestAccrualInfo(String empId, String createdById){
    	Accrual_Information__c accInfo = new Accrual_Information__c(Emp_Id__c = empId, Additional_Severance__c = '1000', 
                                                            Basic_Severance__c = '1000',
                                                            Benefits__c = '1000',
                                                            Buy_Out_Of_Termination__c = '1000', 
                                                            enhanced_severance_lcl__c = '1000',
                                                            Ex_Gracia_Cash_Payment__c = '1000', 
                                                            Notice_Amount__c = '1000',
                                                            Additional_Notice__c = '1000',
                                                            pay_in_lieu_of_ben_lcl__c = '1000',
                                                            Pension_Contribution__c = '1000', 
                                                            Social_Insurance__c = '1000', 
                                                            Statutory_Redundancy_Pay__c = '1000', 
                                                            Termination_Bonus__c = '1000', 
                                                            createdByID__c = createdById,
                                                            Communicated_Date__c = Date.today());
		return accInfo;
    }
}