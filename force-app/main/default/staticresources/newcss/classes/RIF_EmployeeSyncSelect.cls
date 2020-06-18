/** Extension class for RIF_EmployeeSyncSelect VF page
* this class will get the entire SNRs (as per the logged in users access) and give the user the option
* to start a bulk update process where the details from the Project will be synced
**/
public with sharing class RIF_EmployeeSyncSelect {
    // page variables
    public List<Severance_and_Release__c> snrList {get; set;}
    public Set<String> selectedIds {get;set;}
    public Boolean hasSNRs {get; set;}
    public Integer totalSNRs {get; set;}
    public boolean isselectAll {get; set;}
    public boolean isselect {get; set;}
    // processing variables
    public String projectId = '';
    public Project__c project = new Project__c();
    public ApexPages.StandardSetController con {get; set;}
    public List<Severance_and_Release__c> snrList1 ;
    public List<WrapperSNR> listWrapper{get;set;}
    public Map<String,Severance_Release_ETL_Temp__c> snrTempMap;
    
    // constructor for snr list page
    public RIF_EmployeeSyncSelect(ApexPages.StandardController controller){
        snrList = new List<Severance_and_Release__c>();
        snrTempMap = new Map<String,Severance_Release_ETL_Temp__c>();
        selectedIds= new Set<String>();
        listWrapper = new  List<WrapperSNR>(); 
        hasSNRs = false;
        isselectAll = false;
        // get the Project record
        project = (Project__c)controller.getRecord();
        projectId = project.Id;
        /*con = new ApexPages.StandardSetController(Database.getQueryLocator([select id,ownerid,Outplacement__c,Communicated__c,Over_40__c,Over_40_Age_Disclosure__c,Communicated_Date__c,Decisional_Unit__c,exhibit_A__c,name, emp_Id__c,employee__c, status__c, age__c,Document_Generation_Status__c,Document_Download_Status__c,Level_Desc__c,First_Name__c, Last_Name__c, DocVersion__c,Conductor_URL__c,
                                                                            employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c,Project__c,Employee__r.HasEquity__c
                                                                            from Severance_And_Release__c order by name limit 100 ]));
        */
        snrList1 = RIF_UserLevelData.getSyncSRLIStInUserMode(projectId);
        snrTempMap = RIF_UserLevelData.getSyncSRTemp(projectId);
        con = new ApexPages.StandardSetController(snrList1);
        totalSNRs = con.getResultSize();
        con.setPageSize(25);
        getAllSNRs();
    }
    
    
    public Integer getTotalPages(){
        Decimal totalSize = con.getResultSize();
        Decimal pageSize = con.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    // get all the SNRs which are visible to the user
    public void getAllSNRs(){
        if(!String.isEmpty(projectId)){
            snrList = con.getRecords();
            for(Severance_And_Release__c sr : snrList )
            {
                listWrapper.add(new WrapperSNR(sr,snrTempMap.get(sr.Id)));
            }
        }
        if(!snrList.isEmpty()){
            hasSNRs = true;
        }
    }
    
    
    public PageReference redirectPrj()
    {
        PageReference pageRef = new PageReference('/'+projectId);
        pageRef.setredirect(true);
        return pageRef;
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // returns the first page of records
    public void first() {
        //throw new RecordNotFoundException('--sadsd--'+listWrapper.size());
        for(WrapperSNR sr : listWrapper)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.snr.Name);
            }
            else
            {
                selectedIds.remove(sr.snr.Name);
            }
        }
        con.first();
        snrList = con.getRecords();
        listWrapper =  new  List<WrapperSNR>(); 
        for(Severance_And_Release__c sr : snrList )
        {
            if(selectedIds.contains(sr.name))
            {
                listWrapper.add(new WrapperSNR(sr,true,snrTempMap.get(sr.Id)));
            }
            else
            {
                listWrapper.add(new WrapperSNR(sr,snrTempMap.get(sr.Id)));
            }
        }
    }
    
    // returns the last page of records
    public void last() {
        for(WrapperSNR sr : listWrapper)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.snr.Name);
            }
            else
            {
                selectedIds.remove(sr.snr.Name);
            }
        }
        con.last();
        snrList = con.getRecords();
        listWrapper =  new  List<WrapperSNR>(); 
        for(Severance_And_Release__c sr : snrList )
        {
            if(selectedIds.contains(sr.name))
            {
                listWrapper.add(new WrapperSNR(sr,true,snrTempMap.get(sr.Id)));
            }
            else
            {
                listWrapper.add(new WrapperSNR(sr,snrTempMap.get(sr.Id)));
            }
        }
    }
    
    // returns the previous page of records
    public void previous() {
        for(WrapperSNR sr : listWrapper)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.snr.Name);
            }
            else
            {
                selectedIds.remove(sr.snr.Name);
            }
        }
        con.previous();
        snrList = con.getRecords();
        listWrapper =  new  List<WrapperSNR>(); 
        for(Severance_And_Release__c sr : snrList )
        {
            if(selectedIds.contains(sr.name))
            {
                listWrapper.add(new WrapperSNR(sr,true,snrTempMap.get(sr.Id)));
            }
            else
            {
                listWrapper.add(new WrapperSNR(sr,snrTempMap.get(sr.Id)));
            }
        }
    }
    
    // returns the next page of records
    public void next() {
        for(WrapperSNR sr : listWrapper)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.snr.Name);
            }
            else
            {
                selectedIds.remove(sr.snr.Name);
            }
        }
        
       
        con.next();
        snrList = con.getRecords();
        listWrapper =  new  List<WrapperSNR>(); 
        for(Severance_And_Release__c sr : snrList )
        {
            if(selectedIds.contains(sr.name))
            {
                listWrapper.add(new WrapperSNR(sr,true,snrTempMap.get(sr.Id)));
            }
            else
            {
                listWrapper.add(new WrapperSNR(sr,snrTempMap.get(sr.Id)));
            }
        }
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    
    // redirect to synchronize SNRs bulk processor
    public PageReference syncSNRs(){
        for(WrapperSNR sr : listWrapper)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.snr.Name);
            }
            else
            {
                selectedIds.remove(sr.snr.Name);
            }
        }
        String snrName='';
        for(String str : selectedIds)
        {
           	String sr = str+';'; 
            snrName = snrName +sr;
        }
        
        if(snrName.endsWith(';'))
        {
            snrName=snrName.removeEnd(';');
        }
        //throw new RecordNotFoundException('hi=='+snrName);
        PageReference syncPage = Page.RIF_EmployeeSyncProcessorPage;
        syncPage.getParameters().put('projectId',projectId);
        syncPage.getParameters().put('snrName',snrName);
        syncPage.setRedirect(true);
        return syncPage;
    }
    
    public class WrapperSNR{
        public Severance_And_Release__c snr{get;set;}
        public boolean isSelected{get;set;}
       public Severance_Release_ETL_Temp__c snrTemp{get;set;}
        public WrapperSNR(Severance_And_Release__c snr,Severance_Release_ETL_Temp__c snrTemp)
        {
            this.snrTemp = snrTemp;
            this.snr =snr;
        }
        public WrapperSNR(Severance_And_Release__c snr,boolean iselected,Severance_Release_ETL_Temp__c snrTemp)
        {
              this.snrTemp = snrTemp;
            this.snr =snr;
            this.isSelected=iselected;
        }
    }
    
}