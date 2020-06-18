public class EM_MainPageController{
    
    
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
    public String edeonid{get;set;}
    public String edrole{get;set;}
    public String eddesc{get;set;}
    public String edEntProvider{get;set;}
    public String edEntProvName{get;set;}
    
    Map<String,String> descriptionMap = new Map<String,String>();
    
    public EM_MainPageController(ApexPages.StandardController controller){            //override the standard controller
        
        this.entobj = (Entitlement_Mapping__c)controller.getRecord();
        ctrlr = controller;

    }
    
    public String getgroupName(){                                      //get the Group Name field value
        return groupName;
    }
    
    public Decimal geteonId(){                                         //get the EON ID field value
        return eonId;
    }
    
    public String getentitlprovname(){                   //get the currently selected value from the dependent picklist
        return entitlprovname;
    }
    
    public String getdescription (){                                   //get the description field value
        return description;
    }
    public List<SelectOption> getEntProvOptions(){       //For the primary picklist to select Profile or Permission Set
        
        List<SelectOption> entopt = new List<SelectOption>();
        entopt.add(new SelectOption('','--None--'));
        entopt.add(new SelectOption('Permission Set','Permission Set'));
        entopt.add(new SelectOption('Profile','Profile'));
        return entopt;
        
    }
    
    //Method to filter permission sets and profiles in primary pick list and
    public pagereference EntProvFilter(){                        
        System.debug('selected: ' + selectEntProv );      
        
        //get all the profiles and permission sets and populate them in the dependent pick list
        listUserPerSets = new List<PermissionSet>();             
        listUserProfiles = new List<Profile>();
        entprov = new List<SelectOption>();
        entprov.add(new SelectOption('---Select---','---Select---'));
        
        if(selectEntProv  == 'Permission Set') {
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
        } else if(selectEntProv == 'Profile') {
            
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
        
        listUserProfiles.clear();
        listUserPerSets.clear();   
        
        return null;  
        
    }
    
    public PageReference setDescription() {
        // System.debug('entitlprovname-' + entitlprovname);
        description = descriptionMap.get(entitlprovname);
        // System.debug('description-'+description);
        return null;
    }
    
    public String getselectEntProv(){            //get the currently selected value from primary picklist
        return selectEntProv;
    }
    
    public pagereference save(){                 //called upon clicking Save button
        
        System.debug('entry@@@save()@@@');
        
        try{
            
            Entitlement_Mapping__c   entobjinst = new Entitlement_Mapping__c ();      
            
            //assign the values from the page to the object custom fields
            entobjinst.LDAP_Group__c = groupName;
            entobjinst.Entitlement_Provider__c = selectEntProv;
            entobjinst.EONID__c= eonId ;
            entobjinst.Description__c= description;
            entobjinst.Role__c = role;
            //show the id of the profile or permission set as selected in the picklist
            if(selectEntProv == 'Permission Set') { 
                System.debug(permsetid);
                entobjinst.Entitlement_Provider_Id__c = entitlprovname;
                entobjinst.Entitlement_Provider_Name__c = [select Label, Description from PermissionSet 
                                                           where id = :entitlprovname LIMIT 1].get(0).Label;
                
            } else if(selectEntProv == 'Profile') {
                System.debug(permsetid);
                entobjinst.Entitlement_Provider_Id__c = entitlprovname;
                entobjinst.Entitlement_Provider_Name__c = [select id, Name, Description from Profile 
                                                           where id = :entitlprovname LIMIT 1].get(0).Name;
            }
            
            insert entobjinst;             //insert the values into the object, record created
            
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
    
    public pagereference cancel(){ 
        Id id = ApexPages.CurrentPage().getParameters().get('id');
        Schema.DescribeSObjectResult cancel = Entitlement_Mapping__c.SObjectType.getDescribe();
        String urlcancel = '/'+cancel.getKeyprefix();
        System.debug('url : ' + urlcancel);
        
        PageReference cancelref = new PageReference(urlcancel);      //Redirect to all records list after clicking only save
        return cancelref ;
    }
    
    public pagereference editRecord(){
       List<Entitlement_Mapping__c> empSavedRecs = new List<Entitlement_Mapping__c>();
       empSavedRecs  = [Select name,Description__c,Entitlement_Provider__c,Entitlement_Provider_Id__c,Entitlement_Provider_Name__c,EONID__c,LDAP_Group__c,Role__c from Entitlement_Mapping__c where Id =:entobjinst.id];
       return null;
    }
    
}