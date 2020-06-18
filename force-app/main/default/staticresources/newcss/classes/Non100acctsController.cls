public class Non100acctsController {

    private final Non_100_accts__c non100accts;
    
    String PageTitle;
    Integer MSET_Stage1_Flag = 0 , MSET_Stage2_Flag = 0;
    String MsetCustomer = '';
    
    public Non100acctsController (ApexPages.Standardcontroller stdController) {
      this.non100accts = (Non_100_accts__c)stdController.getRecord();
      this.non100accts.Logged_In_User__c = userinfo.getName();
      calcDisplayFlagMsetStage();
      if(this.non100accts.Name == null)
      {PageTitle = '';}
      else
      {PageTitle = this.non100accts.Name;}
    }
    
    public Integer getMSET_Stage1_Flag() {
        return MSET_Stage1_Flag;
    }
    
    public Integer getMSET_Stage2_Flag() {
        return MSET_Stage2_Flag;
    }
    
    public PageReference calcDisplayFlagMsetStage() {
        
        MsetCustomer = non100accts.MSET_customer_del__c;
        if (((MsetCustomer != null) && MsetCustomer.indexOf('Yes') != -1))
          {
            MSET_Stage2_Flag =1;            
          }
        else
          {
          	MSET_Stage2_Flag =0;
          }
        
        if ((MsetCustomer != null) && (MsetCustomer.indexOf('No') != -1))
          {
            MSET_Stage1_Flag =1;
          }
        else
          {
            MSET_Stage1_Flag =0;
          }
        return null;
    }
    
    
    public PageReference refreshpagesections() 
    {
    	calcDisplayFlagMsetStage();
    	return null;
    }
    
    public String getPageTitle() {
        return this.PageTitle;
    }
    
     public PageReference cloneAction() {
      PageReference editForm = new Apexpages.Standardcontroller(non100accts).edit();
      
      editForm.getParameters().put('flow', 'clone');
      editForm.setRedirect(true); 
      return editForm;    
      } 
    
    
}