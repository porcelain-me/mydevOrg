public class RIF_ProjectDecisionalUnitManager{
    public RIF_ProjectDecisionalUnitManager(){
    }
    
    //Added on Nov 16,2015 for applying validation while updating/deleting PDU if employees are dependendent based on decisional unit 
    /*public static void checkEmployeesDependencyOnDecisionalUnits(List <Project_Decisional_Unit__c> newPDUList, Map<id,Project_Decisional_Unit__c> newProjectDecisionalUnitsMap,List <Project_Decisional_Unit__c> oldPDUList, Map<id,Project_Decisional_Unit__c> OldProjectDecisionalUnitsMap){
        
            Map<id,List <Severance_And_Release__c> > PDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> (RIF_DataUtil.getPDUToSRListMap(OldProjectDecisionalUnitsMap.keyset())); 
            if(PDUToSRListMap!=null && PDUToSRListMap.size()>0){
                for(Project_Decisional_Unit__c pdu: newPDUList){
                	if(  
                	    (pdu.Project__c!=OldProjectDecisionalUnitsMap.get(pdu.id).Project__c)
                	    && (PDUToSRListMap.containsKey(pdu.id))
            	    )
            	    
                    	pdu.addError('You can not edit the project decisional unit as some/multiple Employees are dependent');    
                }        
            } 
            
    }*/
    public static void checkEmployeesDependencyOnDecisionalUnits(List <Project_Decisional_Unit__c> oldPDUList, Map<id,Project_Decisional_Unit__c> OldProjectDecisionalUnitsMap){
        //Emp_Id__c
        // 2-Aug-2016 : Defect#1712 Changes to allow PDU deletion (highest to lowest and vice versa) --- STARTS
        Set<String> projectIDsSet = new Set<String>();
        List<Severance_And_Release__c> snrList = new List<Severance_And_Release__c>();
        List<String> errorSNRList = new List<String>();
        Map<String,Severance_And_Release__c> snrUpdateMap = new Map<String,Severance_And_Release__c>();
        Map<id,List <Severance_And_Release__c> > PDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> (RIF_DataUtil.getPDUToSRListMap(OldProjectDecisionalUnitsMap.keyset())); 
        
        // get all the SnRs in the selected PDU
        system.debug(' -- PDUToSRListMap -- ' + PDUToSRListMap);
        if(!PDUToSRListMap.isEmpty()){
            for(Project_Decisional_Unit__c oldPDU: oldPDUList){ 
                projectIDsSet.add(oldPDU.Project__c);
                if(PDUToSRListMap.containsKey(oldPDU.id)){
                    Severance_And_Release__c newSnR = new Severance_And_Release__c();
                    for(Severance_And_Release__c sr: PDUToSRListMap.get(oldPDU.id)){
                        snrList.add(sr);
                    }
                } 
                //oldPDU.addError('Some Error!!');
            }        
        }
        system.debug(' -- snrList -- ' + snrList);
        // get the all the orgs PDUs from the lowest 
        for(Child_Project_Decisional_Unit__c childPdu : RIF_DataUtil.getProjectDecisionalOrgLevelsOnProjectId(projectIDsSet)){
            // loop over each SnR and find the lowest PDU possible, if found fill the map
            system.debug(' -- childPdu -- ' + childPdu);
            for(Severance_And_Release__c eachSnR : snrList){
                // this set will hold each employee's center codes, this will be checked against Child PDUs and then used to assign it to the respective PDU
                Set<String> empCodesSet = new Set<String>();
                empCodesSet.add(eachSnR.Employee__r.Cost_Center__c);
                empCodesSet.add(eachSnR.Employee__r.Sub_Depart2_Org__c);
                empCodesSet.add(eachSnR.Employee__r.Subdept_Org__c);   
                empCodesSet.add(eachSnR.Employee__r.Dept_Org__c); 
                empCodesSet.add(eachSnR.Employee__r.Super_Depart_Org__c); 
                empCodesSet.add(eachSnR.Employee__r.Division_Org__c); 
                empCodesSet.add(eachSnR.Employee__r.Super_Division__c);
                empCodesSet.add(eachSnR.Emp_Id__c);
                system.debug(' -- empCodesSet -- ' + empCodesSet);
                // check if the employee has got the org code as defined by PDU and checks to prevent present PDU from being added again
                // also make sure that the PDU level is always the lowest
                if(!snrUpdateMap.containsKey(eachSnR.Id) && (empCodesSet.contains(childPdu.Decisional_Unit_Derived__c) || empCodesSet.contains(childPdu.Emp_ID__c)) && (String.valueOf(eachSnR.Decisional_Unit__c) != String.valueOf(childPdu.Project_Decisional_Unit__c))){
                    snrUpdateMap.put(eachSnR.Id,new Severance_And_Release__c(Id = eachSnR.Id, Decisional_Unit__c = childPdu.Project_Decisional_Unit__c, Project_Decisional_Org_Level__c = childPdu.Id) );
                }
            }
        }
        system.debug(' -- snrUpdateMap -- ' + snrUpdateMap);
        // if the map is empty it means that there are not lower PDU for the employee to get assigned to, give user a message
        // 1-Nov-2016 : check if all the SNRs in the PDU has been reassigned, if not DO NOT delete
        // if(!PDUToSRListMap.isEmpty() && snrUpdateMap.isEmpty()){
        if(!PDUToSRListMap.isEmpty() && (snrUpdateMap.size() != snrList.size())){
            // loop over PDUs again to display the error messages with SnR
            for(Project_Decisional_Unit__c oldPDU: oldPDUList){ 
                for(Severance_And_Release__c sr: PDUToSRListMap.get(oldPDU.id)){
                    errorSNRList.add(sr.Name);  
                }
                oldPDU.addError('The following S&R records depends on the org PDU, and need to be removed before proceeding: ' + '</br>' +'<b>' + errorSNRList + '</b>', false);
            } 
        }
        else{
            try{
                // update the new SnRs
                update snrUpdateMap.values();
                // delete selected the PDUs
                delete oldPDUList;
            }
            catch(Exception exp){
                system.debug(' -- Exception while deleting and or updating -- ' + exp.getMessage());
            }
        }
        // 2-Aug-2016 : Defect#1712 Changes to allow PDU deletion (highest to lowest and vice versa) --- ENDS
    }
    
    //Added on July 20,2015 to share project decisional unit to the RIF Roles
   /* public static void shareProjectDecisionalUnitsWithRIFRoles(Map<id,Project_Decisional_Unit__c > NewProjectDecisionalUnitsMap){
        Map<Id,Permissionset> OperationsPermissionMap= new Map<Id,Permissionset>();
        Map<Id,Permissionset> compensationPermissionMap= new Map<Id,Permissionset>();
        set<Id> OperationsUsers= new set<Id>();
        set<Id> compensationUsers=new set<Id>();
        OperationsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']);
        compensationPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
        if(OperationsPermissionMap!= null && OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment opUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:OperationsPermissionMap.keyset()]){
                OperationsUsers.add(opUser.assigneeid);
            }
            RIF_Sharing.shareProjectDecUnitsWithUsers(NewProjectDecisionalUnitsMap.keyset(),OperationsUsers,'Read');
        }
        if(compensationPermissionMap!= null && compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment compUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:compensationPermissionMap.keyset()]){
                compensationUsers.add(compUser.assigneeid);
            }
            RIF_Sharing.shareProjectDecUnitsWithUsers(NewProjectDecisionalUnitsMap.keyset(),compensationUsers,'Read');
        }
    
    }*/ 

}