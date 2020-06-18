public class RIF_OrgProjectDecisionalUnitManager {
    //Added on 02 Feb 2016 for populating project id field which is used in identifying duplicate org decisional units for the particular project
    public static void popuateProjectID(List <Child_Project_Decisional_Unit__c> newOrgLevelPDUList,Map<id,Child_Project_Decisional_Unit__c> newOrgLevelPDUMap){
        Set <string> pduIDs= new Set <string> ();
        for(Child_Project_Decisional_Unit__c childPDU: newOrgLevelPDUList){
            pduIDs.add(childPDU.Project_Decisional_Unit__c);
        }
        Map <string,string> pduToProjMap = new Map <string,string>();
        for(Project_Decisional_Unit__c pdu:[select id,Project__c from Project_Decisional_Unit__c where id IN:pduIDs]){
            pduToProjMap.put(pdu.id,pdu.Project__c);
        }
        //Map <id,Child_Project_Decisional_Unit__c> orgPDUMap= new Map <id,Child_Project_Decisional_Unit__c>([select id,name,ProjectID__c,Project_Decisional_Unit__c,Project_Decisional_Unit__r.Project__c from Child_Project_Decisional_Unit__c where Project_Decisional_Unit__c IN:pduIDs]);
        for(Child_Project_Decisional_Unit__c newChildPDU: newOrgLevelPDUList){
            newChildPDU.ProjectID__c=pduToProjMap.get(newChildPDU.Project_Decisional_Unit__c);
        }
    } 
    //Added to restric non coverage user for creating org pdu
    public static void checkorgPDUEntitlements(List <Child_Project_Decisional_Unit__c> newOrgLevelPDUList, Map<id,Child_Project_Decisional_Unit__c> newOrgLevelPDUMap){
    	system.debug('INSIDE RIF_OrgProjectDecisionalUnitManager:checkorgPDUEntitlements:: ####newOrgLevelPDUList#####'+newOrgLevelPDUList);   	
        for(Child_Project_Decisional_Unit__c childPDU: newOrgLevelPDUList){
            // 07-18-2016 : Validate the selected fields for child PDU
            // 31-Aug-2016 : Org Hierarchy changes
            //String showErrors = RIF_DataUtil.checkOrgPDUFields(childPDU);
            //if(String.isBlank(showErrors)){
                Boolean isOrgPDUEligibility=RIF_DataUtil.checkOrgPDUEligibility(childPDU);
                if(!isOrgPDUEligibility && !Test.isRunningTest()){
                    childPDU.addError('You are not entitled to create this Org Level PDU as it is outside your coverage area.');
                    system.debug('You are not entitled to create the coverage.Kindly contact System Administrator');   		
            	}
            //}
            //else{
                //childPDU.addError(showErrors);
            //}
        }
    
    }
    //Added on Nov 16,2015 for applying validation while deleting Org PDU if employees are dependendent based on decisional unit 
    public static void checkEmployeesDependencyOnDeletedOrgLevelDecisionalUnits(List <Child_Project_Decisional_Unit__c> oldOrgLevelPDUList, Map<id,Child_Project_Decisional_Unit__c> OldOrgLevelPDUMap){
        Map<id,List <Severance_And_Release__c> > oldOrgPDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> (RIF_DataUtil.getOrgPDUToSRListMap(OldOrgLevelPDUMap.keyset())); 
        //getPDUToSRListMap=; 
        if(oldOrgPDUToSRListMap!=null && oldOrgPDUToSRListMap.size()>0){
            for(Child_Project_Decisional_Unit__c  oldChildPDU: oldOrgLevelPDUList){ 
                if(oldOrgPDUToSRListMap.containsKey(oldChildPDU.id)){
                	Set <id> tempSRIDs= new Set <id> ();
                	for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(oldChildPDU.id)){
                		tempSRIDs.add(sr.id);	
                	}
                	
                    Set <id> tempCoveredSRIds= new Set <id>(RIF_DataUtil.getSRListInTriggerCoveredByOtherOrgPDU(oldChildPDU.id,oldChildPDU.ProjectID__c,oldOrgPDUToSRListMap.get(oldChildPDU.id)));
                    //On deletion of org PDU record,if the S&R records are not covered by any org pdu
                    if(!tempCoveredSRIds.containsALL(tempSRIDs)){ 
            			Set <string> empIDs= new Set <string> ();
            			for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(oldChildPDU.id)){ 
	                		if(sr.status__c!='Not Selected')
	                			empIDs.add(sr.emp_id__c);
            			}
            			oldChildPDU.addError('The following S&R records depends on the org PDU, and need to be removed before proceeding:'+empIDs);		
                	}
                	//On deletion of org PDU record,if the S&R records are still covered by other org pdu
                	else if(tempCoveredSRIds.containsALL(tempSRIDs)){//else
            			
            			//for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(oldChildPDU.id)){
	                		RIF_DataUtil.updateSRWithOtherOrgPduANDPdu(oldChildPDU.id,oldChildPDU.ProjectID__c,oldOrgPDUToSRListMap.get(oldChildPDU.id),'delete');
            			//}
            				
                	}
                }    
            }       
    	} 
         
         
    }  
    
    //Added on Nov 16,2015 for applying validation while updating Org PDU if employees are dependendent based on decisional unit
    public static void checkEmployeesDependencyOnUpdatedOrgLevelDecisionalUnits(List<Child_Project_Decisional_Unit__c> newOrgLevelPDUList,Map<id,Child_Project_Decisional_Unit__c> newOrgLevelPDUMap,List<Child_Project_Decisional_Unit__c> oldOrgLevelPDUList, Map<id,Child_Project_Decisional_Unit__c> OldOrgLevelPDUMap){
        Map<id,List <Severance_And_Release__c> > oldOrgPDUToSRListMap=new  Map<id,List <Severance_And_Release__c>> (RIF_DataUtil.getOrgPDUToSRListMap(OldOrgLevelPDUMap.keyset())); 
        if(oldOrgPDUToSRListMap!=null && oldOrgPDUToSRListMap.size()>0){
            for(Child_Project_Decisional_Unit__c  newChildPDU: newOrgLevelPDUList){
                if(oldOrgPDUToSRListMap.containsKey(newChildPDU.id)){
                	Set <id> tempSRIDs= new Set <id> ();
                	for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(newChildPDU.id)){
                		tempSRIDs.add(sr.id);	
                	}
                    // 3-Apr-2017 : JIRA#RIF-22 : Call new method to get employee PDU details
                	//Set <id> tempCoveredSRIds= new Set <id>(RIF_DataUtil.getSRListInTriggerCoveredByAllOrgPDU(newChildPDU.id,newChildPDU.ProjectID__c,oldOrgPDUToSRListMap.get(newChildPDU.id))); 
                    Set <id> tempCoveredSRIds= new Set <id>(RIF_DataUtil.getSRListInTriggerCoveredByAllOrgPDU(newOrgLevelPDUList,oldOrgPDUToSRListMap.get(newChildPDU.id))); 
                    system.debug(' -- tempCoveredSRIds -- ' + tempCoveredSRIds);
                    /*Boolean isScopeDowngraded=RIF_DataUtil.checkOrgPDUScopeDowngraded(newChildPDU, oldOrgPDUToSRListMap.get(newChildPDU.id));
                    if(isScopeDowngraded){
                        Set <string> empIDs= new Set <string> ();
	                	for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(newChildPDU.id)){
	                		if(sr.status__c!='Not Selected')
	                			empIDs.add(sr.emp_id__c);	
	                	}
                        newChildPDU.addError('The following S&R records are outside the scope of this ORg PDU, and need to be removed before proceeding:'+empIDs); 
                    } */ 
                    //On editing of org PDU record,if the S&R records are not covered by any org pdu
                    if(!tempCoveredSRIds.containsALL(tempSRIDs)){ 
            			Set <string> empIDs= new Set <string> ();
            			for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(newChildPDU.id)){ 
	                		if(sr.status__c!='Not Selected')
	                			empIDs.add(sr.emp_id__c);
            			}
            			newChildPDU.addError('The following S&R records depends on the org PDU, and need to be removed before proceeding:'+empIDs);		
                	}
                	//On editing of org PDU record,if the S&R records are still covered by other org pdu
                	else if(tempCoveredSRIds.containsALL(tempSRIDs)){//else
            			
            			//for(Severance_And_Release__c sr: oldOrgPDUToSRListMap.get(oldChildPDU.id)){
	                		RIF_DataUtil.updateSRWithOtherOrgPduANDPdu(newChildPDU.id,newChildPDU.ProjectID__c,oldOrgPDUToSRListMap.get(newChildPDU.id),'edit');
            			//}
            				
                	}
                }       
            }       
        }       
    }
}