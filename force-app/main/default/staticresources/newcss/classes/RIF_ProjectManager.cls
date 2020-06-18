public class RIF_ProjectManager {
    /*private static final String SHARING_ACCESS_LEVEL = 'Edit';
    private static final String DELIMETER_PROJECT_SUPER_DIVISION = ',|:';*/
    //variables
    
    //Added by Anshul Goyal on Aug 17,2015 to appply validation rules related to the different use cases 
    //corresponding to the statuses 'None,Model,Active,Cancelled,Closed' of the project
    public static void applyStatusValidations(Boolean isBefore,Boolean isUpdate,Boolean isDelete,List<project__c> newList, Map <id,project__c> oldMap,Map <id,project__c> newMap){
        System.debug('####applyStatusValidations() called####');
        Boolean currUserAdmin=false;
        List <permissionsetAssignment> setAssigmnentList=new List <permissionsetAssignment>([select id,assigneeid,permissionset.name from permissionsetAssignment where assigneeid=:UserInfo.getUserID()]);
        if(setAssigmnentList.size()>0){
            for(permissionsetAssignment assignment: setAssigmnentList){
                if(assignment.permissionset.name.equals('RIF_System_Admin')) 
                    currUserAdmin=true;  
            }
        }
        Map <id,List <severance_and_release__c>> mapProject_SRList= new  Map <id,List <severance_and_release__c>>();
        try{
            for(severance_and_release__c sr: RIF_DataUtil.getAllSRRecords(newList[0].id)){ 
                if(!mapProject_SRList.containsKey(sr.project__c))
                    mapProject_SRList.put(sr.project__c,new List<severance_and_release__c>{sr});
                else{
                    List <severance_and_release__c> tempSRList= new List <severance_and_release__c>(mapProject_SRList.get(sr.project__c));
                    tempSRList.add(sr); 
                    mapProject_SRList.put(sr.project__c,tempSRList); 
                } 
            
            }
        }
        catch(Exception e){
        }
        if(isUpdate && isBefore)  {
            System.debug('### full #srlist####'+RIF_DataUtil.getAllSRRecords(newList[0].id));
            System.debug('####mapProject_SRList####'+mapProject_SRList);
            //Validations related to the before insert of the project
            
           
            for(Project__c proj: newList){
               //restrict the edit of cancelled project
               if( ( (currUserAdmin==false) &&(oldMap.get(proj.id).Status__c=='Cancelled'))&& ((oldMap.get(proj.id).Name!=proj.Name)||
                       (oldMap.get(proj.id).Status__c!=proj.Status__c)||(oldMap.get(proj.id).Country__c!=proj.Country__c)||
                       (oldMap.get(proj.id).Communication_Date__c!=proj.Communication_Date__c)||(oldMap.get(proj.id).Termination_Date__c!=proj.Termination_Date__c)||
                       (oldMap.get(proj.id).Notice_Days__c!=proj.Notice_Days__c)||(oldMap.get(proj.id).WARN__c!=proj.WARN__c))){
                   proj.addError('You can\'t edit a cancelled project.Please contact System administrator.');
               }
               //restrict the edit of a closed project except RIF sys Admin
               if( ( (currUserAdmin==false) &&(oldMap.get(proj.id).Status__c=='Closed'))&& ((oldMap.get(proj.id).Name!=proj.Name)||
                       (oldMap.get(proj.id).Status__c!=proj.Status__c)||(oldMap.get(proj.id).Country__c!=proj.Country__c)||
                       (oldMap.get(proj.id).Communication_Date__c!=proj.Communication_Date__c)||(oldMap.get(proj.id).Termination_Date__c!=proj.Termination_Date__c)||
                       (oldMap.get(proj.id).Notice_Days__c!=proj.Notice_Days__c)||(oldMap.get(proj.id).WARN__c!=proj.WARN__c))){
                   proj.addError('You can\'t edit a closed project.Please contact System administrator.');
               }
               if(proj.status__c=='Model'){
                    
                }
                else if(proj.status__c.equalsIgnoreCase('Active')){
                    if(oldMap.get(proj.id).status__c=='Model'){
                      proj.addError('You can\'t convert a model project into Active');
                    }
                }
                else if(proj.status__c.equalsIgnoreCase('Cancelled')){  
                    
                    if( (oldMap.get(proj.id).status__c!='Active') && (oldMap.get(proj.id).status__c!='Cancelled')){
                      proj.addError('Only Active project can be cancelled');
                    } 
                    if(mapProject_SRList.containsKey(proj.id)){
                      System.debug('##proj.status__c###'+proj.status__c); 
                      for(severance_and_release__c sr: mapProject_SRList.get(proj.id)){
                          System.debug('#####sr.Communicated__c####'+sr.Communicated__c);
                          if(sr.Communicated__c)  //&& (sr.Communicated_Date__c!=null)
                              proj.addError('You can\'t cancel this project as some employee has been communicated already');
                      }
                    }   
                }
                else if( (proj.status__c.equalsIgnoreCase('Closed')) && (oldMap.get(proj.id).status__c!='Closed')){
                    if(oldMap.get(proj.id).status__c!='Active') {
                      proj.addError('Only Active project can be closed');
                    } 
                    if(mapProject_SRList.containsKey(proj.id)){
                        for(severance_and_release__c sr: mapProject_SRList.get(proj.id)){
                            // 17-Apr-2017 : ALM#1864,JIRA#71 : Allow users to close the project only if, 
                            // 1. all the 'Selected' emps are 'Communicated'
                            if(sr.Status__c == 'Selected' && !sr.Communicated__c){
                                proj.addError('You can\'t close this project as some employee has not been communicated yet'); 
                            }
                        }
                    }     
                }
            
            }
            
        } 
        if(isDelete && isBefore)  {
            for(Project__c proj: oldMap.values()){
                if(proj.status__c.equalsIgnoreCase('Cancelled')){
                    proj.addError('Cancelled project can\'t be deleted');    
                }
                else if(proj.status__c.equalsIgnoreCase('Active')){
                    if(mapProject_SRList.containsKey(proj.id)){
                        for(severance_and_release__c sr: mapProject_SRList.get(proj.id)){
                            if(sr.status__c.equalsIgnoreCase('Selected')){
                                proj.addError('This project can\'t be deleted as some employee in the project has been selected already');
                            }
                        
                        }
                    }
                } 
            }               
        }
    
    
    
    }
    
    public static void copySuperDivision(List<Project__c> listNewProjects){
        for (Project__c p: listNewProjects){
            if (p.Super_Division__c != p.System_Super_Division__c){
                 p.System_Super_Division__c = p.Super_Division__c;
            }
        }
    }
    //added on 12/08/2015 for calculation of the notice days from Communication_Date and Termination datae on the project
    /*public static void calculateNoticeDays(List<Project__c> listNewProjects){
        for (Project__c p: listNewProjects){
            if ( (p.Termination_Date__c!=Null) &&  (p.Communication_Date__c!=Null)){
                 p.Notice_Days__c= p.Communication_Date__c.daysBetween(p.Termination_Date__c);
            }
        }
    }*/
     //added on 20/10/2015 for changing the s&r record type on updating project's record type from project based to one off
    /*public static void changeSRRecordTpe(Project__c newProject){
        string SOBJECT_NAME = 'Project__c'; 
        final string recordTypeName='One Off Termination';
        ID oneOffProjectRecTypeID;
        boolean oneOffprojectFlag=false;
        List<RecordType> lstAllRT = RIF_DataUtil.getRecordTypeForName(recordTypeName);
        for(RecordType rt : lstAllRT){            
            if(rt.SobjectType == SOBJECT_NAME){
                oneOffProjectRecTypeID=rt.id;
            }
        }
        if(newProject.recordTypeID==oneOffProjectRecTypeID){ 
            List <severance_and_release__c> srList= new List <severance_and_release__c>( [select id,recordTypeID from severance_and_release__c where project__c =:newProject.id]);
            if(srList.size()>1)
                newProject.addError('You can not convert this project to One Off because of multiple employees.');
            else{
                    SOBJECT_NAME = 'Severance_And_Release__c';
                    //recordTypeName='Project Based Termination';
                    List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(recordTypeName);
                    for(RecordType rt : lstRT){            
                        if(rt.SobjectType == SOBJECT_NAME){
                            srList[0].recordTypeID=rt.Id;
                        }
                    }
                    update srList[0]; 
                    //stop update trigger on S&R
                    RIF_StopDuplicateAccrualByWorkflow.stopSRUpdateFromProject=true; 
            }
        }
    }*/
    
    
    //Added by Anshul on July 16,2015 to share the project with eligible RIF roles
    public static void shareProjectWithRIFRoles(List<Project__c> listNewProjects){
        
        /*Map<Id,Permissionset> OperationsPermissionMap= new Map<Id,Permissionset>();
        Map<Id,Permissionset> compensationPermissionMap= new Map<Id,Permissionset>();
        set<Id> OperationsUsers= new set<Id>();
        set<Id> compensationUsers=new set<Id>();
        
        
        
        OperationsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']);
        compensationPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
        
       
        if(OperationsPermissionMap!= null && OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment opUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:OperationsPermissionMap.keyset()]){
                OperationsUsers.add(opUser.assigneeid);
            }
            RIF_Sharing.shareProjectWithUsers(listNewProjects[0].id,OperationsUsers,'Read');
            
        }
        if(compensationPermissionMap!= null && compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment compUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:compensationPermissionMap.keyset()]){
                compensationUsers.add(compUser.assigneeid);
            }
            System.debug('####compensationUsers#####'+compensationUsers); 
            RIF_Sharing.shareProjectWithUsers(listNewProjects[0].id,compensationUsers,'Read');
            
        }*/
        /*set<id> pduIDs= new set<id> ();
        for(Project_Decisional_Unit__c pdu: [select id from Project_Decisional_Unit__c where Project__c=:listNewProjects[0].id]){
            pduIDs.add(pdu.id);
        
        }
        List <Project_Decisional_Unit__Share> listPduShareRecord=[select id,parentid,UserOrGroupId from Project_Decisional_Unit__Share where parentid IN:pduIDs];
        Ssstem.debug('#####listPduShareRecord####'+listPduShareRecord);*/
    }
    //Added by Abhijeet on July 24,2015 to delete Severance Records & Project Decisional Units when the corresponding Project is deleted
    public static void deleteProjectDUAndSRecord(List<Project__c> projectList){
        Set<ID> setProjectIDs = new Set<ID>();
        for(Project__c projectObj:projectList){
              setProjectIDs.add(projectObj.id);
        }
            
        List <Severance_And_Release__c> srList=new List <Severance_And_Release__c>([select id,Project__c from Severance_And_Release__c
                where Project__c in : setProjectIDs]);
                
        List <Project_Decisional_Unit__c> DecisionalList=new List <Project_Decisional_Unit__c>([select id,Project__c from Project_Decisional_Unit__c
                where Project__c in : setProjectIDs]);
        List <Project_Level__c> parameterLevelList=new List <Project_Level__c>([select id,Project__c from Project_Level__c
                where Project__c in : setProjectIDs]);       
        if((srList!=null && srList.size() > 0) && (!RIF_StopRecursiveloopOnDeleteOneOffSR.stopRecursion) ){
            RIF_StopRecursiveloopOnDeleteOneOffSR.stopRecursion=true;
            delete srList; 
            
        }
        if(DecisionalList!=null && DecisionalList.size() > 0){
            delete DecisionalList;
        }
        if(parameterLevelList!=null && parameterLevelList.size()>0)
            delete parameterLevelList;  
       
    }
}