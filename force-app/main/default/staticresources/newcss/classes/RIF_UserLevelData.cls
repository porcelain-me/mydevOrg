public with sharing class RIF_UserLevelData {
    public static List<Severance_And_Release__c> getSRLIStInUserMode(string projectID){
        return [select id,ownerid,Outplacement__c,Over_40__c,Over_40_Age_Disclosure__c,Communicated_Date__c,Decisional_Unit__c,exhibit_A__c,name, emp_Id__c,employee__c, status__c, age__c,Document_Generation_Status__c,Document_Download_Status__c,Level_Desc__c,First_Name__c, Last_Name__c, DocVersion__c,Conductor_URL__c,
                employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c,Project__c,Employee__r.HasEquity__c
                from Severance_And_Release__c 
                where project__c =:projectID Order by First_Name__c ASC ];
    }	
    
    
    /*MSN: RIF#121 Changes 19 March 2018 - Starts*/
    public static List<Severance_And_Release__c> getSyncSRLIStInUserMode(string projectID){
        Set<String> snrIDSet = new Set<String>();
        List<Severance_Release_ETL_Temp__c> listETLTemp = [Select Severance_And_Release__c  from Severance_Release_ETL_Temp__c  where project__c =:projectID and active__c =true order by createddate desc];
        if(listETLTemp!=null && !listETLTemp.isEmpty())
        {
            for(Severance_Release_ETL_Temp__c snrTemp :listETLTemp )
            {
                	snrIDSet.add(snrTemp.Severance_And_Release__c);
            }
        }
        
        return [select id,name, emp_Id__c,employee__c,status__c, 
                employee__r.Emp_ID__c,employee__r.Name
                from Severance_And_Release__c 
                where project__c =:projectID and project__r.status__c='Active'  and ID=:snrIDSet and Historical_Data_Load__c=false and Communicated__c =false Order by First_Name__c ASC ];
    }
    
    public static List<Severance_And_Release__c> getSRLIStfromSNRName(string snrname){
        List<string> snrNameList = new List<String>();
        if(String.isNotBlank(snrname))
        {
            snrNameList =  snrname.split(';');
        }
        return [select name,id,
                employee__r.Emp_ID__c,employee__r.Name
                from Severance_And_Release__c 
                where name =:snrNameList Order by First_Name__c ASC ];
    }
    
    public static Map<String,Severance_Release_ETL_Temp__c> getSyncSRTemp(string projectID){
        Map<String,Severance_Release_ETL_Temp__c> snrTempMap = new  Map<String,Severance_Release_ETL_Temp__c>();
        List<Severance_Release_ETL_Temp__c> listETLTemp = [Select name, Changed_Fields__c, project__c,Severance_And_Release__c  from Severance_Release_ETL_Temp__c  where project__c =:projectID and active__c =true order by createddate desc];
        if(listETLTemp!=null && !listETLTemp.isEmpty()){
            for(Severance_Release_ETL_Temp__c snrTemp :listETLTemp )
            {
                if(!snrTempMap.containsKey(snrTemp.Severance_And_Release__c))
                	snrTempMap.put(snrTemp.Severance_And_Release__c,snrTemp); 
            }
        }
        return snrTempMap;
    }
    
 	/*MSN: RIF#117/121 Changes 19 March 2018 - Ends*/   
    
    //MSN: RIF#54 Changes 16 March 18 - Starts
    public static   List<Project_Decisional_Unit__c> getPDUs(String projectID)
    {
        return [Select Decisional_Unit_Name__c,ID,name from Project_Decisional_Unit__c 
                where Project__c=:projectID];
    }
    //MSN: RIF#54 Changes 16 March 18 - Ends
   
    //MSN 26 March
     public static List<Severance_And_Release__c> getPrjtSRLIStInUserMode(string projectID){
        return [select id,ownerid,Outplacement__c,Over_40__c,Over_40_Age_Disclosure__c,Communicated_Date__c,Decisional_Unit__c,exhibit_A__c,name, emp_Id__c,employee__c, status__c, age__c,Document_Generation_Status__c,Document_Download_Status__c,Level_Desc__c,First_Name__c, Last_Name__c, DocVersion__c,Conductor_URL__c,
                employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c,Project__c,Employee__r.HasEquity__c
                from Severance_And_Release__c 
                where project__c =:projectID  and project__r.status__c='Active' and Communicated__c =false  Order by First_Name__c ASC ];
    }	
}