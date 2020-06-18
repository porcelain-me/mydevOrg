public class ContactControllerExtension {

    private final MSET_Contact__c contactrequest;
    
    Integer PEFprofile = 0;
    
    public ContactControllerExtension (ApexPages.StandardController stdController) {
        this.contactrequest = (MSET_Contact__c )stdController.getRecord();
        //calcIsPEFprofile();
    }
    
   /* public Integer calcIsPEFprofile()
    {
        if (userinfo.getProfileId() == '00e600000017D9nAAE') //'00eT0000000mLMiIAM' QA one
        {PEFprofile = 1 ;
        return 1;}
        else
        return 0;
    }*/
    
    public Integer getPEFprofile()
    {
        return PEFprofile;
    }

}