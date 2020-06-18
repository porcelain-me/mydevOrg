@isTest(SeeAlldata=true)
public class RIF_Rollup_SRCountTest {
    
    static testMethod void myTest1(){
        
        set<String> EmptyString = new set<String>();
        test.startTest();
            RIF_Rollup_SRCount obj = new RIF_Rollup_SRCount();
            obj.updateCount(EmptyString);
            
        test.stopTest();

    } 
    
    static testMethod void myTest2() {
    
       Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
       insert snr; 
         
       Set<String> plid = new Set<String>();
       plid.add(snr.Project_Level__c);
            
            Test.startTest();
                RIF_Rollup_SRCount obj = new RIF_Rollup_SRCount ();
                obj.updateCount(plid);
            Test.stopTest();
         
            
            
           
       
   }
}