public without sharing class Chatter_Disclaimer_Controller{
	  public GPSEmployee__c currentUser{get;set;}
	  public boolean chatterDisclaimerAcknowledgedForCurrentUser{get;set;}
    public Chatter_Disclaimer_Controller(){
    	currentUser = [SELECT Id, Chatter_Disclaimer_Acknowledged__c FROM GPSEmployee__c WHERE User__c = : UserInfo.getUserId()];   
    	chatterDisclaimerAcknowledgedForCurrentUser = currentUser.Chatter_Disclaimer_Acknowledged__c; 	
    }
    
    
    public PageReference Update_Chatter_Disclaimer_Acknowledged(){      
      system.debug('currentUser.Chatter_Disclaimer_Acknowledged__c: ' + currentUser.Chatter_Disclaimer_Acknowledged__c);
      currentUser.Chatter_Disclaimer_Acknowledged__c = true;
      system.debug('currentUser.Chatter_Disclaimer_Acknowledged__c: ' + currentUser.Chatter_Disclaimer_Acknowledged__c);
      try {
         update currentUser;
      } catch (DmlException e) {
        system.debug('Chatter_Disclaimer_Controller DmlException: ' + e);
      }    
      return null;
    }  // end method Update_Chatter_Disclaimer_Acknowledged
}  // end class Chatter_Disclaimer_Controller