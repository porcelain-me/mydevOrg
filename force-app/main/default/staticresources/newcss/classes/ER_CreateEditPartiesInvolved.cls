//Jitendra: Created for create or Edit Parties Involved record
//IF PI is system generated then: User can not edit that record
// PI should be for one of Person/External/Anonymous

/* Change Log */
/* MRM 12/26/14 - Added edit to not allow person to be removed if it was there previously */
/* MRM 12/26/14 - Corrected logic to copy org information for historical purposes */

public with sharing class ER_CreateEditPartiesInvolved {
    public Parties_Involved__c partiesInvolved{get;set;}
    public  Employee__c emp{get;set;}
    public Id partiesInvolvedId{get; set;}
    public boolean isSystemCaseRecord{get;set;}
    public String person{get;set;}
    
    public Boolean showExternalSection {get;set;}
    
    public ER_CreateEditPartiesInvolved(ApexPages.StandardController stdController) {
        isSystemCaseRecord = false;
        if(ApexPages.currentPage().getParameters().get('id') != NULL){
            partiesInvolvedId = ApexPages.currentPage().getParameters().get('id');
            List<Parties_Involved__c> partiesInvolvedList = ER_DataUtil.getPartiesInvoledDetails(new list<string>{partiesInvolvedId});
            if(!partiesInvolvedList.isEmpty()){
                partiesInvolved = partiesInvolvedList.get(0);
                isSystemCaseRecord = partiesInvolvedList.get(0).Is_System_Case_Record__c;
                
            }else{
                this.partiesInvolved = new Parties_Involved__c();
            }
        }else{
            this.partiesInvolved = new Parties_Involved__c();
            List<String> strList = apexpages.currentPage().getUrl().split('&');
            for(String param : strList){
                if(param.contains('_lkid')){system.debug('param:'+ param);
                    partiesInvolved.Case__c = param.split('=')[1];
                }
            }
        } 
        if(ApexPages.currentPage().getParameters().get('RecordType') != NULL){
            partiesInvolved.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        }
        
        if(isSystemCaseRecord){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ER_SystemGeneratedPartyEditError));
        }       
    }
     
    public Pagereference saveData(){
         system.debug('*********** Party Edit *********************');
        
        if (partiesInvolved.is_Person_External__c == false && partiesInvolved.is_Person_anonymous__c == false
            && partiesInvolved.person__c == null)
        {   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'At least one value should populate from Person, Is Person External and Is Person Anonymous!'));
            return null;
        }
        // JIRA#ERCM7 : make sure the user cannot edit/delete the primary parties involved record
        // check if the record that is being edited is the primary record
        if(partiesInvolved.Is_a_trigger_record__c == true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Modifications to this primary \'Parties Involved\' record is not allowed!'));
            return null;
        }
         
        //partiesInvolved.Person__c = null;
        system.debug('---- Value of parties Involved'+PartiesInvolved);
        system.debug('--- value of person__c'+ PartiesInvolved.Person__c);
        if(partiesInvolved.Is_Person_Anonymous__c || partiesInvolved.Is_Person_External__c){
            system.debug('------------In If loop-------: ');            
            clearEmployeeFields();
        }
        try{
             system.debug('------------In try partiesInvolved-------: '+ partiesInvolved);
           upsert partiesInvolved;
             Parties_Involved__c temp = [select person__c from Parties_Involved__c where id = :partiesInvolved.id];
           system.debug(temp);
           system.debug('Emp:' + emp);
           
           system.debug('---- value of parties involved'+PartiesInvolved);             
        }catch(DMLException ex){
           	//ApexPages.addMessages(ex);
            return null;    
        }
        
        return new PageReference('/' + partiesInvolved.Id);
    }
    public Pagereference cancel(){
        if(partiesInvolved <> null && partiesInvolved.Id <> null)
           return new PageReference('/' + partiesInvolved.Id);

        return new PageReference('/' + partiesInvolved.Case__c);
    }
    public void copyParty(){
        
       
        getEmployeeDetails();
        partiesInvolved.Is_Person_Anonymous__c = false;
        partiesInvolved.Is_Person_External__c = false;
        
       
    }
    public void showExternal(){
        
        system.debug('is external is:' + partiesinvolved.Is_Person_External__c);
        if(partiesinvolved.Is_Person_External__c == true){
            showExternalSection = true;
            partiesinvolved.is_person_anonymous__c = false;
            clearEmployeeFields();
        }
        else{
            showExternalSection = false;
            clearPerson();
        }
            
        system.debug('show external:' + showExternalSection);
        
    }
    public void getEmployeeDetails(){
        system.debug('------------In getEmployeeDetails-------: '+ partiesInvolved);
        ApexPages.getMessages().clear();
        List<Employee__c> empList = ER_DataUtil.getEmployee(partiesInvolved.Person__c);
        if(!empList.isEmpty()){
            emp = empList[0];
            system.debug('------------In getEmployeeDetails EmpList-------: '+ emp);
            partiesInvolved.Party_Name__c = emp.Name + ' | ' +  emp.Emp_ID__c + ' | ' +  emp.Login_Id_Directory__c;            
            System.debug('partiesInvolved.Party_Name__c************** : '+partiesInvolved.Party_Name__c);
            partiesInvolved.Party_Full_Name__c = emp.Name;
            partiesInvolved.Emp_Id__c = emp.Emp_Id__c;
            partiesInvolved.Person__c= emp.id;
            partiesInvolved.emp_record_id__c=string.valueof(emp.id);
            emp.Name = string.escapeSingleQuotes(emp.Name);
            if(emp.Login_Id_Directory__c <> null && emp.Login_Id_Directory__c <> ''){
            emp.Login_Id_Directory__c = string.escapeSingleQuotes(emp.Login_Id_Directory__c);
            }
            system.debug('------------PartyInvolved--------: '+ partiesInvolved); 
            //clearPerson();
            
        }else{
            emp = null;
            partiesInvolved.Person__c = null;
            clearEmployeeFields();
        }
    }
    public void clearEmployeeFields(){ 
         
        partiesInvolved.Party_Name__c = null;
        partiesInvolved.Party_Full_Name__c = null;
        partiesInvolved.Emp_Id__c = null;
        partiesInvolved.Person__c = null;
        partiesInvolved.Cost_Center__c = null;
        partiesInvolved.Cost_Center_Desc__c = null;
        partiesInvolved.Departmant__c = null;
        partiesInvolved.Dept_Dsc__c = null;
        partiesInvolved.Division__c = null;
        partiesInvolved.Division_Desc__c = null;
        partiesInvolved.Emp_Type__c = null;
        partiesInvolved.Jobcode__c = null;
        partiesInvolved.Job_Title_Dsc__c = null;
        partiesInvolved.Level_Job__c = null;
        partiesInvolved.Level_Dsc_Job__c = null;
        partiesInvolved.Region_Desc__c = null;
        partiesInvolved.Super_Division__c = null;
        partiesInvolved.Super_Division_Desc__c = null;
        partiesInvolved.Super_Depart_Org__c = null;
        partiesInvolved.Super_Depart_Dsc_Org__c = null;
        partiesInvolved.Sub_dept__c = null;
        partiesInvolved.Subdept_Dsc_Org__c  = null;
        partiesInvolved.Sub_Depart2_Org__c = null;
    }
    
    public void clearPerson(){ 
        
        partiesInvolved.Person__c = null;
        partiesInvolved.Party_Full_Name__c = null;
        partiesInvolved.Party_Name__c = null;
        partiesInvolved.External_Email__c = null;
        partiesInvolved.External_Others__c = null;
        partiesInvolved.External_Party_Name__c = null;
        partiesInvolved.External_Phone__c = null;
        partiesInvolved.Is_Person_External__c = false;
        showExternalSection = false;
    } 
}