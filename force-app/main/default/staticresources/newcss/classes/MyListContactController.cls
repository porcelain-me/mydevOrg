/*......................................................................................................................................
@@ Modified by      : Appirio Offshore(Prakash G)
@@ Modified Date    : April, 03 2010
@@ Reference PR     : PR-04277
// John Gorup, August, 12 2010, added "Active_Flag__c = true" in the soql
// Kapil Choudhary , 07 Sep 2010  Update AddCon  method for EmailOnly
//                              Added a Url parameter listType to get if dialog is invoked by EmailOnly grid section    
// Parth Tamhaney   13,Sept 2010 Added code to Set queryLimit in case of Tests (Line 123,127,132)
// Chetan Garg  , 14/09/10  PR-06204: More functionality on Add a contact , Added Code to maintain selction while searching and paging.
// Chetan Garg ; 21/10/10  PR-06272 - Performance on Searching and adding a contact
// Kapil Choudhary 29 Sep 2010 [PR-06457] - Added the list type on the Add Contact.
// Chetan Garg       30 Sep 2010  changed search query PR-06272: Performance on Searching and adding a contact
// Chetan Garg       30 Sep 2010  Implement SOSL to search cotnact
// Chetan Garg       04 Oct 2010  PR-06525: Strange results when adding a contact  
// Chetan Garg       21 Oct 2010  PR-06781: Configurable Additional Owner Hover Labels in last column 
// Kapil Choudhary 22 Oct 2010  Update syncPageToSelectedContactsMap for the PR-06783.
// Chetan Garg       11/01/2010 PR-06864: Ad-Hoc Contacts in myiiList
// Parth Tamhaney    11/08/2010 Set NotII friendly (PR-06983- Mark added contacts Not II Friendly, if they are Not II Friendly elsewhere)
//                              Check For contact of Accounts that are included in Exclude List
//Chetan Garg        11/09/2010 PR-07010: Contacts marked Not II Friendly - set contact as ineligible for email
//                              if a user adds that contact AFTER a version has been marked as non-II Friendly, that added contact should still have their setting Email flag defaulted to NO
//11/17/2010   Chetan Garg      PR-07128 - Show Company name in capsule for customer contacts
//11/17/2010   Chetan Garg      PR-07134 - Adding functionality to the export to Excel..           
//Kapil Choudhary 18 Nov 2010 Added a property 'totalRecords' to standard set controller for the []
// 11/22/2010   Chetan Garg PR-07219 - PR for II - Exclusion Emails - Additional Requirement      
// 11/26/2010   Chetan Garg     PR-07236 - Morgan Stanley - II Search from Add Contact Page (10)        
//12/14/2010    ParthT          Added Check for null campaign (lines 568,571)     
//01/02/2011    Chetan Garg     PR-07748 - Morgan Stanley - II - TLM's fall out of sync if contact is added after a vote is
........................................................................................................................................*/

public class MyListContactController{
  public List<ContactWrapper> listContacts {get;set;}
  public String selectedID {get;set;}
  public String result {get;set;}
  public String searchText{get;set;}
  public String action{get;set;}
  public Boolean isContactAdded {get;set;}
  public ApexPages.StandardSetController conList{get;set;}
  // private List<Contact> listOfContacts {get;set;}
  public Set<String> recordTypeNames =new Set<String>{'Voters','iiCampaign Contact'};
  public List<Integer> pageIndexList{ get; set;}
  public Integer currentPage{ get; set;}
  //Map Id of selected contact to ContactWrapper
  private Map<ID, ContactWrapper> selectedContactsMap;
  public Boolean isTargetList {get;set;}
  public Target_List__c userTargetList {get;set;}
  public Boolean isEmailOnlyContact {get;set;} 
  public Boolean matchWithExistingContact{get;set;}
  
  public String targetListId {get;set;}
  public string contactCapsuleToRemove {get;set;}
  public Boolean resultNotFound {get;set;} 
    
  private RecordType iiCampaignContactRecord {get;set;}
  public string emailExclusionMessage {get;set;}
  public Boolean isSearchNotProper {get;set;}      
  
  public MyListContactController(){
    emailExclusionMessage ='Account restricted from receiving automated emails.  If you wish to call this contact anyway, please add him/her to your <Call List Name> list instead of <Email List Name> list.';
     for(RecordType recordType :  [Select r.SobjectType, r.Name, r.Id From RecordType r 
      where r.SobjectType = 'GPSContact__c' and r.Name = 'iiCampaign Contact']){
        iiCampaignContactRecord = recordType;
     }      
    
     init();
     if(Apexpages.currentPage().getParameters().get('list') != null && Apexpages.currentPage().getParameters().get('list') != ''){
        targetListId = Apexpages.currentPage().getParameters().get('list');
        system.debug('*********************MyListContactController******************************');
        system.debug('*********************targetListId******************************'+targetListId);
        isTargetList = true;
        for(Target_List__c targetList : [Select id,iiCampaign__c,iiCampaign__r.Contacts_to_Call_Tab_Text__c,
                                        iiCampaign__r.Email_only_Contacts_Tab_Text__c,iiCampaign__r.Allow_ad_hoc_contacts__c
                                        ,iiCampaign__r.Synch_Target_List_Member_Statuses__c 
                                        FROM Target_List__c Where id =:targetListId]){
            userTargetList = targetList;
        }
        
        if(Apexpages.currentPage().getParameters().get('listtype') != null && Apexpages.currentPage().getParameters().get('listtype') != ''){
          if(Apexpages.currentPage().getParameters().get('listtype') == 'emailonly'){
            isEmailOnlyContact = true;
          } 
        }
     }  
  }
  
  private void init(){
    isEmailOnlyContact = isTargetList = false;
    selectedContactsMap = new Map<ID, ContactWrapper>();
    result = targetListId = '';
    action = 'next';
    listContacts = new List<ContactWrapper>();
    pageIndexList = new Integer[3];
    userTargetList = null;
    contactCapsuleToRemove = '';
    resultNotFound = false;
    matchWithExistingContact = false;
    initNewContact();
    isSearchNotProper = false;
  }
  public void setController(){
    listContacts = new List<ContactWrapper>();
    pageIndexList = new Integer[3];
    resultNotFound = false;
    selectedContactsMap = new Map<ID, ContactWrapper>();
    for(Target_List__c targetList : [Select id,iiCampaign__c,iiCampaign__r.Contacts_to_Call_Tab_Text__c,
                                    iiCampaign__r.Email_only_Contacts_Tab_Text__c,iiCampaign__r.Allow_ad_hoc_contacts__c
                                    ,iiCampaign__r.Synch_Target_List_Member_Statuses__c
                                    FROM Target_List__c Where id =:targetListId]){
        userTargetList = targetList;
        isTargetList = true;
    }
    
    emailExclusionMessage ='Account restricted from receiving automated emails.  If you wish to call this contact anyway,'+
    ' please add him/her to your ' + userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c + ' list instead of '+
         userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c+' list.';
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
    
  public void resetController(){
    init();
    conList = null;
  }
  
  private void updateCurrentPage(){
     
      currentPage = conList.getPageNumber();
      listContacts.clear();
      Set<Id> setOfContactIds = new Set<Id>();
      Set<Id> setOfAccounts = new Set<Id>();
      Set<Id> setOfAccountsExcluded = new Set<Id>();
      system.debug('______________updateCurrentPage _____________________________');
      for (GPSContact__c c : (List<GPSContact__c>)conlist.getRecords()){        
         setOfContactIds.add(c.Id);
          if(selectedContactsMap != null && selectedContactsMap.containsKey(c.Id)) {
            listContacts.add(new ContactWrapper(c,true) );
          }else{
            listContacts.add(new ContactWrapper(c) );
          }     
          setOfAccounts.add(c.GPSAccount__r.id);
      }
      
      Set<String> setExclusionFilter = new Set<String>();
      Set<String> setEmailExcludedAccounts = new Set<String>();
      
      setExclusionFilter.add('Exclude from Campaign'); //Default Filter      
      if(isEmailOnlyContact == true){
         setExclusionFilter.add('Contacts do not get email'); // Only for Email Exclusion
      }
      
      //11/08/2010 Parth Tamhaney :Fetch Exclusions related to this Campaign and Accounts of Contacts    
      for(Exclusion__c excl : [Select Id,GPSAccount__c,Exclusion__c
                                              From Exclusion__c t
                                              Where GPSAccount__c in : setOfAccounts
                                              AND iiCampaign__c =: userTargetList.iiCampaign__c 
                                              AND Exclusion__c  IN : setExclusionFilter]){
                                                
        
            setOfAccountsExcluded.add(excl.GPSAccount__c);
            if(isEmailOnlyContact == true && excl.Exclusion__c == 'Contacts do not get email'){
                setEmailExcludedAccounts.add(excl.GPSAccount__c);// Only for Email Exclusion
            }
      }
      
       system.debug('---------setOfContactIds'+setOfContactIds); 
      Map<Id,Set<String>> contactWithSalesPerson = new Map<Id,Set<String>>();    
      for(Target_List_Member__c listMember : [Select t.removed_reason__c ,t.Target_List__r.User__r.Name, Target_List__r.Preferred_User__c, t.GPSContact__c
                                              From Target_List_Member__c t
                                              Where (t.removed_reason__c = null or t.removed_reason__c ='Email Only')  
                                              AND Target_List__r.iiCampaign__c =: userTargetList.iiCampaign__c
                                              AND GPSContact__c IN :setOfContactIds ]){
                        system.debug('---------listMember.Contact__c'+listMember.GPSContact__c);
        if(contactWithSalesPerson.containsKey(listMember.GPSContact__c)){
            Set<String> setSalesPersons = contactWithSalesPerson.get(listMember.GPSContact__c);
            setSalesPersons.add(listMember.Target_List__r.Preferred_User__c + (listMember.removed_reason__c == null ? ' (Call)' : ' (Email)'));
            contactWithSalesPerson.put(listMember.GPSContact__c, setSalesPersons);
        }else{
            contactWithSalesPerson.put(listMember.GPSContact__c, new Set<String>{listMember.Target_List__r.Preferred_User__c + (listMember.removed_reason__c == null ? ' (Call)' : ' (Email)')});
        }
      }
      
      if(contactWithSalesPerson.size() > 0 || setOfAccountsExcluded.size()>0 ){
        for (ContactWrapper conWrapper : listContacts){         
          if(contactWithSalesPerson.containsKey(conWrapper.con.id)){
             conWrapper.salesPersonsList = contactWithSalesPerson.get(conWrapper.con.id); 
          }
          //11/08/2010 PartT : If the Contact needs to be excluded, Set isAvailable=false
           if(setOfAccountsExcluded.contains(conWrapper.con.GPSAccount__r.Id)){
             conWrapper.isAvailable = false; 
             if(isEmailOnlyContact == true && setEmailExcludedAccounts.contains(conWrapper.con.GPSAccount__r.Id)){
                conWrapper.isExcludeFromEmailOnly = true; // Only for Email Exclusion
            }
          }
        }
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
  
  public PageReference doSearch(){
    try{ 
    isSearchNotProper = false;  
    syncPageToSelectedContactsMap();
    listContacts = new List<ContactWrapper>();
    action = 'next';
    pageIndexList = new Integer[3];
   // selectedContactsMap = new Map<ID, ContactWrapper>();
    String soql;
    Integer queryLimit= (Test.isRunningTest()? 50 : 2000 );
      resultNotFound = true;
      matchWithExistingContact = false;
      initNewContact();   
     
      if(searchText.length() >= 2){
         String searchInNameField = '';
        //11/09/10 : Chetan Garg : Do not repalce '
        //Set<String> setOfSearchTexts = new Set<String>();
        for(String splited : searchText.split(' ')){
            if(splited != ''){
                //setOfSearchTexts.add(splited);
                searchInNameField += (searchInNameField == '' ? '' : ' AND ' ) + ' ( II_Company__c like \'%' + splited.replace('\'','\\\'') + '%\' OR GPSAccount__r.Name like \'%' + splited.replace('\'','\\\'') + '%\' OR  Name like \'%' + splited.replace('\'','\\\'') + '%\' ) ';
            }
        }
        
        searchInNameField = (searchInNameField == '' ? '' : 'AND ('+ searchInNameField + ')');
          
        searchText =  + searchText.replace(' ','* AND ')  +'*';//replace('\'','\\\'').
          
         
            
           system.debug('___________________searchText________________' + searchText);
  
          /*
          List<List<Sobject>> searchList = [FIND :searchText  //OR :searchText1 OR :searchText2 OR : searchText3
                                            IN ALL FIELDS  
                                            RETURNING 
                                                //Account (id,Name),
                                                Contact (id, name,Account.Name,RecordType.Name,ii_Company__c ,Account.Id,FirstName,LastName
                                                         WHERE Active_Flag__c = true
                                                         AND RecordType.Name  IN : recordTypeNames
                                                        
                                                         And ( Account.Name like :accountText
                                                         OR firstname like : nameText
                                                         OR lastname like : nameText
                                                         OR name like : nameText
                                                         )
                                                         
                                                         Order by Account.Name , LastName)
                                           ];
                                           
         */
         
         String searchQuery = 'FIND :searchText  ' +
                                            + ' IN ALL FIELDS '   
                                            + ' RETURNING '
                                            + '     GPSContact__c (id, name,GPSAccount__r.Name,RecordType.Name,II_Company__c ,GPSAccount__r.Id,FirstName__c,LastName__c '
                                            +'           WHERE Active_Flag__c = true '
                                            +'           AND RecordType.Name  IN : recordTypeNames ' + searchInNameField
                                            +'           Order by GPSAccount__r.Name , LastName__c) ';
         
         system.debug('___________________searchQuery________________' + searchQuery);
         List<List<Sobject>> searchList  = Search.query(searchQuery);
         
                                               
         List<GPSContact__c> searchResult = (List<GPSContact__c>)searchList[0];
         
         
          System.debug('searchResult :-' + searchResult);
          
         if( searchResult.size() < 200 ){
            isSearchNotProper = true;
         }
       
            System.debug('searchList________ :-' + searchList.size());                             
         if(searchResult.size() > 0){
            resultNotFound = false;
            System.debug('Searchhhhhhhhhhhh :-' + searchResult.size());
            System.debug('Searchhhhhhhhhhhhttttttttttttt :-' + searchResult);
         } 
      
         system.debug('___________________doSearch________________' + soql);
         conList = new ApexPages.StandardSetController(searchResult);
          //conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));    
          //conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
         updateCurrentPage(); 
      }
    }catch(Exception exp){
            System.debug('________________CAUGHT EXCEPTION IN MyLsitCotnactcontroller doSearch _____________________');
            //Util.HANDLE_ERROR(exp);
            ApexPages.addMessages(exp);
    }
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
            if(conList ==null) return false;
          return conList.getHasNext();
        }
        set;
    }
    
     public Boolean hasPrevious {
        get {
            if(conList ==null) return false;
            return conList.getHasPrevious();
        }
        set;
    }
     public Boolean isFirst{
        get{
            if(conList ==null) return false;
           return (conList.getPageNumber() != 1);
        }
        set;
    }
    
     public Boolean isLast{
        get {
            if(conList ==null) return false;
           return (conList.getPageNumber()!= (conList.getResultSize()/conList.getPageSize()));
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
    
 /*private void syncPageToSelectedContactsMap() {
        if(listContacts != null ) {
            for(ContactWrapper cw : listContacts) {
                if(cw.isSelected) {
                    selectedContactsMap.put(cw.con.Id, cw);
                }else {
                    if(selectedContactsMap.containsKey(cw.con.Id)) {
                        selectedContactsMap.remove(cw.con.Id);
                    }
                }
            }
        }
  }*/
  private void syncPageToSelectedContactsMap() {
        if(contactCapsuleToRemove != ''){
            for(string conId : contactCapsuleToRemove.split(',')){
                if(conId != ''){
                  selectedContactsMap.remove(conId);    
                }
            }
        }
        
        contactCapsuleToRemove = '';
        if(listContacts != null ) {
            for(ContactWrapper cw : listContacts) {
                if(cw.isSelected) {
                    if(!selectedContactsMap.containsKey(cw.con.Id)){
                        selectedContactsMap.put(cw.con.Id, cw);
                    }   
                }else {
                    if(selectedContactsMap.containsKey(cw.con.Id)) {
                        selectedContactsMap.remove(cw.con.Id);
                    }
                }
            }
        }
    }
    
  public PageReference addCon(){
        result ='';
        isContactAdded = false;
        syncPageToSelectedContactsMap();
        Set<Id> setOfselectedCon = new Set<Id>();
        
        for (ContactWrapper conWarp : selectedContactsMap.values() ) {
            if (conWarp.isSelected) {
                setOfselectedCon.add(conWarp.con.id);
            }
        }
        
        system.debug('#setOfselectedCon' + setOfselectedCon);
        Set<String> setOfalreadyAdded = new Set<String>();
        Set<String> setOtherListContacts = new Set<String>();
        List<Target_List_Member__c> listOfMemberToUpsert = new List<Target_List_Member__c>();
        
        for(Target_List_Member__c listMember :  [Select id,Removed_Reason__c,t.GPSContact__c ,t.GPSContact__r.Name,Eligible_for_email__c,
                                                Not_II_Friendly__c
                                                 From Target_List_Member__c t
                                                 Where t.GPSContact__c IN :setOfselectedCon  AND 
                                                 t.Target_List__c=:targetListId]){
                system.debug('#listMember -->' + listMember );
                /**                               
                if(listMember.Removed_Reason__c == null){
                    setOfalreadyAdded.add(listMember.GPSContact__r.Name);
                }else{
                    listMember.Removed_Reason__c =  null;
                    listOfMemberToUpsert.add(listMember);
                }
                **/
                //IF Contact is called for Email only
                if(isEmailOnlyContact == true){
                  if(listMember.Removed_Reason__c == 'Email Only'){
                    setOfalreadyAdded.add(listMember.GPSContact__r.Name);
                  }else{
                    if(listMember.Removed_Reason__c == null){
                      setOtherListContacts.add(listMember.GPSContact__r.Name);// + ' - ( Call List )');    
                    }
                    listMember.Removed_Reason__c =  'Email Only';
                    //11/09/10; Chetan Garg; if a user adds that contact AFTER a version has been marked as non-II Friendly, that added contact should still have their setting Email flag defaulted to NO
                    if(listMember.Not_II_Friendly__c == true){
                      listMember.Eligible_for_email__c = false;
                    }
                    listOfMemberToUpsert.add(listMember);
                  } 
                }else{
                  //IF Contact is called for Client To Call
                  if(listMember.Removed_Reason__c == null){
                    setOfalreadyAdded.add(listMember.GPSContact__r.Name);
                  }else{
                    if(listMember.Removed_Reason__c == 'Email Only'){
                      setOtherListContacts.add(listMember.GPSContact__r.Name) ;//+ ' - ( Email Only )');   
                    }
                    listMember.Removed_Reason__c =  null;
                    
                    //11/09/10; Chetan Garg; if a user adds that contact AFTER a version has been marked as non-II Friendly, that added contact should still have their setting Email flag defaulted to NO
                    if(listMember.Not_II_Friendly__c == true){
                      listMember.Eligible_for_email__c = false;
                    }
                    
                    listOfMemberToUpsert.add(listMember);
                  } 
                }
                
                setOfselectedCon.remove(listMember.GPSContact__c);
            }
                                                 
        if(setOfselectedCon.size() > 0) {
              List<Target_List__c> lsttarget = [Select id,iiCampaign__c,iiCampaign__r.Synch_Target_List_Member_Statuses__c   from Target_List__c where id =: targetListId limit 1];
            system.debug('#lsttarget -->' + lsttarget );
            
            if(lsttarget.size() == 0 ){
                result ='List not found';
                return null;
            } 
            
            //11/8/2010 ParthT: Set Not II Friendly 
            //Retrieve existing Non friendly List Member entries for contacts being added
            Map<Id,Target_List_Member__c> MapOfNotIIfriendlyContacts = new Map<Id,Target_List_Member__c> ();
            Map<Id,Target_List_Member__c> MapOfContactsForSynch = new Map<Id,Target_List_Member__c> ();
            List<Target_List_Member__c> otherListMemberForContact ;
            //If This Campaign has TLM synch
            if(lsttarget[0].iiCampaign__r.Synch_Target_List_Member_Statuses__c == true){
                otherListMemberForContact = [Select id,t.GPSContact__c ,t.GPSContact__r.Name,
                                             Not_II_Friendly__c, User_Who_Confirmed_Non_II_Friendly__c,
                                             User_Who_Confirmed_Non_II_Friendly__r.firstName,User_Who_Confirmed_Non_II_Friendly__r.Preferred_Name__c,User_Who_Confirmed_Non_II_Friendly__r.LastName,
                                             Called_about_II__c,User_who_left_Voicemail_del__c,Contact_would_not_reveal_vote__c,
                                             User_who_confirmed_Vote_Last__c,user_who_confirmed_ballot_received__c,
                                             Ballot_Received__c,Contact_has_been_called__c,User_Who_Called_the_Contact__c,
                                             Voted_in_II_Campaign__c,
                                             Blanket_Voter__c,Target_List_Status__c ,Call_Notes__c
                                             From Target_List_Member__c t
                                             Where t.GPSContact__c IN :setOfselectedCon  
                                             AND Target_List__r.iiCampaign__c = :  lsttarget[0].iiCampaign__c ];
                                             //And Not_II_Friendly__c = true and User_Who_Confirmed_Non_II_Friendly__c <> null];
            }else{
              //ELSE If This Campaign does not has TLM synch
                otherListMemberForContact = [Select id,t.GPSContact__c ,t.GPSContact__r.Name,
                                             Not_II_Friendly__c,Call_Notes__c, User_Who_Confirmed_Non_II_Friendly__c,User_Who_Confirmed_Non_II_Friendly__r.firstName,User_Who_Confirmed_Non_II_Friendly__r.Preferred_Name__c,User_Who_Confirmed_Non_II_Friendly__r.LastName  
                                             From Target_List_Member__c t
                                             Where t.GPSContact__c IN :setOfselectedCon  
                                             AND Target_List__r.iiCampaign__c = :  lsttarget[0].iiCampaign__c 
                                             and Not_II_Friendly__c = true and User_Who_Confirmed_Non_II_Friendly__c <> null];
            }
             for(Target_List_Member__c listMember :  otherListMemberForContact){                                                    
                System.debug('______________________listMember_________' + listMember.GPSContact__r.Name);
                System.debug('______________________listMember.Not_II_Friendly__c_________' + listMember.Not_II_Friendly__c);
                System.debug('______________________listMember.User_Who_Confirmed_Non_II_Friendly__r.firstName_________' + listMember.User_Who_Confirmed_Non_II_Friendly__r.firstName);
                if(listMember.Not_II_Friendly__c == true && listMember.User_Who_Confirmed_Non_II_Friendly__c != null){
                  MapOfNotIIfriendlyContacts.put(listMember.GPSContact__c,listMember); 
                }
                //If This Campaign has TLM synch
                if(lsttarget[0].iiCampaign__r.Synch_Target_List_Member_Statuses__c == true){
                    MapOfContactsForSynch.put(listMember.GPSContact__c,listMember);
                }
             }
                
          //11/09/2010 Parth Tamhaney :Fetch Exclusions related to this Campaign and Accounts of Contacts   
            
          Map<Id,GPSContact__c> mapContacts = new Map<Id,GPSContact__c>([Select id,GPSAccount__r.id from GPSContact__c where id in :setOfselectedCon]);
          
          Set<id> setOfAccountIds = new Set<id>();
           Set<id> setOfAccountsExcluded = new Set<id>();
          for(GPSContact__c con : mapContacts.values()){
            setOfAccountIds.add(con.GPSAccount__r.id);
          }
             
          for(Exclusion__c excl : [Select Id,GPSAccount__c
                                                  From Exclusion__c t
                                                  Where GPSAccount__c in :setOfAccountIds
                                                  AND iiCampaign__c =: userTargetList.iiCampaign__c 
                                                  AND Exclusion__c = 'Contacts do not get email']){
                                                    
            
                setOfAccountsExcluded.add(excl.GPSAccount__c);
          }
                      
            for(Id conId : setOfselectedCon){
                 Target_List_Member__c newListMember= new Target_List_Member__c();
                 newListMember.Target_List__c = lsttarget[0].id;
                 newListMember.Target_List_Status__c ='Call & Confirm vote';
                 newListMember.GPSContact__c = conId;
                 if(isEmailOnlyContact == true){
                   newListMember.Removed_Reason__c =  'Email Only';
                 }
                 //11/8/2010 ParthT: Set Not II friendly
                 //11/09/2010 Parth Tamhaney :if The contact exclusion is 'Contacts do not get email' set Eligible_for_email__c = false
                 newListMember.Eligible_for_email__c = true;
                 //Check if the contact is already set as non II Friendly in come other list
                 if(MapOfNotIIfriendlyContacts.containsKey(conId)){
                    Target_List_Member__c notFriendlyListMember = MapOfNotIIfriendlyContacts.get(conId);
                    newListMember.Not_II_Friendly__c = true;
                    //11/09/10; Chetan Garg; if a user adds that contact AFTER a version has been marked as non-II Friendly, that added contact should still have their setting Email flag defaulted to NO
                    newListMember.Eligible_for_email__c = false;
                    newListMember.User_Who_Confirmed_Non_II_Friendly__c = notFriendlyListMember.User_Who_Confirmed_Non_II_Friendly__c;
                    
                 }
                 
                 if(setOfAccountsExcluded.contains(mapContacts.get(conId).GPSAccount__r.Id)){
                    newListMember.Eligible_for_email__c = false;
                 }
                 
                 //If This Campaign has TLM synch then set Status of the contact from exisitnf target list member for the contact
                 if(lsttarget[0].iiCampaign__r.Synch_Target_List_Member_Statuses__c == true 
                            && MapOfContactsForSynch.containsKey(conId)){
                    //MapOfContactsForSynch.put(listMember.Contact__c,listMember);
                    Target_List_Member__c existinglistMember = MapOfContactsForSynch.get(conId);
                    newListMember.Called_about_II__c = existinglistMember.Called_about_II__c;
                    newListMember.User_who_left_Voicemail_del__c = existinglistMember.User_who_left_Voicemail_del__c;   
                    newListMember.Contact_would_not_reveal_vote__c = existinglistMember.Contact_would_not_reveal_vote__c;
                    newListMember.User_who_confirmed_Vote_Last__c = existinglistMember.User_who_confirmed_Vote_Last__c;
                    newListMember.user_who_confirmed_ballot_received__c = existinglistMember.user_who_confirmed_ballot_received__c;
                    newListMember.Ballot_Received__c = existinglistMember.Ballot_Received__c;
                    newListMember.Contact_has_been_called__c = existinglistMember.Contact_has_been_called__c;
                    newListMember.User_Who_Called_the_Contact__c = existinglistMember.User_Who_Called_the_Contact__c;
                    newListMember.Not_II_Friendly__c = existinglistMember.Not_II_Friendly__c;
                    newListMember.User_Who_Confirmed_Non_II_Friendly__c = existinglistMember.User_Who_Confirmed_Non_II_Friendly__c;
                    newListMember.Voted_in_II_Campaign__c = existinglistMember.Voted_in_II_Campaign__c;
                    newListMember.Blanket_Voter__c = existinglistMember.Blanket_Voter__c;
                    newListMember.Target_List_Status__c = existinglistMember.Target_List_Status__c;
                    newListMember.Call_Notes__c = existinglistMember.Call_Notes__c;
                 }
                 listOfMemberToUpsert.add(newListMember);
                 system.debug('#newListMember-->' + newListMember);
             }
        }       
                                                         
        if(listOfMemberToUpsert.size() > 0){
            upsert listOfMemberToUpsert;
            isContactAdded = true;
        }
        
        if(setOfalreadyAdded.size() > 0){
            result += 'The following contacts are already on the list:';
            for (String conName : setOfalreadyAdded){
                    result = result + '~' + conName ;
            }
        }
        
        //Get Tab label by iiCampaign's Setting
        String clientToCallSuffix = (userTargetList.iiCampaign__c != null && userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c : 'Contacts to Call';
        String emailOnlySuffix = (userTargetList.iiCampaign__c != null && userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c : 'Email Only Contacts';
                                    
        
        if(setOtherListContacts.size() > 0){
            String msg = 'The following contacts are already in '+ emailOnlySuffix +' List and moved to '+ clientToCallSuffix; 
            if(isEmailOnlyContact){
                msg = 'The following contacts are already in '+ clientToCallSuffix +' and moved to '+ emailOnlySuffix ;
            }
            result += '~~'+msg;
            for (String conName : setOtherListContacts){
                    result = result + '~' + conName ;
            }
        }
        
        
       system.debug('#result-->' + result);
       system.debug('#listOfMemberToUpsert-->' + listOfMemberToUpsert);
       selectedContactsMap.clear();
       listContacts.clear();
      return null;
  }
  
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
  
  public GPSContact__c newContact{get;set;}
  public void createAlternateContact(){     
    syncPageToSelectedContactsMap();
    //-> checkif already exist by email address
    //-> display block of already exist contact
    //-> if not exist then create contact and add this contact to capusle
    matchWithExistingContact = false;
    GPSContact__c alredyExistCotnact;
    system.debug('newContact.Email++++++++++' + newContact.Email__c);
    for(GPSContact__c con : [Select id,Name,GPSAccount__r.Name,II_Company__c,GPSAccount__c,Email__c FROM GPSContact__c where Email__c =:newContact.Email__c limit 1]){
     alredyExistCotnact = con;
    }  
    system.debug('alredyExistCotnact~~~~~' + alredyExistCotnact);
    if(alredyExistCotnact != null){
      matchWithExistingContact = true;
      newContact = alredyExistCotnact;    
      return;
    }else{
    	try{
    		//Create contact
	        upsert newContact;
	        system.debug('___________newContact_______________' + newContact.Name);
	        //This query is used to populate Name of Contact        
	        GPSContact__c insertedContact = [Select id , Name ,GPSAccount__r.Name ,II_Company__c, GPSAccount__c from GPSContact__c where id =:newContact.id];
	        system.debug('___________insertedContact_______________' + insertedContact.Name);
	        selectedContactsMap.put(insertedContact.Id,new  ContactWrapper(insertedContact,true));
    	}catch(Exception e){
    		ApexPages.addMessages(e);
    	}
       initNewContact();
        
    }
    resultNotFound = false;
  }
  
  public void addExistingContact(){
     syncPageToSelectedContactsMap();
     GPSContact__c insertedContact = newContact.clone();
     selectedContactsMap.put(insertedContact.Id,new  ContactWrapper(insertedContact,true));
     initNewContact();
     resultNotFound = false;
     matchWithExistingContact = false;
  }
  
  private void initNewContact(){
    newContact = new GPSContact__c(RecordTypeId = iiCampaignContactRecord.id );
    //Account = new Account(id='001Q000000C1G63', Name = 'GE Energy Financial Services' ));
    newContact.Trading_Name_ID__c = '0';
    newContact.TN_Contact_Key__c = '0';
    newContact.CIS_Contact_ID__c = '0';
  }
  
    public class ContactWrapper {
        public GPSContact__c con{get;set;}
        public Boolean isSelected {get;set;}
        public Set<String> salesPersonsList {get;set;}
        public Boolean isAvailable {get;set;}  //11/08/2010 PartT: For Exclusions
          public Boolean isExcludeFromEmailOnly {get;set;} //11/23/2010 ChetanG: For Exclusions
        public String salesPersons {
            get{
                String result = '';
                for(String str : salesPersonsList){
                    result += (result == '') ? str : ', ' + str; 
                }
                return result;
            }
        } 
        public ContactWrapper(GPSContact__c con){
            this.con = con;
            this.isSelected = false;
            this.salesPersonsList = new Set<String>();
            this.isAvailable = true;
            this.isExcludeFromEmailOnly = false;
        }
        public ContactWrapper(GPSContact__c con,Boolean isSelected){
            this.con = con;
            this.isSelected = isSelected;
            this.salesPersonsList = new Set<String>();
            this.isAvailable = false;
            this.isExcludeFromEmailOnly = false;
        }
    }   
    
}