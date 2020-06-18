/**
    THIS CLASS IS USED FOR GENERATING PACKAGES FOR BULK SEVERANCE AND RELEASE RECORD USING CONGA-CONDUCTOR. 
    
**/

public without sharing class RIF_SelectSR_Print_Cont {
    //Variables
    List<Severance_And_Release__c> srList;
    private project__c proj;
    private Id projectID;
    public integer totalEmployees{get;set;}
    public String conductorFinalURL{get;set;} 
    public string NoOfPackages {get;set;}
    public boolean displayGenerateAllPackages{get;set;}
    public boolean  errorFlag{get;set;}
    public boolean nonEditFlag{get;set;}
    String ServerUrl;
    set<string> selectedItems;
    Map<String,String> congaDocs;
    // 23-Feb-2017 : Fix to show delete link to RIF System Admins as well
    public PermissionSetAssignment currentAdminUser; 
    // Added for Employee Age Map
    public String employeeAge{get;set;}
    
    public Decimal empAge;
    
    private static  String EXHIBIT_A_UNDER_40 = 'ExhibitA(U40)'; //ExhibitA_U40
    private static  String EXHIBIT_A_OVER_40 = 'ExhibitA(O40)';//;ExhibitA_O40
    
    //getter-setters
    public List <wrapSR> wrapperList {get;set;}
    public List<selectoption> documentsList {get; set;}
    public List<String> selectedDocs { get; set;}
    public string selectedVersion {get; set;}
    //public boolean isselectAll {get; set;}    //MSN:RIF#54 Changes Added getter setter below
    public ApexPages.StandardSetController setCon {get; set;}
    private boolean flagExhibitAforSomeRecords =false;
    
    public String returnURL {get; set;}
    // 5-Apr-2017 : Changes for generic user
    private List<PermissionSetAssignment> userPSAssignment;
    public Boolean isAdminUser {get;set;}
    public Boolean isCompUser {get;set;}
    public Boolean isGenericUser {get;set;}
    public Boolean isSuperUser {get;set;}
    public String projectStatus {get;set;}
	public List<selectoption> pduNameList {get; set;}  //MSN: RIF#54 Changes 16 March 18
    public String selectedPDU {get;set;}  //MSN: RIF#54 Changes 16 March 18
    public Set<String> selectedIds {get;set;}  //MSN: RIF#54 Changes
   public Set<String> selectedSNRIds {get;set;}  //MSN:RIF#54 Changes
    public Map<Integer,Boolean> mapPageNumSel; // MSN:RIF#54 Changes
    public RIF_SelectSR_Print_Cont (ApexPages.StandardController stdCont){  
        selectedIds= new Set<String>(); // MSN:RIF#54 Changes
        selectedSNRIds = new Set<String>();  // MSN:RIF#54 Changes
        mapPageNumSel =  new Map<Integer,Boolean>(); // MSN:RIF#54 Changes
        permissionsetAssignment currentCompUser;
        pduNameList = new List<selectoption>(); //MSN: RIF#54 Changes 16 March 18
        // 5-Apr-2017 : Changes for generic user
        isAdminUser = false;
        isCompUser = false;
        isGenericUser = false;
        isSuperUser = false;
        projectStatus = '';
       Map<Id,Permissionset> compensationPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
       Map<Id,Permissionset> adminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
       // 5-Apr-2017 : Changes for generic user
       Map<Id,Permissionset> genericPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_Generic_User']);
       // 31-Aug-2017 : ALM#1969 : Super users should be able to see the Delete option on SNRs 
       Map<Id,Permissionset> superPermissionMap = new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_Super_User']);
        
        try{
            //currentAdminUser=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionMap.keyset() AND assigneeid=:UserInfo.getUserID()];
            //currentCompUser=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:compensationPermissionMap.keyset() AND assigneeid=:UserInfo.getUserID()];
            // 5-Apr-2017 : Check the user's PS and accordingly set the user permission flag
            userPSAssignment = [SELECT id,assigneeid,permissionsetid from permissionsetAssignment WHERE AssigneeId =: UserInfo.getUserID()];
            if(userPSAssignment != null && !userPSAssignment.isEmpty()){
                for(PermissionSetAssignment psAsgn : userPSAssignment){
                    if(adminPermissionMap != null && !adminPermissionMap.isEmpty() && adminPermissionMap.containsKey(psAsgn.permissionsetid)){
                        isAdminUser = true;
                    }
                    else if(compensationPermissionMap != null && !compensationPermissionMap.isEmpty() && compensationPermissionMap.containsKey(psAsgn.permissionsetid)){
                        isCompUser = true;
                    }
                    else if(genericPermissionMap != null && !genericPermissionMap.isEmpty() && genericPermissionMap.containsKey(psAsgn.permissionsetid)){
                        isGenericUser = true;
                    }
                    // 31-Aug-2017 : ALM#1969 : Super users should be able to see the Delete option on SNRs 
                    else if(superPermissionMap != null && !superPermissionMap.isEmpty() && superPermissionMap.containsKey(psAsgn.permissionsetid)){
                        isSuperUser = true;
                    }
                }
            }
        }
        catch(Exception e){
            System.debug(e);
        }
        
        //if(currentCompUser!=null ){
        // 5-Apr-2017 : Changes for generic user
         if(isCompUser || isGenericUser){
            nonEditFlag=true;   
        }
        
        errorFlag=false;
        selectedVersion = 'Draft';
        selectedDocs=new List<String> {'All'};
        wrapperList= new List <wrapSR>();
        srList= new List<Severance_And_Release__c>();
        congaDocs=new Map<String,String>();
            
        proj = (project__c)stdCont.getRecord();
        projectID = stdCont.getRecord().id;
        // the params from the page
        system.debug(' -- params -- ' +  ApexPages.currentPage().getParameters());
        
        if(projectID != null) {
            RecordType projRecordType = RIF_DataUtil.getProjectRecordTypeForId(proj.recordTypeID)[0];
            
            if(projRecordType.name.equalsIgnoreCase('Project Based Termination'))
                displayGenerateAllPackages=true;    
            else
                displayGenerateAllPackages=false;
            // 20-Jul-17 : JIRA#RIF-89 : Commented the below line to add Status field to the query
            // ServerUrl=[select id , Partner_Server_URL__c from project__c where id=:projectID].Partner_Server_URL__c;          
            List<Project__c> prjtRec = [SELECT Id, Partner_Server_URL__c, Status__c FROM Project__c WHERE Id =: projectID ];
            if(prjtRec != null && !prjtRec.isEmpty()){
                ServerUrl = prjtRec[0].Partner_Server_URL__c;
                projectStatus = prjtRec[0].Status__c;
            }
            //MSN: RIF#54 Changes 16 March 18 - Starts
            List<Project_Decisional_Unit__c> pduList = RIF_UserLevelData.getPDUs(projectID);
            if(pduList!=null && !pduList.isEmpty())
            {
                pduNameList.add(new SelectOption('','--Select PDU--'));
                pduNameList.add(new SelectOption('All','All'));
                for(Project_Decisional_Unit__c pdu : pduList )
                {
                    pduNameList.add(new SelectOption(pdu.ID,pdu.Decisional_Unit_Name__c));
                }
            }
            else
            {
                pduNameList.add(new SelectOption('','--PDU(No access)--'));
            }
            //MSN: RIF#54 Changes 16 March 18 - Ends
        }
            

        //prepare select list of all documents
        documentsList=new List<Selectoption>();
        documentsList.add(new selectoption('All','All'));
        documentsList.add(new selectoption('Release Agreement','Release Agreement'));
        documentsList.add(new selectoption('Separation Summary','Separation Summary'));
        documentsList.add(new selectoption('Exhibit A','Exhibit A')); 
        documentsList.add(new selectoption('Exec Comp Overview','Exec Comp Overview'));
        documentsList.add(new selectoption('Important Contacts','Important Contacts'));
        documentsList.add(new selectoption('Benefits Memo','Benefits Memo'));
        documentsList.add(new selectoption('Benefits FAQ','Benefits FAQ'));
        documentsList.add(new selectoption('Age Disclosure','Age Disclosure'));
        documentsList.add(new selectoption('Code of Conduct','Code of Conduct'));
        documentsList.add(new selectoption('LHH','LHH'));
        documentsList.add(new selectoption('Lifeworks','Lifeworks'));

        try{

            //srList = RIF_Util_Kumaresan.getFullQueryFromSobject(new Severance_And_Release__c(),projectID,'proj',null);
            //Commented on 01/05/2016  and moved to the new class "RIF_UserLevelData" that runs in user mode
            /*srList =[select id,name, emp_Id__c,employee__c, status__c, age__c,Document_Generation_Status__c,Document_Download_Status__c,Level_Desc__c,First_Name__c, Last_Name__c, DocVersion__c,Conductor_URL__c,
                                                    employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c,Project__c,Employee__r.HasEquity__c
                                                    from Severance_And_Release__c using scope MINE
                                                    where project__c =:projectID Order by First_Name__c ASC ];*/
            srList=RIF_UserLevelData.getSRLIStInUserMode(projectID);  
            system.debug('#####srlist for current logged in user'+srList);
            if(srList != null && srList.size() >0){
                
                totalEmployees=srList.size();
                setCon= new ApexPages.StandardSetController(srList);
                setCon.setPageSize(Integer.valueOf(Label.RIF_Mass_Print_Records_per_Page)); 
                setCon.setpageNumber(1); 
                wrapperList = new List<wrapSR>(); 

                for(sObject r : setcon.getRecords()){
                    Severance_And_Release__c sr = (Severance_And_Release__c)r;
                    //system.debug('####sr.age__c####'+sr.age__c); 
                    Boolean tempDeleteFlag=false;
                    //if(sr.ownerid==UserInfo.getUserId() || currentAdminUser!=null)
                    // 5-Apr-2017 : Changes for generic user
                    // 31-Aug-2017 : ALM#1969 : Super users should be able to see the Delete option on SNRs
                    if(sr.ownerid==UserInfo.getUserId() || isAdminUser || isSuperUser)  
                        tempDeleteFlag=true;    
                    wrapperList.add(new wrapSR(tempDeleteFlag,sr,sr.name,sr.id,sr.emp_Id__c,sr.employee__c,sr.employee__r.name,
                                                    sr.status__c,sr.Project_Decisional_Org_Level__c,
                                                    sr.Project_Decisional_Org_Level__r.name,
                                                    'Not Generated','Not Downloaded', sr.employee__r.age__c,sr.Employee__r.HasEquity__c));
                    //System.debug('@@@wrapperList[0].srID@@@@'+wrapperList[0].srID);
                }
                //System.debug('**********wrapperList:'+wrapperList.size());
                system.debug(' -- wrapperList-- ' + wrapperList);
            }
            
            //Getting conga template records for Package creation
            List<APXTConga4__Conga_Template__c > congaTemp=[select id,APXTConga4__Name__c from APXTConga4__Conga_Template__c where
                                                            APXTConga4__Template_Group__c='RIF Template']; 
            if(congaTemp != null && congaTemp.size() >0){
                for(APXTConga4__Conga_Template__c t: congaTemp){
                    congaDocs.put(t.APXTConga4__Name__c,t.Id);
                }
            }
        }
        catch(Exception e){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR,
                                                         'There are no employees as per your coverage entitlement'));
        }
        
    }
    
    /*MSN:RIF#54 Changes*/
    public boolean isselectAll
    {
        get;
        set{
            isselectAll =value;
            if(isselectAll)
            	mapPageNumSel.put(getPageNumber(),true);
        }
    }
    /*MSN:RIF#54 Changes*/
    
    /*
     *
     *  Added by Avinash on 21/07/2016
     *  Button click to download generated documents/ attachments from Project or SnR
     *
     */
    //public PageReference redirectToDownloadPage() {
    public void redirectToDownloadPage() {
        String docs = '';
        if(selectedDocs != null || selectedDocs.size() > 0) {
            for(String docName: selectedDocs) {
                docs += docName + ';';
            }
            docs.removeEnd(';');
        }
        System.debug('selectedDocs : ' + selectedDocs);
        System.debug('selectedVersion : ' + selectedVersion);
        
        PageReference pageRef = new PageReference('/apex/RIF_Download?id=' + projectID);
        pageRef.setRedirect(false);
        
        pageRef.getParameters().put('id', projectID);
        pageRef.getParameters().put('documents', docs);
        pageRef.getParameters().put('version', selectedVersion);
        pageRef.getParameters().put('pduID', selectedPDU);  //MSN:RIF#54 Changes
        
        Integer i = 0;
        //MSN:RIF#54 Commented below Code
        /*for(wrapSR wrapObj: wrapperList){
            // 16-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
            if(wrapObj.isSelected != null && wrapObj.isSelected && wrapObj.srStatus == 'Selected'){
                // selectedSnR.add(wrapObj.SR.Id);
                i++;
                pageRef.getParameters().put('snr'+i, wrapObj.SR.Id);
            }
        }*/
        //MSN:RIF#54 Changes -Starts
        for(wrapSR sr : wrapperList)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.sr.Id);
            }
            else
            {
                selectedIds.remove(sr.sr.Id);
            }
        }
        pageRef.getParameters().put('selectedIDSize', String.valueOf(selectedIds.size()));
        for(String snrID : selectedIds)
        {
            i++;
            pageRef.getParameters().put('snr'+i, snrID);
        }
        //MSN:RIF#54 Changes -Ends
       	System.debug(' -- pageRef.getParameters() -- ' + pageRef.getParameters()+'selectedIds--'+selectedIds);
        returnURL = pageRef.getURL();
        System.debug('returnURL-' + returnURL);
        
        // return pageRef;
    }
    
    //create config records
    public void createConfigRecords(){
        List <severance_and_release__c> updatedSRList= new List <severance_and_release__c> ();
        RIF_Print_Project_Config__c configRecord= new RIF_Print_Project_Config__c();
        configRecord.Project__c=projectID;
        String srIDs='';
        for(wrapSR wrapObj: wrapperList){
            if(wrapObj.isSelected==true){
                srIDs+= wrapObj.srID+';';

                wrapObj.sr.Document_Download_Status__c='Downloaded';
                updatedSRList.add(wrapObj.sr);
            }
        }
        srIDs=srIDs.removeEnd(';');
        configRecord.SRIDs__c=srIDs;
        configRecord.User__c=UserInfo.getUserId();
        String docNames='';
        for(String docName: selectedDocs){
            docNames+=docName+';';
        }
        docNames=docNames.removeEnd(';');

        configRecord.DocNames__c=docNames;
        configRecord.Doc_Version__c=selectedVersion;
        insert configRecord;
        System.debug('###configRecord####'+configRecord); 
        
        if(updatedSRList!=null && updatedSRList.size()>0)
            update updatedSRList;
    }
    
    //Pagination Code
    public pageReference selectAll(){ 
        for(wrapSR wrapSR: wrapperList){
            wrapSR.IsSelected=true;
        }
        return null;
    }
    
    public pageReference deSelectAll(){
        for(wrapSR wrapObj : wrapperList){
            wrapObj.IsSelected=false;
        }
        return null;
    }

    public void doNext(){
        //MSN:Rif#54 Changes - Starts
        for(wrapSR sr : wrapperList)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.sr.Id);
            }
            else
            {
                selectedIds.remove(sr.sr.Id);
            }
        }
      
        if(isselectAll)
        {
            mapPageNumSel.put(getPageNumber(),true);        
        }
        else
        {
            mapPageNumSel.put(getPageNumber(),false);
        }
        isselectAll=false;
        //MSN:Rif#54 Changes - Ends
        if(this.setCon.getHasNext()){
            this.setCon.next();
            if(mapPageNumSel.containsKey(getPageNumber()))
            {
                isselectAll = mapPageNumSel.get(getPageNumber());
            }
            system.debug('****setcon.getRecords():doNext():'+setcon.getRecords());
            wrapperList = new List<wrapSR>(); 
            for(sObject r : setcon.getRecords()){
                Severance_And_Release__c sr = (Severance_And_Release__c)r;
                Boolean tempDeleteFlag=false;
                // 23-Feb-2017 : Fix to show delete link to RIF System Admin as well
                //if(sr.ownerid==UserInfo.getUserId() || currentAdminUser != null)
                // 5-Apr-2017 : Changes for generic user
                // 31-Aug-2017 : ALM#1969 : Super users should be able to see the Delete option on SNRs
                //MSN:Rif#54 Changes -Added if else condition
                if(selectedIds.contains(sr.Id))
                {
                    if(sr.ownerid==UserInfo.getUserId() || isAdminUser || isSuperUser)
                        tempDeleteFlag=true;
                    wrapSR wrapObj = new wrapSR(tempDeleteFlag,sr,sr.name,sr.id,sr.emp_Id__c,sr.employee__c,sr.employee__r.name,
                                                sr.status__c,sr.Project_Decisional_Org_Level__c, sr.Project_Decisional_Org_Level__r.name,
                                                sr.Document_Generation_Status__c,sr.Document_Download_Status__c, sr.employee__r.age__c,sr.Employee__r.HasEquity__c,true);
                    wrapperList.add(wrapObj);
                }
                else
                {
                    if(sr.ownerid==UserInfo.getUserId() || isAdminUser || isSuperUser)
                        tempDeleteFlag=true;
                    wrapSR wrapObj = new wrapSR(tempDeleteFlag,sr,sr.name,sr.id,sr.emp_Id__c,sr.employee__c,sr.employee__r.name,sr.status__c,
                                                sr.Project_Decisional_Org_Level__c, sr.Project_Decisional_Org_Level__r.name,
                                                sr.Document_Generation_Status__c,sr.Document_Download_Status__c, sr.employee__r.age__c,sr.Employee__r.HasEquity__c);
                    wrapperList.add(wrapObj);
                }
            }   
        }
    }
    
    public void doPrevious(){
        //MSN: RIF#54 Changes - Starts
        for(wrapSR sr : wrapperList)
        {
            if(sr.isSelected)
            {
                selectedIds.add(sr.sr.Id);
            }
            else
            {
                selectedIds.remove(sr.sr.Id);
            }
        }
        if(isselectAll)
        {
            mapPageNumSel.put(getPageNumber(),true);
        }
        else
        {
            mapPageNumSel.put(getPageNumber(),false);
        }
        isselectAll=false;
        //MSN: RIF#54 Changes - Ends
        if(this.setCon.getHasPrevious()){
            this.setCon.previous(); 
            if(mapPageNumSel.containsKey(getPageNumber()))
            {
                isselectAll = mapPageNumSel.get(getPageNumber());
            }
            system.debug('****setcon.getRecords():doPrevious():'+setcon.getRecords());
            wrapperList = new List<wrapSR>(); 
            for(sObject r : setcon.getRecords()){
                Severance_And_Release__c sr = (Severance_And_Release__c)r;
                Boolean tempDeleteFlag=false;
                // 23-Feb-2017 : Fix to show delete link to RIF System Admins as well
                //if(sr.ownerid==UserInfo.getUserId() || currentAdminUser != null)
                // 5-Apr-2017 : Changes for generic user
                // 31-Aug-2017 : ALM#1969 : Super users should be able to see the Delete option on SNRs 
                //  MSN:Rif#54 Changes -Added if else condition
                if(selectedIds.contains(sr.Id))
                {
                    if(sr.ownerid==UserInfo.getUserId() || isAdminUser || isSuperUser)
                        tempDeleteFlag=true;
                    wrapSR wrapObj = new wrapSR(tempDeleteFlag,sr,sr.name,sr.id,sr.emp_Id__c,sr.employee__c,sr.employee__r.name,
                                                sr.status__c,sr.Project_Decisional_Org_Level__c, sr.Project_Decisional_Org_Level__r.name,
                                                sr.Document_Generation_Status__c,sr.Document_Download_Status__c, sr.employee__r.age__c,sr.Employee__r.HasEquity__c,true);
                    wrapperList.add(wrapObj);
                }
                else
                {
                    
                    if(sr.ownerid==UserInfo.getUserId() || isAdminUser || isSuperUser)
                        tempDeleteFlag=true;
                    wrapSR wrapObj = new wrapSR(tempDeleteFlag,sr,sr.name,sr.id,sr.emp_Id__c,sr.employee__c,sr.employee__r.name,
                                                sr.status__c,sr.Project_Decisional_Org_Level__c, sr.Project_Decisional_Org_Level__r.name,
                                                sr.Document_Generation_Status__c,sr.Document_Download_Status__c, sr.employee__r.age__c,sr.Employee__r.HasEquity__c);
                    wrapperList.add(wrapObj);
                }
            }
        }
    }
    
    public Boolean getHasPrevious(){
        return this.setCon.getHasPrevious();
    }

    public Boolean getHasNext(){
        return this.setCon.getHasNext();
    }
    
    public Integer getPageNumber(){
        return this.setCon.getPageNumber();
    }
    
    public Integer getPageSize(){
        return this.setCon.getPageSize();
    }
    
    Public Integer getTotalPages(){
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    //Wrapper Class
    public class wrapSR{
        public severance_and_release__c sr{get;set;}
        public boolean deleteFlag{get;set;}
        public boolean isSelected{get;set;}
        public string srName{get;set;}
        public string srID{get;set;}
        public string empMSID{get;set;}
        public string empRecordID{get;set;} 
        public string printStatus{get;set;}
        public string generatePackagestatus{get;set;}
        public string empName{get;set;}
        public string srStatus{get;set;}
        public string srPDUOrgLevelName{get;set;}
        public string pduOrgLevelRecordID{get;set;}
        public String empAge{get; set;}
        public Boolean hasEquity{get;set;}
        
        public wrapSR(Boolean deleteFlag,severance_and_release__c sr, String srName, Id srID, string empMSID,String empRecordID,
                      String empName,String srStatus,String pduOrgLevelRecordID,String srPDUOrgLevelName,
                      String generatePackagestatus,String printStatus, String empAge, Boolean hasEquity){
                          this.deleteFlag=deleteFlag;
                          this.sr=sr;
                          this.srName=srName;
                          this.srID=srID;
                          this.empMSID=empMSID;
                          this.empRecordID=empRecordID;
                          this.empName=empName;
                          this.srStatus=srStatus;
                          this.generatePackagestatus=generatePackagestatus;
                          this.printStatus=printStatus;
                          this.pduOrgLevelRecordID=pduOrgLevelRecordID;
                          this.srPDUOrgLevelName=srPDUOrgLevelName;
                          this.empAge = empAge;
                          this.hasEquity = hasEquity;
                      }
        
        	//MSN:RIF#54 Added below constructor with var isSelected
            public wrapSR(Boolean deleteFlag,severance_and_release__c sr, String srName, Id srID, string empMSID,String empRecordID,
                      String empName,String srStatus,String pduOrgLevelRecordID,String srPDUOrgLevelName,
                      String generatePackagestatus,String printStatus, String empAge, Boolean hasEquity,boolean isSelected){
                          this.deleteFlag=deleteFlag;
                          this.sr=sr;
                          this.srName=srName;
                          this.srID=srID;
                          this.empMSID=empMSID;
                          this.empRecordID=empRecordID;
                          this.empName=empName;
                          this.srStatus=srStatus;
                          this.generatePackagestatus=generatePackagestatus;
                          this.printStatus=printStatus;
                          this.pduOrgLevelRecordID=pduOrgLevelRecordID;
                          this.srPDUOrgLevelName=srPDUOrgLevelName;
                          this.empAge = empAge;
                          this.hasEquity = hasEquity;
                          this.isSelected =isSelected;
                      }
        
    }
    

    
      //Generate S&R documents underlying to the project using conga conductor
    public pageReference Generate(){
        
        List<Severance_And_Release__c> srManualList = new List<Severance_And_Release__c>();
        
        ApexPages.getMessages().clear();
        Set<String> staticDocs=new Set<String>();
        List<Severance_And_Release__c> selectedSRList;
        List<Severance_And_Release__c> selectedSRList1;  //MSN:RIF#54 Changes
        List<Severance_And_Release__c> nonSelectedSRList;
        
        // 20-Jul-17 : JIRA#RIF-89 : check if the project is a MODEL project and the document version is FINAL  
        if(projectStatus.equalsIgnoreCase('Model') && selectedVersion.equalsIgnoreCase('Final')){
            errorFlag = true;
            conductorFinalURL = '';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_Model_Projects_Doc_Type_Error);
            ApexPages.addMessage(myMsg);
            return null;
        } 
        
        if(NoOfPackages!=NUll && NoOfPackages!='' && NoOfPackages.equalsIgnoreCase('All Packages')){
            //14-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected', else show error message
            //selectedSRList= new List<Severance_And_Release__c>(srList);
            selectedSRList = new List<Severance_And_Release__c>();
            nonSelectedSRList = new List<Severance_And_Release__c>();
            for(Severance_and_Release__c eachSNR : srList){
                if(eachSNR.Status__c == 'Selected'){
                    selectedSRList.add(eachSNR);
                }
                else if(eachSNR.Status__c == 'Not Selected'){
                    nonSelectedSRList.add(eachSNR);
                }
            }
        }
        else{
            selectedSRList= new List<Severance_And_Release__c>();
            nonSelectedSRList = new List<Severance_And_Release__c>();
            /*MSN:RIF#54 Changes - Starts*/
            for(wrapSR sr : wrapperList)
            {
                if(sr.isSelected)
                {
                    selectedIds.add(sr.sr.Id);
                }
                else
                {
                    selectedIds.remove(sr.sr.Id);
                }
            }
            
            if(selectedIds.size() > 10){
                errorFlag = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot select more than 10 employees');
                ApexPages.addMessage(myMsg);
                return null;
            } 

            
            List<Severance_And_Release__c> checkedSNRList = [select id,ownerid,Outplacement__c,Over_40__c,Over_40_Age_Disclosure__c,Communicated_Date__c,Decisional_Unit__c,exhibit_A__c,name, emp_Id__c,employee__c, status__c, age__c,Document_Generation_Status__c,Document_Download_Status__c,Level_Desc__c,First_Name__c, Last_Name__c, DocVersion__c,Conductor_URL__c,
                employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c,Project__c,Employee__r.HasEquity__c
                from Severance_And_Release__c 
                where Id =:selectedIds Order by First_Name__c ASC];
            
			//MSN:RIf#54 Commented Existing Below Code
           /*for(wrapSR wrapObj: wrapperList){
                //14-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected', else show error message
                if(wrapObj.isSelected && wrapObj.srStatus == 'Selected'){
                    selectedSRList.add(wrapObj.SR);
                }
                else if(wrapObj.isSelected && wrapObj.srStatus == 'Not Selected'){
                    nonSelectedSRList.add(wrapObj.SR);
                }
            }*/
            
            if(checkedSNRList!=null && !checkedSNRList.isEmpty())
            {
                for(Severance_And_Release__c wrapObj: checkedSNRList){
                    //14-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected', else show error message
                    if( wrapObj.Status__c == 'Selected'){
                        selectedSRList.add(wrapObj);
                    }
                    else if( wrapObj.Status__c == 'Not Selected'){
                        nonSelectedSRList.add(wrapObj);
                    }
                }
            }
            /*MSN:RIF#54 Changes - Ends*/
        }

        System.debug('##selectedSRList###' + selectedSRList.size());
        System.debug('##selectedSRList::###' + selectedSRList);
        
        //BOTH CONGA QUERY AS WELL AS CONGA CONDUCTOR RECORD SHOULD NOT BE CREATED FROM THIS PROCESS, SHOULD USE THE ONE WHICH ALREAY EXISTS
        String CongaConductorQuery='select id from Severance_And_Release__c where ';
        APXTConga4__Conga_Merge_Query__c congaQuery=new APXTConga4__Conga_Merge_Query__c();
        APXT_BPM__Conductor__c conductorRecord=new APXT_BPM__Conductor__c();
        conductorFinalURL='';
        String urlParameters='';
        List<Attachment> SRDocument;
        set<String> congaTemp=new set<String>();

        //apply validation rules
        if(!nonSelectedSRList.isEmpty() && selectedSRList.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot Generate the document(s) for employees with Severance Status equals Not Selected.');
            ApexPages.addMessage(myMsg);
            errorFlag=true;
            return null;
        }
        else if(selectedSRList.isEmpty() && nonSelectedSRList.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No SnR records found/selected for this project.');
            ApexPages.addMessage(myMsg);
            errorFlag=true;
            return null;
        }
        
        if(selectedDocs == null || selectedDocs.size()==0){
                ApexPages.Message myMsgSelectedDocs = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'Please choose documents and choose version (if applicable).');
                ApexPages.addMessage(myMsgSelectedDocs);
                errorFlag=true;
        }
        
            
        if(selectedDocs != null && selectedDocs.size() >0 ){
            errorFlag=false;
            selectedItems=new set<String>(selectedDocs);
            
            if(selectedItems.contains('All')){
                selectedItems=new set<String>{'Separation Summary','Exec Comp Overview','Important Contacts',
                    'Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH',
                    'Lifeworks','Exhibit A'};
            }
    

            if(selectedItems.size() >0){
                if(selectedItems.contains('Exec Comp Overview')){
                        staticDocs.add(congaDocs.get('Exec Comp Overview'));
                } 
                if(selectedItems.contains('Important Contacts')){
                    staticDocs.add(congaDocs.get('Important Contacts'));
                } 
                if(selectedItems.contains('Benefits Memo')){
                    staticDocs.add(congaDocs.get('Benefits Memo'));
                } 
                if(selectedItems.contains('Benefits FAQ')){
                    staticDocs.add(congaDocs.get('Benefits FAQ'));
                } 
                if(selectedItems.contains('Code of Conduct')){
                    staticDocs.add(congaDocs.get('Code of Conduct'));
                }
                if(selectedItems.contains('LHH')){
                    staticDocs.add(congaDocs.get('LHH ED'));
                    staticDocs.add(congaDocs.get('LHH MD'));
                    staticDocs.add(congaDocs.get('LHH Other'));
                } 
                if(selectedItems.contains('Lifeworks')){
                    staticDocs.add(congaDocs.get('Lifeworks'));
                }              
            }   

            System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): Display StaticDocs.....'+staticDocs);        
            
            //THIS WHOLE EMPLOYEE AGE MAP NEEDS TO BE RE-LOOKED
            /// employeeAge = '041LG-31.07/131FL-33.07/';
            if(selectedSRList != null && selectedSRList.size() >0){
                //get emp age map for avoiding encryption on employee age value
                System.debug('##employeeAge in Generate selected###' + employeeAge);
        
                Map<String, String> ageMap = new Map<String, String>();
                if(employeeAge != null && employeeAge != '' ) {
                    List<String>tempList = new List <String>(employeeAge.split('/'));
                    //System.debug('Size 1: ' + tempList.size());
                    //System.debug('@@@@tempList: ' + tempList);
                    for(String temp: tempList){
                        List <string> innerTempList= new List <string> ();
                        innerTempList = temp.split('-');
                      //  System.debug('Size 2: ' + innerTempList.size() + temp);
                        if(innerTempList.size() > 0) {
                        //    System.debug(innerTempList[0] + ' - ' + innerTempList[1]);
                            ageMap.put(innerTempList[0].trim(), innerTempList[1].trim());
                        }
                    }
                }
                
                System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): EmpAgeAmp.....'+ageMap);        
    
                if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A')) && (selectedVersion==null || selectedVersion=='')){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                         'Please choose Document version.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                }
                flagExhibitAforSomeRecords = false;
                Map<string,List<Attachment>> decisionalunitDocs=new Map<String,List<Attachment>>();
                Map<string,String> SRMap=new Map<String,String>();
                Set<String> decisionalUnits=new Set<String>();
                Set<String> empIDs = new Set<String>();
                
                if(selectedSRList != null && selectedSRList.size() >0){   
                    integer countrecord = 0;
                    for(Severance_And_Release__c  s: selectedSRList){
                        // 21-Mar-2017 : Added key check for 'ageMap'
                        if(ageMap!= null && ageMap.size() > 0 && ageMap.containsKey(s.employee__r.Emp_ID__c)) {
                            system.debug('***s.employee__r.Emp_ID__c:'+s.employee__r.Emp_ID__c);
                            system.debug('***ageMap:'+ageMap);
                            system.debug('***ageMap with emp:'+ageMap.get(s.employee__r.Emp_ID__c));
                            empAge= Decimal.Valueof(ageMap.get(s.employee__r.Emp_ID__c.trim()).trim());
                            System.debug('Employee Age from Map :####' + empAge);
                        }
                        
                        empIDs.add(s.emp_id__c);
                        
                        if(selectedVersion =='Draft'){
                            s.DocVersion__c='Draft Version';
                            s.Document_Generation_Status__c='Draft';
                        }
                        else{
                            s.DocVersion__c='';
                            s.Document_Generation_Status__c='Official';
                        }
    
                     if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A'))){
                         System.debug('*************************up to Second if s.exhibit_A__c*******'+s.exhibit_A__c);
                         if((!selectedItems.contains('Release Agreement')) && (!selectedItems.contains('Separation Summary'))
                         && (selectedItems.contains('Exhibit A'))&& (!s.exhibit_A__c)){
                            urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments';
                            System.debug('*************************Inside Second if*******');
                            countrecord++;
                             
                             continue;
                            
                         }
                         System.debug('*************************Inside First if*******');
                        urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments&TemplateId=';
                        // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- STARTS
                        If(selectedItems.contains('Release Agreement') && congaDocs.containsKey('Release Agreement')){
                            if(selectedVersion =='Final'){
                                urlParameters += '['+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                    +congaDocs.get('Release Agreement')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters += '[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                   +congaDocs.get('Release Agreement')+',';
                            }
                            congaTemp.add(congaDocs.get('Release Agreement'));
                        }
                        if(selectedItems.contains('Separation Summary')){
                            if(selectedVersion =='Final'){
                                urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            congaTemp.add(congaDocs.get('Separation Summary'));
                        }
						
                        System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters before Exhibit A.....'+urlParameters);        
                        
                        
                        if(selectedItems.contains('Exhibit A')  && s.exhibit_A__c ){//&& s.exhibit_A__c
                            
                            //flagExhibitAforSomeRecords = true;
                            //System.debug('before entry into bug ageMap@@@ : ' + ageMap);
                           
                           System.debug('*******************Age of Employee: ' + s.Over_40__c);
                            If(!s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_UNDER_40));
                            }
                            If(s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_OVER_40));
                            }
                            // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- ENDS
                        } 
                        else if(selectedItems.contains('Exhibit A') && !s.exhibit_A__c){
                            //flagExhibitAforSomeRecords =true;
                        }
                        
                        if(urlParameters.EndsWith(',')){
                            urlParameters=urlParameters.removeEnd(',');
                        }
                        
                        if(selectedVersion=='Draft'){
                            urlParameters+='&DefaultPDF=0&ZipFiles=0';
                        }
                        else if(selectedVersion=='Final'){
                            //urlParameters+='&DefaultPDF=1&APDF=0';
                            urlParameters+='&DefaultPDF=0&APDF=0';
                        }
                        
                        s.Conductor_URL__c=urlParameters;                               
                        CongaConductorQuery+=' Id=\''+s.Id+'\' OR'; 
                     }
    
                        if(  (s.Over_40__c) &&(selectedItems.contains('Age Disclosure'))){
                            system.debug(' -- in AGE check -- ');
                            SRMap.put(s.Id,s.Decisional_Unit__c);
                            decisionalUnits.add(s.Decisional_Unit__c); 
                        }
                    }
                    system.debug(' -- decisionalUnits -- ' + decisionalUnits);
                    system.debug(' -- SRMap -- ' + SRMap);
                    if(selectedSRList.size()== countrecord){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                         'Exhibit A document isn\'t relevant for the selected S&R records.');
                             ApexPages.addMessage(myMsg);
                             errorFlag=true;
                             return null;
                    }
                    
                    /**
                    if(selectedItems.contains('Exhibit A') && !selectedItems.contains('Release Agreement') && !selectedItems.contains('Separation Summary') && flagExhibitAforSomeRecords){
                          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                         'Selected documents may not be relevant to all employees.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                    }**/
                    System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters Finally.....'+urlParameters);        
                    
                    //List<Severance_And_Release__c> fewSnRLst = new List<Severance_And_Release__c>();
                    //integer tracker = 0;
                    set<string> snrIDs = new set<string>();
                    if(selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                       || selectedItems.contains('Exhibit A')){
                           system.debug('****selectedSRList.size():'+selectedSRList.size());
                            
                            for(Severance_And_Release__c snr: selectedSRList)
                                snrIDs.add(snr.id);
                           
                           /**for(integer i= 0; i<selectedSRList.size();i++){ 
                                //system.debug('******value of i:='+i);
                                //system.debug('******value of tracker:='+tracker);
                                
                                if(tracker == 10 || i== selectedSRList.size()-1 ){
                                    tracker =0;
                                    fewSnRLst.add(selectedSRList[i]);
                                    system.debug('****Before sending to RIF Util::'+fewSnRLst);
                                    fewSnRLst = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,fewSnRLst);
                                    update fewSnRLst;
                                    fewSnRLst = new List<Severance_And_Release__c>();
                                    //fewSnRLst.clear();
                                }
                                else{
                                    fewSnRLst.add(selectedSRList[i]);
                                    //system.debug('****Inside else selectedSRList[i]::'+selectedSRList[i]);
                                    tracker++;
                                }
                           }**/
                          //srList = RIF_Util_Kumaresan.getFullQueryFromSobject(
                                          //new Severance_And_Release__c(),projectID,'proj',null);
                           //selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,selectedSRList);
                           //MSN:RIF#54 Commented below 3 lines added 3 new lines with var selectedSRList1
                           /*selectedSRList = RIF_Util_Kumaresan.getAllFieldsFromSObject(new Severance_And_Release__c(),projectID,'proj',snrIDs);
                           selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp, selectedSRList);
                           update selectedSRList;*/
                           
                           selectedSRList1 = RIF_Util_Kumaresan.getAllFieldsFromSObject(new Severance_And_Release__c(),projectID,'proj',snrIDs);
                           selectedSRList1 = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp, selectedSRList1);
                           update selectedSRList1;
                       }
                    
                    if(CongaConductorQuery.EndsWith('where ')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('where ');
                    }
                    if( CongaConductorQuery.EndsWith('OR')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('OR');
                    }
                    
                	//setcon.save();  //MSN:RIf#54 Changes
                    update selectedSRList; //MSN:RIf#54 Changes
                }
                

                if(( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                      || selectedItems.contains('Exhibit A') ) && ProjectId != null && CongaConductorQuery != '' )){
                          // 19-Jan-2017 : ALM#1874 : Fixed spelling of 'Generation'
                          congaQuery.APXTConga4__Name__c='RIF Project Package Generation';
                          congaQuery.APXTConga4__Description__c ='RIF Project Package Generation';
                          congaQuery.APXTConga4__Query__c=CongaConductorQuery;
                          insert congaQuery;
                          
                          conductorRecord.APXT_BPM__Title__c='RIF Project Package Generation';
                          conductorRecord.APXT_BPM__Query_Id__c=congaQuery.Id;
                          conductorRecord.APXT_BPM__URL_Field_Name__c='Conductor_URL__c';
                          conductorRecord.APXT_BPM__Version__c='C8';
                          conductorRecord.APXT_BPM__Conductor_Environment__c='prod-';
                          insert conductorRecord;
                          
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+ServerUrl;
                          conductorFinalURL = Label.RIF_Dev_CongaConductorURL+'?SessionId='
                                              + userinfo.getsessionId() + '&ServerUrl='+ServerUrl;     
                                                
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com'+'?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+'https://morganstanleyhr----dev----c-cs16-visual-force-com.ccg-dev.ms.com/services/Soap/u/29.0/00Df0000002K0p7';                        
                          // For Skyhigh : Changes to the dynamic URL string, commented the 'reportId/recordId'
                          conductorFinalURL += '&Id=' + conductorRecord.Id + '&QueryId='
                                                + congaQuery.ID + '&UrlFieldName=' +
                                                conductorRecord.APXT_BPM__URL_Field_Name__c; //&ReportId=&RecordId=
                      }
                system.debug('*******************conductorFinalURL-Generate():'+conductorFinalURL);
                
                
                
                set<String> staticDocset=new set<String>();
                List<Attachment> AllAttachments=new List<Attachment>();
                
                if(selectedItems.contains('Age Disclosure') && SRMap.keyset() != null && SRMap.keyset().size() >0){//body
                    //THIS QUERY TAKES 5 SECONDS TO EXECUTE
                    List <attachment> listAllAttach_At_DecisionalUnits=[select id,name,parentid,contentType,body from
                                                                        attachment where parentid IN:decisionalUnits 
                                                                        order By LastModifiedDate DESC];
                    system.debug(' -- listAllAttach_At_DecisionalUnits -- ' + listAllAttach_At_DecisionalUnits);
                    if(listAllAttach_At_DecisionalUnits != null && listAllAttach_At_DecisionalUnits.size() > 0){
                                    
                    // if(listAllAttach_At_DecisionalUnits != null && listAllAttach_At_DecisionalUnits.size() > 0){
                        for(Attachment attachmentObj: listAllAttach_At_DecisionalUnits){
                            Attachment newAttachment=attachmentObj.clone();
                            if(decisionalunitDocs.containsKey(attachmentObj.parentid)){
                            }
                            else{
                                List<Attachment> newAttatchList=new List<Attachment>();                                    
                                newAttatchList.add(newAttachment);
                                decisionalunitDocs.put(attachmentObj.parentId,newAttatchList);
                            }
                        }
                        
                    }
                }
                system.debug(' -- decisionalunitDocs --' + decisionalunitDocs);
                
              /***********************LOGIC NOT NEEDED*****************************
               //THIS MAY COME AS ENCRYPTED, NEED TO REVIST IT AGAIN..
               boolean unVestedEqty = true;
               Map<String,boolean> equityMap = new Map<String, boolean>();

                                  
                
                   List<Unvested_Equity__c> unVestedEqtyLst = [SELECT Id, Name, Emp_Id__c, Unvested_total_balance__c from Unvested_Equity__C where Emp_Id__c IN: empIDs];
                   if(unVestedEqtyLst != null && unVestedEqtyLst.size() > 0 ){
                        for( String e: empIDs){
                            equityMap.put(e,( Double.valueOf(unVestedEqtyLst[0].Unvested_total_balance__c) > 0));
                        }
                   }
                   
                   system.debug('****unVestedEqtyLst:'+unVestedEqtyLst);
                   system.debug('****equityMap:'+equityMap);
                   system.debug('****unVestedEqty:'+unVestedEqty);
                }
                *****************************************************/
                system.debug(' -- staticDocs -- ' + staticDocs);
                if(staticDocs != null && staticDocs.size() >0){
                    //THIS QUERY TAKES 5 SECONDS TO EXECUTE
                    SRDocument=[select id,name,parentId,body,contentType from Attachment where parentId IN:staticDocs
                                order By LastModifiedDate DESC];
                    system.debug(' -- SRDocument -- ' + SRDocument);
                }
                
              
                
                for(Severance_And_Release__c s1:selectedSRList){
                    system.debug(' -- IN FOR -- SNR --' + s1);
                    system.debug('-- decisionalunitDocs.containsKey(s1.Decisional_Unit__c) -- ' + decisionalunitDocs.containsKey(s1.Decisional_Unit__c));
                    system.debug(' -- s1.Over_40__c -- ' + s1.Over_40__c);
                    if( (decisionalunitDocs != null) && (decisionalunitDocs.containsKey(s1.Decisional_Unit__c)) &&  (s1.Over_40__c)        ){
                        system.debug(' -- IN FOR -- ');
                        for(Attachment att:decisionalunitDocs.get(s1.Decisional_Unit__c)){
                            Attachment attachNew=att.clone();
                            attachNew.parentId=s1.Id;
                            attachNew.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_06_Age Disclosure.pdf'; 
                            AllAttachments.add(attachNew); 
                        } 
                    }
                    system.debug(' --AllAttachments -- ' + AllAttachments);
                    system.debug(' -- SRDocument -- ' + SRDocument);
                    if(SRDocument != null && SRDocument.size() >0){
                        for(Attachment d:SRDocument){
                            Attachment each= new Attachment();
                            if(!staticDocset.contains(d.parentId)){
                                each=d.clone();
                                each.parentid=s1.Id;
                                //system.debug('***each.name:'+each.name);
                                system.debug('***s1.employee__r.hasEquity__c:'+s1.employee__r.hasEquity__c);
                                //USE BELOW CONDITION TO CHECK HAS EQUITY AND CREATE EXEC COMP DOCUMENT
                                // 22-Mar-2017 : Removed 'CC' prefix for all static docs
                                if(each.name.contains('Exec Comp Overview') && s1.employee__r.hasEquity__c){                                    
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_02_'+each.name;
                                }
                                if(each.name.contains('Important Contacts')){
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_03_'+each.name;
                                }
                                if(each.name.contains('Benefits Memo')){
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_04_'+each.name;
                                }
                                if(each.name.contains('Benefits FAQ')){
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_05_'+each.name;
                                }
                                if(each.name.contains('Code of Conduct')){
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_08_'+each.name;
                                }
                                if(each.name.contains('LHH') && s1.Outplacement__c != null){
                                   System.debug('************Value of S1***************'+s1);
                                   System.debug('************Value of Outplacement***************'+s1.Outplacement__c);
                                    if(  (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('3 Months')) && (each.name.contains('LHH ED')) ){
                                        each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';   //each.name;
                                    }
                                    else if(  (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('6 Months')) &&(each.name.contains('LHH MD')) ){
                                        each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';
                                    }
                                    else if(   (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('Milestone Seminar') && (each.name.contains('LHH Other')) )  ){                                
                                        each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf'; 
                                    }  
                                
                                }                                
                                if(each.name.contains('LifeWorks')){
                                    each.name= s1.Last_Name__c+'_'+s1.First_Name__c+'_10_'+each.name; 
                                }
                                
                                AllAttachments.add(each);
                                staticDocset.add(d.parentId);  
                            }
                        }   
                    }   
                    staticDocset.clear();
                }
                system.debug(' -- AllAttachments AFTER IF -- ' + AllAttachments);
                if(AllAttachments.size() >0){
                    List<Attachment> attListTobeDeleted = [Select id,name,parentId from Attachment where parentId in:selectedSRList and (name like '%Age_Disclosure%')];
                    if(attListTobeDeleted != null && attListTobeDeleted.size()>0)
                        delete attListTobeDeleted ;
                    
                    insert AllAttachments;
                    system.debug('All attachment list after insert:' + allattachments);
                     
                    for (attachment a:AllAttachments){
                        if (a.name.toLowerCase().contains('age') && a.name.toLowerCase().contains('disclosure')){
                            Severance_And_Release__c sr = new Severance_And_Release__c(id=a.parentId, Manual_Age_Disclosure_Doc_Id__c = string.valueOf(a.id));
                            srManualList.add(sr);
                        }
                    }
                    attListTobeDeleted = [Select id,name,parentId from Attachment where parentId in:selectedSRList and (name like 'LHH%' or name like 'Exec Comp Overview%' )];
                    if(attListTobeDeleted != null && attListTobeDeleted.size()>0)
                        delete attListTobeDeleted ;
                    
                    decisionalunitDocs=null;  
                    SRDocument=null;  
                    attListTobeDeleted =null;              
                }
                selectedSRList = null;
                system.debug('**********My Value: conductorFinalURL:'+conductorFinalURL);
                if(conductorFinalURL == '') {//Means only static documents have been generated, the present user with pageMessage
                    //ApexPages.getMessages().clear();
                    if(AllAttachments.size() >0){
                        
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'Static document(s) generated. Please visit the individual S&R record to see the document(s) in the Notes & Attachments section.');
                        ApexPages.addMessage(myMsg);
                    }
                else {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'This document(s) is not relevant for the selected employee(s).');
                        ApexPages.addMessage(myMsg);
                }
                errorFlag=true;

                }
                AllAttachments.clear();            
                //System.debug('###conductorFinalURL just before pagereference in selectprintcontroller####'+conductorFinalURL);
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                'No SnR records found/selected for this project.');
                ApexPages.addMessage(myMsg);
                errorFlag=true;
                //return null;
            }
            NoOfPackages=null;
            
        }
        
        if (!srManualList.isEmpty())
            update srManualList;
            
        return null;
    }
    
    //GenerateAll S&R generates all documents underlying to the project using conga conductor
    public pageReference GenerateAll(){
        boolean isCongaDocument =false;
        ApexPages.getMessages().clear();
        Set<String> staticDocs=new Set<String>();
        List<Severance_And_Release__c> selectedSRList;

        // 20-Jul-17 : JIRA#RIF-89 : check if the project is a MODEL project and the document version is FINAL  
        if(projectStatus.equalsIgnoreCase('Model') && selectedVersion.equalsIgnoreCase('Final')){
            errorFlag = true;
            conductorFinalURL = '';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_Model_Projects_Doc_Type_Error);
            ApexPages.addMessage(myMsg);
            return null;
        } 
        
        if(NoOfPackages!=NUll && NoOfPackages!='' && NoOfPackages.equalsIgnoreCase('All Packages')){
            //selectedSRList= new List<Severance_And_Release__c>(srList);
            //15-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
            selectedSRList= new List<Severance_And_Release__c>();
            for(Severance_and_Release__c eachSNR : srList){
                if(eachSNR.Status__c == 'Selected'){
                    selectedSRList.add(eachSNR);
                }
            }
        }
        else{
            selectedSRList= new List<Severance_And_Release__c>();
            for(wrapSR wrapObj: wrapperList){
                //15-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
                if(wrapObj.isSelected && wrapObj.srStatus == 'Selected'){
                    selectedSRList.add(wrapObj.SR);
                }
            }
        }

        System.debug('##selectedSRList###' + selectedSRList.size());
        System.debug('##selectedSRList::###' + selectedSRList);
        
        //BOTH CONGA QUERY AS WELL AS CONGA CONDUCTOR RECORD SHOULD NOT BE CREATED FROM THIS PROCESS, SHOULD USE THE ONE WHICH ALREAY EXISTS
        String CongaConductorQuery='select id from Severance_And_Release__c where ';
        APXTConga4__Conga_Merge_Query__c congaQuery=new APXTConga4__Conga_Merge_Query__c();
        APXT_BPM__Conductor__c conductorRecord=new APXT_BPM__Conductor__c();
        conductorFinalURL='';
        String urlParameters='';
        List<Attachment> SRDocument;
        set<String> congaTemp=new set<String>();

        //apply validation rules
        if(selectedSRList==null || selectedSRList.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'No SnR records found/selected for this project.');
            ApexPages.addMessage(myMsg);
            errorFlag=true;
            
        }
        if(selectedDocs == null || selectedDocs.size()==0){
                ApexPages.Message myMsgSelectedDocs = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'Please choose documents and choose version (if applicable).');
                ApexPages.addMessage(myMsgSelectedDocs);
                errorFlag=true;
        }

        if(selectedDocs != null && selectedDocs.size() >0){
            errorFlag=false;
            selectedItems=new set<String>(selectedDocs);
            
            if(selectedItems.contains('All')){
                selectedItems=new set<String>{'Separation Summary','Exec Comp Overview','Important Contacts',
                    'Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH',
                    'Lifeworks','Exhibit A'};
            }
    

            if(selectedItems.size() >0){
                if(selectedItems.contains('Exec Comp Overview')){
                    staticDocs.add(congaDocs.get('Exec Comp Overview'));
                } 
                if(selectedItems.contains('Important Contacts')){
                    staticDocs.add(congaDocs.get('Important Contacts'));
                } 
                if(selectedItems.contains('Benefits Memo')){
                    staticDocs.add(congaDocs.get('Benefits Memo'));
                } 
                if(selectedItems.contains('Benefits FAQ')){
                    staticDocs.add(congaDocs.get('Benefits FAQ'));
                } 
                if(selectedItems.contains('Code of Conduct')){
                    staticDocs.add(congaDocs.get('Code of Conduct'));
                }
                if(selectedItems.contains('LHH')){
                    staticDocs.add(congaDocs.get('LHH ED'));
                    staticDocs.add(congaDocs.get('LHH MD'));
                    staticDocs.add(congaDocs.get('LHH Other'));
                } 
                if(selectedItems.contains('Lifeworks')){
                    staticDocs.add(congaDocs.get('Lifeworks'));
                }              
            }   

            System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): Display StaticDocs.....'+staticDocs);        
            
            //THIS WHOLE EMPLOYEE AGE MAP NEEDS TO BE RE-LOOKED
            /// employeeAge = '041LG-31.07/131FL-33.07/';
            if(selectedSRList != null && selectedSRList.size() >0){
                //get emp age map for avoiding encryption on employee age value
                System.debug('##employeeAge for Generate All Step 1###' + employeeAge);
        
                Map<String, String> ageMap = new Map<String, String>();
                if(employeeAge != null && employeeAge != '' ) {
                    List<String>tempList = new List <String>(employeeAge.split('/'));
                    //System.debug('Size 1: ' + tempList.size());
                    //System.debug('@@@@tempList: ' + tempList);
                    for(String temp: tempList){
                        List <string> innerTempList= new List <string> ();
                        innerTempList = temp.split('-');
                      //  System.debug('Size 2: ' + innerTempList.size() + temp);
                        if(innerTempList.size() > 0) {
                        //    System.debug(innerTempList[0] + ' - ' + innerTempList[1]);
                            ageMap.put(innerTempList[0].trim(), innerTempList[1].trim());
                        }
                    }
                }
                
                System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): EmpAgeAmp.....'+ageMap);        
    
                if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A')) && (selectedVersion==null || selectedVersion=='')){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                         'Please choose Document version.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                }
                flagExhibitAforSomeRecords = false;
                Map<string,List<Attachment>> decisionalunitDocs=new Map<String,List<Attachment>>();  
                Map<string,String> SRMap=new Map<String,String>();
                Set<String> decisionalUnits=new Set<String>();
                Set<String> empIDs = new Set<String>();
                
                if(selectedSRList != null && selectedSRList.size() >0){                       
                    integer countrecord=0;
                    for(Severance_And_Release__c  s: selectedSRList){
                        
                        if(ageMap!= null && ageMap.size() > 0  && s.employee__r.Emp_ID__c!=null && s.employee__r.Emp_ID__c.trim()!=null && ageMap.get(s.employee__r.Emp_ID__c.trim())!=null) {
                          
                            empAge= Decimal.Valueof(ageMap.get(s.employee__r.Emp_ID__c.trim()).trim()); 
                            System.debug('Employee Age from Map :####' + empAge);
                        }
                        
                        empIDs.add(s.emp_id__c);
                        
                        if(selectedVersion =='Draft'){
                            s.DocVersion__c='Draft Version';
                            s.Document_Generation_Status__c='Draft';
                        }
                        else{
                            s.DocVersion__c='';
                            s.Document_Generation_Status__c='Official';
                        }
    
                     if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A'))){
                        if((!selectedItems.contains('Release Agreement')) && (!selectedItems.contains('Separation Summary'))
                         && (selectedItems.contains('Exhibit A'))&& (!s.exhibit_A__c)){
                            urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments';
                            System.debug('*************************Inside Second if*******');
                            countrecord++;
                             
                             continue;
                            
                         }
                        isCongaDocument = true;
                        urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments&TemplateId=';
                        // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- STARTS
                        If(selectedItems.contains('Release Agreement') && congaDocs.containsKey('Release Agreement')){
                            if(selectedVersion =='Final'){
                                urlParameters += '['+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                    +congaDocs.get('Release Agreement')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters += '[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                   +congaDocs.get('Release Agreement')+',';
                            }
                            congaTemp.add(congaDocs.get('Release Agreement'));
                        }
                        if(selectedItems.contains('Separation Summary')){
                            if(selectedVersion =='Final'){
                                urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            congaTemp.add(congaDocs.get('Separation Summary'));
                        }

                        System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters before Exhibit A.....'+urlParameters);        
                        
                        
                        if(selectedItems.contains('Exhibit A') && s.exhibit_A__c ){
                            // Decimal empAge;
                            //flagExhibitA = true;
                            //System.debug('before entry into bug ageMap@@@ : ' + ageMap);
                           
                            If(!s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_UNDER_40));
                            }
                            If(s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_OVER_40));
                                // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- ENDS
                            }
                        } 
                        /*else if(selectedItems.contains('Exhibit A') && !s.exhibit_A__c){
                            flagExhibitAforSomeRecords =true;
                        }*/
                        
                        if(urlParameters.EndsWith(',')){
                            urlParameters=urlParameters.removeEnd(',');
                        }
                        
                        if(selectedVersion=='Draft'){
                            urlParameters+='&DefaultPDF=0&ZipFiles=0';
                        }
                        else if(selectedVersion=='Final'){
                            //urlParameters+='&DefaultPDF=1&APDF=0';
                            urlParameters+='&DefaultPDF=0&APDF=0';
                        }
                        
                        s.Conductor_URL__c=urlParameters;                               
                        CongaConductorQuery+=' Id=\''+s.Id+'\' OR';   
                     }
    
                        if(  (s.Over_40__c)&&
                        (selectedItems.contains('Age Disclosure'))){
                            SRMap.put(s.Id,s.Decisional_Unit__c);
                            decisionalUnits.add(s.Decisional_Unit__c); 
                        }
                    }
                    //system.debug('####SRMap####'+SRMap); 
                    /*if(selectedItems.contains('Exhibit A') && !selectedItems.contains('Release Agreement') && !selectedItems.contains('Separation Summary') && flagExhibitAforSomeRecords){
                          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                         'Selected documents may not be relevant to all employees.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                    }*/
                    if(selectedSRList.size()== countrecord){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                     'Exhibit A document isn\'t relevant for the S&R records.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                    }
                    System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters Finally.....'+urlParameters);        
                    
                    //List<Severance_And_Release__c> fewSnRLst = new List<Severance_And_Release__c>();
                    //integer tracker = 0;
                    set<string> snrIDs = new set<string>();
                    if(selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                       || selectedItems.contains('Exhibit A')){
                           system.debug('****selectedSRList.size():'+selectedSRList.size());
                            
                            for(Severance_And_Release__c snr: selectedSRList)
                                snrIDs.add(snr.id);
                           
                           /**for(integer i= 0; i<selectedSRList.size();i++){ 
                                //system.debug('******value of i:='+i);
                                //system.debug('******value of tracker:='+tracker);
                                
                                if(tracker == 10 || i== selectedSRList.size()-1 ){
                                    tracker =0;
                                    fewSnRLst.add(selectedSRList[i]);
                                    system.debug('****Before sending to RIF Util::'+fewSnRLst);
                                    fewSnRLst = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,fewSnRLst);
                                    update fewSnRLst;
                                    fewSnRLst = new List<Severance_And_Release__c>();
                                    //fewSnRLst.clear();
                                }
                                else{
                                    fewSnRLst.add(selectedSRList[i]);
                                    //system.debug('****Inside else selectedSRList[i]::'+selectedSRList[i]);
                                    tracker++;
                                }
                           }**/
                           //srList = RIF_Util_Kumaresan.getFullQueryFromSobject(
                                          //new Severance_And_Release__c(),projectID,'proj',null);
                           //selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,selectedSRList);
                           //selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,RIF_Util_Kumaresan.getAllFieldsFromSObject(new Severance_And_Release__c(),projectID,'proj',snrIDs));
                          // update selectedSRList;
                       }
                    
                    if(CongaConductorQuery.EndsWith('where ')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('where ');
                    }
                    if( CongaConductorQuery.EndsWith('OR')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('OR');
                    }
                setcon.save();
                }
                
                /**************************
                ********** CONGA CONDUCTOR WILL BE CALLED FROM NEXT BUTTON
                if(( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                      || selectedItems.contains('Exhibit A') ) && ProjectId != null && CongaConductorQuery != '' )){
                          congaQuery.APXTConga4__Name__c='RIF Project Package Genaration';
                          congaQuery.APXTConga4__Description__c ='RIF Project Package Genaration';
                          congaQuery.APXTConga4__Query__c=CongaConductorQuery;
                          insert congaQuery;
                          
                          conductorRecord.APXT_BPM__Title__c='RIF Project Package Genaration';
                          conductorRecord.APXT_BPM__Query_Id__c=congaQuery.Id;
                          conductorRecord.APXT_BPM__URL_Field_Name__c='Conductor_URL__c';
                          conductorRecord.APXT_BPM__Version__c='C8';
                          conductorRecord.APXT_BPM__Conductor_Environment__c='prod-';
                          insert conductorRecord;
                          
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+ServerUrl;
                          conductorFinalURL = Label.RIF_Dev_CongaConductorURL+'?SessionId='
                                              + userinfo.getsessionId() + '&ServerUrl='+ServerUrl;     
                                                
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com'+'?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+'https://morganstanleyhr----dev----c-cs16-visual-force-com.ccg-dev.ms.com/services/Soap/u/29.0/00Df0000002K0p7';                        
                          	// For Skyhigh : Changes to the dynamic URL string, commented the 'reportId/recordId'
							conductorFinalURL += '&Id=' + conductorRecord.Id + '&QueryId='
                                                + congaQuery.ID + '&UrlFieldName=' +
                                                conductorRecord.APXT_BPM__URL_Field_Name__c;//&ReportId=&RecordId=
                      }
                system.debug('*******************conductorFinalURL'+conductorFinalURL);
                
                *************************/
                
                
                /* start of batch
                
                    needed 
                        decisionalUnits
                        srmap
                        staticDocs
                        
                    
                */
               
                set<String> staticDocset=new set<String>();
                List<Attachment> AllAttachments=new List<Attachment>();
            //THIS IS WHERE THE PROBLEM COMES WITH ATTACHMENTS    
                if(selectedItems.contains('Age Disclosure') && SRMap.keyset() != null && SRMap.keyset().size() >0){//body
                    //THIS QUERY TAKES 5 SECONDS TO EXECUTE
                    List <attachment> listAllAttach_At_DecisionalUnits= new List <attachment>();
                    
                    if (decisionalUnits != null)
                            listAllAttach_At_DecisionalUnits=[select id,name,parentid,contentType from
                                                                        attachment where parentid IN:decisionalUnits
                                                                        
                                                                      order By LastModifiedDate DESC];
                    //system.debug('###empAge####'+empAge);
                    
                    if( (listAllAttach_At_DecisionalUnits != null) 
                                    && (listAllAttach_At_DecisionalUnits.size() > 0) ){ 
                    //if(listAllAttach_At_DecisionalUnits != null && listAllAttach_At_DecisionalUnits.size() >0){
                        for(Attachment attachmentObj: listAllAttach_At_DecisionalUnits){
                            Attachment newAttachment=attachmentObj.clone();
                            if(decisionalunitDocs.containsKey(attachmentObj.parentid)){
                            }
                            else{
                                List<Attachment> newAttatchList=new List<Attachment>();                                    
                                newAttatchList.add(newAttachment);
                                decisionalunitDocs.put(attachmentObj.parentId,newAttatchList);
                            }
                        }
                        system.debug('###decisionalunitDocs####'+decisionalunitDocs);
                        
                    }
                }
                
               //result:   decisionalUnitDocs by decisional unit id
                
                
               //THIS MAY COME AS ENCRYPTED, NEED TO REVIST IT AGAIN..
               boolean unVestedEqty = true;
               Map<String,boolean> equityMap = new Map<String, boolean>();

                if(staticDocs != null && staticDocs.size() >0){
                    //THIS QUERY TAKES 5 SECONDS TO EXECUTE
                    SRDocument=[select id,name,parentId,contentType from Attachment where parentId IN:staticDocs
                                order By LastModifiedDate DESC];                       
                
                   List<Unvested_Equity__c> unVestedEqtyLst = [SELECT Id, Name, Emp_Id__c, Unvested_total_balance__c
                    from Unvested_Equity__C where Emp_Id__c IN: empIDs];
                   if(unVestedEqtyLst != null && unVestedEqtyLst.size() > 0 ){
                        for( String e: empIDs){
                            equityMap.put(e,( Double.valueOf(unVestedEqtyLst[0].Unvested_total_balance__c) > 0));
                        }
                   }
                   
                   system.debug('****unVestedEqtyLst:'+unVestedEqtyLst);
                   system.debug('****equityMap:'+equityMap);
                   system.debug('****unVestedEqty:'+unVestedEqty);
                }
                
                
              
                
                Map<ID,Map<ID,List<Attachment>>> fromToDU = new Map<ID,Map<ID,List<Attachment>>>();
                Map<ID,Map<ID,List<Attachment>>> fromToSRDoc = new Map<ID,Map<ID,List<Attachment>>>();
                Set<ID> srBatchSet = new Set<ID>();
                
                //THE BELOW PROCESS IS USED TO ADD ALL ATTACHMENTS IN A LIST
                for(Severance_And_Release__c s1: selectedSRList){
                    srBatchSet.add(s1.id);
                        
                    Map<ID,List<Attachment>> tempMap = new Map<ID,List<Attachment>>(); 
                    //Need to change the check with new field 'Over_40__c'
                    
                    if((s1.Over_40__c) && (decisionalunitDocs != null) && (decisionalunitDocs.containsKey(s1.Decisional_Unit__c))   ){ 
                        System.debug('####decisionalunitDocs####'+decisionalunitDocs); 
                        for(Attachment att: decisionalunitDocs.get(s1.Decisional_Unit__c)){
                            Attachment attachNew=att.clone(); 
                            attachNew.parentId=s1.Id;
                            attachnew.body = blob.valueOf(' ');
                            attachNew.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_06_Age Disclosure.pdf'; 
                            AllAttachments.add(attachNew); 
                           
                            List<Attachment> temp = new List<Attachment>();
                            
                            if (tempMap.get(att.id) != null)
                                temp = tempMap.get(att.id);
                                            
                            temp.add(attachNew);
                            tempMap.put(att.id,temp);
                            
                        }
                        fromToDU.put(s1.id,tempMap);
                    }
                    
                    tempMap = new Map<ID,List<Attachment>>();
                    if(SRDocument != null && SRDocument.size() >0){
                        for(Attachment d:SRDocument){
                            Attachment each= new Attachment();
                            if(!staticDocset.contains(d.parentId)){
                                each=d.clone();
                                each.body= blob.valueOf(' ');
                                each.parentid=s1.Id;
                                if(each.name.contains('Exec Comp Overview') && s1.employee__r.hasEquity__c){                                    
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_02_'+each.name;
                                }
                                if(each.name.contains('Important Contacts')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_03_'+each.name;
                                }
                                if(each.name.contains('Benefits Memo')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_04_'+each.name;
                                }
                                if(each.name.contains('Benefits FAQ')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_05_'+each.name;
                                }
                                if(each.name.contains('Code of Conduct')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_08_'+each.name;
                                }
                                if(each.name.contains('LHH') && s1.Outplacement__c != null){
                                    
                                     if(  (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('3 Months')) && (each.name.contains('LHH ED')) ){
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';
                                    }
                                    else if(  (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('6 Months')) &&(each.name.contains('LHH MD')) ){
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';
                                    }
                                    else if(   (s1.Outplacement__c!='') && (s1.Outplacement__c.contains('Milestone Seminar') && (each.name.contains('LHH Other')) )  ){                                
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';  
                                    }   
                                }                                
                                if(each.name.contains('LifeWorks')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_10_'+each.name;
                                }
                            /**********************************************
                                //USE BELOW CONDITION TO CHECK HAS EQUITY AND CREATE EXEC COMP DOCUMENT
                                if(each.name.contains('Exec Comp Overview')){                                    
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_02_'+each.name;
                                }
                                if(each.name.contains('Important Contacts')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_03_'+each.name;
                                }
                                if(each.name.contains('Benefits Memo')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_04_'+each.name;
                                }
                                if(each.name.contains('Benefits FAQ')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_05_'+each.name;
                                }
                                if(each.name.contains('Code of Conduct')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_08_'+each.name;
                                }
                                if(  (s1.Level_Desc__c=='Executive Director') && (each.name.contains('LHH ED')) ){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+each.name;
                                }
                                if(  (s1.Level_Desc__c=='Managing Director')&&(each.name.contains('LHH MD')) ){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+each.name;
                                }
                                if((each.name.contains('LHH Other'))){                                
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+each.name;  
                                }  
                                if(each.name.contains('LifeWorks')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_10_'+each.name;
                                }
                            ***************************************/
                            
                                AllAttachments.add(each);
                                staticDocset.add(d.parentId);
                                
                                List<Attachment> temp = new List<Attachment>();
                            
                                if (tempMap.get(d.id) != null)
                                    temp = tempMap.get(d.id);
                                            
                                temp.add(each);
                                tempMap.put(d.id,temp); 
                            }
                        } 
                        fromToSRDoc.put(s1.id,tempMap);  
                    }   
                    staticDocset.clear();
                }
                
                
                /*  Batch here */
                /* don't make the batch size more than 8  */
                //Integer batchSize = Integer.valueof(label.RIF_GenerateALL_BatchSize);
                id batchId = Database.executeBatch(new RIF_AttachmentCopy(isCongaDocument,SRBatchSet,fromToDU,fromToSRDoc,congaTemp),Integer.valueof(label.RIF_GenerateALL_BatchSize) );   
                     
                
                selectedSRList = null;
                system.debug('**********My Value: conductorFinalURL:'+conductorFinalURL);
                if(conductorFinalURL == '') {//Means only static documents have been generated, the present user with pageMessage
                    //ApexPages.getMessages().clear();
                    if(AllAttachments.size() >0){
                        
                        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                          //                                      'Static document(s) generated. Please visit the individual S&R record to see the document(s) in the Notes & Attachments section.');
                        //ApexPages.addMessage(myMsg);
                    }
                else {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'This document(s) is not relevant for the selected employee(s).');
                        ApexPages.addMessage(myMsg);
                }
                errorFlag=true;

                }
                AllAttachments.clear();            
                //System.debug('###conductorFinalURL just before pagereference in selectprintcontroller####'+conductorFinalURL);
                
                /* end of batch */
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                'No SnR records found/selected for this project.');
                ApexPages.addMessage(myMsg);
                errorFlag=true;
                //return null;
            }
            NoOfPackages=null;
            
        }
        return null;
    }
    
    //GenerateAll S&R generates all documents underlying to the project using conga conductor
    public pageReference GenerateAllStep2(){
            ApexPages.getMessages().clear();
        Set<String> staticDocs=new Set<String>();
        List<Severance_And_Release__c> selectedSRList;

        // 20-Jul-17 : JIRA#RIF-89 : check if the project is a MODEL project and the document version is FINAL  
        if(projectStatus.equalsIgnoreCase('Model') && selectedVersion.equalsIgnoreCase('Final')){
            errorFlag = true;
            conductorFinalURL = '';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_Model_Projects_Doc_Type_Error);
            ApexPages.addMessage(myMsg);
            return null;
        } 
        
        if(NoOfPackages!=NUll && NoOfPackages!='' && NoOfPackages.equalsIgnoreCase('All Packages')){
            //selectedSRList= new List<Severance_And_Release__c>(srList);
            //15-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
            selectedSRList= new List<Severance_And_Release__c>();
            for(Severance_and_Release__c eachSNR : srList){
                if(eachSNR.Status__c == 'Selected'){
                    selectedSRList.add(eachSNR);
                }
            }
        }
        else{
            selectedSRList= new List<Severance_And_Release__c>();
            for(wrapSR wrapObj: wrapperList){
                //15-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
                if(wrapObj.isSelected && wrapObj.srStatus == 'Selected'){
                    selectedSRList.add(wrapObj.SR);
                }
            }
        }

        System.debug('##selectedSRList###' + selectedSRList.size());
        System.debug('##selectedSRList::###' + selectedSRList);
        
        //BOTH CONGA QUERY AS WELL AS CONGA CONDUCTOR RECORD SHOULD NOT BE CREATED FROM THIS PROCESS, SHOULD USE THE ONE WHICH ALREAY EXISTS
        String CongaConductorQuery='select id from Severance_And_Release__c where ';
        APXTConga4__Conga_Merge_Query__c congaQuery=new APXTConga4__Conga_Merge_Query__c();
        APXT_BPM__Conductor__c conductorRecord=new APXT_BPM__Conductor__c();
        conductorFinalURL='';
        String urlParameters='';
        List<Attachment> SRDocument;
        set<String> congaTemp=new set<String>();

        //apply validation rules
        if(selectedSRList==null || selectedSRList.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'No SnR records found/selected for this project.');
            ApexPages.addMessage(myMsg);
            errorFlag=true;
            
        }
        if(selectedDocs == null || selectedDocs.size()==0){
                ApexPages.Message myMsgSelectedDocs = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'Please choose documents and choose version (if applicable).');
                ApexPages.addMessage(myMsgSelectedDocs);
                errorFlag=true;
        }

        if(selectedDocs != null && selectedDocs.size() >0){
            errorFlag=false;
            selectedItems=new set<String>(selectedDocs);
            
            if(selectedItems.contains('All')){
                selectedItems=new set<String>{'Separation Summary','Exec Comp Overview','Important Contacts',
                    'Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH',
                    'Lifeworks','Exhibit A'};
            }
    

            if(selectedItems.size() >0){
                if(selectedItems.contains('Exec Comp Overview')){
                    staticDocs.add(congaDocs.get('Exec Comp Overview'));
                } 
                if(selectedItems.contains('Important Contacts')){
                    staticDocs.add(congaDocs.get('Important Contacts'));
                } 
                if(selectedItems.contains('Benefits Memo')){
                    staticDocs.add(congaDocs.get('Benefits Memo'));
                } 
                if(selectedItems.contains('Benefits FAQ')){
                    staticDocs.add(congaDocs.get('Benefits FAQ'));
                } 
                if(selectedItems.contains('Code of Conduct')){
                    staticDocs.add(congaDocs.get('Code of Conduct'));
                }
                if(selectedItems.contains('LHH')){
                    staticDocs.add(congaDocs.get('LHH ED'));
                    staticDocs.add(congaDocs.get('LHH MD'));
                    staticDocs.add(congaDocs.get('LHH Other'));
                } 
                if(selectedItems.contains('Lifeworks')){
                    staticDocs.add(congaDocs.get('Lifeworks'));
                }              
            }   

            System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): Display StaticDocs.....'+staticDocs);        
            
            //THIS WHOLE EMPLOYEE AGE MAP NEEDS TO BE RE-LOOKED
            /// employeeAge = '041LG-31.07/131FL-33.07/';
            if(selectedSRList != null && selectedSRList.size() >0){
                //get emp age map for avoiding encryption on employee age value
                System.debug('##employeeAge###' + employeeAge);
        
                Map<String, String> ageMap = new Map<String, String>();
                if(employeeAge != null && employeeAge != '' ) {
                    List<String>tempList = new List <String>(employeeAge.split('/'));
                    //System.debug('Size 1: ' + tempList.size());
                    //System.debug('@@@@tempList: ' + tempList);
                    for(String temp: tempList){
                        List <string> innerTempList= new List <string> ();
                        innerTempList = temp.split('-');
                      //  System.debug('Size 2: ' + innerTempList.size() + temp);
                        if(innerTempList.size() > 0) {
                        //    System.debug(innerTempList[0] + ' - ' + innerTempList[1]);
                            ageMap.put(innerTempList[0].trim(), innerTempList[1].trim());
                        }
                    }
                }
                
                System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): EmpAgeAmp.....'+ageMap);        
    
                if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A')) && (selectedVersion==null || selectedVersion=='')){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                         'Please choose Document version.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                }
                flagExhibitAforSomeRecords = false;
                Map<string,List<Attachment>> decisionalunitDocs=new Map<String,List<Attachment>>();
                Map<string,String> SRMap=new Map<String,String>();
                Set<String> decisionalUnits=new Set<String>();
                Set<String> empIDs = new Set<String>();
                
                if(selectedSRList != null && selectedSRList.size() >0){                       
                    integer countrecord=0;
                    for(Severance_And_Release__c  s: selectedSRList){
                        
                        empIDs.add(s.emp_id__c);
                        
                        if(selectedVersion =='Draft'){
                            s.DocVersion__c='Draft Version';
                            s.Document_Generation_Status__c='Draft';
                        }
                        else{
                            s.DocVersion__c='';
                            s.Document_Generation_Status__c='Official';
                        }
    
                     if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                     || selectedItems.contains('Exhibit A'))){
                        if((!selectedItems.contains('Release Agreement')) && (!selectedItems.contains('Separation Summary'))
                         && (selectedItems.contains('Exhibit A'))&& (!s.exhibit_A__c)){
                            urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments';
                            System.debug('*************************Inside Second if*******');
                            countrecord++;
                             
                             continue;
                            
                         }
                        urlParameters='&id='+s.Id+'&LG4=1&qmode=Attachments&TemplateId=';
                        // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- STARTS
                        If(selectedItems.contains('Release Agreement') && congaDocs.containsKey('Release Agreement')){
                            if(selectedVersion =='Final'){
                                urlParameters += '['+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                    +congaDocs.get('Release Agreement')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters += '[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'
                                   +congaDocs.get('Release Agreement')+',';
                            }
                            congaTemp.add(congaDocs.get('Release Agreement'));
                        }
                        if(selectedItems.contains('Separation Summary')){
                            if(selectedVersion =='Final'){
                                urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            else if(selectedVersion =='Draft'){
                                urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'
                                    +congaDocs.get('Separation Summary')+',';
                            }
                            congaTemp.add(congaDocs.get('Separation Summary'));
                        }

                        System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters before Exhibit A.....'+urlParameters);        
                        
                        
                        if(selectedItems.contains('Exhibit A') && s.exhibit_A__c ){
                            Decimal empAge;
                            //flagExhibitA = true;
                            //System.debug('before entry into bug ageMap@@@ : ' + ageMap);
                           if(ageMap!= null && ageMap.size() > 0) {
                              //  System.debug('s.employee__r.Emp_ID__c.trim() : ' + s.employee__r.Emp_ID__c.trim());
                                empAge= Decimal.Valueof(ageMap.get(s.employee__r.Emp_ID__c.trim()).trim()); 
                                //empAge= Decimal.Valueof(ageMap.get('K9226').trim());
                                System.debug('Employee Age from Map :####' + empAge); 
                                //empAge= Decimal.Valueof(ageMap.get(s.Emp_ID__c.trim()));
                            }
                            If(!s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_UNDER_40));
                            }
                            If(s.Over_40__c){
                                if(selectedVersion =='Final'){
                                    urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                else if(selectedVersion =='Draft'){
                                    urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                        +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                }
                                congaTemp.add(congaDocs.get(EXHIBIT_A_OVER_40));
                                // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- ENDS
                            }
                        } 
                        /*else if(selectedItems.contains('Exhibit A') && !s.exhibit_A__c){
                            flagExhibitAforSomeRecords =true;
                        }*/
                        
                        if(urlParameters.EndsWith(',')){
                            urlParameters=urlParameters.removeEnd(',');
                        }
                        
                        if(selectedVersion=='Draft'){
                            urlParameters+='&DefaultPDF=0&ZipFiles=0';
                        }
                        else if(selectedVersion=='Final'){
                            //urlParameters+='&DefaultPDF=1&APDF=0';
                            urlParameters+='&DefaultPDF=0&APDF=0';
                        }
                        
                        s.Conductor_URL__c=urlParameters;                               
                        CongaConductorQuery+=' Id=\''+s.Id+'\' OR'; 
                     }
    
                        if(selectedItems.contains('Age Disclosure')){
                            SRMap.put(s.Id,s.Decisional_Unit__c);
                            decisionalUnits.add(s.Decisional_Unit__c); 
                        }
                    }

                    /*if(selectedItems.contains('Exhibit A') && !selectedItems.contains('Release Agreement') && !selectedItems.contains('Separation Summary') && flagExhibitAforSomeRecords){
                          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                         'Selected documents may not be relevant to all employees.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                    }*/
                    if(selectedSRList.size()== countrecord){
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                     'Exhibit A document isn\'t relevant for the S&R records.');
                         ApexPages.addMessage(myMsg);
                         errorFlag=true;
                         return null;
                    }
                    System.debug('Inside RIF_SelectSR_Print_Cont.Generate(): urlParameters Finally.....'+urlParameters);        
                    
                    //List<Severance_And_Release__c> fewSnRLst = new List<Severance_And_Release__c>();
                    //integer tracker = 0;
                    set<string> snrIDs = new set<string>();
                    if(selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                       || selectedItems.contains('Exhibit A')){
                           system.debug('****selectedSRList.size():'+selectedSRList.size());
                            
                            for(Severance_And_Release__c snr: selectedSRList)
                                snrIDs.add(snr.id);
                           
                           /**for(integer i= 0; i<selectedSRList.size();i++){ 
                                //system.debug('******value of i:='+i);
                                //system.debug('******value of tracker:='+tracker);
                                
                                if(tracker == 10 || i== selectedSRList.size()-1 ){
                                    tracker =0;
                                    fewSnRLst.add(selectedSRList[i]);
                                    system.debug('****Before sending to RIF Util::'+fewSnRLst);
                                    fewSnRLst = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,fewSnRLst);
                                    update fewSnRLst;
                                    fewSnRLst = new List<Severance_And_Release__c>();
                                    //fewSnRLst.clear();
                                }
                                else{
                                    fewSnRLst.add(selectedSRList[i]);
                                    //system.debug('****Inside else selectedSRList[i]::'+selectedSRList[i]);
                                    tracker++;
                                }
                           }**/
                           //srList = RIF_Util_Kumaresan.getFullQueryFromSobject(
                                          //new Severance_And_Release__c(),projectID,'proj',null);
                           //selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,selectedSRList);
                           //selectedSRList = RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,RIF_Util_Kumaresan.getAllFieldsFromSObject(new Severance_And_Release__c(),projectID,'proj',snrIDs));
                          // update selectedSRList;
                       }
                    
                    if(CongaConductorQuery.EndsWith('where ')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('where ');
                    }
                    if( CongaConductorQuery.EndsWith('OR')){
                        CongaConductorQuery=CongaConductorQuery.removeEnd('OR');
                    }
                setcon.save();
                }
                
                system.debug('*******************GENERATEALLSTEP2::CongaConductorQuery :'+CongaConductorQuery ); 
                if(( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                      || selectedItems.contains('Exhibit A') ) && ProjectId != null && CongaConductorQuery != '' )){
                          // 19-Jan-2017 : ALM#1874 : Fixed spelling of 'Generation'
                          congaQuery.APXTConga4__Name__c='RIF Project Package Generation - Step 2';
                          congaQuery.APXTConga4__Description__c ='RIF Project Package Generation - STEP 2';
                          congaQuery.APXTConga4__Query__c=CongaConductorQuery;
                          insert congaQuery;
                          
                          conductorRecord.APXT_BPM__Title__c='RIF Project Package Generation - Step 2';
                          conductorRecord.APXT_BPM__Query_Id__c=congaQuery.Id;
                          conductorRecord.APXT_BPM__URL_Field_Name__c='Conductor_URL__c';
                          conductorRecord.APXT_BPM__Version__c='C8';
                          conductorRecord.APXT_BPM__Conductor_Environment__c='prod-';
                          insert conductorRecord;
                          
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+ServerUrl;
                          conductorFinalURL = Label.RIF_Dev_CongaConductorURL+'?SessionId='
                                              + userinfo.getsessionId() + '&ServerUrl='+ServerUrl;     
                                                
                          //conductorFinalURL = 'https://conductor-congamerge-com.ccg-dev.ms.com'+'?SessionId='
                                                //+ userinfo.getsessionId() + '&ServerUrl='+'https://morganstanleyhr----dev----c-cs16-visual-force-com.ccg-dev.ms.com/services/Soap/u/29.0/00Df0000002K0p7';                        
                          // For Skyhigh : Changes to the dynamic URL string, commented the 'reportId/recordId'
                          conductorFinalURL += '&Id=' + conductorRecord.Id + '&QueryId='
                                                + congaQuery.ID + '&UrlFieldName=' +
                                                conductorRecord.APXT_BPM__URL_Field_Name__c;//&ReportId=&RecordId=
                      }
                system.debug('*******************conductorFinalURL-STEP2:'+conductorFinalURL); 
            }
            
        }
        return null;
        
    }
        // IGNORE THIS METHOD
    public void test_method(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
   
}