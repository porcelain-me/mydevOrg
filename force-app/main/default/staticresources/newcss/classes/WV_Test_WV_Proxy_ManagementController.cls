@istest(SeeAllData=false)

public class WV_Test_WV_Proxy_ManagementController{

    public testmethod static void Testmethod01(){     
        WV_Proxy_ManagementController proxy=new WV_Proxy_ManagementController();
        proxy.sendErrorEmail();
        proxy.search();
        proxy.searchText='Test';
        proxy.search();
        proxy.searchText='Martin';
        proxy.search();
    }
}