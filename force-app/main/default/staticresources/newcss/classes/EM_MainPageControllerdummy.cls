@isTest                                                //dummy class
public class EM_MainPageControllerdummy{

    public String saveAndNewFlag{get;set;}
    public String selectEntProv {get;set;}
    public String entitlprovname{get;set;}
    public List<SelectOption> entprov {get;set;}
    public final Entitlement_Mapping__c entobj;
    private final ApexPages.StandardController ctrlr;
    public Entitlement_Mapping__c entobjinst{get;set;}
    public String groupName {get;set;}
    public Integer eonId {get;set;}
    public List<PermissionSet> listUserPerSets = new List<PermissionSet>();
    public List<Profile> listUserProfiles = new List<Profile>();
    public String permsetid{get;set;}
    public String profileid{get;set;}
    public Boolean pageErrorMessage{get;set;}
    
    public EM_MainPageControllerdummy(ApexPages.StandardController controller){            //override the standard controller

        this.entobj = (Entitlement_Mapping__c)controller.getRecord();
        ctrlr = controller;
        
        }
        
        public String getgroupName(){                                //get the Group Name field value
        return groupName;
        }
        
        public Decimal geteonId(){                                    //get the EON ID field value
        return eonId;
        }
      
        public String getentitlprovname(){                            //get the currently selected value from the dependent picklist
        return entitlprovname;
        }
                
    public List<SelectOption> getEntProvOptions(){                    //For the primary picklist to select Profile or Permission Set
    
         List<SelectOption> entopt = new List<SelectOption>();
         entopt.add(new SelectOption('','--None--'));
         entopt.add(new SelectOption('Permission Set','Permission Set'));
         entopt.add(new SelectOption('Profile','Profile'));
         return entopt;
         
         }
         
    public pagereference EntProvFilter(){                        //Method to filter permission sets and profiles in primary pick list and
         System.debug('selected: ' + selectEntProv );            //get all the profiles and permission sets and populate them in the 
         listUserPerSets = new List<PermissionSet>();            //dependent pick list
         listUserProfiles = new List<Profile>();
         entprov = new List<SelectOption>();
         
         if(selectEntProv  == 'Permission Set')
         {
         listUserPerSets.clear();
         listUserPerSets = [select id,Label from PermissionSet];
         listUserPerSets.sort();
         
             for (PermissionSet  ps : listUserPerSets) {
                 entprov.add(new SelectOption(ps.id,ps.Label));
                 permsetid = ps.id;
                 
                 }   
         }
         
         if(selectEntProv == 'Profile'){
         
         listUserProfiles .clear();
         listUserProfiles = [select id,Name from Profile];
         listUserProfiles.sort();
             for (Profile pr : listUserProfiles){
                 entprov.add(new SelectOption(pr.id,pr.Name));
                 profileid = pr.id;   
                 }
         }
      listUserProfiles.clear();
      listUserPerSets.clear();   
      
     return null;  
      
     }   
    
    public String getselectEntProv(){                            //get the currently selected value from priamry picklist
      return selectEntProv;
      }
      
    
    public pagereference save(){                                //called upon clicking Save button

        try{
        
        Entitlement_Mapping__c   entobjinst = new Entitlement_Mapping__c ();
        entobjinst.LDAP_Group__c = groupName;
        entobjinst.Entitlement_Provider__c = selectEntProv;
        entobjinst.EONID__c= eonId ;
        //entobjinst.Entitlement_Provider_Name__c = entitlprovname;
        
        if(selectEntProv == 'Permission Set'){                //show the id of the profile or permission set as selected in the picklist
        System.debug(permsetid);
          entobjinst.Entitlement_Provider_Id__c = entitlprovname;
          entobjinst.Entitlement_Provider_Name__c = [select Label from PermissionSet where id = :entitlprovname LIMIT 1].get(0).Label;

        }
        else if(selectEntProv == 'Profile')
        {
        System.debug(permsetid);
        entobjinst.Entitlement_Provider_Id__c = entitlprovname;
        entobjinst.Entitlement_Provider_Name__c = [select id,Name from Profile where id = :entitlprovname LIMIT 1].get(0).Name;
        }
       
        insert entobjinst;                                    //insert the values into the object, record created
         
         }
      
       catch(DMLException dmle){                                         // If there is blank field or duplicate data, control 
                                                                         //enters catch block and user is redirected to error page
           
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the record');
            ApexPages.addMessage(myMsg);
            pageErrorMessage = true;
            return null;        
       }
       
      
        for(String key : Apexpages.currentPage().getParameters().keySet()){
            if(key.contains('saveAndNew')){                                     //Passed the id of Save & New button through apex:param
            
                Apexpages.currentPage().setRedirect(true);                      
                PageReference pageRef = new PageReference ('/a3M/e');            //redirect to new EM_MainPage after saving the record
                return pageRef ;
            }
        } 
        
         PageReference pageRefer = new PageReference ('/a3M');                //Redirect to all records list after clicking only save
             return pageRefer ;     
       
    }
        
}