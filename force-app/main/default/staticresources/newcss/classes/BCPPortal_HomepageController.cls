public class BCPPortal_HomepageController {

    public exception exp{get; set;} 
    public string customPageMessage {get; set;}
    public string typeOfMessage {get; set;}
    public final static string PAGE_ERROR=Label.BCP_Exception_Admin;
    public List<BCP_Event_Frame_Placement__c> eventPlacementList {get; set;}
    
    public BCPPortal_HomepageController(){        
        try{
            eventPlacementList = [SELECT Display_Order__c, Event_Slide__r.BCP_Event__c, Event_Slide__r.Content__c FROM BCP_Event_Frame_Placement__c WHERE Event_Frame__r.Active__c = true ORDER BY Display_Order__c ASC];
        }
        catch(Exception e){
            system.debug('*****Exception in constructor of Home page BCPPortal_HomepageController()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
        }
    }
}