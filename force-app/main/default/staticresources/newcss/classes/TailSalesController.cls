public class TailSalesController {

    private final Tail_Sales__c tailSales;
    
    String PageTitle;
    
    public TailSalesController (ApexPages.StandardController stdController) {
      this.tailSales = (Tail_Sales__c)stdController.getRecord();
      this.tailSales.Logged_In_User__c = userinfo.getName();
      if(this.tailSales.Name == null)
      {PageTitle = '';}
      else
      {PageTitle = this.tailSales.Name;}
    }
    
    public String getPageTitle() {
        return this.PageTitle;
    }
    
}