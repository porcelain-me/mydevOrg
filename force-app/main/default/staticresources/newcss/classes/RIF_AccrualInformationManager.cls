// 07/010/2013 : Manisha Gupta : ORIGINAL
// Description : Manager class for RIF_AccrualInformation trigger
// 09/02/2013 : MG : Updated to populate newly added delta fields. HRFORCE-197

public without sharing class RIF_AccrualInformationManager {

    
    public static void checkAndUpdateDeltaFields(List<Accrual_Information__c> listNewAccInfo, map<Id,Accrual_Information__c> mapOldAccInfo,
                                                     boolean isInsert, boolean isUpdate, boolean isDelete, boolean isBefore){
                                                        
        if(isInsert && isBefore){
            // create map of emp id and Accrual Information
            map<String,Accrual_Information__c> mapEmpIdNewAccInfo = new map<String,Accrual_Information__c>();
            for(Accrual_Information__c accInfo : listNewAccInfo){
                mapEmpIdNewAccInfo.put(accInfo.Emp_Id__c, accInfo);
            }
            
            // loop over exisitng Accrual Information records and update accrual info record's delta fields with latest communicated accrual info
            // recrod's related fields.
            for(Accrual_Information__c existingAccInfo : RIF_DataUtil.getListExistingAccrualInfoForEmpIds(mapEmpIdNewAccInfo.keySet())){
                if(mapEmpIdNewAccInfo.containsKey(existingAccInfo.Emp_Id__c)){
                    Accrual_Information__c newAccInfo = mapEmpIdNewAccInfo.get(existingAccInfo.Emp_Id__c);
                    newAccInfo.Is_Delta_Change__c = true;
                    newAccInfo.Delta_Additional_Severance__c = existingAccInfo.Additional_Severance__c;
                    newAccInfo.Delta_Basic_Severance__c = existingAccInfo.Basic_Severance__c;
                    newAccInfo.Delta_Benefits__c = existingAccInfo.Benefits__c;
                    newAccInfo.Delta_Buy_Out_Of_Termination__c = existingAccInfo.Buy_Out_Of_Termination__c;
                    newAccInfo.Delta_Enhanced_Severance_Lcl__c = existingAccInfo.enhanced_severance_lcl__c;
                    newAccInfo.Delta_Ex_Gracia_Cash_Payment__c = existingAccInfo.Ex_Gracia_Cash_Payment__c;
                    newAccInfo.Delta_Notice_Amount__c = existingAccInfo.Notice_Amount__c;
                    // 13-Mar-17 : Changes to below given delta fields
                    // Delta Additional Notice days -> Additional Notice Days, Delta Addtl. Notice Amt -> Addtl. Notice Amnt
                    newAccInfo.Delta_Additional_Notice_Days__c = existingAccInfo.Additional_Notice__c;
                    newAccInfo.Delta_Additional_Notice__c = existingAccInfo.Additional_Notice_Amount__c;
                    newAccInfo.Delta_pay_in_lieu_of_ben_lcl__c = existingAccInfo.pay_in_lieu_of_ben_lcl__c;
                    newAccInfo.Delta_Pension_Contribution__c = existingAccInfo.Pension_Contribution__c;
                    newAccInfo.Delta_Social_Insurance__c = existingAccInfo.Social_Insurance__c;
                    newAccInfo.Delta_Statutory_Redundancy_Pay__c = existingAccInfo.Statutory_Redundancy_Pay__c;
                    newAccInfo.Delta_Termination_Bonus__c = existingAccInfo.Termination_Bonus__c;
                    newAccInfo.Delta_Notice_Days__c = existingAccInfo.Notice_Days__c;
                    newAccInfo.Delta_Buy_Out_of_Notice_Period_Lcl__c = existingAccInfo.Buy_Out_of_Notice_Per_Lcl__c;
                    mapEmpIdNewAccInfo.remove(existingAccInfo.Emp_Id__c);
                }
            }
        }
    }
}