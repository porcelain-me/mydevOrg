public class DET_UploadNMLSDetailsController {

public Blob csvattachment{get;set;}
public List<attachment> latestHistory{get;set;}
public List<Employee__c> emplList{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}

    //constructor
 public DET_UploadNMLSDetailsController (){
    csvFileLines = new String[]{};
    emplList= New List<Employee__c>(); 
  }
  

public pagereference attachFile(){

     try{
         csvAsString = csvattachment.toString();
         csvFileLines = csvAsString.split('\n'); 
         
         List<String> csvFileLinesTemp = csvAsString.split('\n'); 
         Boolean firstLine = true;
            for(String s:csvFileLinesTemp){
            if (firstLine)
                firstLine = false;
            else
                csvFileLines.add(s);
        }
         
       //  wrapEList = new List<wrapEmployee>();
         Map<String, Object> fieldValueMap = new Map<String, Object>();
         
         List<String> empIds = new List<String>();
         
             for(integer i= 0; i < csvFileLines.size(); i++ ){
             List<String> csvRecordData = csvFileLines[i].split(',');
             empIds .add(csvRecordData [0]);  
                 
         }
         
         List<Employee__c> listEmployee  =  [select id,Emp_ID__c,Dual_Employment_NMLS_Registration__c,Dual_Employment_NMLS_Registration_Date__c from Employee__c where Emp_ID__c IN:empIds ];
                Map<String, Employee__C> mapMSIDEmployee = new Map<String, Employee__C>();
                for(Employee__C emp :listEmployee  )
                {
                    mapMSIDEmployee.put(emp.Emp_ID__c , emp);
                }
                
                 for(integer i= 0; i < csvFileLines.size(); i++ ){
                    List<String> csvRecordData = csvFileLines[i].split(',');
                    
                    mapMSIDEmployee.get(csvRecordData[0]).Dual_Employment_NMLS_Registration__c = csvRecordData[1];
                    mapMSIDEmployee.get(csvRecordData[0]).Dual_Employment_NMLS_Registration_Date__c = Date.parse(csvRecordData[2]);
                }
               
                   update  mapMSIDEmployee.values(); 
 
                  }
         
     
     catch(Exception e){
         ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data. Please upload csv file in correct format');
         ApexPages.addMessage(errorMessage);
     }
        return null;
        
    }
    
public List<attachment> getuploadHistory(){

    List<attachment> historyAttachmnt = new List<Attachment>();
    historyAttachmnt = [select id,name,parentId,body,contentType,CreatedById,
                            CreatedDate,LastmodifiedDate,LastmodifiedBy.Name from attachment
                            order By CreatedDate DESC Limit 10];

    return historyAttachmnt;
    }    
}