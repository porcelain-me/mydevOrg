/** Manager class for Coverage Entitlement Orgs object trigger,
handle all the operations from the trigger **/
public class RIF_CoverageEntitlementOrgManager{
    
    /** method that will delete all shared SNR of the user, once a coverage org ent is removed for the user  **/
    public static void deleteAllSharedSNRs(Map<Id,Coverage_Entitlement_Org__c> oldCovEntsMap){
        List<Severance_and_Release__share> sharedSNRsList = new List<Severance_and_Release__share>();
        List<Employee__c> empsFromCovEnt = new List<Employee__c>();
        List<Severance_and_Release__c> snrList = new List<Severance_and_Release__c>();
        List<Severance_and_Release__share> finalSharedList = new List<Severance_and_Release__share>();
        Set<String> empMSIdsSet = new Set<String>();
        Set<String> snrIdsSet = new Set<String>();
        Set<String> userIdsSet = new Set<String>();
        Set<String> covEntCodeSet = new Set<String>();
        Set<Severance_and_Release__c> changeSNROwnerSet = new Set<Severance_and_Release__c>();
        Set<Severance_and_Release__share> deleteSNRSharingSet = new Set<Severance_and_Release__share>();
        Map<String,Severance_and_Release__share> snrShareMap = new Map<String,Severance_and_Release__share>();
        Map<String,Set<String>> deletedCovEntCodeMap = new Map<String,Set<String>>();
        
        for(Coverage_Entitlement_Org__c oldCov : oldCovEntsMap.values()){
            system.debug(' -- oldCov -- ' + oldCov);
            empMSIdsSet.add(oldCov.HR_EmpID__c);
            covEntCodeSet.add(oldCov.Coverage_Entitlement_Org_Code_Derived__c);
        }
        system.debug(' -- covEntCodeSet -- ' + covEntCodeSet);
        // get all the emp details for this cov ent
        if(!empMSIdsSet.isEmpty()){
            empsFromCovEnt = RIF_DataUtil.getEmployeesForEmpIds(empMSIdsSet);
        }
        if(!empsFromCovEnt.isEmpty()){
            for(Employee__c emp : empsFromCovEnt){
                userIdsSet.add(emp.User__c);
            }
        }
        // get all the shared SNR records for this emp, this would contain the 'Shared' and 'Owner' records
        if(!userIdsSet.isEmpty()){
            sharedSNRsList = getAllSharedSNRs(userIdsSet);
        }
        if(!sharedSNRsList.isEmpty()){
            system.debug(' -- sharedSNRsList SIZE-- ' + sharedSNRsList.size());
            for(Severance_and_Release__share eachSR : sharedSNRsList){
                snrIdsSet.add(eachSR.ParentId);
                snrShareMap.put(eachSR.ParentId, eachSR);
            }
        }
        // get the SNR details from the shared SNR rec Ids
        if(!snrIdsSet.isEmpty()){
            List<Severance_and_Release__c> snRes = getSNRDetails(snrIdsSet);
            if(!snRes.isEmpty()){
                system.debug(' -- ALL SNR sizes -- ' + snRes.size());
                for(Severance_and_Release__c snr : snRes){
                    system.debug(' -- snr-- ' + snr);
                    // get all the org codes for this SNR
                    Set<String> snrCodes = new Set<String>{snr.Employee__r.Super_Division__c,snr.Employee__r.Division_Org__c,snr.Employee__r.Super_Depart_Org__c,snr.Employee__r.Dept_Org__c,snr.Employee__r.Subdept_Org__c,snr.Employee__r.Sub_Depart2_Org__c,snr.Employee__r.Cost_Center__c};
                        system.debug(' -- snrCodes -- ' + snrCodes);
                    for(String code : snrCodes){
                        // check if any of the org code of the SNR matched that of the cov ent
                        if(covEntCodeSet.contains(code)){
                            // this SNR falls under the user's deleted cov ent
                            system.debug(' -- user\'s SNR -- ' + snr);
                            snrList.add(snr);
                        }
                    }
                }
                if(!snrList.isEmpty()){
                    system.debug(' -- shared SNR sizes -- ' + snrList.size());
                    for(Severance_and_Release__c snr : snrList){
                        for(Severance_and_Release__share shared : snrShareMap.values()){
                            if(snrShareMap.containsKey(snr.Id)){
                                // if owner
                                if(shared.RowCause == 'Owner' && snr.OwnerId == shared.UserOrGroupId){
                                    changeSNROwnerSet.add(snr); // SNR record
                                }
                                // if shared
                                else if(shared.RowCause == 'Manual'){
                                    deleteSNRSharingSet.add(shared); // SNR Share record
                                }
                            }
                        }
                    }
                }
                system.debug(' -- changeSNROwnerSet -- ' + changeSNROwnerSet);
                system.debug(' -- changeSNROwnerSet SIZE-- ' + changeSNROwnerSet.size());
                system.debug(' -- deleteSNRSharingSet -- ' + deleteSNRSharingSet);
                system.debug(' -- deleteSNRSharingSet SIZE-- ' + deleteSNRSharingSet.size());
                if(!changeSNROwnerSet.isEmpty()){
                    changeOwnershipOfSNRs(new List<Severance_and_Release__c>(changeSNROwnerSet));
                }
                if(!deleteSNRSharingSet.isEmpty()){
                    deleteSNRAccessForUsers(new List<Severance_and_Release__share>(deleteSNRSharingSet));
                }
                
            }
        }
    }
    /** get all the SNR details from SNR IDs**/
    public static List<Severance_and_Release__c> getSNRDetails(Set<String> snrIds){
        if(!snrIds.isEmpty()){
            List<Severance_and_Release__c> snrDetails = [SELECT Id, Project_Level__c, Emp_Id__c, Name,OwnerId,Employee__c,
                                                         Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c 
                                                         FROM Severance_And_Release__c WHERE Id IN : snrIds];
            if(!snrDetails.isEmpty()){
                return snrDetails;
            }
        }
        return null; 
    }
    /** get all the shared and owned SNR records, from SNR_share object **/
    public static List<Severance_and_Release__share> getAllSharedSNRs(Set<String> userSet){
        if(!userSet.isEmpty()){
            List<Severance_and_Release__share> allSharedSNRs = [SELECT AccessLevel,Id,ParentId,RowCause,UserOrGroupId FROM Severance_And_Release__share WHERE UserOrGroupId IN : userSet];
            if(!allSharedSNRs.isEmpty()){
                return allSharedSNRs;
            }
        }
        return null; 
    }
    
    /** method to delete the shared SNRs **/
    public static void deleteSNRAccessForUsers(List<Severance_and_Release__share> shareRecToDel){
        if(!shareRecToDel.isEmpty()){
            deleteResults(shareRecToDel);
        }
    }
    
    /** main method to retag the user owned SNRs to a RIF Admin 
when a record is deleted that was owned by the user, this record will now be assigned to a RIF Admin user, this can be configured from the custom setting, or else any Admin in picked at random **/
    public static void changeOwnershipOfSNRs(List<Severance_and_Release__c> affectedSNRs){
        List<User> userNameDetails,userDetails;
        Set<String> rifAdminsUserIdsSet;
        String getAdminQuery,rifAdminId;
        
        if(!affectedSNRs.isEmpty()){
            rifAdminsUserIdsSet = new Set<String>();
            getAdminQuery = 'SELECT Id,Emp_Id__c,LastName,FirstName FROM User';
            RIF_Master_Settings__c settings = RIF_Master_Settings__c.getValues('Settings');
            // get the RIF Admin user with whom the 'Owner' records will be shared with
            String adminName = settings.Default_RIF_System_Admin__c != '' || settings.Default_RIF_System_Admin__c != null ? settings.Default_RIF_System_Admin__c : '';
            system.debug(' -- ADMIN from Settings -- ' + adminName);
            PermissionSet permSet = [SELECT Id,Name,Label FROM PermissionSet WHERE Name = : String.ValueOf(System.Label.RIF_Admin_PS_API)];
            List<PermissionSetAssignment> permSetAssigns = [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: permSet.Id];
            if(!permSetAssigns.isEmpty()){
                for(PermissionSetAssignment perAsgn : permSetAssigns){
                    rifAdminsUserIdsSet.add(perAsgn.AssigneeId);
                }
            }
            if(!rifAdminsUserIdsSet.isEmpty()){
                if(!String.isBlank(adminName)){
                    system.debug(' -- HAS ADMIN NAME -- ');
                    getAdminQuery += ' WHERE Name LIKE \'%' + adminName + '%\' LIMIT 1';
                    userNameDetails = Database.query(getAdminQuery);
                    system.debug(' -- userNameDetails -- ' + userNameDetails);
                    if(!userNameDetails.isEmpty()){
                        for(User usr : userNameDetails){
                            rifAdminId = usr.Id;
                            break;
                        }
                    }
                }
                if(String.isBlank(adminName) || userNameDetails.isEmpty()){
                    getAdminQuery += ' WHERE Id IN : ' + rifAdminsUserIdsSet;
                    userDetails = Database.query(getAdminQuery);
                    system.debug(' -- userDetails -- ' + userDetails);
                    if(!userDetails.isEmpty()){
                        for(User eachUsr : userDetails){
                            rifAdminId = eachUsr.Id;
                            break;
                        }
                    }
                }
            }
            system.debug(' -- rifAdminId -- ' + rifAdminId );
            for(Severance_and_Release__c eachSNR : affectedSNRs){
                eachSNR.OwnerID = rifAdminId;
            }
            // update the owners
            updateResults(affectedSNRs);   
        }
    }
    
    /** general method that performs the DELETE operations of any SObject **/
    public static void deleteResults(List<SObject> lstSObj){
        if(!lstSObj.isEmpty()){
            Database.DeleteResult[] lsr = Database.delete(lstSObj, false);   
            // check if there are any errors
            for(Database.DeleteResult sr : lsr){
                if(!sr.isSuccess()){
                    Database.Error err = sr.getErrors()[0]; 
                    system.debug('Unable to DELETE due to exception: ' + err.getMessage());            
                }            
            }
        }
    }
    /** general method that performs the UPDATE operations of any SObject **/
    public static void updateResults(List<SObject> lstSObj){
        if(!lstSObj.isEmpty()){
            Database.SaveResult[] lsr = Database.update(lstSObj, false);   
            // check if there are any errors
            for(Database.SaveResult sr : lsr){
                if(!sr.isSuccess()){
                    Database.Error err = sr.getErrors()[0]; 
                    system.debug('Unable to UPDATE due to exception: ' + err.getMessage());            
                }            
            }
        }
    }
    /** general method that performs the INSERT operations of any SObject **/
    public static void insertResults(List<SObject> lstSObj){
        if(!lstSObj.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(lstSObj, false);   
            // check if there are any errors
            for(Database.SaveResult sr : lsr){
                if(!sr.isSuccess()){
                    Database.Error err = sr.getErrors()[0]; 
                    system.debug('Unable to INSERT due to exception: ' + err.getMessage());            
                }            
            }
        }
    }
    
    /** share all the SNRs in the system with the user's new coverage entitlements **/
    public static void shareAllSNRsWithUser(Map<Id,Coverage_Entitlement_Org__c> newCovEntsMap){
        Set<String> supDivCodeSet = new Set<String>();
        Set<String> divCodeSet = new Set<String>();
        Set<String> supDeptCodeSet = new Set<String>();
        Set<String> deptCodeSet = new Set<String>();
        Set<String> subDeptCodeSet = new Set<String>();
        Set<String> subDept2CodeSet = new Set<String>();
        Set<String> costCentCodeSet = new Set<String>();
        Set<String> empMSIdsSet = new Set<String>();
        Set<String> userIdsSet = new Set<String>();
        String unitType = '';
        List<Employee__c> empsFromCovEnt = new List<Employee__c>();
        List<Severance_and_Release__share> finalShareRecsList = new List<Severance_and_Release__share>();
        Map<String,Set<String>> insertShareRecsMap = new Map<String,Set<String>>();
        for(Coverage_Entitlement_Org__c newCov : newCovEntsMap.values()){
            system.debug(' -- newCov -- ' + newCov);
            empMSIdsSet.add(newCov.HR_EmpID__c);
            if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.SUP_DIV){
                supDivCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.DIV){
                divCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.SUP_DEPT){
                supDeptCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.DEPT){
                deptCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.SUB_DEPT){
                subDeptCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.SUB_DEPT_2){
                subDept2CodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
            else if(newCov.Coverage_Entitlement_Type__c == RIF_OrgHierarchy_Constants.COST_CEN){
                costCentCodeSet.add(newCov.Coverage_Entitlement_Org_Code_Derived__c);
            }
        }
        system.debug(' -- supDivCodeSet -- ' + supDivCodeSet);
        system.debug(' -- divCodeSet -- ' + divCodeSet);
        system.debug(' -- supDeptCodeSet -- ' + supDeptCodeSet);
        system.debug(' -- deptCodeSet -- ' + deptCodeSet);
        system.debug(' -- subDeptCodeSet -- ' + subDeptCodeSet);
        system.debug(' -- subDept2CodeSet -- ' + subDept2CodeSet);
        system.debug(' -- costCentCodeSet -- ' + costCentCodeSet);
        // get all the emp details for this cov ent
        if(!empMSIdsSet.isEmpty()){
            empsFromCovEnt = RIF_DataUtil.getEmployeesForEmpIds(empMSIdsSet);
        }
        if(!empsFromCovEnt.isEmpty()){
            for(Employee__c emp : empsFromCovEnt){
                userIdsSet.add(emp.User__c);
            }
        }
        // get all the SNRs from the system that has the specific coverage entitlement
        // we pass all the new coverage entitlement codes
        List<Severance_and_Release__c> allSNRsForSharing = RIF_CoverageEntitlementOrgManager.getSpecificSNRs(supDivCodeSet,divCodeSet,supDeptCodeSet,deptCodeSet,subDeptCodeSet,subDept2CodeSet,costCentCodeSet);
        if(!allSNRsForSharing.isEmpty()){
            system.debug(' -- allSNRsForSharing SIZE -- ' + allSNRsForSharing.size());
            for(Severance_and_Release__c snr : allSNRsForSharing){
                if(!userIdsSet.isEmpty()){
                    insertShareRecsMap.put(snr.Id,userIdsSet);
                }
            }
        }
        system.debug(' -- insertShareRecsMap -- ' + insertShareRecsMap);
        if(!insertShareRecsMap.isEmpty()){
            finalShareRecsList = createNewSharedRecords(insertShareRecsMap);
        }
        system.debug(' -- finalShareRecsList-- ' + finalShareRecsList);
        if(!finalShareRecsList.isEmpty()){
            insertResults(finalShareRecsList);
        }
    }
    
    // this will assign the SnRs to emp who have the corresponding Coverage Entitlements
    public static List<Severance_and_Release__share> createNewSharedRecords(Map<String,Set<String>> newUsersMap){
        List<Severance_and_Release__share> newSharedRecs = new List<Severance_and_Release__share>();
        if(!newUsersMap.isEmpty()){
            for(String snrId : newUsersMap.keySet()){
                Set<String> tempUsersSet = newUsersMap.get(snrId);
                for(String eachUser : tempUsersSet){
                    Severance_and_Release__share tempShare = new Severance_and_Release__share();
                    tempShare.ParentId = snrId;
                    tempShare.UserOrGroupId = eachUser;
                    tempShare.AccessLevel = 'Read';
                    tempShare.RowCause = 'Manual';
                    newSharedRecs.add(tempShare);            
                }
            }
        }
        return newSharedRecs;        
    }
    
    // get SNRs for specific coverage entitlements
    public static List<Severance_and_Release__c> getSpecificSNRs(Set<String> supDivCodeSet,Set<String> divCodeSet,Set<String> supDeptCodeSet,Set<String> deptCodeSet,Set<String> subDeptCodeSet,Set<String> subDept2CodeSet,Set<String> costCentCodeSet){
        List<Severance_and_Release__c> allEntSNRs = new List<Severance_and_Release__c>();
        //String queryStr = 'SELECT Id, emp_id__c,status__c,Decisional_Unit__c,Project_Decisional_Org_Level__c,Project_Level__c, Project_Level__r.Project__c,Employee__r.Super_Division__c, Employee__r.Division_Org__c, Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c, Employee__r.Subdept_Org__c, Employee__r.Sub_Depart2_Org__c,  Employee__r.Cost_Center__c FROM Severance_And_Release__c ';
        String queryStr = 'SELECT Id FROM Severance_And_Release__c ';
        String whereClauseStr = 'WHERE Employee__r.Super_Division__c IN : supDivCodeSet OR Employee__r.Division_Org__c IN : divCodeSet OR Employee__r.Super_Depart_Org__c IN : supDeptCodeSet OR Employee__r.Dept_Org__c IN : deptCodeSet OR Employee__r.Subdept_Org__c IN : subDeptCodeSet OR Employee__r.Sub_Depart2_Org__c IN : subDept2CodeSet OR Employee__r.Cost_Center__c IN : costCentCodeSet ';
        String finalQry = queryStr + whereClauseStr;
        system.debug(' -- finalQry -- ' + finalQry);
        if(!String.isBlank(finalQry)){
            allEntSNRs = Database.query(finalQry);
        }
        return allEntSNRs;
    }
    
}