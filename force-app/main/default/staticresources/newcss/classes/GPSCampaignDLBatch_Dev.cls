/******************************************************************************************************************************
 *
 *      @File           :       GPSCampaignDLBatch.cls
 *      @Version        :       V1.0.0
 *      @Created        :       21st July 2016 by Sudarshan K.
 *      @Purpose        :       JIRA 4836
 *                                  Purpose is GPS Campaigns upload functionality.                   
 *                                  This batch work to read CSV file asynchronously                    
 *                                              
 *
 *      @Author         :       Capgemini (Sudarshan K)
 *      @Copyright      :       (c) Capgemini India Pvt. Ltd. 2016
 *
 *      @History        :  
 *
 ********************************************************************************************************************************/
global class GPSCampaignDLBatch_Dev implements Database.batchable<String>, Database.Stateful{

   private String m_csvFile;
   private String introVal;
   
   private Blob successString;
   private Blob errorString;
   private String recordId;
   private map<String, String> fieldMap;
   private List<String> fieldNames;
   private String selectedUploadOption;
   private List<String> tempCSV;
   private Schema.SObjectType sObjectDetails;
   private Map<String, Schema.SobjectField> allfields;
   
  public GPSCampaignDLBatch_Dev(String fileData, String success, String failed, String rId, map<String,String> objFieldMap, List<String> fNames, String selectedOperationType){
        m_csvFile = fileData;
        introVal = '\n';
        successString = Blob.valueOf(success);
        errorString = Blob.valueOf(failed);
        recordId = rId; 
        fieldMap = new map<String,String>(objFieldMap);
        fieldNames = new List<String>(fNames);
        selectedUploadOption = selectedOperationType.trim();  
        
        if(selectedUploadOption.contains('__c_del')){
             String objectdel =  selectedUploadOption.subStringBefore('_del');
             sObjectDetails = Schema.getGlobalDescribe().get(objectdel.trim());
             successString = Blob.valueOf(success.replace('Id,',''));
        }else{
            sObjectDetails = Schema.getGlobalDescribe().get(selectedUploadOption);  
        }
        
       allfields = sObjectDetails.getDescribe().fields.getMap(); 
  }
        
   global Iterable<String> start(Database.batchableContext batchableContext){ 
           
       return new GPSCampaignCSVIterator(m_csvFile, introVal);
   }
   
   global void execute(Database.BatchableContext batchableContext, List<String> scope){
       
       List<List<String>> fileLines = GPSIICampaignDataLoaderController.parseCSV(scope);
       
        List<sObject> lstsObject = new List<sObject>();
        tempCSV = new List<String>();
                        
        for(Integer i=0; i < fileLines.size(); i++){
                
            List<String> fieldValues = fileLines[i];
            
            sObject obj = sObjectDetails.newSObject();
            
            String fieldVal = '';
            for(Integer j=0; j < fieldValues.size(); j++){
                
                if(fieldMap.get(fieldNames[j].trim()).contains('__r.')){
                    
                    String fieldName = fieldMap.get(fieldNames[j].trim());
                    String objName = fieldName.subStringBefore('__r');
                    
                    if(!objName.containsIgnoreCase('User'))
                        objName = objName + '__c';
                        
                    fieldName = fieldName.substringAfter('__r.').trim();
                    
                    sObject relObj = Schema.getGlobalDescribe().get(objName).newSObject();
                    
                    relObj.put(fieldName, fieldValues[j]);       
                    
                    if(!objName.containsIgnoreCase('User'))
                        objName = objName.substring(0, objName.length()-1) + 'r';
                    else
                        objName = objName.trim() + '__r';   
                        
                    obj.putSObject(objName, relObj);
                    
                }else{
                    
                    String fieldName = fieldMap.get(fieldNames[j].trim());
                    
                    setValueAsPerFieldType(obj, fieldName, fieldValues[j]);
                    
                }
                
                if(j+1 != fieldValues.size())
                    fieldVal += fieldValues[j] + '","';
                else
                    fieldVal += fieldValues[j] + '\n';
            }
            lstsObject.add(obj);
           
            tempCSV.add(fieldVal);
        }
         
        if(selectedUploadOption.trim().contains('__c_del')){
        	
        	List<sObject> lstVRDel = new List<sObject>();
        	
        	List<String> validCSV = new List<String>();
			List<String> invalidCSV = new List<String>();
			
			//successString = errorString;
			
        	Integer counterVal = 0;
        	for(sObject obj : lstsObject){
        		
        		String recordId = obj.Id;
				
        		if(recordId.startsWith(sObjectDetails.getDescribe().getKeyPrefix())){
        			if(recordId.length() >= 15 && recordId.length() <= 18){
        				validCSV.add(tempCSV[counterVal]);
        				lstVRDel.add((sObject)obj);
        			}else{
        				invalidCSV.add(tempCSV[counterVal]);
        			}
        		}else{
        			invalidCSV.add(tempCSV[counterVal]);
        		}
        		counterVal++;
        	}
        	
        	if(!lstVRDel.isEmpty()){
        		DeleteRecords(Database.delete(lstVRDel, false), validCSV);	
        	}
        	
        	if(invalidCSV.size() > 0){
        		String failedResult = '';        		
        		for(String str : invalidCSV){
        			failedResult += str.trim() + '","' + 'Invalid record id.' + '"\n"';
        		}
        		UpdateGPSCDLRecord('',failedResult);	
        	}
        	
        }else{
        	
        	List<Candidate_Information__c> lstCI = new List<Candidate_Information__c>();
        	List<Target_List__c> lstTL = new List<Target_List__c>();
        	List<Target_List_Member__c> lstTLM = new List<Target_List_Member__c>();
        	List<Voter_Recommendation__c> lstVR = new List<Voter_Recommendation__c>();
        	List<Candidate_Sector__c> lstCS = new List<Candidate_Sector__c>();
        	List<Exclusion__c> lstExc = new List<Exclusion__c>();
        	
        	for(sObject obj : lstsObject){
        		
        		if(sObjectDetails.getDescribe().getName() == 'Candidate_Information__c'){
        			lstCI.add((Candidate_Information__c)obj);
        			
        		}else if(sObjectDetails.getDescribe().getName() == 'Target_List__c'){
        			lstTL.add((Target_List__c)obj);
        			
        		}else if(sObjectDetails.getDescribe().getName() == 'Target_List_Member__c'){
        			lstTLM.add((Target_List_Member__c)obj);
        			
        		}else if(sObjectDetails.getDescribe().getName() == 'Voter_Recommendation__c'){
        			lstVR.add((Voter_Recommendation__c)obj);
        			
        		}else if(sObjectDetails.getDescribe().getName() == 'Candidate_Sector__c'){
        			lstCS.add((Candidate_Sector__c)obj);
        			
        		}else if(sObjectDetails.getDescribe().getName() == 'Exclusion__c'){
        			lstExc.add((Exclusion__c)obj);
        		}
        	}
        	
        	if(Limits.getHeapSize() > Limits.getLimitHeapSize()){
        		system.debug(lstCI.size()+'Heap size limit is exceeded'+Limits.getHeapSize());
        	}
        	
        	if(!lstCI.isEmpty()){
        		Schema.SObjectField f = Candidate_Information__c.Fields.MSID__c;
        		UpsertRecords(Database.upsert(lstCI,f,false));
        	}	
        		
        	if(!lstTL.isEmpty()){
        		Schema.SObjectField f = Target_List__c.Fields.MSID__c;
				UpsertRecords(Database.upsert(lstTL,f,false));
        	}	
				
        	if(!lstTLM.isEmpty()){
        		Schema.SObjectField f = Target_List_Member__c.Fields.Target_List_Member_Key__c;
				UpsertRecords(Database.upsert(lstTLM,f,false));
        	}	
        		
        	if(!lstVR.isEmpty())
        		InsertRecords(lstVR);
        		
        	if(!lstCS.isEmpty())
        		InsertRecords(lstCS);
        	
        	if(!lstExc.isEmpty())
        		InsertRecords(lstExc);		
        		
        }    
   }
   
   global void finish(Database.BatchableContext batchableContext){
        

	        List<Attachment> lstAttach = new List<Attachment>();
	        lstAttach.add(new Attachment(ParentId = recordId, name = 'SuccessRecords.csv', body = successString, contentType='application/vnd.ms-excel'));
	        lstAttach.add(new Attachment(ParentId = recordId, name = 'FailedRecords.csv', body = errorString, contentType='application/vnd.ms-excel'));
	        
	        insert lstAttach;

   }
   
   private void UpdateGPSCDLRecord(String successStr, String ErrorStr){
   		
   			
   			if(String.isNotEmpty(successStr)){
   				String SResult = successString.toString();
   				successString = Blob.valueOf(SResult + successStr);
   			}
   				
   			if(String.isNotEmpty(ErrorStr)){
   				String EResult = errorString.toString();
   				errorString = Blob.valueOf(EResult + ErrorStr);
   			}
   			
   }
   
   private void UpsertRecords(Database.UpsertResult[] results){
   		
   		Integer counter = 0;
		String successRes = '';
		String failedRes = '';
        for(Database.UpsertResult sr : results){
            if(sr.isSuccess()){
                
                successRes += sr.getId() + '","' + tempCSV[counter].trim() + '","Record '+(sr.isCreated()?'Created':'Updated')+' successfully' + '"\n"'; 

            }else{
                
                String ErrorMessage = '';
                for(Database.Error err : sr.getErrors()){
                                        
                    ErrorMessage += err.getStatusCode() + ' : ' + err.getMessage() + ' ';
                }
                
                failedRes += tempCSV[counter].trim() + '","' + ErrorMessage + '"\n"';
                
            }
            counter++;
        }
        UpdateGPSCDLRecord(successRes, failedRes);
   }
   
   private void InsertRecords(List<sObject> records){
         
        Database.SaveResult[] srList = Database.insert(records, false);
        
        Integer counter = 0;
		String successRes = '';
		String failedRes = '';
		
        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                
                successRes += sr.getId() + '","' + tempCSV[counter].trim() + '","Record created successfully' + '"\n"'; 

            }else{
                
                String ErrorMessage = '';
                for(Database.Error err : sr.getErrors()){
                                        
                    ErrorMessage += err.getStatusCode() + ' : ' + err.getMessage() + ' ';
                }
                
                failedRes += tempCSV[counter].trim() + '","' + ErrorMessage + '"\n"';
                
            }
            counter++;
        }
        
		UpdateGPSCDLRecord(successRes, failedRes);
    }
    
     private void DeleteRecords(Database.DeleteResult[] results, List<String> validCSV){
                
        Integer counter = 0;
        String successRes = '';
		String failedRes = '';
		
        for(Database.DeleteResult sr : results){
            
            if(sr.isSuccess()){
            
            	successRes += validCSV[counter].trim() + '","Record Deleted' + '"\n"';
            
            }else{
                
                String ErrorMessage = '';
                for(Database.Error err : sr.getErrors()){
                                        
                    ErrorMessage += err.getStatusCode() + ' : ' + err.getMessage() + ' ';
                }
                
                failedRes += validCSV[counter].trim() + '","' + ErrorMessage + '"\n"';
            }
            
            counter++;
        }
        UpdateGPSCDLRecord(successRes, failedRes);
     }
     
     private void setValueAsPerFieldType(sObject newSobject, String fieldName, String fieldValue){
        
        Schema.DisplayType valueType = allfields.get(fieldName).getDescribe().getType();
        
        if(valueType != Schema.DisplayType.String){
                        
            if(valueType == Schema.DisplayType.Boolean)
            
                newSobject.put(fieldName, Boolean.valueOf(fieldValue));
                
           /* else if(valueType == Schema.DisplayType.Date)
            
                newSobject.put(fieldName, Date.valueOf(fieldValue));
                
            else if(valueType == Schema.DisplayType.DateTime)
            
                newSobject.put(fieldName, DateTime.valueOfGmt(fieldValue));
                
            else if(valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
            
                newSobject.put(fieldName, fieldValue == '' ? null : Decimal.valueOf(fieldValue));
                
            else if(valueType == Schema.DisplayType.Double)
            
                newSobject.put(fieldName, fieldValue == '' ? null : Double.valueOf(fieldValue));
                
            else if(valueType == Schema.DisplayType.Integer)
            
                newSobject.put(fieldName, Integer.valueOf(fieldValue));
                
            else if(valueType == Schema.DisplayType.Base64)
            
                newSobject.put(fieldName, Blob.valueOf(fieldValue));*/
                
            else
                newSobject.put(fieldName, fieldValue);
                
        }else
        
            newSobject.put(fieldName, fieldValue);
     }
}