global class AMS_WebServiceHelper {
    webservice static String terminateProject(Id projectId, String loginId,String projNumber)
    {
        /*try {
Id terminatedProjId = AMS_ProjectHelper.terminateProject(projectId);
return terminatedProjId;
}
catch(Exception e) {
}*/
        String queryfield='';
        Map<String, Schema.SObjectField> mapfields = Schema.SObjectType.AMS_Project__c.fields.getMap();
        for(String fieldName : mapfields.keySet()) {
            if(mapfields.get(fieldName).getDescribe().isCreateable()) {
                if(fieldName!='Project_ID__c')
                    queryfield=queryfield +fieldName+',';
            }
        }
        queryfield= queryfield.removeEnd(',');
        String query = 'Select '+queryfield+' from AMS_Project__c where ID=\''+projectId+'\'';
        
        AMS_Project__c amsProject = (AMS_Project__c)Database.query(query); 
        if(amsProject.Status__c!='Completed') {
            return 'You can only terminate Completed records';
        }
        else{
            AMS_Project__c terminateProj = amsProject.clone();
            terminateProj.Project_Access_ID__c = null;
            String projName = (String)terminateProj.get('Project_Name__c');
            terminateProj.put('Project_Name__c',projName+' Termination of '+projNumber);
            terminateProj.put('Status__c','Active');
            terminateProj.Type__c='Termination';
            if(terminateProj.Contract_Start_Date__c!=null)
            {
                terminateProj.Contract_Start_Date__c=terminateProj.Contract_Start_Date__c.addYears(1);
                terminateProj.Expire_Renew_Date__c =  terminateProj.Contract_Start_Date__c.addDays(1);
            }
            if(terminateProj.Accrual_Start_Date__c!=null)
            {
                terminateProj.Accrual_Start_Date__c = terminateProj.Accrual_Start_Date__c.addYears(1);
            }
            terminateProj.Completion_Date__c=null;
            insert   terminateProj; 
            
            List<Cost_Center_Allocation__c> listCostCenter = [Select Active__c,Amount__c, Cost_Center__c, List_Description__c,Percent__c,Project__c from Cost_Center_Allocation__c where Project__c =:projectId];
            List <Cost_Center_Allocation__c> listCloneCostCenter;
            
            if(listCostCenter!=null && !listCostCenter.isEmpty())
            {
                listCloneCostCenter = listCostCenter.deepClone();
            }
            if(listCloneCostCenter!=null && !listCloneCostCenter.isEmpty())
            {
                for(Cost_Center_Allocation__c costCenter :listCloneCostCenter)
                {
                    costCenter.Project__c=terminateProj.Id;
                }
                insert listCloneCostCenter;
            }

            return terminateProj.Id;
        }
    }
    
    webservice static string renewProject(Id projectId, String loginId,String projNumber){		
        
        /*Check for existing project details
        List<AMS_Project__c> projects = [Select Id From AMS_Project__c 
                                         WHERE Id = :projectId];
        
        return 'The project has been renewed';*/
        String queryfield='';
        Map<String, Schema.SObjectField> mapfields = Schema.SObjectType.AMS_Project__c.fields.getMap();
        for(String fieldName : mapfields.keySet()) {
            if(mapfields.get(fieldName).getDescribe().isCreateable()) {
                if(fieldName!='Project_ID__c')
                    queryfield=queryfield +fieldName+',';
            }
        }
        queryfield= queryfield.removeEnd(',');
        String query = 'Select '+queryfield+' from AMS_Project__c where ID=\''+projectId+'\'';
        
        AMS_Project__c amsProject = (AMS_Project__c)Database.query(query); 
            AMS_Project__c renewProj = amsProject.clone();
            renewProj.Project_Access_ID__c = null;
            String projName = (String)renewProj.get('Project_Name__c');
            renewProj.put('Project_Name__c',projName+' Renewal of '+projNumber);
            renewProj.put('Status__c','Active');
            renewProj.Type__c='Renewal';
            if(renewProj.Contract_Start_Date__c!=null)
            {
                renewProj.Contract_Start_Date__c=renewProj.Contract_Start_Date__c.addDays(2);
                renewProj.Expire_Renew_Date__c =  renewProj.Contract_Start_Date__c.addYears(1); 
            }
            if(renewProj.Accrual_Start_Date__c!=null)
            {
                renewProj.Accrual_Start_Date__c = renewProj.Accrual_Start_Date__c.addDays(2);
            }
       		renewProj.Activity_Start_Date__c = Date.today();
            renewProj.Completion_Date__c=null;
            insert   renewProj; 
            
            List<Cost_Center_Allocation__c> listCostCenter = [Select Active__c,Amount__c, Cost_Center__c, List_Description__c,Percent__c,Project__c from Cost_Center_Allocation__c where Project__c =:projectId];
            List <Cost_Center_Allocation__c> listCloneCostCenter;
            
            if(listCostCenter!=null && !listCostCenter.isEmpty())
            {
                listCloneCostCenter = listCostCenter.deepClone();
            }
            if(listCloneCostCenter!=null && !listCloneCostCenter.isEmpty())
            {
                for(Cost_Center_Allocation__c costCenter :listCloneCostCenter)
                {
                    costCenter.Project__c=renewProj.Id;
                }
                insert listCloneCostCenter;
            }
            return renewProj.Id;
    }
}