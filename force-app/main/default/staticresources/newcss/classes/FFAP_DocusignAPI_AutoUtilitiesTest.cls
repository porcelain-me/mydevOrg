@isTest(SeeAllData = false)
private class FFAP_DocusignAPI_AutoUtilitiesTest {
    private static User sysUser;
    private static Employee__c emp1;
    private static Employee__c emp2;
    private static Employee__c emp3;
    private static testmethod void testDocusignAPI(){
    	sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();  
            /*
            FFAP_DocusignAPI_AutoUtilities utilities = new FFAP_DocusignAPI_AutoUtilities('NOEMP');
            String resultString = utilities.sentCommitmentAgreementForSignature('NOEMP');
            //System.assertEquals(resultString, 'No Employee found with provided MSID.');
            
            utilities = new FFAP_DocusignAPI_AutoUtilities(emp1.Emp_Id__c);
            resultString = utilities.sentCommitmentAgreementForSignature('NOEMP');
            String empName = '(' + emp1.Name + ' - ' + emp1.Emp_Id__c + ')';
            //System.assertEquals(resultString, 'Employee' + empName + ' is not Active.\nBranch Manager not found on Employee' + empName + '.\n');
            
            emp1.Status__c = 'Active';
            emp1.Manager__c = emp2.Id;
            update emp1;            
            
            empName = '(' + emp2.Name + ' - ' + emp2.Emp_Id__c + ')';
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, 'Branch Manager' + empName + ' is not Active.\n');
            
            emp2.Status__c = 'Active';
            update emp2; 
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, 'Docusign Account is not configured. Please ask your System Administrator to configure.');
            
            FFAP_TestClassUtilities.createDocusignRecord();
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, 'Docusign Templates are not configured. Please ask your System Administrator to configure.');
            
            FFAP_TestClassUtilities.createDocusignTemplate();
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, FFAP_DataUtil.SUCCESS);
            
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, 'Commitment Agreement is already created for this Employee.');
            
            utilities = new FFAP_DocusignAPI_AutoUtilities(emp3.Emp_Id__c);
            resultString = utilities.sentCommitmentAgreementForSignature(emp3.emp_id__c);
            //System.assertEquals(resultString, 'Employee is not FA/PWA.');
            
            emp3.FFAP_Is_PWA__c =true;
            update emp3;
            resultString = utilities.sentCommitmentAgreementForSignature(emp2.emp_id__c);
            //System.assertEquals(resultString, FFAP_DataUtil.SUCCESS);
            */
            Test.stopTest();
        }
    }
    private static void createData(){
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Branch Manager', 'TestJobLevelDesc', 'TestJobLevel');
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp3 = FFAP_TestClassUtilities.createTestEmployee(3, 'TEST003', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp1.Status__c = 'InActive';
        emp2.Status__c = 'InActive';
        emp3.FFAP_Is_PWA__c = false;
        emp3.FFAP_Is_FA__c = false;
        empList.add(emp1);
        empList.add(emp2);
        empList.add(emp3);
        insert empList;
        
        emp3.Manager__c = emp2.Id;
        update emp3;
        //
        FFAP_Agreement__c faAgreement = FFAP_TestClassUtilities.createAgreement(emp3.Id);
        insert faAgreement;
        insert FFAP_TestClassUtilities.createDocusignStatusRecord(null, null);
    }
}