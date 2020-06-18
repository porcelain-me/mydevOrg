@istest(SeeAllData=false)

public class WV_Test_WV_Utility_ExceptionEmails{

    public testmethod static void Testmethod02(){ 
        //test class
        WV_Utility.captureException('My Elections','Employee facing UI Home page-->getSchemeWrapper()','Exception Type','test','test','test',null,userinfo.getuserId());
        WV_Utility.captureExceptionFuture('My Elections','Employee facing UI Home page-->getSchemeWrapper()','Exception Type','test','test','test',null,userinfo.getuserId());
        
    }
    
    public testmethod static void Testmethod03(){ 
        Test.Starttest();
        Map<Id,user> inactiveUSers=new Map<Id,user>([select id,isactive from user where isactive=false limit 1]);
        if(inactiveUSers != null && inactiveUSers.keyset() != null && inactiveUSers.keyset().size() >0){
            List<string> lst=new List<Id>(inactiveUSers.keyset());
            WV_Utility.doActivateUsers(lst);
            WV_Utility.doActivateUsers(lst[0]);
        }
         Test.Stoptest();
        
    }
}