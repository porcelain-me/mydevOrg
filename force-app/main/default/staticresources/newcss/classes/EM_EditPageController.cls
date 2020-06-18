public class EM_EditPageController {

    public String selectEntProv {get;set;}
    public String entitlprovname{get;set;}
    public List<SelectOption> entprov {get;set;}
    public final Entitlement_Mapping__c entobj;
    private final ApexPages.StandardController ctrlr;
    public Entitlement_Mapping__c entobjinst{get;set;}
    public String groupName {get;set;}
    public Integer eonId {get;set;}
    public String description {get;set;}
    public List<PermissionSet> listUserPerSets = new List<PermissionSet>();
    public List<Profile> listUserProfiles = new List<Profile>();
    public String permsetid{get;set;}
    public String profileid{get;set;}
    public Boolean pageErrorMessage{get;set;}
    public String role{get;set;}
    
    public String edGrpName{get;set;}
    public decimal edeonid{get;set;}
    public String edrole{get;set;}
    public String eddesc{get;set;}
    public String edEntProvider{get;set;}
    public String edEntProvId{get;set;}
    public String edEntProvName{get;set;}
    
    Map<String,String> descriptionMap = new Map<String,String>();
    
    public EM_EditPageController(ApexPages.StandardController controller) {
         this.entobj = (Entitlement_Mapping__c)controller.getRecord();
         system.debug(' -- entobj CON -- ' + entobj );
        ctrlr = controller;
       
       Entitlement_Mapping__c empSavedRecs = new Entitlement_Mapping__c();
       empSavedRecs  = [Select name,Description__c,Entitlement_Provider__c,Entitlement_Provider_Id__c,Entitlement_Provider_Name__c,EONID__c,LDAP_Group__c,Role__c from Entitlement_Mapping__c where Id =:entobj.id];
       picklistValues(empSavedRecs.Entitlement_Provider__c);
       edGrpName = empSavedRecs.LDAP_Group__c;
       edeonid = empSavedRecs.EONID__c;
       edrole   = empSavedRecs.Role__c ;
       eddesc = empSavedRecs.Description__c;
       edEntProvider = empSavedRecs.Entitlement_Provider__c;
       edEntProvId = empSavedRecs.Entitlement_Provider_Id__c;
       entitlprovname = empSavedRecs.Entitlement_Provider_Name__c;
       //entprov = new List<SelectOption>();
       //entprov.add(new SelectOption(empSavedRecs.Entitlement_Provider_Id__c,empSavedRecs.Entitlement_Provider_Name__c));
    }
    
    public List<SelectOption> getEntProvOptions(){       //For the primary picklist to select Profile or Permission Set
        
        List<SelectOption> entopt = new List<SelectOption>();
        entopt.add(new SelectOption(edEntProvider,edEntProvider));
        if(edEntProvider !='Permission Set'){
            entopt.add(new SelectOption('Permission Set','Permission Set'));
        } 
        else if(edEntProvider !='Profile'){
            entopt.add(new SelectOption('Profile','Profile'));
        }
        return entopt;
    }
    
     public List<SelectOption> getentprov(){       //For the primary picklist to select Profile or Permission Set
        
        List<SelectOption> entprov = new List<SelectOption>();
        if(edEntProvider == 'Permission Set') {
            //get all the permission sets from the database
            listUserPerSets = [select id,Label, Description from PermissionSet];     
            listUserPerSets.sort();

            for(PermissionSet  ps : listUserPerSets) {
                entprov.add(new SelectOption(ps.id,ps.Label));
                permsetid = ps.id;
                //description = ps.Description;
                
                descriptionMap.put(ps.id, ps.Description);
            }   
        } 
        else if(edEntProvider == 'Profile') {
            //get all the profiles from database
            listUserProfiles = [select id,Name, Description from Profile];            
            listUserProfiles.sort();
            for (Profile pr : listUserProfiles){
                entprov.add(new SelectOption(pr.id,pr.Name));
                profileid = pr.id; 
                //description = pr.Description;
                descriptionMap.put(pr.id, pr.Description);
            }
            }
       // entopt.add(new SelectOption(edEntProvider,edEntProvider));
       
        return entprov;
    
    }
    
    
    public pagereference EntProvFilter(){                        
        System.debug('selected: ' + selectEntProv );      
        
        //get all the profiles and permission sets and populate them in the dependent pick list
        listUserPerSets = new List<PermissionSet>();             
        listUserProfiles = new List<Profile>();
        entprov = new List<SelectOption>();
        entprov.add(new SelectOption('---Select---','---Select---'));
        
        if(edEntProvider== 'Permission Set') {
            listUserPerSets.clear();
            //get all the permission sets from the database
            listUserPerSets = [select id,Label, Description from PermissionSet];     
            listUserPerSets.sort();
            
            for (PermissionSet  ps : listUserPerSets) {
                entprov.add(new SelectOption(ps.id,ps.Label));
                permsetid = ps.id;
                //description = ps.Description;
                
                descriptionMap.put(ps.id, ps.Description);
            }   
        } else if(edEntProvider == 'Profile') {
            
            listUserProfiles .clear();
            //get all the profiles from database
            listUserProfiles = [select id,Name, Description from Profile];            
            listUserProfiles.sort();
            for (Profile pr : listUserProfiles){
                entprov.add(new SelectOption(pr.id,pr.Name));
                profileid = pr.id; 
                //description = pr.Description;
                
                descriptionMap.put(pr.id, pr.Description);
            }
        }
        
        //listUserProfiles.clear();
        //listUserPerSets.clear();   
        
        return null;  
        
    }
    
     public PageReference setDescription() {
        // System.debug('entitlprovname-' + entitlprovname);
        description = descriptionMap.get(entitlprovname);
        // System.debug('description-'+description);
        return null;
    }
    
     public pagereference save(){                 //called upon clicking Save button
        
        System.debug('entry@@@save()@@@');
        
        try{
            
            Entitlement_Mapping__c   entobjinst = new Entitlement_Mapping__c ();      
            
            //assign the values from the page to the object custom fields
            entobjinst.Id = entobj.id;
            entobjinst.LDAP_Group__c = edGrpName;
            entobjinst.Entitlement_Provider__c = edEntProvider;
            entobjinst.EONID__c= edeonid;
            entobjinst.Description__c= eddesc;
            entobjinst.Role__c = edrole;
            //show the id of the profile or permission set as selected in the picklist
            if(selectEntProv == 'Permission Set') { 
                System.debug(permsetid);
                PermissionSet newPerm = permissionSetDetails(entitlprovname);
                entobjinst.Entitlement_Provider_Id__c = newPerm.Id;
                entobjinst.Entitlement_Provider_Name__c = newPerm.Label;
                
            } else if(selectEntProv == 'Profile') {
                System.debug(permsetid);
                Profile newProf = profileDetails(entitlprovname);
                entobjinst.Entitlement_Provider_Id__c = newProf.Id;
                entobjinst.Entitlement_Provider_Name__c = newProf.Name;
            }
            system.debug(' -- entobjinst -- ' + entobjinst);
            update entobjinst;             //insert the values into the object, record created
            
        } catch(Exception dmle){           // If there is blank field or duplicate data, control 
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the record');
            ApexPages.addMessage(myMsg);
            pageErrorMessage = true;
            
            return null;
        }
        
        Id id = ApexPages.CurrentPage().getParameters().get('id');
        Schema.DescribeSObjectResult r = Entitlement_Mapping__c.SObjectType.getDescribe();
        String url = '/'+r.getKeyprefix();                                                    //get the url dynamically
        System.debug('url : ' + url);
        
        
        PageReference pageRef = new PageReference(url);       //Redirect to all records list after clicking only save
        return pageRef ;
        
    }
    
    public PermissionSet permissionSetDetails(String entitlName){
        PermissionSet perRes = new PermissionSet();
        perRes = [Select Id,Label, Description from PermissionSet where id = : entitlName LIMIT 1];
        return perRes;
    }
    public Profile profileDetails(String entName){
        Profile profRes = new Profile();
        profRes = [select id, Name, Description from Profile where id = : entName LIMIT 1];
        return profRes;
    }
    
    public void picklistValues(String optionValue){
        entprov = new List<SelectOption>();
        if(optionValue == 'Profile'){
            List<Profile> allProfiles = new List<Profile>();
            allProfiles = [select Id,Name,Description from Profile];    
            for(Profile eachPr : allProfiles){
                entprov.add(new SelectOption(eachPr.Id,eachPr.Name));
            }
        }
        else if(optionValue == 'Permission Set'){
            List<PermissionSet> allPer = new List<PermissionSet>();
            allPer = [select Id,Label, Description from PermissionSet];
            for(PermissionSet eachPer : allPer){
                entprov.add(new SelectOption(eachPer.Id,eachPer.Label));
            }
        }
	}
}