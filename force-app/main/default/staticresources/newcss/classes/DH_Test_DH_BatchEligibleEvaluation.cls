@istest(SeeAllData=false)
public class DH_Test_DH_BatchEligibleEvaluation {
    
    public static String sch = '0 5 * * * ? ';
    
    static testMethod  void batchtestmethod()
    {
     
	Test.startTest();
    Employee__c emp = new Employee__c();
    emp.Last_Name__c='Mishra';
    emp.First_Name__c='Ashutosh';
    insert emp;
    
 
	String jobId = System.schedule('Ashutosh',
      DH_Test_DH_BatchEligibleEvaluation.sch, 
         new DH_BatchEligibleEvaluation());
        id batchId = Database.executeBatch(new DH_BatchEligibleEvaluation(), 1000);
            system.debug('\n\n==> batchId = ' + batchId);


    }
}