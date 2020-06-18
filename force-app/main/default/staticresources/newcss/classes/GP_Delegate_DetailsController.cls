/************** Controller Class for GP_Delegate_Details Visualforce Component***********/

public class GP_Delegate_DetailsController{
    
    public string employeeId {get;set;}
    public String getdelegatedetails(){
    System.debug('*********************Employee ID***************************************'+employeeId);
        List<String> emailCCAddresses =  new List<String>();
        String allstring ;
        if (employeeId!= null) {
        
            Map<ID,Employee_Delegate__c> delegatesEmpMap = new Map<ID,Employee_Delegate__c>( 
                [Select id, Delegate__r.User__c, Delegate__r.Name, Delegate__r.Middle_Name__c, 
                    Delegate__r.Login_Id_Directory__c, 
                    Delegate__r.Last_Name__c, 
                    Delegate__r.First_Name__c, Delegate__r.Emp_ID__c, Delegate__r.Email__c From Employee_Delegate__c  
                    where Employee__c =:employeeId
                        and Application__c = 'Global Parking' and  Status__c = 'Approved']);
                        
            for(Id key : delegatesEmpMap.keySet()){
                
                emailCCAddresses.add(delegatesEmpMap.get(key).Delegate__r.Email__c);
            }
            allstring = string.join(emailCCAddresses,',  '); 
        System.debug('*********************emailCCAddresses***************************************'+emailCCAddresses);
        }
        if(emailCCAddresses!= null){ 
            return allstring; 
        }
        else{
            return null;
        }
    }
}