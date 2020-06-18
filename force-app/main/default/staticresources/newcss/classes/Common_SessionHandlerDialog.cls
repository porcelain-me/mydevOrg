// 01/18/2012 UV: ORIGINAL  
//                controller class for Common_SessionHandlerDialog component                   
// 
public without sharing class Common_SessionHandlerDialog {
    
  
  public String dialogMessage{get;set;}
  public String dialogHeaderTitle{get;set;}
  public String redirectUrl{get;set;}
  public String appId{get;set;}
  
  private final String DIALOG_ERR_MESSAGE = 'Your Session has expired due to inactivity. Click OK to reload application and start a new session.';
  private final String HEADER_TITLE = 'Timeout Notification';
  private final String REDIRECT_URL = 'https://gpsbeta';
  
  private String getAppId(){
    if(ApexPages.currentPage().getParameters().get('appId') <> null){
       return ApexPages.currentPage().getParameters().get('appId');
    }
    return '';
  }
  
  
  public Common_SessionHandlerDialog() {
      Common_SessionHandlerSettings__c sessionMessages = Common_SessionHandlerSettings__c.getInstance();
            
      appId = getAppId();
      
      if(sessionMessages <> null && sessionMessages.Id <> null) {
        dialogMessage = sessionMessages.Error_Message__c == null || sessionMessages.Error_Message__c == '' ? DIALOG_ERR_MESSAGE : sessionMessages.Error_Message__c;
        dialogHeaderTitle = sessionMessages.Dialogue_Heading__c == null || sessionMessages.Dialogue_Heading__c =='' ? HEADER_TITLE : sessionMessages.Dialogue_Heading__c;
        redirectUrl = sessionMessages.Redirect_Url__c == null || sessionMessages.Redirect_Url__c == '' ? REDIRECT_URL : sessionMessages.Redirect_Url__c;
      } else  {
        dialogMessage = DIALOG_ERR_MESSAGE;
        dialogHeaderTitle = HEADER_TITLE;
        redirectUrl = REDIRECT_URL;
      }
      
  }
}