/*********************************************************************************************************************************************************
// Name             : RIF_SNRShareBatch.cls
// Description      : This class shares the SNR record with the Coverage Entitlement  User based on the Project record
// Created By       : Mayur Naik Capgemini
// Created Date     : 15 Mar 2017
// Project: RIF
// **************************************************************** Version Updates ***********************************************************************
// Updated Date     Updated By      Update Comments        SR No#           SR Targeted Release date
/ *******************************************************************************************************************************************************/


global class RIF_SNRShareBatch implements Database.Batchable<SObject>, System.Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext c) { 
        String queryStr = 'SELECT AccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,ParentId,RowCause,UserOrGroupId FROM Project__Share';
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext db, List<Project__Share> listProjectShare)
    {
        Set<String> setProjectID = new Set<String>();
        List<Severance_And_Release__c> listSNR = new List<Severance_And_Release__c>();
        List<String> listUserID = new List<String>();
        List<Coverage_Entitlement_Org__c> listCoverageOrg = new List<Coverage_Entitlement_Org__c>();
        Set<String> setEmpData;
        Map<String,List<Severance_And_Release__c>> mapProjIDSNR = new Map<String,List<Severance_And_Release__c>>();
        Map<String,Set<String>> mapUserIDOrgCode = new  Map<String,Set<String>>(); 
        List<Severance_And_Release__Share> listInsertSNRShare = new List<Severance_And_Release__Share>();
        List<Severance_And_Release__Share> listExistingSNRShare = new List<Severance_And_Release__Share>();
        List<Severance_And_Release__Share> listDeleteSNRShare = new List<Severance_And_Release__Share>();
        Map<String,Set<Severance_And_Release__Share>> mapIDSNRShrRec = new  Map<String,Set<Severance_And_Release__Share>>();
        Map<String,Set<String>> mapIDSNRUserID = new  Map<String,Set<String>>();
        listExistingSNRShare =[SELECT AccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,ParentId,RowCause,UserOrGroupId FROM Severance_And_Release__Share];
        Set<String> setSNRhareID = new Set<String>();
        Map<ID,Severance_And_Release__Share> mapDeleteSNRShare = new Map<ID,Severance_And_Release__Share>();
        if(listExistingSNRShare!=null && !listExistingSNRShare.isEmpty())
        {
            for(Severance_And_Release__Share snrRec :listExistingSNRShare)
            {
                if(!mapIDSNRShrRec.containsKey(snrRec.ParentId))
                {
                    mapIDSNRShrRec.put(snrRec.ParentId ,new Set<Severance_And_Release__Share>{snrRec});
                }
                else
                {
                    Set<Severance_And_Release__Share> srlist = mapIDSNRShrRec.get(snrRec.ParentId);
                    srlist.add(snrRec);
                    mapIDSNRShrRec.put(snrRec.ParentId,srlist);
                }
                if(!mapIDSNRUserID.containsKey(snrRec.ParentId))
                {
                    mapIDSNRUserID.put(snrRec.ParentId ,new Set<String>{snrRec.UserOrGroupId});
                }
                else
                {
                    Set<String> srlist = mapIDSNRUserID.get(snrRec.ParentId);
                    srlist.add(snrRec.UserOrGroupId);
                    mapIDSNRUserID.put(snrRec.ParentId,srlist);
                }
            }
        }
        if(listProjectShare!=null && !listProjectShare.isEmpty())
        {
            for(Project__Share ps:listProjectShare)
            {
                setProjectID.add(ps.ParentId);
                listUserID.add(ps.UserOrGroupId);
            }
        }
        if(setProjectID!=null && !setProjectID.isEmpty())
        {
            listSNR = [Select ID,project__c, Employee__c ,Employee__r.Super_Division__c,Employee__r.Division_Org__c,
                       Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c, Employee__r.Subdept_Org__c,
                       Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c
                       where project__c=: setProjectID];
        }
        if(listUserID!=null && !listUserID.isEmpty())
        {
            listCoverageOrg =[Select Name,id, Coverage_Entitlement_Org_Code_Derived__c,Coverage_Entitlement__r.HR_Name__r.User__c from Coverage_Entitlement_Org__c where Coverage_Entitlement__r.HR_Name__r.User__c=: listUserID];
        }
        
        if(listSNR!=null && !listSNR.isEmpty())
        {
            for(Severance_And_Release__c sr : listSNR)
            {
                if(!mapProjIDSNR.containsKey(sr.Project__c))
                {
                    mapProjIDSNR.put(sr.Project__c, new List<Severance_And_Release__c>{sr});
                }
                else
                {
                    List<Severance_And_Release__c> listSN =   mapProjIDSNR.get(sr.Project__c);
                    listSN.add(sr);
                    mapProjIDSNR.put(sr.Project__c,listSN);
                }
            }
        }
        if(listCoverageOrg!=null && !listCoverageOrg.isEmpty())
        {
            for(Coverage_Entitlement_Org__c covOrg:listCoverageOrg)    
            {
                if(!mapUserIDOrgCode.containsKey(covOrg.Coverage_Entitlement__r.HR_Name__r.User__c))
                {
                    mapUserIDOrgCode.put(covOrg.Coverage_Entitlement__r.HR_Name__r.User__c,new Set<String>{covOrg.Coverage_Entitlement_Org_Code_Derived__c});
                }
                else
                {
                    Set<String> setOrg = mapUserIDOrgCode.get(covOrg.Coverage_Entitlement__r.HR_Name__r.User__c);
                    setOrg.add(covOrg.Coverage_Entitlement_Org_Code_Derived__c);
                    mapUserIDOrgCode.put(covOrg.Coverage_Entitlement__r.HR_Name__r.User__c,setOrg);
                }
            }
        }
        if(listProjectShare!=null && !listProjectShare.isEmpty())
        {
            for(Project__Share ps:listProjectShare)
            {
                if(mapProjIDSNR.get(ps.ParentId)!=null)
                {
                    //System.debug('Hi-ParentId-'+ps.ParentId); 
                    for(Severance_And_Release__c snr : mapProjIDSNR.get(ps.ParentId))
                    {
                        //System.debug('Hi-snrID-'+snr.ID); 
                        Set<String> setOrgCode = mapUserIDOrgCode.get(ps.UserOrGroupId);
                        if(setOrgCode!= null && !setOrgCode.isEmpty())
                        {
                            if(setOrgCode.contains(snr.Employee__r.Super_Division__c) || setOrgCode.contains(snr.Employee__r.Division_Org__c) || setOrgCode.contains(snr.Employee__r.Super_Depart_Org__c) || setOrgCode.contains(snr.Employee__r.Dept_Org__c) || setOrgCode.contains(snr.Employee__r.Subdept_Org__c) || setOrgCode.contains(snr.Employee__r.Sub_Depart2_Org__c) || setOrgCode.contains(snr.Employee__r.Cost_Center__c))
                            {
                                if(ps.RowCause=='Manual')
                                {
                                    if(!mapIDSNRUserID.containsKey(snr.ID) ||(mapIDSNRUserID.containsKey(snr.ID) && !mapIDSNRUserID.get(snr.Id).contains(ps.UserOrGroupId)))
                                    {
                                        System.debug('--SNR ID--'+snr.ID+'--Proj ID--'+ps.ParentId);
                                        Severance_And_Release__Share snrShare = new Severance_And_Release__Share();
                                        snrShare.ParentId = snr.Id;
                                        snrShare.UserOrGroupId = ps.UserOrGroupId;
                                        snrShare.RowCause =Schema.Severance_And_Release__Share.rowCause.ProjectBasedSharing__c;
                                        snrShare.AccessLevel = ps.AccessLevel;
                                        listInsertSNRShare.add(snrShare);
                                    }
                                }
                            }
                        }
                        Set<Severance_And_Release__Share> snrShareList = mapIDSNRShrRec.get(snr.Id);
                        //System.debug('Hi-snrShareList-'+snrShareList); 
                        for(Severance_And_Release__Share snrshareR :snrShareList )
                        {
                            //if(snrshareR.UserOrGroupId != ps.UserOrGroupId && (snrshareR.RowCause=='Manual' || snrshareR.RowCause=='ProjectBasedSharing__c' ))
                            if(snrshareR.UserOrGroupId != ps.UserOrGroupId &&  snrshareR.RowCause=='ProjectBasedSharing__c' )
                            {
                                
                                //listDeleteSNRShare.add(snrshareR);
                                //System.debug('snrshareR.UserOrGroupId-'+snrshareR); 
                                mapDeleteSNRShare.put(snrshareR.ID,snrshareR);
                            }
                        }
                    }
                }
            }
        }
        
        if(listInsertSNRShare!= null && !listInsertSNRShare.isEmpty())
        {
             System.debug('-ListSNRSharetoInsert  Size--'+listInsertSNRShare.size());
            System.debug('-ListSNRSharetoInsert--'+listInsertSNRShare);
            insert listInsertSNRShare;
        }
        
        if(mapDeleteSNRShare.values()!= null && !mapDeleteSNRShare.values().isEmpty())
        {
            //delete mapDeleteSNRShare.values();
        } 
    }
    
    global void finish(Database.BatchableContext db)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
        ID jobID = Database.executeBatch(new RIF_SNRShareBatch());
    }
    
}