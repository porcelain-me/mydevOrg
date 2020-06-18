public class FixIssuesInqueriesControllerExtension {
    FIX_Issues_Inquiries__c FIXIssuesInquiries;
    public FixIssuesInqueriesControllerExtension(ApexPages.StandardController stdController)
    {
        // singhrak, REQ2602432, add Requestor__c in below list, phase 2
         stdController.addFields(new List<String>{'Name', 'Counter__c','Close_Status_Flag__c','startTime__c','Requestor__c'});
        this.FIXIssuesInquiries = (FIX_Issues_Inquiries__c)stdController.getRecord();
        system.debug('CVB::'+FIXIssuesInquiries.Close_Status_Flag__c);
        

        if(FIXIssuesInquiries.Close_Status_Flag__c==true)
            statusHiddenCon = 'Closed';

        // singhrak, REQ2602432, phase 2
        searchTerm = FIXIssuesInquiries.Requestor__c;

        totalSecondsHidden = getTotalSeconds();  
        
        if(FIXIssuesInquiries.Name == null)
        {
        // singhrak, REQ2602432, phase 2, remove Requested_For__c
        FIXIssuesInquiries.Opened_By__c = UserInfo.getUserId();
        FIXIssuesInquiries.startTime__c = datetime.now();
        FIXIssuesInquiries.Status__c = 'Submitted';
        }
        
        // REQ2602432,  singhrak, 9march, 2015,Phase 3,start
        this.FIXIssuesInquiries.Logged_In_User__c = userinfo.getName();
        // REQ2602432,singhrak, 9march, 2015,Phase 3,end        
        
        
        System.debug('ssssx'+totalSecondsHidden);
    }
     
     public String PageTitle;
     public String getPageTitle() {
        return PageTitle;
    }
    
    public String counterVal{get;set;}
    public String statusHiddenCon{get;set;} 
    public String startTime {get;set;}
    
    public long totalSecondsHidden {get;set;}
/*    public Integer getTotalSecondsHidden()
    {
    return totalSecondsHidden;
    }
  */       
    public PageReference saveRecord()
    {
        system.debug('ddd::'+counterVal);
        FIXIssuesInquiries.Counter__c = counterVal;
        
        
        if(FIXIssuesInquiries.Status__c == 'Closed')
            FIXIssuesInquiries.Close_Status_Flag__c = true;

        // singhrak, REQ2602432, phase 2
        FIXIssuesInquiries.Requestor__c = searchTerm;   
        
            
        Database.upsert(FIXIssuesInquiries);
        return (new ApexPages.StandardController(FIXIssuesInquiries)).view();
    
    }
    //Close_Status_Flag
    public long getTotalSeconds()
    {
        //String counterVal= FIXIssuesInquiries.Counter__c;
        long diff = 0;
        if(FIXIssuesInquiries.name != null)
            diff = (datetime.now().getTime() - FIXIssuesInquiries.startTime__c.getTime())/1000; 

        system.debug('diff:::'+diff);
        return diff;
    /*  // 2*86400
        // 1*3600
        // 2*60
        // 3
        // 1 day=86400 sec
        // String x="21 days:01:02:03";
        Integer l=1;
        if(counterVal != null){
        List<String>  lst= counterVal.split(':');
        
            if(lst.size() == 4)
            {
                Integer ind=lst[0].indexOf(' ');
                String nm=lst[0].substring(0,ind); 
                l=Integer.valueOf(nm)*86400+Integer.valueOf(lst[1])*3600+Integer.valueOf(lst[2])*60+Integer.valueOf(lst[3]);
            }
            else if(lst.size() == 3)
            {
                l=Integer.valueOf(lst[0])*3600+Integer.valueOf(lst[1])*60+Integer.valueOf(lst[2]);
            }
            
        }
        
        
        return l;
        */
    }
    
    // singhrak, REQ2602432, phase 2, start
    public String searchTerm {get; set;}    
     @RemoteAction
    public static List<User> searchRequestor(String searchTerm) {
        String qry= 'Select u.Name,Id From User u where isactive = true and ( alias like \'%'+ String.escapeSingleQuotes(searchTerm) +'%\' or name like \'%'+ String.escapeSingleQuotes(searchTerm) + '%\')';
        List<User> lstName = Database.query(qry);
        return lstName;
    }
    // singhrak, REQ2602432, phase 2, end
    public void calcAccount()
    {
        if(this.FIXIssuesInquiries.MSET_Account__c!=null)
        {
            List <MSET_Account__c> tempList = [select TNL_ID__c from MSET_Account__c where Id =: this.FIXIssuesInquiries.MSET_Account__c];
            MSET_Account__c acct=(MSET_Account__c)tempList.get(0);
              FIXIssuesInquiries.TNL__c = acct.TNL_ID__c;
        }
        
    }

// singhrak, 9march, 2015, start, Phase 3, REQ2602432

    public String closeNotes {get; set;}
    public void calcGetAccountName() 
    {
        system.debug('sssdfg::'+FIXIssuesInquiries.TNL__c);
        if(FIXIssuesInquiries.TNL__c != null)
        {
            try{
            MSET_Account__c acnt = [select id from MSET_Account__c where RecordType.DeveloperName='TNL' and  MSET_Account__c.TNL_ID__c =: this.FIXIssuesInquiries.TNL__c limit 1];
            FIXIssuesInquiries.MSET_Account__c = acnt.Id;
            }
            catch(Exception e)
            {
                System.debug('no error:'+FIXIssuesInquiries.TNL__c);
                FIXIssuesInquiries.MSET_Account__c = null;
            }   
        }
        else
        {
            FIXIssuesInquiries.MSET_Account__c = null;
        }
        
    }
    
    public PageReference newForm()
    {
    PageReference pg= new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Fix_Issues_Inqueries');
    return pg;
    }
    
    public PageReference closeTicket()
    {
        system.debug('closenotes::'+closeNotes);
        if(FIXIssuesInquiries.comments__c == null)
            FIXIssuesInquiries.comments__c = closeNotes;
        else
            FIXIssuesInquiries.comments__c = FIXIssuesInquiries.comments__c + '\n'+ closeNotes;  
        FIXIssuesInquiries.status__c  = 'Closed';
        FIXIssuesInquiries.Close_Status_Flag__c = true;
        Database.upsert(FIXIssuesInquiries);
        PageReference pg= new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Fix_Issues_Inqueries_View');
        pg.getParameters().put('id',FIXIssuesInquiries.Id);
    return pg;
    }
    // REQ2602432,singhrak, 9march, 2015, Phase 3, end
}