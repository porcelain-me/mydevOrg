/***
* 
*   (c) 2009 Appirio, Inc.
*
*   Controller class for MyPriorityContacts.page and NewPriorityContacts.page
*
*   03 March 2011     Chetan Garg       Original
*   11 March 2011     Svatka Simpson    Adding Pure_MSID__c to Candidate query
**/
public class MyPriorityContactController {
    
    //Id of the candidate to whom contact will be added
    public String candidateId{get;set;}
    public Candidate_Information__c candidateInfo {get;set;}
    
    private Map<ID, ContactWrapper> selectedContactsMap;
    //Contains contact id to reomve from selection
    public string contactCapsuleToRemove {get;set;}
    public List<ContactWrapper> listContactWrappers {get;set;}
    public Map<Id,ContactWrapper> mapContactWrapToSave{get;set;}
    public String result {get;set;}
    public Boolean isContactAdded {get;set;}
    
    public List<ContactWrapper> listContactWrapToSave {get;set;}
    /*
     {
        get{            
            if(mapContactWrapToSave == null) return new List<ContactWrapper>();
            return mapContactWrapToSave.values();
        }
        set;
    }
    */
    
    public List<ContactWrapper> selectedContacts{
        get{
            return mapContactWrapToSave.values();
        }
    }
    
    //default constructor
    public MyPriorityContactController(){   
                    
        candidateId = Apexpages.currentPage().getParameters().get('candidateId');       
        resetParams();
    }   
    
    public void resetParams(){
        selectedContactsMap = new Map<ID,ContactWrapper>();
        listContactWrappers = new List<ContactWrapper>();
        listContactWrapToSave = new List<ContactWrapper>();
        contactCapsuleToRemove = '';     
        mapContactWrapToSave = new Map<Id,ContactWrapper>();
        result = '';
        if(candidateId != '' && candidateId != null){
            getCandidateInfo();
            loadPriorityContacts();
        }
    }
    
    private void loadPriorityContacts(){ 
        List<GPSContact__c> priorityContacts = IIDataHelper.getUniquePriContacts(candidateInfo.Pure_MSID__c);
        
        Map<Id,contactWrapper> mapPriorityContacts = new Map<Id,ContactWrapper>();
        for(GPSContact__c pc : priorityContacts){
            ContactWrapper cw = new ContactWrapper(pc);
            listContactWrappers.add(cw);
            mapPriorityContacts.put(pc.id,cw);
        }
        
        for(Voter_Recommendation__c vr : [Select GPSContact__c, CreatedDate,Last_Added_Date__c From Voter_Recommendation__c 
                                          where Candidate_Information__c =:candidateId 
                                          AND (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))
                                          AND GPSContact__c IN :mapPriorityContacts.keySet()]){
              ContactWrapper cw = mapPriorityContacts.get(vr.GPSContact__c);
              cw.isPresent = true; 
              cw.dateAdded = vr.Last_Added_Date__c == null ? vr.CreatedDate.format('MMM dd yyyy, hh:mm a', String.valueOf(UserInfo.getTimeZone())) : vr.Last_Added_Date__c.format('MMM dd yyyy, hh:mm a', String.valueOf(UserInfo.getTimeZone()));                                  
        }
    }
    
    private void getCandidateInfo(){       
        for(Candidate_Information__c candidate : [Select id,MSID__c,Pure_MSID__c, Team__r.Fan_Club_Setup__r.Use_Analyst_Buddies__c
        ,Team__r.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c,Team__r.Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c
        From Candidate_Information__c c Where id=:candidateId ]){
            candidateInfo = candidate;
        }
        
        //candidateInfo.Team__r.Fan_Club_Setup__r.Use_Analyst_Buddies__c = false;
        
    }
    
    private void syncPageToSelectedContactsMap() {
        if(contactCapsuleToRemove != ''){
            for(string conId : contactCapsuleToRemove.split(',')){
                if(conId != ''){
                  selectedContactsMap.remove(conId);    
                }
            }
        }
        contactCapsuleToRemove = '';
        if(listContactWrappers != null ) {
            for(ContactWrapper cw : listContactWrappers) {
                if(cw.isSelected) {
                    if(!selectedContactsMap.containsKey(cw.contact.Id)){
                         //Set default Check on Page according to Fan Club Setup object from field Default_Adding_Analyst_Buddies__c.
                         cw.isbuddy = candidateInfo.Team__r.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c;
                         //system.debug('Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c;'+ candidateTeam.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c);
                         selectedContactsMap.put(cw.contact.Id, cw);
                    }   
                }else {
                    if(selectedContactsMap.containsKey(cw.contact.Id)) {
                        selectedContactsMap.remove(cw.contact.Id);
                    }
                }
            }
        }
    }
    
    
    /** 
     *This method iterates over the current list of ContactWrappers. Finds the existing contacts and creates
     *an error message for them. Adds new Voter_Recommendation__c records for new contacts.
     *Sets isContactAdded variable if a Voter_Recommendation__c record is inserted.
     *@return PageReference
     */
    public PageReference addCon(){
        syncPageToSelectedContactsMap();
        List<Voter_Recommendation__c> newVoterRecommendations = new List<Voter_Recommendation__c>();
        Set<String> setOfalreadyAdded = new Set<String>();
        boolean isContactSelected = false;
        //isContactAdded = false;
        result ='';
        Set<Id> existingContactIds = new Set<Id>();
        //existingContactIds.clear();
        
        system.debug('___________________________________Candiate Id :___' + candidateId);
        for(Voter_Recommendation__c voterRecomendation : [Select Id,GPSContact__c 
                From Voter_Recommendation__c Where Candidate_Information__c = :candidateId  AND GPSContact__c IN:selectedContactsMap.keyset()
                and (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))]){
            
            existingContactIds.add(voterRecomendation.GPSContact__c);
        }
        
        system.debug('___________________________________existingContactIds :___' + existingContactIds);
        system.debug('___________________________________ selectedContactsMap :___' + selectedContactsMap);
        Voter_Recommendation__c voterRecomandation;
        mapContactWrapToSave = new Map<Id,ContactWrapper>();
        for(ContactWrapper contactWrap : selectedContactsMap.values()){             
             //If team don't have Analyst Buddies option than they should not be created.
             if(candidateInfo.Team__r.Fan_Club_Setup__r.Use_Analyst_Buddies__c == false){
                     contactWrap.isBuddy = false;
             }
                  
             system.debug('Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c'+candidateInfo.Team__r.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c);
             
             //System.debug('###contactWrap:'+contactWrap);
            if(existingContactIds.contains(contactWrap.contact.id)){
                setOfalreadyAdded.add(contactWrap.contact.Name);
            }else{
                mapContactWrapToSave.put(contactWrap.contact.id,contactWrap);                   
            }
        }
        
        
        if(selectedContactsMap.size() > 0){
            if(setOfalreadyAdded.size() > 0){
                result += 'The following contacts are already on the list:';
                for (String conName : setOfalreadyAdded){
                        result = result + ',' + conName ;
                }
            }
            if(newVoterRecommendations.size() > 0){         
                //isContactAdded = true;
            }
            
        }else{
            //isContactAdded = true;
        }
        if(mapContactWrapToSave.size() ==0){
            return null;
        }
        listContactWrapToSave = mapContactWrapToSave.values();
        selectedContactId = '';
        Pagereference pg = new Pagereference('/apex/NewPriorityContacts');
        return pg.setRedirect(false);
    }
    
    public PageReference returnToStep1(){
        removeFromSavedList();
        syncPageToSelectedContactsMap();
        //selectedContactsMap.clear();
        result ='';
        //isContactAdded = false;
        for(Id conId : selectedContactsMap.keySet()){
            if(! mapContactWrapToSave.containsKey(conId)){
                selectedContactsMap.get(conId).isSelected = false;
                //selectedContactsMap.remove(conId);
            }   
        }
        
        selectedContactsMap.clear();
        for(Id conId : mapContactWrapToSave.keySet()){
            selectedContactsMap.put(conId, mapContactWrapToSave.get(conId));
            //selectedContactsMap.remove(conId);
        }   
        listContactWrapToSave = new List<ContactWrapper>();
        
        //for(Id conId :  selectedContactsMap.keySet()){
            //if(! mapContactWrapToSave.containsKey(conId)){
                //selectedContactsMap.remove(conId);
            //}
        //}       
          
        //listContactWrappers.clear();
        Pagereference pg = new Pagereference('/apex/MyPriorityContacts');
        return pg.setRedirect(false);
    }
    
    //12/15/2010 ParthT  : Updated method to Update existing VoterRecommendations 
    private Voter_Recommendation__c setVoterRecommendationValues(Voter_Recommendation__c voterRecommendation ,ContactWrapper contactWrap){
        //02/04/2011 Urminder : Added new String whyIncluded to trim the value of Why Included text area to 400 characters
         String whyIncluded = contactWrap.WhyIncluded;
         if(whyIncluded.length() > 400) {
            whyIncluded = whyIncluded.substring(0,400);
         }
         voterRecommendation.Why__c = whyIncluded;
         voterRecommendation.Is_Analyst_Buddy__c = contactWrap.isBuddy;
         voterRecommendation.Active_Flag__c = true;
         voterRecommendation.User_Who_Inactivated__c = null;
         voterRecommendation.Last_Added_Date__c = Datetime.now();
         
        if(voterRecommendation.id == null){
            voterRecommendation.Candidate_Information__c = candidateId;
            voterRecommendation.GPSContact__c = contactWrap.contact.id;
       }
        
        return voterRecommendation;
    }
    
    public Pagereference SaveContacts(){
         try{
            removeFromSavedList();
            List<Analyst_Buddy__c> analystBuddiesToCreate = new List<Analyst_Buddy__c>();
            List<Voter_Recommendation__c> newAndUpdatedVoterRecommendations = new List<Voter_Recommendation__c>();
             Set<id> setOfIdsUpdated = new set<id>();
             //First Update Existing VoterRecommendations
             for(Voter_Recommendation__c voter : [select id,GPSContact__c 
                                                  from Voter_Recommendation__c 
                                                  where GPSContact__c = :selectedContactsMap.keySet() 
                                                  AND Candidate_Information__c =: candidateId]) {
               
               if(mapContactWrapToSave.containsKey(voter.GPSContact__c)){
                    ContactWrapper contactWrap  = mapContactWrapToSave.get(voter.GPSContact__c);
                    voter =  setVoterRecommendationValues(voter,contactWrap);
                    
                    setOfIdsUpdated.add(voter.GPSContact__c);
                    newAndUpdatedVoterRecommendations.add(voter);
               }
                 
             }
            
             System.debug('=========================exting:newAndUpdatedVoterRecommendations=================='+newAndUpdatedVoterRecommendations);   
            
            //Now Add new Voter Recommendations
            Voter_Recommendation__c voterRecommendation;
            for(ContactWrapper contactWrap : mapContactWrapToSave.values()){
                System.debug('=========================enrting=================='+contactWrap);
                if(!setOfIdsUpdated.contains(contactWrap.contact.id)){
                    
                    System.debug('###contactWrap:'+contactWrap);
                    voterRecommendation = new Voter_Recommendation__c();
                    voterRecommendation =  setVoterRecommendationValues(voterRecommendation,contactWrap);
                                     
                    newAndUpdatedVoterRecommendations.add(voterRecommendation);
                   
                    
                  
                }
                system.debug('--->contactWrap.isBuddy-->'+contactWrap.isBuddy);
              if(contactWrap.isBuddy == true ){
                  analystBuddiesToCreate.add(new Analyst_Buddy__c(GPSContact__c = contactWrap.contact.id ,
                                                    Candidate_Information_Analyst__c = candidateId ));
                }
                
              //existingContactIds.add(contactWrap.contact.id);
                
            }
            
          
            
             if(newAndUpdatedVoterRecommendations.size() > 0){
                system.debug('upsert____newAndUpdatedVoterRecommendations'+newAndUpdatedVoterRecommendations);
                upsert newAndUpdatedVoterRecommendations;
                isContactAdded = true;
            }
            
            
            if(analystBuddiesToCreate.size() > 0){
                system.debug('insert___analystBuddiesToCreate'+analystBuddiesToCreate);
                insert analystBuddiesToCreate;
            }
            mapContactWrapToSave.clear();
            selectedContactsMap.clear();
         }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));      
        }           
        resetParams();      
        return null;
    }
    
    public String selectedContactId {get;set;}
    public void removeFromSavedList(){
          //mapContactWrapToSave.put(selectedContactId,null);
          System.debug('_______mapContactWrapToSave_____before rem ____' + mapContactWrapToSave);
          List<String> removeids = selectedContactId.split(',');
       for(string idToRem : removeids){
           if(idToRem <> null && idToRem <> ''){
                mapContactWrapToSave.remove(idToRem);
           }
         }
         selectedContactId = '';
         System.debug('_______mapContactWrapToSave_____' + mapContactWrapToSave);
         
    }
    
    /** 
     *Wrapper class for contact, to display information on page.
     */
     //02/23/2011 Urminder : added two new properties contactPriority and isPresent
    public class ContactWrapper{
        public GPSContact__c contact{get;set;}
        public boolean isSelected{get;set;}
        public String WhyIncluded {get;set;}
        public boolean isBuddy {get;set;}
        public boolean contactPriority{get;set;}
        public boolean isPresent{get;set;}
        public String dateAdded {get;set;}
        
        public contactWrapper(GPSContact__c contact){
            this.contact = contact;
            this.isSelected = false;
            this.WhyIncluded ='';
            this.isBuddy = false;
            this.isPresent = false;
            this.dateAdded = '-';
        }
    }

}