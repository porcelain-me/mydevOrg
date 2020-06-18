// RA: created for webservices used in RIF 

global class RIF_Webservice {

    private static final string ONE_OFF_TERMINATION = 'One Off Termination';
    private static final string SEVERANCE_AND_RELEASE = 'Severance_And_Release__c';
    
    // Create 'One Off Termination' project from S&R record
    webservice static string CreateOneOffProjectFromSR(string srId){
        List<Severance_And_Release__c> lstSR = RIF_DataUtil.getSeveranceAndRelease(srId);
        List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(ONE_OFF_TERMINATION);
        
        if(lstSR.size() > 0 && lstRT.size() > 0){
            
            List<Project__c> projectList = RIF_DataUtil.getProject(lstSR[0].Project_Level__r.Project__c);
	        Project__c p2;
	        if(!projectList.isEmpty()){
	            p2 = projectList[0].clone(false,true);
	        }
            for(RecordType rt : lstRT){
	           if(rt.SobjectType == 'Project__c'){
	               p2.RecordTypeId = rt.Id;
	           }
	           if(rt.SobjectType == 'Severance_And_Release__c'){
	               lstSR[0].RecordTypeId = rt.Id;
	           }
	        }
            p2.Name = 'One-Off-RIF-'+ dateTime.now().time();
            p2.Primary_Key__c = ''; 
            insert p2;
            
            List<Project_Level__c> plList = RIF_DataUtil.getProjectLevel(lstSR[0].Project_Level__c);
	        Project_Level__c pl;
	        if(!plList.isEmpty()){
	            pl = plList[0].clone(false,true);
	        }
            pl.Project__c = p2.Id;
            insert pl;
            
            lstSR[0].Project_Level__c = pl.Id;
            update lstSR;
            
            return 'Project created.';
        }
        return 'Project can not create.';
    }
    
    webservice static string getSRRecordTypeId(string recordTypeName){
    	if(recordTypeName == Null || recordTypeName == ''){
    		return '';
    	}
    	
    	List<RecordType> lstRecordType = RIF_DataUtil.getRecordTypeForName(recordTypeName);
    	if(!lstRecordType.isEmpty()){
    		for(RecordType rt : lstRecordType){
    			if(rt.SobjectType == SEVERANCE_AND_RELEASE){
    				return rt.Id;
    			}
    		}
    		
    	}
    	return '';
    }

}