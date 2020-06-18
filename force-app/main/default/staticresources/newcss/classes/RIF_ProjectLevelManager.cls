//
// 06/27/2013 : RA : ORIGINAL
// Description : Manager class to popualte denormalized fields on Project Level.


public without sharing class RIF_ProjectLevelManager {

    public static void populateDenormalizedFieldsIntoPL(list<Project_Level__c> listNewPL, boolean isInsert){
        if(isInsert){
            list<string> spIds = new list<string>();
            system.debug(listNewPL);
            for(Project_Level__c pl : listNewPL){ 
                if(pl.Severance_Parameters__c <> null){
                    spIds.add(pl.Severance_Parameters__c);
                }
            }
            
            
            map<id, Severance_Parameters__c> mapSP = new map<Id, Severance_Parameters__c>(RIF_DataUtil.getSeverancePrameters(spIds));
            
            // update S&R fields
            for(Project_Level__c pl : listNewPL){
                if(pl.Severance_Parameters__c <> null)
                    RIF_DataUtil.cloneSevParamToProjectLevel(pl, mapSP.get(pl.Severance_Parameters__c));
            }
            
        }
    }
}