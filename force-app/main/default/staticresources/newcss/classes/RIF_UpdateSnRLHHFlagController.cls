/** This controller for VF page : RIF_UpdateSnRLHHFlagPage :
this class will check and set the LHH flag to TRUE for all the SnR records that have their sent to LHH value as 1 in the uploaded .csvsheet.
All other values other than 1 will not be considered for updates and relevent error messages will be shown to the user
**/
public class RIF_UpdateSnRLHHFlagController {
    public Blob csvFileBody {get;set;}
    public String fileNameCSV {get;set;}
    public transient List<Severance_And_Release__c> snrList {get;set;}
    public transient List<Severance_And_Release__c> snrUpdateList {get;set;}
    public transient List<RIF_File_Upload_History__c> lstHistoryLoad {get;set;}
    public transient List<wrapperError> wrapperErrorList {get;set;}
    public String errorMessageString {get;set;}
    public Report reportDetails {get;set;} 
    private static final String FILETYPE = 'SnR-LHH';
    private transient String[] csvFileLines;
    private String csvAsString;
    public List<String> snrToUpdate;
    public Severance_And_Release__c snrRec;
    
    // Constructor
    public RIF_UpdateSnRLHHFlagController(){
        csvFileLines = new String[]{};
        errorMessageString= null;
        lstHistoryLoad = new List<RIF_File_Upload_History__c>(RIF_DataUtil.getFileUploadHistories(FILETYPE));
        getReportID();
    }
    // Get the ID of the LHH report, this will be used in the link 
    public void getReportID(){
        reportDetails = [SELECT Id,Name,DeveloperName FROM Report WHERE DeveloperName =: Label.RIF_LHH_Report_Unique_Name];
    }
    //Method invoked while uploading csv file on page
    public PageReference importCSVFile(){ 
        try{
            snrList = new List<Severance_And_Release__c>(); 
            wrapperErrorList = new List <wrapperError>() ;
            snrToUpdate = new List<String>();
            snrUpdateList = new List<Severance_And_Release__c>(); 
            errorMessageString = '';
            if(csvFileBody == null && (String.isBlank(errorMessageString))){
                errorMessageString = 'Please Upload a CSV file!';
                return null;
            }
            else if(csvFileBody != null && !(String.isBlank(errorMessageString))){
                errorMessageString = '';
            }
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            
            for(Integer i=1 ; i<csvFileLines.size() ; i++){
                List<String> csvRecordData = csvFileLines[i].split(',');
                String lhhValue = (String.valueOf(csvRecordData[3])).remove('\r');
                // check for non 1/0 chars
                if(!lhhValue.equals('1') && !lhhValue.equals('0')){
                    wrapperErrorList.add(new wrapperError((String.valueOf(csvRecordData[0])).remove('\r')));    
                }
                // get the recs for update
                else if(lhhValue.equals('1')){
                    snrToUpdate.add((String.valueOf(csvRecordData[0])).remove('\r'));
                }        
            }
            //errorMessageString = '';
            try{
                if(snrToUpdate != null && !snrToUpdate.isEmpty()){
                    // query the SnR details
                    snrList = [SELECT Id,Name,sent_to_LHH__c FROM Severance_And_Release__c WHERE Name IN : snrToUpdate];
                    // check if any of the SnR detail are not present
                    if(snrList.size() < snrToUpdate.size()){
                        Set<String> allSnRUpdateSet = new Set<String>(snrToUpdate);
                        Set<String> allSnRUpdateSetCopy = new Set<String>(snrToUpdate);
                        for(Severance_And_Release__c eachSnR : snrList){
                            if(allSnRUpdateSet.contains(eachSnR.Name)){
                               allSnRUpdateSetCopy.remove(eachSnR.Name);
                            }
                        }
                        // display the error msg with the SnR name
                        for(String newError : allSnRUpdateSetCopy){
                             wrapperErrorList.add(new wrapperError(String.valueOf(newError),true));
                        }
                    }
                }
                else{
                    errorMessageString = 'No \'sent to LHH\' flags are checked in the uploaded sheet!';
                    return null;
                }
                // creating the records for updates
                if(!snrList.isEmpty()){
                    for(Severance_And_Release__c eachSnR : snrList){
                        snrRec = new Severance_And_Release__c();
                        snrRec.Id = eachSnR.Id;
                        snrRec.sent_to_LHH__c = true;
                        snrUpdateList.add(snrRec);
                    }
                }
                // update the SnRs and check if we have any errors while updating
                if(!snrUpdateList.isEmpty()){
                    Database.SaveResult[] SR = Database.update(snrUpdateList, false);
                    for(Integer i = 0 ; snrUpdateList.size() > i ; i++){
                        Database.SaveResult result = SR[i];
                        Severance_And_Release__c eachRec = snrUpdateList[i];
                        if(!result.isSuccess()){
                            for(Database.Error err : result.getErrors()){
                                errorMessageString +='['+ eachRec.Name +',ERROR:'+ result.errors+']'+'\n';
                                wrapperErrorList.add(new wrapperError(eachRec.Id, err.getMessage()));     
                                system.debug('*******Following Error has occurred in Importing SnR LHH: '+err);
                            }
                        }
                    }
                    // insert the uploaded file details in File History object
                    Integer totalRecs = Integer.valueOf(csvFileLines.size() - 1);
                    Integer totalInserted = snrUpdateList.size();
                    Integer totalErrors = wrapperErrorList.size();
                    Integer totalSuccess = Math.abs(totalInserted - totalErrors);
                    
                    //RIF_File_Upload_History__c historyObj= new RIF_File_Upload_History__c(File_Name__c=fileNameCSV,File_type__c=FILETYPE,Total_Records__c=csvFileLines.size()-1,Total_Success_Records__c = (snrUpdateList.size() - wrapperErrorList.size()) ,Total_Failed_Records__c = wrapperErrorList.size());
                    
                    RIF_File_Upload_History__c historyObj = new RIF_File_Upload_History__c();
                    historyObj.File_Name__c = fileNameCSV;
                    historyObj.File_type__c = FILETYPE;
                    historyObj.Total_Records__c = totalRecs;
                    historyObj.Total_Success_Records__c = totalInserted;
                    historyObj.Total_Failed_Records__c = totalErrors;
                    
                    insert historyObj;
                    
                    // display the latest uploaded file in the history
                    lstHistoryLoad = RIF_DataUtil.getFileUploadHistories(FILETYPE);
                    
                    csvFileBody = null;
                    fileNameCSV = null;
                }
            }
            catch(Exception e){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMessage);
            } 
        }
        catch(Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occurred while Uploading the file. Please make sure input file (CSV) is correct. ' +e.getMessage());
            errorMessageString = 'An error has occurred while Uploading the file. Please make sure input file (CSV) is correct. ' +e.getMessage();
            ApexPages.addMessage(errorMessage);
        }
        errorMessageString = null;
        return null;  
    }
    
    //Cancel method refreshes the page and clears the success and error values
    public pageReference refreshPage(){
        csvFileBody=null;
        errorMessageString=null;
        return null;
    }
    
    public class wrapperError{
        public string snrID{get;set;}
        public string errorMessage{get;set;}
        public Severance_And_Release__c snrRec;
        
        // for standard error message
        public wrapperError(string snrID, string errorMessage){
            snrRec = new Severance_And_Release__c();
            snrRec = [SELECT Name FROM Severance_And_Release__c WHERE Id =: snrID LIMIT 1];
            this.snrID = snrRec.Name != '' ? snrRec.Name:snrID;
            this.errorMessage = errorMessage;
        }
        // for non 1/0 error message
        public wrapperError(string snrID){
            this.snrID = snrID;
            this.errorMessage = 'Please use only \'1\' to select the LHH flags, no other characters are allowed for updates';
        }
        // for invalid SnR
        public wrapperError(string snrID, boolean flag){
            this.snrID = snrID;
            this.errorMessage = 'Invalid Severance and Release ID!';
        }
    }
}