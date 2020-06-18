@istest(SeeAllData=true)

public class WV_Test_WV_EnvironmentCheck{

    public testmethod static void Testmethod02(){   
        WV_EnvironmentCheck env=new WV_EnvironmentCheck();
        env.getSubmittime();
        env.submittedTimes=system.now();
        env.getSubmittime();        
    }
    
}