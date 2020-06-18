//
//  06/07/2013: RJ: Created for RIF One off and project based termination wizard. 
//
//
//
public without sharing class RIF_TerminationWizard {  
    private static final String STEP1_BACK_URL = '/apex/RIF_ProjectCustomTab'; // TODO: Move this to custom setting later
    private string projectbasedRecordTypeId;
    private static final String PROJECT_BASED_TERMINATION = Label.RIF_ProjectBasedTermination;
    public string severanceParameterId{get;set;}    
    public Project__c project{get;set;}
    public string recordTypeName{get;set;}
    public string recordTypeId{get;set;}
    public List<Severance_Parameters__c> severanceParams{get;set;}
    public boolean isWarnField_Allowed{get;set;}
    public List<String> fieldsList{get;set;}
    
    public RIF_TerminationWizard(){
        fieldsList = new List<String>();        
        isWarnField_Allowed = true;
        project = new Project__c();
        List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(PROJECT_BASED_TERMINATION);
        for(RecordType rt : lstRT){
           if(rt.SobjectType == 'Project__c'){
               projectbasedRecordTypeId = rt.Id;
           }
        }
    }
     
      
    public pagereference cancelStep1_Click(){
        return new pageReference(STEP1_BACK_URL);
    }
    
    public pagereference nextStep1_Click(){
        // clear heap
        fieldsList.clear();
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message> ();
        // To Enforce uniqueness of project name before insert statement.
        List<Project__c> projectList = RIF_DataUtil.getProjectListOnName(project.name);
        if(!projectList.isEmpty()){
          // clear heap now, not required anymore       
          projectList.clear();
          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_ProjectNameExistsAlready));
          return null;
        }
        /*if(project.status__c.equalsIgnoreCase('Cancelled') || project.status__c.equalsIgnoreCase('Closed')){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_projectCannotbeCreatedAsCancelled));
             return null;   
        }
        if(project.Communication_Date__c < Date.today()){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_CommDateLessthanToday));
             return null;   
        }
        if(project.Termination_Date__c < Date.today()){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_TermDateLessthanToday));
             return null;   
        }
        if(project.Communication_Date__c >project.Termination_Date__c){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_CommDateLessThanTerminationDate));
             return null;   
        } */
        fieldsList = RIF_DataUtil.getConfiguredFieldsList(recordTypeName); 
        severanceParams = RIF_DataUtil.getSeverancePrametersForCountry(project.Country__c);
       
           // AS PER DP Email on 6/26/2013 
           // When we create a project through wizard… we do not need Step2…. 
           // It will be just one page screen…. On first page when you click on save… 
           // we will automatically create project records for each severance parameter for that country.
           if(!severanceParams.isEmpty()){
               List<Project_Level__c> projectLevels = new List<Project_Level__c>(); 
               for(Severance_Parameters__c sevParam : severanceParams){
                  Project_Level__c pLevel = RIF_DataUtil.cloneSevParamToProjectLevel(sevParam);
                  projectLevels.add(pLevel);
               }
               /*if(masterProjectId <> null && masterProjectId <> ''){
                    project.Master_Project__c = masterProjectId;
               }*/
               project.recordTypeId=projectbasedRecordTypeId; 
               /*try{
                    RIF_DataUtil.insertResult(project);  
               }
               catch(Exception e){
                 ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getmessage()));
                 return null;   
               }*/
               pageMessages = RIF_DataUtil.insertResult(new List<SObject>{project});
               if(!pageMessages.isEmpty()){
                    for(ApexPages.Message msg : pageMessages){
                       ApexPages.addMessage(msg);
                    }
                    return null;
                }
                associateProject(project, projectLevels);
               RIF_DataUtil.insertResult(projectLevels);
               return new pageReference('/' + project.id);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Severance Parameters Exists'));
                return null;
            }           
                //return Page.RIF_ProjectBasedTerminationWizard; 
                   
    }
    private void associateProject(Project__c project, List<Project_Level__c> projectLevels){
        for(Project_Level__c pLevel : projectLevels){
            associateProject(project, pLevel);
        }
    }
    private void associateProject(Project__c project, Project_Level__c pLevel){       
          pLevel.Project__c = project.id;          
          pLevel.WARN__c = project.WARN__c;
          
    }
}