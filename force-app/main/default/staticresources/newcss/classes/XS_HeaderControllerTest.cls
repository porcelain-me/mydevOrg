@isTest
public class XS_HeaderControllerTest
{
    
    static testMethod void xsHeadTest()
    {    
        XS_HeaderController xsHeadContr = new XS_HeaderController();
        XS_HeaderController xsHead = new XS_HeaderController ();
        ApexPages.Currentpage().getParameters().put('tab','home');
        ApexPages.Currentpage().getParameters().put('setupid','setup');   
        xsHeadContr.isAdmin = true;
    }
}