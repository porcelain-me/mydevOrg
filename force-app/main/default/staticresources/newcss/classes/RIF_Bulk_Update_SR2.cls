public without sharing class RIF_Bulk_Update_SR2 { 

    //Getter-Setters
    public Blob csvFileBody{get;set;}
    public string fileNameCSV{get;set;}
    public List<Severance_And_Release__c> srList{get;set;}
    public List<Employee__c> eList {get;set;}
    public List <wrapperError> wrapperErrorList    {get;set;}
    public List<RIF_File_Upload_History__c> lstHistoryLoad {get;set;} 
    public List<string> faultyEmpIDs{get;set;}
    public string errorMessageString {get;set;}
    public string projectId{get;set;}
    public boolean isUploaded{get;set;}
    public list<prepareSeveranceAndRelease> lstPSR{get;set;}
    public List<wrapEmployee> wrapEList{get;set;}
    public Employee__c oneEmployee {get;set;} 
    //Variables
    private String recordTypeName; 
    public string recordTypeId;  
    private static final string FILETYPE='Bulk Create Severance And Release'; 
    private static final string SOBJECT_NAME = 'Severance_And_Release__c'; 
    private string csvAsString;
    private String[] csvFileLines;
    private Map <string,string> msIDWithErrorMessageMap;
    public Project__c p {get;set;}
    public String fileToProcess {get;set;}
    public String projectID15 {get;set;}
    
    //Controller
    public RIF_Bulk_Update_SR2 (ApexPages.StandardController controller){
        initiateMembers();
        lstHistoryLoad = new List<RIF_File_Upload_History__c> (RIF_DataUtil.getFileUploadHistories(FILETYPE)); 
        projectId = ApexPages.currentPage().getParameters().get('projectId'); 
        recordTypeName = ApexPages.currentPage().getParameters().get('recordType');
        if(recordTypeName <> NULL){  
            List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(recordTypeName);
            for(RecordType rt : lstRT){            
                if(rt.SobjectType == SOBJECT_NAME){
                    recordTypeId = rt.Id; 
                }
            }
        }
        
        p = (Project__c)controller.getRecord();
        projectID15 = string.valueOf(p.id).substring(0,15);
        
        List<Attachment> aList = [select name from Attachment where parentId = :p.id order by createddate desc];
        if (!aList.isEmpty())
        	filetoProcess = aList[0].name;	
         
    }
   //method is used to initiate variables from constructor or anywhere
   private void initiateMembers(){
        csvFileLines = new String[]{};
        isUploaded=false;
        //errorMessageString='';
        srList= New List<Severance_And_Release__c>(); 
        lstPSR = new list<prepareSeveranceAndRelease>();
        faultyEmpIDs=new List<string> ();
        wrapperErrorList    = new List <wrapperError> () ;
        msIDWithErrorMessageMap= new Map <string,string>();
        
   }
  //method invoked while uploading csv file on page
	public pageReference attachMyFile(){
		
		PageReference p = new PageReference('/p/attach/NoteAttach?pid=' + p.id + '&retURL=' + '/apex/RIF_Bulk_Update_SR2?id=' + p.id);
       	p.setRedirect(true); 
       	return p; 
		
	}
	
	public pageReference exit(){
		
		PageReference p = new PageReference('/apex/rif_standardprojectpage?id=' + p.id);
       	p.setRedirect(true); 
       	return p; 
		
	}
	
	public pageReference transfer(){
		
		PageReference p = new PageReference('/apex/rif_bulk_employee_processor?id=' + p.id + '&mode=u');
       	p.setRedirect(true); 
       	return p; 
		
	}
	
	public pageReference testProcess(){
		
		system.debug('test calc');
		List< Severance_And_Release__c> sList = new List< Severance_And_Release__c>();
		for (wrapEmployee w:wrapEList){
			system.debug(w.e.IND_Basic_Salary_Amount__c);
			system.debug(w.basesalary);
  			system.debug(w.weeklyRate);
  			w.s.project__c = p.id;
  			w.s.employee__c = w.e.id;
  			w.s.base_salary__c = w.e.IND_Basic_Salary_Amount__c;
  			system.debug('record type id: ' + recordtypeid);
  			w.s.recordtypeId = '012f00000004Kzv';
  			slist.add(w.s);
  			 
  			  
  			 
  		}
  		system.debug('slist is:' + slist);
  		insert sList;
       	return null; 
		
	}
	
    public pageReference importCSVFile(){
        isUploaded=true;
        
        
        List<Attachment> aList = [select id,body, name from Attachment where parentId = :p.id order by createddate desc];
        if (!aList.isEmpty()){
        	csvFileBody = aList[0].body;	
        	fileNameCSV = aList[0].name;
        }
        
        
        try{
             Map<string, Employee__c> empMap = new map<string, Employee__c>();
             
             srList= New List<Severance_And_Release__c>(); 
             lstPSR = new list<prepareSeveranceAndRelease>();
             Map<string, prepareSeveranceAndRelease> psrMap = new map<string, prepareSeveranceAndRelease>();
             faultyEmpIDs=new List<string> ();
             wrapperErrorList    = new List <wrapperError> () ;
             msIDWithErrorMessageMap= new Map <string,string>();
            //srList.clear();
           // faultyEmpIDs.clear();
            //wrapperErrorList   .clear();
            system.debug('#####importCSVFile() called#####');
            if(csvFileBody == null && (errorMessageString=='' || errorMessageString==null)) {
                //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Upload a CSV file.');
                //ApexPages.addMessage(errorMessage);
                errorMessageString='Please Upload a CSV file.';
                return null;
            }
            else if(csvFileBody != null && (errorMessageString!=Null || errorMessageString!='')){
                errorMessageString=null;
                //return null; 
            } 
            
            system.debug('#####csvFileBody #####'+csvFileBody );
            csvAsString = csvFileBody.toString();
           
            system.debug('#####csvAsString #####'+csvAsString );
            csvFileLines = csvAsString.split('\n'); 
            System.debug('####csvFileLines[1].split###'+csvFileLines[1].split(','));
            
            
            /* go thru each line */
             for(Integer i=1;i<csvFileLines.size();i++) {
                string[] csvRecordData = csvFileLines[i].split(',');
                Severance_And_Release__c srObj= new Severance_And_Release__c();
                 
                 /* first field is emp id */
                 srObj.Emp_Id__c = csvRecordData[0].trim();
                 
                 
                 empMap.put(csvRecordData[0].trim(), RIF_DataUtil.getSingleEmployeeRecord(srObj.emp_id__c));
                 
                /*(if(csvRecordData[6] != '') {//&& csvRecordData[6] != null
                         try{
                            accrualObj.Communicated__c =   getBooleanValue(csvRecordData[6]);
                        }
                        catch(Exception e){
                            createErrorMessageWithMSID(csvRecordData[0], 'COMMUNICATED__C ' , e.getMessage());
                        }

                }*/

                System.debug('********empMap***'+empMap);
                if(!msIDWithErrorMessageMap.containsKey(csvRecordData[0].trim())){  
                    srList.add(srObj);
                    //prepare wrapper list "lstPSR"
                    prepareSeveranceAndRelease psrObj=new prepareSeveranceAndRelease(srObj, empMap.get(csvRecordData[0].trim()));
                    lstPSR.add(psrObj);
                    psrMap.put(csvRecordData[0].trim(),psrObj);
                }
                if(msIDWithErrorMessageMap!=null && msIDWithErrorMessageMap.containsKey(csvRecordData[0])){
                   // wrapperList = new List <wrapperError> ();
                    wrapperErrorList.add(new wrapperError(csvRecordData[0],msIDWithErrorMessageMap.get(csvRecordData[0])));      
                }        
                System.debug('**********Finished *Read all S&R Information');

            }
            
            
            eList = [select id, age__c, emp_id__c, IND_Basic_Salary_Amount__c from Employee__c where emp_id__c in :empMap.keyset()];
            system.debug('elist is: ' + elist);
            
            wrapEList = new List<wrapEmployee>();
            
            for (Employee__c e:eList){
            	wrapEList.add(new wrapEmployee(e,null)); 
            }
            
            
            /*
            String errorMessageString='';
            try{
                    System.debug('**********Starting Insert S&R Information'+srList);
                    system.debug('###lstPSR####'+lstPSR);
                    system.debug('#######'+srList);
                    //copy encrypted info from wrapper list to srList
                    for(Severance_And_Release__c srObj: srList){
                    	if(psrMap!=null && psrMap.containsKey(srObj.Emp_Id__c))
                        	srObj.Base_Salary__c=psrMap.get(srObj.Emp_Id__c).empData.IND_Basic_Salary_Amount__c;		
                    }
                    //system.debug('###srObj after copying encrypted info####'+srObj);
                    system.debug('##srList after copying encrypted info#####'+srList);
                    system.debug('##projectId###'+projectId+'###recordTypeId####'+recordTypeId);
                    //List<Severance_And_Release__c> templistSR = RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectId, recordTypeId, srList);
                    //System.debug('listSR returned from RIF_SeveranceAndReleaseManager.validateAndCreateSR()'+templistSR); 
                    //List<ApexPages.Message> pageMessages = RIF_DataUtil.insertResult(templistSR);    
                    //Database.SaveResult[] SR = Database.insert(srList, False);
                    //System.debug('SaveResult: ' + SR.size());
                    //System.debug('SaveResult: ' + SR.isSuccess());
                    //Create entry for the custom object 'RIF Regional File Upload History object'
                    System.debug('Inserting historyObj: ' );
                    RIF_File_Upload_History__c historyObj= new RIF_File_Upload_History__c(File_Name__c=fileNameCSV,File_type__c=FILETYPE,Total_Records__c=SR.size()+wrapperErrorList.size(),Total_Success_Records__c=SR.size(),Total_Failed_Records__c=wrapperErrorList.size());
                    insert historyObj;
                    System.debug('Insert Happened: ' + historyObj);
                    lstHistoryLoad = RIF_DataUtil.getFileUploadHistories(FILETYPE);
                    csvFileBody = null;
                    fileNameCSV = null;
                    /*
                    for(Integer i=0;i<=SR.size();i++){
                        if(!SR[i].isSuccess()){//only look at failures, or NOT Successes
                          errorMessageString+='['+srList[i].id+',ERROR:'+SR[i].getErrors()+']'+'\n';
                          system.debug('*******Following Error has occurred in Importing AI:'+SR[i].getErrors());
                          //system.debug(srList[i]); //instead of debug, you could have an email processor something else that looks at that record and the error message
                        }
                        else
                            system.debug('*******No Error has occurred in Importing AI:'+SR[i].isSuccess());
                    }
                   
            }
            catch(Exception e){
                 ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,errorMessageString);
                 ApexPages.addMessage(errorMessage);
            }
            */
    }
    catch (Exception e)
    {
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occurred while Uploading the file. Please make sure input file (CSV) is correct.' +e.getMessage());//+e.getMessage()
        ApexPages.addMessage(errorMessage );
    }
    /*
    if(lstHistoryLoad !=null && lstHistoryLoad .size()>0){
        lstHistoryLoad.clear();
        lstHistoryLoad =RIF_DataUtil.getFileUploadHistories();
    }*/
    return null;  
  }
  
  
  public pageReference saveFile(){
  	
  	system.debug('**** save file ******');
  	
  	for (wrapEmployee w:wrapEList){
  		w.weeklyrate = (decimal.valueOf(w.e.ind_basic_salary_amount__c) / 52.0).setScale(2);
  	}
  	
  	for (wrapEmployee w:wrapEList){
  		system.debug(w.e);
  		system.debug(w.weeklyRate);
  		
  	}
  	/* now copy the data from employee to sr and insert sr...*/
  	
  	return null;
  	
  }
  //cancel method refreshes the page and clear the success and error values
  
  public pageReference refreshPage(){
      srList = null;
      faultyEmpIDs = null;
      wrapperErrorList= null;
      csvFileBody=null;
      //srList.clear();
      //faultyEmpIDs.clear();
      //wrapperErrorList.clear();
      errorMessageString=null;

      return null;
  }
  
  //this method converts string value into boolean
  private boolean getBooleanValue(String stringVal){
      boolean booleanval;
      if(stringVal.equalsIgnoreCase('Y')||stringVal.equalsIgnoreCase('Yes')||stringVal.equalsIgnoreCase('true')||stringVal.equalsIgnoreCase('t'))
          booleanval=true;
      if(stringVal.equalsIgnoreCase('N')||stringVal.equalsIgnoreCase('No')||stringVal.equalsIgnoreCase('false')||stringVal.equalsIgnoreCase('f'))
          booleanval=false;
      return booleanval;
  }
  
  //this method create a error message corresponding to MSID as per the one row in csv file
   public void createErrorMessageWithMSID(String msID, String fieldName, String exceptionMessage){ 
        if(!msIDWithErrorMessageMap.containsKey(msID)){
            msIDWithErrorMessageMap.put(msID,'Invalid '+fieldName+':'+exceptionMessage.split(':',-2)[1]);  
        }
        else{
                String errorMessage=msIDWithErrorMessageMap.get(msID);
                errorMessage+=';'+'Invalid '+ fieldName + ':'+ exceptionMessage.split(':',-2)[1];
                msIDWithErrorMessageMap.put(msID,errorMessage);     
                
                        
        }

    }
    
    
  public class wrapEmployee{
      public Employee__c e{get;set;}
      public Decimal weeklyRate {get;set;}
      public String baseSalary {get;set;}
      public Severance_And_Release__c s {get;set;}
      
      public wrapEmployee(Employee__c e, Decimal weeklyRate){
          this.e = e;
          this.weeklyRate = weeklyRate;
          s = new Severance_and_release__c();
          
      }
  }
  
  /**
    ** Class used for Displaying errors related to the employees loaded via csv file
    ** Errors are associated with the emp id's using this class
  **/
  public class wrapperError{
      public string empID{get;set;}
      public string errorMessage{get;set;}
      
      public wrapperError(string empID, string errorMessage){
          this.empID=empID;
          this.errorMessage=errorMessage;
      }
  }
  /**
    ** Class used for associating employee record with related S&R records for copying encrypted dat of employees into SR
    
  **/
  public class prepareSeveranceAndRelease{
        public Severance_And_Release__c srRecord{get;set;}
        public Employee__c empData{get;set;}
        
        public prepareSeveranceAndRelease(Severance_And_Release__c srRecord, Employee__c empData){
            this.srRecord = srRecord;
            this.empData = empData;
        }
    }
}