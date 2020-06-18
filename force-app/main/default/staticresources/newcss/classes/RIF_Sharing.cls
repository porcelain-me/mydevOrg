public class RIF_Sharing{
    public RIF_Sharing(){
        
    }
    
    //Share S&R records associated to the particular project as soon as the member opens the shared project
    //static list<ApexPages.Message>
    public static void shareSRWithUsers(Id srID,Set <id> userorGroupIDs,String accessLevel){
        List<Severance_And_Release__Share> newSRShrs = new List<Severance_And_Release__Share>();
        for(String userID: userorGroupIDs){
            Severance_And_Release__Share newSRShareRecord= new Severance_And_Release__Share();
            
            newSRShareRecord.UserOrGroupId = userID;
            newSRShareRecord.AccessLevel = accessLevel;
            // The ID of the record being shared

            newSRShareRecord.ParentId = srID;
            // This establishes the sharing record as Apex managed sharing.

            //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            // Add sharing record to list for insertion.
            newSRShrs.add(newSRShareRecord);
        
        }
        if(newSRShrs !=null && newSRShrs .size()>0)
            insert newSRShrs ;
    
    }
    public static void shareSRListWithUsers(Set <id>srIDs,Set <id> userorGroupIDs,String accessLevel){
        List<Severance_And_Release__Share> newSRShrs = new List<Severance_And_Release__Share>();
        for(String userID: userorGroupIDs){
           for(String srID:srIDs){
                Severance_And_Release__Share newSRShareRecord= new Severance_And_Release__Share();
            
                newSRShareRecord.UserOrGroupId = userID;
                newSRShareRecord.AccessLevel = accessLevel;
            // The ID of the record being shared

                newSRShareRecord.ParentId = srID;
            // This establishes the sharing record as Apex managed sharing.

            //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            // Add sharing record to list for insertion.
                newSRShrs.add(newSRShareRecord);
           }
        
        }
        if(newSRShrs !=null && newSRShrs .size()>0)
            insert newSRShrs ;
    
    }
    public static void shareProjectWithUsers(Id projectID,Set <id> userorGroupIDs,String accessLevel){
        List<Project__Share> newProjectShrs = new List<Project__Share>();
        for(String userID: userorGroupIDs){
            Project__Share newProjShareRecord= new Project__Share();
            
            newProjShareRecord.UserOrGroupId = userID;
            newProjShareRecord.AccessLevel = accessLevel;
            // The ID of the record being shared

            newProjShareRecord.ParentId = projectID;
            // This establishes the sharing record as Apex managed sharing.

            //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            // Add sharing record to list for insertion.
            newProjectShrs.add(newProjShareRecord);
        
        }
        if(newProjectShrs!=null && newProjectShrs.size()>0)
            insert newProjectShrs;
        
    }
    public static void shareProjectDecUnitsWithUsers( Set <id> pduIDs,Set <id> userorGroupIDs,String accessLevel){
        List<Project_Decisional_Unit__Share> newProjectDecUnitShrs = new List<Project_Decisional_Unit__Share>();
        for(String userID: userorGroupIDs){
            for(string pduID: pduIDs){
                Project_Decisional_Unit__Share newProjDecUnitShareRecord= new Project_Decisional_Unit__Share();
                
                newProjDecUnitShareRecord.UserOrGroupId = userID;
                newProjDecUnitShareRecord.AccessLevel = accessLevel;
                // The ID of the record being shared
    
                newProjDecUnitShareRecord.ParentId = pduID;
                // This establishes the sharing record as Apex managed sharing.
    
                //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
                // Add sharing record to list for insertion.
                newProjectDecUnitShrs.add(newProjDecUnitShareRecord);
            }
        }
        if(newProjectDecUnitShrs !=null && newProjectDecUnitShrs.size()>0)
            insert newProjectDecUnitShrs ; 
        
    }
    
    public static void Share_S_R_From_Project(List <Severance_And_Release__c> eligibleS_R_TO_Share,Id loggedInUserID,String accessLevel){ 
        // Create a list of Job__Share objects to be inserted.
        List<Severance_And_Release__Share> newS_RShrs = new List<Severance_And_Release__Share >();
        List<Severance_And_Release__Share> updateS_RShrs = new List<Severance_And_Release__Share>();
        Map <string,Severance_And_Release__Share> srIDToSRShareMap= new Map <string,Severance_And_Release__Share>();
        Set <id> eligibleSRIDs= new Set <id>  ();
        
        
        for(Severance_And_Release__c srRecord: eligibleS_R_TO_Share){
            eligibleSRIDs.add(srRecord.id); 
        }
        for(Severance_And_Release__Share srShareObj: [select UserOrGroupId,AccessLevel,ParentId from Severance_And_Release__Share where UserOrGroupId=:loggedInUserID and ParentId IN:eligibleSRIDs]){
            srIDToSRShareMap.put(srShareObj.ParentId,srShareObj);   
        }
        for(Severance_And_Release__c srRecord: eligibleS_R_TO_Share){
        	system.debug('**************accessLevel'+accessLevel);
            Severance_And_Release__Share tempShareObj=srIDToSRShareMap.get(srRecord.id);
            if( (srIDToSRShareMap.containskey(srRecord.id)) && (tempShareObj.AccessLevel!='All')  ){   
            system.debug('**************srIDToSRShareMap.containskey(srRecord.id)'+srIDToSRShareMap.containskey(srRecord.id));	
                Severance_And_Release__Share updatesrShr=srIDToSRShareMap.get(srRecord.id);
                updatesrShr.AccessLevel = accessLevel;
                updateS_RShrs.add(updatesrShr);
            system.debug('**************srIDToSRShareMap.containskey(srRecord.id)'+srIDToSRShareMap.containskey(srRecord.id));    
            }
            else if( !(srIDToSRShareMap.containskey(srRecord.id))   ){  
                Severance_And_Release__Share srShr = new Severance_And_Release__Share ();
            
                srShr.UserOrGroupId = loggedInUserID;
                srShr.AccessLevel = accessLevel;
                srShr.ParentId = srRecord.Id;
                // Set the rowCause to the Apex sharing reason for hiring manager.
    
                // This establishes the sharing record as Apex managed sharing.
    
                //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
                // Add sharing record to list for insertion.
                newS_RShrs.add(srShr);
            
            }

        }
        
        if(newS_RShrs!=null && newS_RShrs.size()>0){
            System.debug('####new share records of S&R:'+newS_RShrs);
            insert newS_RShrs;
        }
        if(updateS_RShrs!=null && updateS_RShrs.size()>0){
            System.debug('####updated share records of S&R:'+updateS_RShrs);
            update updateS_RShrs;
        
        }
        /*if(newS_RShrs!=null && newS_RShrs.size()>0)
            return RIF_DataUtil.upsertResult(newS_RShrs);
        else
            return null;*/
    }
    
    //Added on july 201,2015 to share project decisional unit records with the sharing user whom the project is being shared
    /*public static void Share_PDU_From_Project(List <Project_Decisional_Unit__c> eligible_PDU_TO_Share,Id loggedInUserID,String accessLevel){
         // Create a list of Project_Decisional_Unit__Share objects to be inserted.
        List<Project_Decisional_Unit__Share> newPDUShrs = new List<Project_Decisional_Unit__Share >();
        
        for(Project_Decisional_Unit__c pduRecord: eligible_PDU_TO_Share){
            Project_Decisional_Unit__Share pduShr = new Project_Decisional_Unit__Share ();
        
            pduShr.UserOrGroupId = loggedInUserID;
            pduShr.AccessLevel = accessLevel;

            // The ID of the record being shared

            pduShr.ParentId = pduRecord.Id;
            // Set the rowCause to the Apex sharing reason for hiring manager.

            // This establishes the sharing record as Apex managed sharing.

            //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            // Add sharing record to list for insertion.
            newPDUShrs.add(pduShr);
            
           

        }
        if(newPDUShrs!=null && newPDUShrs.size()>0)
            insert newPDUShrs;
    
    }*/
    public static void Share_PDU_From_Project(List <Project_Decisional_Unit__c> eligible_PDU_TO_Share,Id loggedInUserID,String accessLevel){
         // Create a list of Project_Decisional_Unit__Share objects to be inserted.
        List<Project_Decisional_Unit__Share> newPDUShrs = new List<Project_Decisional_Unit__Share >();
        List<Project_Decisional_Unit__Share> updatePDUShrs = new List<Project_Decisional_Unit__Share >();
        Map <string,Project_Decisional_Unit__Share> pduIDToPDUShareMap= new Map <string,Project_Decisional_Unit__Share>();
        Set <id> eligiblePDUIDs= new Set <id>  ();
        for(Project_Decisional_Unit__c pduRecord: eligible_PDU_TO_Share){
            eligiblePDUIDs.add(pduRecord.id);   
        }
        for(Project_Decisional_Unit__Share pduShareObj: [select UserOrGroupId,AccessLevel,ParentId from Project_Decisional_Unit__Share where UserOrGroupId=:loggedInUserID and ParentId IN:eligiblePDUIDs]){
            pduIDToPDUShareMap.put(pduShareObj.ParentId,pduShareObj);   
        }
        for(Project_Decisional_Unit__c pduRecord: eligible_PDU_TO_Share){
            if(pduIDToPDUShareMap.get(pduRecord.id)!=null){
                Project_Decisional_Unit__Share updatepduShr=pduIDToPDUShareMap.get(pduRecord.id);
                updatepduShr.AccessLevel = accessLevel;
                updatePDUShrs.add(updatepduShr);
            }
            else{
                Project_Decisional_Unit__Share pduShr = new Project_Decisional_Unit__Share ();
            
                pduShr.UserOrGroupId = loggedInUserID;
                pduShr.AccessLevel = accessLevel;
    
                // The ID of the record being shared
    
                pduShr.ParentId = pduRecord.Id;
                // Set the rowCause to the Apex sharing reason for hiring manager.
    
                
                // This establishes the sharing record as Apex managed sharing.
    
                //jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
                // Add sharing record to list for insertion.
                newPDUShrs.add(pduShr);
            }
           

        }
        if(newPDUShrs!=null && newPDUShrs.size()>0)
            insert newPDUShrs;
        if(updatePDUShrs!=null && updatePDUShrs.size()>0)
            update updatePDUShrs;
    
    }
    

}