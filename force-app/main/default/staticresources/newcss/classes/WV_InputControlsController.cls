public class WV_InputControlsController {

    public Waiver_Template__c temp {get; set;}
    private List<Input_Controls_Mapping__c> contrls;
    public string inputControlPrefix {get; set;}
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    
    public WV_InputControlsController(ApexPages.StandardController controller) {
        try{
            customPageMessage =null;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null; 
            OrgName=Label.ORG_ENVIRONMENT;                              
            
            this.temp= (Waiver_Template__c)controller.getRecord();
            if(this.temp != null){
                this.temp=[Select id,name FROM Waiver_Template__c where id = :temp.id];
            }
            inputControlPrefix=Schema.getGlobalDescribe().get('Input_Controls_Mapping__c').getDescribe().getKeyPrefix();
        }
        catch(Exception e){
            system.debug('****Exception in constructor of WV_InputControlsController()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;   
        }
    }
    
    public List<Input_Controls_Mapping__c> getControls()
    {
        try{
            if(temp != null){
                contrls = [Select id,name,Waiver_Template__c,Value_Type__c,Input_Control_Type__c,Required__c,scheme__c,Order__c,Control_Visibility__c FROM Input_Controls_Mapping__c where Waiver_Template__c = :temp.id AND scheme__c=null Order by Order__c ASC];
                if(contrls != null && contrls.size() >0){
                    return contrls;
                }
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside getControls()'+e.getlinenumber()+'-'+e.getmessage());                  
        }  
        return null;      
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Template Detail page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }  

}