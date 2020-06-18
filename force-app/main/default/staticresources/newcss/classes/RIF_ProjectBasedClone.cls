public class RIF_ProjectBasedClone {

    public ApexPages.standardController controller{get;set;}
    public Project__c proj {get;set;}
    public Project__c newproj;
    public ID newRecordId {get;set;}
    public string projID;
    public static boolean clonesevParameters = false;
    
    public RIF_ProjectBasedClone(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        //proj= (Project__c)controller.getRecord();
        projID=controller.getId();
 
    }

    public PageReference cloneWithHistory() {
 
      //Project__c newproj;
        
        try{
                    // COPY THE FIELDS THAT ARE TO BE CLONED
                proj = [select Id ,Country__c,Status__c,Termination_Date__c,Name,Template1__c,Communication_Date__c,S_R_Warn_Count__c,Notice_Days__c,WARN__c,System_Super_Division__c from Project__c where id=:projID];
                  
                newproj=proj.clone(false);
                newproj.name='Cloned_'+proj.name;             //IT WILL ADD Cloned_ TO THE CLONED RECORD NAME
                newproj.Communication_Date__c=Date.today();
                 newproj.termination_Date__c=Date.today();
                insert newproj;
                System.debug('####newproj###'+newproj);
                List<Project_Level__c> insertedProjLevList = new List<Project_Level__c>();
             
                 for( Project_Level__c pl :[Select Back_Out_Notice__c,WARN__c,Covenant_Notice__c,Cobra_Months__c,Basic_Max__c,Basic_Min__c,Sev_Weeks_Min__c,Sev_Weeks_Max__c,Enhanced_Percent__c,Enhanced_Min__c,Enhanced_Max__c,Level__c,Template__c,Severance_Parameters__c ,Country__c,MS_MSSB__c,Level_Dsc__c,Sev_Weeks__c,Weekly_Mulitple__c,Notice_Calc__c,Los_Through__c,OutPlacement__c From Project_Level__c  where Project__c=:projID])
                 {
                     Project_Level__c newpl = pl.clone(false);
                     newpl.Project__c = newproj.id;
                     insertedProjLevList.add(newpl); 
                   
                 }
                 clonesevParameters=true;
                 
                 if( insertedProjLevList .size()>0 && insertedProjLevList !=Null )
                 {
                      insert insertedProjLevList ;
                 }
             
       
       }
       
       catch(Exception e){
       
           system.debug(e);
           
      }
       
      //return new PageReference ('/apex/RIF_Custom_Project_Page?id='+newproj.id);
      return new PageReference ('/'+newproj.id);
   }
}