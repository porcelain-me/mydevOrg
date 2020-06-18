/**************************************************************************************
//Name            : CandidateContactsController
//Date            : 22 March,2010
//Description     : Controller for Add Contact popup(PR-04120)
//Author          : Vinod Jain
//Modified :
//
//11 oct 2010  Chetan Garg :  Added logic to create Analust Buddy and delete Analyst Buddy [PR-06648].
//13 oct 2010  Kapil Choudhary Added a function "getCandidateInfo" to get candidate information [PR-06682].
//14 oct 2010  Kapil Choudhary Add logic to prevent default check for buddy in step2 [PR-06687]
//10 Dec,2010  Kapil Choudhary updated for Inactivate Voter Recommendations instead of deleting [PR-07419].
//12/15/2010 ParthT  : Updated SaveContacts method to Update existing VoterRecommendations if readded 
                        Added Method setVoterRecommendationValues() to Update  VoterRecommendations
//02/04/2011 Urminder : added try-catch block to catch the exception during Search contacts (Example 'y)','j ','()',etc ) line#(237,258-260)
                         Added code to trim the value of Why Included text area to 400 characters (line# 468-476)   
// 02/09/2011 Urminder : Replaced Team_uses_Analyst_Buddies__c with Fan_Club_Setup__r.Use_Analyst_Buddies__c (line# 112,409)
//02/23/2011  Urminder : Added two new Properties in ContactWrapper class.
                         added a logic to fetch the priority contacts (line# 130-150)
//02/24/2011 Urminder  : Added two new Properties  (line# 78) 
                         Added new method setBuddy to update Analyst Buddy(line# 519)
//   //03/05/2011 Urminder : updated the query to fetch priority contacts from the contacts of current list only and applied MAX limit(line#160)
//03/07/2011 Urminder : Remove Limit from Query (line# 162)   
//03/10/2011 Svatka Simpson:     Adding where clause - show priority contacts with relationship type = P
//03/11/2011 Svatka Simpson:     Adding Pure_MSID__c to Candidate query. It's formula field and replacing the priority contact query to include this one over MSID__c                                                                                           
***************************************************************************************/

public with sharing class CandidateContactsController {
     public Fan_Club_Setup__c fanClubSetup {get;set;}    
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
    
    public Map<Id,ContactWrapper> mapContactWrapToSave {get;set;}
    //List for displaying contact info on page
    public List<ContactWrapper> listContactWrappers {get;set;}
    //Id of the candidate to whom contact will be added
    public String candidateId{get;set;}
    //Error message with comma seperated string of duplicate contact names
    public String result {get;set;}
    //Search text
    public String searchText{get;set;}
    //Variable to track addition of new contact, to close the popup window
    public Boolean isContactAdded {get;set;}
    //StandardSetController for pagination
    public ApexPages.StandardSetController conList{get;set;}
    //Pagination action [next,previous]
    public String action{get;set;}
    //List of page numbers to be displayed for pagination
    public List<Integer> pageIndexList{ get; set;}
    //Current page number in pagination
    public Integer currentPage{ get; set;}
    //set of duplicate contact ids
    private Set<String> existingContactIds = new Set<String>();
    //Query string for StandardSetController
    private String soql;
    public String contactOrder{get;set;}
    public String accountOrder{get;set;}
    //private Map<String,String> SORTING_ON = new Map<String,String>{'contact'=>'Contact__r.LastName','account'=>'Contact__r.Account.Name'};
    private Set<String> SORTING_ON = new Set<String>{'contact','account'};
    private Map<String,String> SORTING_ORDER = new Map<String,String>{'1'=>'ASC','2'=>'DESC'};
    public String sortingImg{get;set;}
    //private Map<String,String> SORTING_ORDERS = new Map<String,String>{'1'=>'ASC','2'=>'DESC'};
    //private Map<String,String> SORTING_IMG = new Map<String,String>{'ASC'=>'arrow_under_transp.gif','DESC'=>'arrow_over_transp.gif'}; 
    public String sortOn{get;set;}
    //public String sortOrder{get;set;}
    private String RECORD_LIMIT = '2000';
    //Map Id of selected contact to ContactWrapper
    private Map<ID, ContactWrapper> selectedContactsMap;
    //Contains contact id to reomve from selection
    public string contactCapsuleToRemove {get;set;}
    public Boolean isInitLoad {get;set;}
    public Boolean isFound {get;set;}
    public Team__c candidateTeam {get;set;}
    
    public Boolean isSearchNotProper {get;set;}
    public List<Priority_Contacts__c> lstPriCon;
    
    //02/24/2011 Urminder : added two new Properties to set Analyst Buddy
    public Id candidate{get;set;}
    public boolean Buddy{get;set;}
    
      
    private final integer MAX_UI_QUERY_LIMIT = 1499;  
    
    
        
    //default constructor
    public CandidateContactsController(){
        fanClubSetup = new Fan_Club_Setup__c();
        listContactWrapToSave = new List<ContactWrapper>();
        candidateId = Apexpages.currentPage().getParameters().get('candidateId');
        isSearchNotProper = false;
        system.debug('_________constructor________candidateId__'+candidateId);
        if(candidateId != '' && candidateId != null){
            getCandidateInfo();
        }
        resetParams();
        //System.debug('### Popup CandidateID:'+candidateId);
         
    }
    
    /** 
     *This method is called every time popup window is closed, to reset all parameters.
     *@return PageReference
     */
    public PageReference resetParams(){
        isInitLoad = true;
          listContactWrapToSave = new List<ContactWrapper>();
          selectedContactsMap = new Map<ID, ContactWrapper>();
          action = 'next';
          searchText = '';
          result = '';
          contactCapsuleToRemove = '';
          pageIndexList = new Integer[3];
          listContactWrappers = new List<ContactWrapper>();
          mapContactWrapToSave = new Map<Id,ContactWrapper>();
      conList = null;
      isFound = true;
      return null; 
    }
    
    // Used to Show "Still Can not find" Section On Page For Asia Pacific Team only.
    private void getCandidateInfo(){
    	system.debug('candidateId:'+candidateId);
        String teamName = '';
        for(Candidate_Information__c candidate : [Select Team_Name__c From Candidate_Information__c c Where id=:candidateId ]){
            teamName = candidate.Team_Name__c;
        }
        system.debug('teamName'+teamName);
        for(Team__c team : [Select Team_Region__r.Name,Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c,Fan_Club_Setup__r.Use_Analyst_Buddies__c,Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c //25-Jan-2011 one field added in query.
                                                FROM Team__c 
                                                where Name =:teamName limit 1]){
          candidateTeam = team; 
           fanClubSetup= candidateTeam.Fan_Club_Setup__r;
                                                                                 
            }
            system.debug('Canidate team is:'+candidateTeam);
    }
    
    /** 
     *This method updates listContactWrappers with current record set.
     *@return void
     */
         
    
        private void updateCurrentPage(){
         
         currentPage = conList.getPageNumber();
         Candidate_Information__c candidateInfo = new Candidate_Information__c();
        
             for(Candidate_Information__c canInfo : [Select id ,MSID__c, Pure_MSID__c from Candidate_Information__c where id =:candidateId limit 1]){
                    candidateInfo = canInfo;
                }
              Set<Id> setPriCon = new Set<Id>();
              
              
             
              
              system.debug('============candidateInfo========='+candidateInfo);
              lstPriCon = new List<Priority_Contacts__c>();
               //03/05/2011 Urminder : updated the query to fetch priority contacts from the contacts of current list only and applied MAX limit
               //03/10/2011 Svatka: updated where clause Relationship_Type__c = 'P' and replaced candidate MSID field for Pure_MSID__c (formula)
              for(Priority_Contacts__c pricon :[Select p.MS_Id__c, p.GPSEmployee__r.MS_ID__c, p.GPSEmployee__c, p.GPSContact__c From Priority_Contacts__c p
                                                    where Relationship_Type__c = 'P' AND (p.GPSEmployee__r.MS_ID__c =:candidateInfo.Pure_MSID__c or GPSEmployee__r.User__r.Emp_ID__c =:candidateInfo.Pure_MSID__c) and p.GPSContact__c IN : (List<GPSContact__c>)conlist.getRecords()])
                {
                             setPriCon.add(pricon.GPSContact__c);
                }
              system.debug('============setPriCon========='+setPriCon);
              existingContactIds.clear();
              
              
              
            
            
            for(Voter_Recommendation__c voterRecomendation : [Select Id, GPSContact__c From Voter_Recommendation__c Where Candidate_Information__c = :candidateId 
                                                                and (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))]){
                
                existingContactIds.add(voterRecomendation.GPSContact__c);
            }
        
              
        listContactWrappers.clear();
        
        for (GPSContact__c c : (List<GPSContact__c>)conlist.getRecords()){
            ContactWrapper cw = new ContactWrapper(c);
            if(selectedContactsMap != null && selectedContactsMap.containsKey(c.Id)) {
                cw.isSelected = true;
                
            } 
            cw.contactPriority = setPriCon.contains(c.id);
            cw.isPresent = existingContactIds.contains(c.id);
            listContactWrappers.add(cw);
        }
        Boolean isPopulate = true;
        for(Integer i = 0; i < pageIndexList.size() ; i++) {
            if(pageIndexList.get(i) != null && pageIndexList.get(i) == currentPage) {
                isPopulate = false;
                break;
            }
        }
        if(isPopulate) {
            populatePageIndexList();
        }
        
    }
    
     /**                
     *This method searches contacts based on searchText.
     *@return PageReference
     */
    public PageReference doSearch(){
        /**
        selectedContactsMap.clear();
        rerenderContacts(1);
        return null;
        **/
        system.debug('Within search Candidate team'+candidateTeam);
        isInitLoad = false;
        isfound = false;
        isSearchNotProper = false;
        syncPageToSelectedContactsMap();
        listContactWrappers = new List<ContactWrapper>();
        action = 'next';
        pageIndexList = new Integer[3];
        // selectedContactsMap = new Map<ID, ContactWrapper>();
        String soql;
        
        if(searchText.length() >= 2){
            /*
              String accountText = '%' + searchText.replaceAll('\'','\\\'').replaceAll (' ','%') + '%';
              String nameText =  searchText.replaceAll('\'','\\\'').replaceAll (' ','%') + '%';
              searchText =  + searchText.replaceAll('\'','\\\'').replaceAll(' ','* AND ')  +'*';
              
             //String searchText1 = searchText + '*';
              //String searchText2 = '*' + searchText + '*';
              //String searchText3 = '*' + searchText ;
                
              system.debug('___________________searchText________________' + searchText);
      //        String qry = 'FIND \'Yosh* or Hopper*\'  IN All FIELDS RETURNING Contact (id, name,Account.Name  WHERE Active_Flag__c = true     AND AccountId != null   Order by Account.Name , LastName) ';
      //          List<List<SObject>>searchList=search.query(qry);
    
              List<List<Sobject>> searchList = [FIND :searchText  //OR :searchText1 OR :searchText2 OR : searchText3
                                                IN ALL FIELDS  
                                                RETURNING 
                                                    Contact (id, name,Account.Name 
                                                             WHERE Active_Flag__c = true 
                                                             AND AccountId != null
                                                             And ( Account.Name like :accountText
                                                             OR firstname like : nameText
                                                             OR lastname like : nameText
                                                             OR name like : nameText
                                                             )
                                                             order by Account.Name asc, FirstName)
                                               ];
                                               
              
             */
             String searchInNameField = '';
             for(String splited : searchText.split(' ')){
                if(splited != ''){
                    //setOfSearchTexts.add(splited);
                    
                    searchInNameField += (searchInNameField == '' ? '' : ' AND ' ) + ' ( ii_Company__c like \'%' + splited.replace('\'','\\\'') + '%\' OR GPSAccount__r.Name like \'%' + splited.replace('\'','\\\'') + '%\' OR  Name like \'%' + splited.replace('\'','\\\'') + '%\' ) ';
                    
                }
             }
            
             searchInNameField = (searchInNameField == '' ? '' : 'AND ('+ searchInNameField + ')');
             searchText =  + searchText.replace(' ','* AND ')  +'*';
             searchText = searchText.replace('(',' ');
             searchText = searchText.replace(')',' ');
             
             system.debug('___________________searchText________________' +  searchText);
             
             String searchQuery = 'FIND :searchText  ' +
                                                + ' IN ALL FIELDS '   
                                                + ' RETURNING '
                                                + '     GPSContact__c (id, name, GPSAccount__r.Name,RecordType.Name,II_Company__c ,GPSAccount__r.Id, FirstName__c,LastName__c '
                                                +'           WHERE Active_Flag__c = true ' + searchInNameField
                                                +'           Order by GPSAccount__r.Name , LastName__c) ';
             
             system.debug('___________________searchQuery________________' + searchQuery);
             // 02/04/2011 Urminder : added try-catch block to catch the exception during Search contacts (Example 'y)','j ','()',etc ) 
             try {
                 List<List<Sobject>> searchList  = Search.query(searchQuery);
                
                 
                 List<GPSContact__c> searchResult = (List<GPSContact__c>)searchList[0];
                 
                 System.debug('searchResult :-' + searchResult);
              
                 system.debug('___________________doSearch________________' + soql);
                 
                 if( searchResult.size() < 200 ){
                    isSearchNotProper = true;
                 }
                 
                 conList = new ApexPages.StandardSetController(searchResult);
                 conList.setPageSize(50);
                  
                 isfound = (conlist.getResultSize()>0) ? true : false;
                  //conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));    
                  //conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
                 updateCurrentPage(); 
                 system.debug('Within search Candidate team'+candidateTeam);
          
          }catch(SearchException e){
                System.debug('_______________SearchException in doSearch()__________' + e);
                isSearchNotProper = true;
          }
        }
      return null;
  }
    
    public Pagereference rerenderContacts(Integer currentPage){
        if(currentPage == null){
            currentPage = 0;
        }
        action = 'next';
        pageIndexList = new Integer[3];
        if(currentPage == null){
            currentPage = 0;
        }
        String orderBy = 'account';//default sorting on account.Name
        String accOrder = SORTING_ORDER.get('1');//default sorting order ASC
        String conOrder = SORTING_ORDER.get('1');//default sorting order ASC
            
        if(SORTING_ON.contains(sortOn)){
            orderBy = sortOn;
        }
        if(SORTING_ORDER.containskey(accountOrder)){
            accOrder = SORTING_ORDER.get(accountOrder);
        }
        if(SORTING_ORDER.containskey(contactOrder)){
            conOrder = SORTING_ORDER.get(contactOrder);
        }   
                
        String soql;
        
        if(searchText!= null && searchText!= ''){
            searchText = '%' + searchText +'%';
        }else{
            searchText = '%';
        }
                    
        if(orderBy == 'account'){
            soql = 'Select id, Name,GPSAccount__r.Name, GPSAccount__c FROM GPSContact__c  Where  GPSAccount__c != null and (Name like :searchText   or GPSAccount__r.Name like :searchText ) Order By GPSAccount__r.Name '+ accOrder +', FirstName__c ASC LIMIT '+ RECORD_LIMIT;
        }
        if(orderBy == 'contact'){
            soql = 'Select id, Name, GPSAccount__r.Name, GPSAccount__c FROM GPSContact__c  Where  GPSAccount__c != null and (Name like :searchText   or GPSAccount__r.Name like :searchText ) Order By GPSAccount__r.Name '+accOrder+', LastName__c '+conOrder +' LIMIT '+ RECORD_LIMIT;
        }
                
        
        
        system.debug('###soql:'+soql);
        
        conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));   
        conList.setPageSize(50);
         
        updateCurrentPage(); 
        return null;
    }
  
    public void first() {
        syncPageToSelectedContactsMap();
        conList.first();
        updateCurrentPage();
    }
    
    public void last() {
        syncPageToSelectedContactsMap();
        conList.last();
        updateCurrentPage();
    }
    public void previous() {
        syncPageToSelectedContactsMap();
        conList.previous();
        updateCurrentPage();
    }
    public void next() {
        syncPageToSelectedContactsMap();
        conList.next();
        updateCurrentPage();
    }
    
    public void getRecordByPageNo() {
        syncPageToSelectedContactsMap();
        conList.setPageNumber(currentPage);
        updateCurrentPage();
    }
    
    public Boolean hasNext {
        get{
          if(conList == null) return false; 
          return conList.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            if(conList == null) return false;
            return conList.getHasPrevious();
        }
        set;
    }
    
    public Boolean isFirst{
        get{
           if(conList == null) return false;
           return (conList.getPageNumber() != 1);
        }
        set;
    }
    
    public Integer totalRecords{
        get {
            if(conList ==null) return 0;
           return conList.getResultSize();
        }
        set;
    }     
    
    public Boolean isLast{
        get {
           if(conList == null) return false;    
           return (conList.getPageNumber()!= (conList.getResultSize()/conList.getPageSize()));
        }
        set;
    }
   
        
    public List<ContactWrapper> selectedContacts {
      get{
        if(selectedContactsMap != null){
            return selectedContactsMap.values();
        }else{
            return new List<ContactWrapper>();
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
        isContactAdded = false;
        result ='';
        
        existingContactIds.clear();
        
        system.debug('___________________________________Candiate Id :___' + candidateId);
        for(Voter_Recommendation__c voterRecomendation : [Select Id,GPSContact__c From Voter_Recommendation__c Where Candidate_Information__c = :candidateId 
            and (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))]){
            
            existingContactIds.add(voterRecomendation.GPSContact__c);
        }
        
        system.debug('___________________________________existingContactIds :___' + existingContactIds);
        system.debug('___________________________________ selectedContactsMap :___' + selectedContactsMap);
        Voter_Recommendation__c voterRecomandation;
        mapContactWrapToSave = new Map<Id,ContactWrapper>();
        for(ContactWrapper contactWrap : selectedContactsMap.values()){
              system.debug('___________________________________ candidateTeam :___' + candidateTeam);
             //If team don't have Analyst Buddies option than they should not be created.
             if(candidateTeam.Fan_Club_Setup__r.Use_Analyst_Buddies__c == false){
                     contactWrap.isBuddy = false;
             }
                  
             system.debug('Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c'+candidateTeam.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c);
             
             //System.debug('###contactWrap:'+contactWrap);
            if(existingContactIds.contains(contactWrap.contact.id)){
                setOfalreadyAdded.add(contactWrap.contact.Name);
            }else{
                mapContactWrapToSave.put(contactWrap.Contact.id,contactWrap);                   
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
                isContactAdded = true;
            }
            
        }else{
            isContactAdded = true;
        }
        if(mapContactWrapToSave.size() ==0){
            return null;
        }
        selectedContactId = '';
        listContactWrapToSave = mapContactWrapToSave.values();
        Pagereference pg = new Pagereference('/apex/CandidateContactsRecords');
        return pg.setRedirect(false);
    }
    
    public PageReference returnToStep1(){
        removeFromSavedList();
        //syncPageToSelectedContactsMap();
        selectedContactsMap.clear();
        result ='';
        isContactAdded = false;
        for(Id conId : mapContactWrapToSave.keySet()){
            selectedContactsMap.put(conId, mapContactWrapToSave.get(conId));
        }
        
        system.debug('return To Step-1'+ selectedContactsMap);
        conList = new Apexpages.Standardsetcontroller(new List<GPSContact__c>());
        pageIndexList.clear();
        listContactWrappers.clear();
        Pagereference pg = new Pagereference('/apex/CandidateContactsPage');
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
         //03/03/2011  Chetan : populate Last_Added__c field whrn voter recommendation is added 
         voterRecommendation.Last_Added_Date__c = datetime.now();
         
        if(voterRecommendation.id == null){
            voterRecommendation.Candidate_Information__c = candidateId;
            voterRecommendation.GPSContact__c = contactWrap.contact.id;
       }
        
        return voterRecommendation;
    }
    
    public Pagereference setBuddy() {
        ContactWrapper contactWrap  = mapContactWrapToSave.get(candidate);
        contactWrap.isBuddy = Buddy;
        System.debug('===='+Buddy+'=====buddy======'+contactWrap);
        
        mapContactWrapToSave.put(candidate,contactWrap);
        System.debug('=========mapContactWrapToSave======'+mapContactWrapToSave);
        return null;
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
                
              existingContactIds.add( contactWrap.contact.id);
                
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
         listContactWrapToSave = mapContactWrapToSave.values();
    }
    
    public Pagereference sortContacts(){
        selectedContactsMap.clear();        
        rerenderContacts(this.currentPage);
        return null;
    }
    
    private void syncPageToSelectedContactsMap() {
        system.debug('syncPageToSelectedContactsMap:BEFORE:'+selectedContactsMap);
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
                         // Set default Check on Page according to Fan Club Setup object from field Default_Adding_Analyst_Buddies__c.
                           cw.isbuddy = candidateTeam.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c;
                         system.debug('Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c;'+ candidateTeam.Fan_Club_Setup__r.Default_Adding_Analyst_Buddies__c);
                         selectedContactsMap.put(cw.contact.Id, cw);
                    }   
                }else {
                    if(selectedContactsMap.containsKey(cw.contact.Id)) {
                        selectedContactsMap.remove(cw.contact.Id);
                    }
                }
            }
        }
        system.debug('syncPageToSelectedContactsMap:AFTER:'+selectedContactsMap);
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
        
        public contactWrapper(GPSContact__c contact){
            this.contact = contact;
            this.isSelected = false;
            this.WhyIncluded ='';
            this.isBuddy = false;
        }
    }
    
    /** 
     *This method populates pageIndexList with appropriate page numbers.
     *@return void
     */
    private void populatePageIndexList() {
        Integer totalResult  = conList.getResultSize();
        Integer pageSize = conList.getPageSize();
        pageIndexList.clear();
        
        Integer sPage;
        Integer ePage;
        Integer cPage = conList.getPageNumber();
        if(action != null) {
            if('next'.equals(action)) {
                if((cPage* pageSize) < totalResult) {
                    ePage = cPage + 1;
                    if((ePage * pageSize) < totalResult) {
                        sPage = cPage;
                        cPage = ePage;
                        ePage = ePage + 1;
                    }
                }   
            }else if('previous'.equals(action)) {
                ePage = currentPage;
                cPage = currentPage-1;
                sPage = currentPage-2;
            }
            
        }
        if(sPage != null) {
            pageIndexList.add(sPage);
        }
        if(cPage != null) {
            pageIndexList.add(cPage);
        }
        if(ePage != null) {
            pageIndexList.add(ePage);
        }
    }
    
    
}