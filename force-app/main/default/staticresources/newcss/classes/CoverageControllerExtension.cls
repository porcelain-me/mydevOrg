public class CoverageControllerExtension {

	String PageTitle = 'Coverage Information';
 	public String id {get;set;}
 	public String empName {get;set;}
 	public String accountName {get;set;}
 	public String tnlId {get;set;}
 	public String role {get;set;}
 	public String comment {get;set;}
 	
 
// 	public CoverageControllerExtension()
    public CoverageControllerExtension(ApexPages.StandardController stdController) 
 	{
 		 
 	     id = ApexPages.currentPage().getParameters().get('id1');
 	     if(id!=null)
 	     {
 	     List <MSET_Account__c> tempList = [select Name,TNL_ID__c from MSET_Account__c where Id =: id];
	     MSET_Account__c acct=(MSET_Account__c)tempList.get(0);
 		 accountName = acct.Name;
 		 tnlId = acct.TNL_ID__c;	
 	     }
 	     role = 'Electronic Distribution Account Manager';
 	     empName = UserInfo.getName();
 	}
 	
 	

	public String getPageTitle()
	{
		return PageTitle;
		
	}

	public PageReference sendEmail()
	{
		String url = null;
		if(checkValidation())
			return null;
		senEmailCoverageNotification();
		//PageReference currentpage = ApexPages.currentPage(); 
		//String appURL = currentpage.getUrl();
		//String appURL = URL.getSalesforceBaseUrl().toExternalForm() ;
		String appURL = System.Url.getSalesforceBaseUrl().toExternalForm() ;
		 url = appURL+'/'+id;
		PageReference newocp = new PageReference(url);
			newocp.setRedirect(true);
			return newocp;
	}
	
	
	public PageReference cancelButton()
	{
		String url = null;
	//	PageReference currentpage = ApexPages.currentPage(); 
	//	String appURL = currentpage.getUrl();
		String appURL = System.Url.getSalesforceBaseUrl().toExternalForm() ;
		url = appURL+'/'+id;
		PageReference newocp = new PageReference(url);
			newocp.setRedirect(true);
			return newocp;
	}
	/*
	 public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--None--'));
            options.add(new SelectOption('Electronic Distribution Account Manager','Electronic Distribution Account Manager'));
            return options;
        }
	*/
	public String primarycapacityval {get;set;} 
		 public List<SelectOption> getPrimaryCapacity() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--None--'));
            options.add(new SelectOption('n','n'));
            options.add(new SelectOption('y','y'));
            return options;
        }
	
	public String regionval {get;set;} 
		 public List<SelectOption> getRegionList() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--None--'));
            options.add(new SelectOption('AME','AME'));
            options.add(new SelectOption('EME','EME'));
            options.add(new SelectOption('PAN ASIA','PAN ASIA'));
            return options;
        }

	public boolean checkValidation()
	{
		boolean result = false;
		if(empName == null || empName.length()<1)
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You must enter Team Member.');
            ApexPages.addMessage(myMsg);
            result = true;
		}
		if(primarycapacityval == null || primarycapacityval == ' ')
		 {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You must select Primary Capacity.');
            ApexPages.addMessage(myMsg);
            result = true;
		 }
		if(regionval == null || regionval ==' ')
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You must select Region.');
    		 ApexPages.addMessage(myMsg);
			 result = true;
		}
		return result;
	}

 	public void senEmailCoverageNotification()
    {
    	  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	  String[] toAddresses = new String[1];
    	  
    	  if(regionval == 'EME')
    	  	 toAddresses[0] = 'mset-eu-coverage-changes@morganstanley.com.test';
    	  else if (regionval == 'AME')
    	  	 toAddresses[0] = 'mset-na-coverage-changes@morganstanley.com.test';
    	  else
    	   	 toAddresses[0] = 'mset-fe-coverage-changes@morganstanley.com.test';
    	   
    	    mail.setToAddresses(toAddresses);   	 
/*
mset-eu-coverage-changes@morganstanley.com.test – for region = EME
mset-na-coverage-changes@morganstanley.com.test – for region = AME
mset-fe-coverage-changes@morganstanley.com.test – for region = not equals to EME or AME (what are the values for selection?)
*/
   //       mail.setTargetObjectId(UserInfo.getUserId());
          mail.setSaveAsActivity(false);
          mail.setSubject('O2 account coverage update notification');
          mail.setHtmlBody('Please update the following account coverage information on O2: <br></br><br></br>'+
          '<b>Account: </b>'+accountName+' <br></br><br></br>' +
          '<b>TNL ID: </b>'+tnlId+'<br></br><br></br>'+
          '<b>Team Member: </b>'+empName+'<br></br><br></br>'+
          '<b>Role: </b> Electronic Distribution Account Manager<br></br><br></br>'+
          '<b>Primary Capacity: </b>'+primarycapacityval+'<br></br><br></br>'+
          '<b>Region: </b>'+regionval+'<br></br><br></br>' +
          '<b>Comment: </b>'+comment+'<br></br><br></br>'
          );
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}