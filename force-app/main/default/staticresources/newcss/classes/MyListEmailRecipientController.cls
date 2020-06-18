/***********************************************************************************
Name        : MyListEmailRecipientController 
Author      : Appirio Offshore (Chetan Garg)
Date        : March 30, 2010
Description : Controller class for MyListEmailRecipient
Last Modified: 25 Aug 2010 Appirio Offshore (Chetan Garg) [PR-05946]
               06 Sept 2010 Appirio Offshore (Parth Tamhaney)[PR-06083] 
               07 Sept 2010 Appirio Offshore (Parth Tamhaney) [Changes to remove member - added removeMembersFromList()]
               14 Sep 2010   Chetan Garg     Changes for 
                                               PR-06202: Default Sort Order - Account Asc, Contact.firstName asc    
                                               PR-06192: Make columns sortable on the myiilist page
               21 Sep 2010   Chetan Garg     Refactored code and remove unused methods
                                             (PR-06273): Performance on switching tabs to contacts to call and Email only contacts.      
         24 Sep 2010   Chetan Garg     Make Chnages in wrapper class for Additional contact list.[PR-06325].
         28 Oct 2010   Kapil Choudhary Made a function "updateReassignedViewedByUser" for [PR-06854].   
         12/31/2010    Chetan Garg    PR-07703 - Morgan Stanley - II - Pagination requirement refinement with use cases   
         01/05/2011   Chetan Garg    PR-07767 - A few issues with Key Milestones and Campaign Resources & wireframe
                              PR-07770 - Move this code from hotfix to GPSQA7 (other owner actions)
                              PR-07768 - Exclude ANY document from the resources = "important_news"
                              PR-07771 - Move this code from hotfix to GPSQA7 (important_news)      
************************************************************************************/
public class MyListEmailRecipientController {
    //Hold List of Target members of Logged-in User's Target List
    public List<memberWrapper> listOfMyTarget {get;set;}
    public String selectedContactId {get;set;}  
    public String selectedId {get;set;} 
    public String selectedLang {get;set;}    
    public String reason {get;set;}
    public Target_List__c userTargetList {get;set;}    
    //public ApexPages.StandardSetController conList{get;set;}
    //public List<Target_List_Member__c> lstTargetListMembers{get;set;}
    //public List<Integer> pageIndexList{ get; set;}    
    public Integer currentPage{ get; set;}
    //public String action{get;set;}
    public String sortOrder {get; set;} // '1'-'ASC'; '2'-'DESC'
    public String sortOn {get; set;} // Contact ,Account
    
    private Map<String,String> SORTING_ORDER_MAP = new Map<String,String>{'1'=>'ASC','2'=>'DESC'};
    private Map<String,String> SORT_BY_MAP = new Map<String,String>{'Default' => 'GPSContact__r.GPSAccount__r.Name, GPSContact__r.FirstName__c,GPSContact__r.LastName__c ',
                                                              'Contact'=>'GPSContact__r.Name ',
                                                              'Account'=>'GPSContact__r.GPSAccount__r.Name ',
                                                              'Lang' => 'GPSContact__r.II_Language__c'};
                                                              
    
    public Integer unviewedCount {get;set;}
   
    //15 december 2010
    public Integer RECORD_PAGE_SIZE {get;set;}
    public ApexPages.StandardSetController listTargetMemberSet{get;set;}
    public Integer CurrentPageNumber {get;set;}
    public String currentpagesize {get;set;}
    public List<Target_List_Member__c> listCurrentPageTargetListMember;
    //public List<Integer> pageIndexNumber {get;set;} 24-Jan-2011
    public String selectedAnalyst {get;set;}
    public List<String> pageIndexNumber {get;set;}
    public List<String> ShowRecordsOnPage {get;set;}
    public static Integer MAX_LIMIT = 9999; 
    
    public MyListEmailRecipientController(){
        listOfMyTarget = new List<memberWrapper>();
        userTargetList = new Target_List__c();
        sortOn = 'Default';
        sortOrder = '1';
        unviewedCount = 0;
        
        //15 Dec 2010
        listTargetMemberSet = null;
        RECORD_PAGE_SIZE = 25;
        currentpagesize = '50';
        CurrentPageNumber =0;
        listCurrentPageTargetListMember = new List<Target_List_Member__c>(); 
        
        //pageIndexNumber = new List<Integer>(); 24-Jan-2011
        pageIndexNumber = new List<String>();
        ShowRecordsOnPage = new String[]{'25','50','100'};
        currentpagesize = ShowRecordsOnPage[0];
    }
    
     // Remove Contacts : update Remove Reason in the Target List Member 
    public Pagereference updateReassignedViewedByUser(){
         List<Target_List_Member__c> memberToUpdate = new List<Target_List_Member__c>();
        for(memberWrapper member :listOfMyTarget){  
            if(!member.listMember.Viewed_by_User__c)           
                 member.listMember.Viewed_by_User__c= true;
                memberToUpdate.add( member.listMember);
        }
        if(memberToUpdate.size()>0){
            update memberToUpdate;        
         }
         unviewedCount = 0;
        //GetMemberList();
        return null;
    }
    public void sortTargetListMembers(){
      listOfMyTarget = new  List<memberWrapper>();
      GetMemberList();
    }
    
    public void getEmailOnlyTargetMembers(){
        sortOn = 'Default';
        sortOrder = '1';
        listOfMyTarget = new  List<memberWrapper>();
        //Chetan Garg: 12/15/2010 ; If TARGET_LIST__c.Sends_Email__c = FALSE , DO NOT LOAD EMAIL ONLY LIST (PR-07489)
        if(!(userTargetList.iiCampaign__r.Show_Email_Only_Page__c == false || userTargetList.Sends_Email__c == 'No') ){
            GetMemberList();
        }
        
    }
    ////t.Removed_Reason__c = 'Email Only' and
    public void GetMemberList(){
        unviewedCount = 0;
        system.debug('_____________SortOn___________' + sortOn);
        system.debug('_____________SortOn___________' + SORT_BY_MAP.get(sortOn));
        
        system.debug('_____________SortOrder___________' + sortOrder);
        system.debug('_____________SortOrder___________' + SORTING_ORDER_MAP.get(sortOrder));
        
        String whereCondition = ' t.Removed_Reason__c = \'Email Only\' and t.Target_List__c = \''+ userTargetList.id +'\'';
        Set<ID> setOfContactIds = new Set<ID>();
        if(selectedAnalyst != null && selectedAnalyst != ''){
            for(Voter_Recommendation__c voter : [Select v.GPSContact__c 
                                                 From Voter_Recommendation__c v
                                                 where v.Candidate_Information__c = : selectedAnalyst and
                                                 v.Use_Recommendations_in_Campaign__c <> 'No' and
                                                 v.Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                 and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ]){
                setOfContactIds.add(voter.GPSContact__c);                                  
             }
             whereCondition += ' AND GPSContact__c IN :setOfContactIds ';  
        } 
        String soql ='Select id, t.GPSContact__r.Name,t.GPSContact__r.GPSAccount__c, t.Viewed_by_User__c,t.GPSContact__c ,t.GPSContact__r.GPSAccount__r.Name,t.GPSContact__r.II_Language__c, t.Reassigned_By__r.Name, t.Reassigned_By__r.Preferred_Name__c, t.Reassigned_By__r.LastName, t.Reassigned_By__c  ' +
                        ' ,t.GPSContact__r.II_Company__c, GPSContact__r.RecordType.Name ' +  
                        '  From Target_List_Member__c t Where ' + whereCondition +
                        //' t.Removed_Reason__c = \'Email Only\' and t.Target_List__c = \''+ userTargetList.id +'\'  order by '+ SORT_BY_MAP.get(sortOn) + ' ' + SORTING_ORDER_MAP.get(sortOrder)  + ' limit 1000';
                        ' order by '+ SORT_BY_MAP.get(sortOn) + ' ' + SORTING_ORDER_MAP.get(sortOrder)  + ' limit 1000';
        system.debug('#Soql->' + soql);
        
               //15 Dec 2010
               Database.Querylocator  dbqueryLocator = Database.getQueryLocator(soql);
             listTargetMemberSet = new ApexPages.StandardSetController(dbqueryLocator);
             system.debug('___________listTargetMemberSet.getResultSize()()():- '+listTargetMemberSet.getResultSize());
             if(listTargetMemberSet != null)
                {
                    setpagesize();
                    setcurrentpageno(CurrentPageNumber);
                }
                if(userTargetList.Current_Page_Size__c == null){
                   userTargetList.Current_Page_Size__c = 'Show 50';
                }  
                
                    if(userTargetList.Current_Page_Size__c == 'Show 25' ){
                         RECORD_PAGE_SIZE = 25 ;
                          currentpagesize = '25';
                      }else if(userTargetList.Current_Page_Size__c == 'Show 50' ){
                         RECORD_PAGE_SIZE = 50 ;
                          currentpagesize = '50';
                      }else if(userTargetList.Current_Page_Size__c == 'Show 100'){
                         RECORD_PAGE_SIZE = 100;
                          currentpagesize = '100';
                      }
                      
             listTargetMemberSet.setPageSize(RECORD_PAGE_SIZE);
             
             listTargetMemberSet.setPageNumber(CurrentPageNumber);
             updateContactsList();
             buildWrapperMembers();
        //conList = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        //lstTargetListMembers = ;
         
          
        
    }
    
    public void updateContactsList()
    {
        listCurrentPageTargetListMember = (List<Target_List_Member__c>)listTargetMemberSet.getRecords();
        CurrentPageNumber = listTargetMemberSet.getPageNumber();
        //24-Jan-2011
        /*pageIndexNumber = new List<integer>(); 
        
        for(Integer index = 0 ; index < TotalPage; index++){
            pageIndexNumber.add(index+1);
        }*/
        pageIndexNumber = new List<String>();
        for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
            //pageIndexNumber.add(index+1); 19-Jan-2011
           
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listTargetMemberSet.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
    }
    
    public void updateNewPagesize()
     {
          integer oldpageno=1;
          setpagesize();
          listTargetMemberSet.setPageSize(RECORD_PAGE_SIZE);
          
          listTargetMemberSet.setPageNumber(oldpageno);
          pageIndexNumber.clear();
                /*for(Integer index = 0 ; index < TotalPage; index++)
                 {
                pageIndexNumber.add(index+1);
           }*/ // 24-Jan-2011
           
           for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
            //pageIndexNumber.add(index+1); 19-Jan-2011
           
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listTargetMemberSet.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
         
          //Update Target List page Size
           if(RECORD_PAGE_SIZE == 50 ){
             userTargetList.Current_Page_Size__c = 'Show 50';
           }else if(RECORD_PAGE_SIZE == 100){
             userTargetList.Current_Page_Size__c = 'Show 100';
           }if(RECORD_PAGE_SIZE == 25 ){
             userTargetList.Current_Page_Size__c = 'Show 25';
           } 
           
           update userTargetList;
           updateContactsList();
           buildWrapperMembers();
           CurrentPageNumber =oldpageno;
    }
    
    //Build Wrapper Members For Current Page.
    public void buildWrapperMembers(){
        Map<Id,memberWrapper> mapListcontacts = new Map<Id,memberWrapper>();
        listOfMyTarget = new List<memberWrapper>();
        for(Target_List_Member__c targetMember : listCurrentPageTargetListMember){
            memberWrapper emailonlymember = new memberWrapper(false,targetMember);
            listOfMyTarget.add(emailonlymember);
            mapListcontacts.put(targetMember.GPSContact__c, emailonlymember);
            
          if(!targetMember.Viewed_by_User__c){
              unviewedCount++;
          }

        }     
       
       
        //Get Top 3 voterRecommendations
         Map<id,GPSContact__c> mapContactVoterRecommendations = new Map<id,GPSContact__c>([ Select id, 
                                                                                        (Select Candidate_Name__c From Voter_Recommendations__r 
                                                                                        where Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                                                        and Use_Recommendations_in_Campaign__c <> 'No'
                                                                                        and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) 
                                                                                         order by Candidate_Name__c  limit 4) 
                                                                                From GPSContact__c c
                                                                                where id in :mapListcontacts.keySet()]);
        for(MemberWrapper wrapper : listOfMyTarget){
          GPSContact__c con = mapContactVoterRecommendations.get(wrapper.listMember.GPSContact__c);
          if(con <> null){
            wrapper.voterRecommendations = con.Voter_Recommendations__r;
            if(wrapper.voterRecommendations.size()> 3){
                wrapper.showMore = true;
                wrapper.voterRecommendations.remove(3);
             }
          }
        }
        //Get Tab label by iiCampaign's Setting
        String clientToCallSuffix = (userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c : 'Contacts to Call';
        String emailOnlySuffix = (userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c : 'Email Only Contacts';
                                      
        Map<Id,List<String>> mapOfAdditionalMembers = new Map<Id,List<String>>();
        //12/20/10 Chetan Garg; PR-07536 - AP: Show actions of other Target List Member owners
        for(Target_List_Member__c member : [select GPSContact__c,removed_reason__c ,Target_List__r.User__r.Name,Target_List__r.User__c,Target_List__r.Preferred_User__c,User_who_left_Voicemail_del__c
                                            ,user_who_confirmed_ballot_received__c,User_Who_Called_the_Contact__c,User_who_confirmed_Vote_Last__c
                                            from Target_List_Member__c 
                                            where Target_List__r.iiCampaign__r.Id =:userTargetList.iiCampaign__c 
                                            and Target_List__c <>: userTargetList.id 
                                            and (removed_reason__c = null or removed_reason__c ='Email Only') 
                                            and GPSContact__c in :mapListcontacts.keyset() limit :MAX_LIMIT]){
                String listType = (member.removed_reason__c == null ? clientToCallSuffix : emailOnlySuffix);                                                                    
                String memberName = member.Target_List__r.Preferred_User__c + '<span class="gray"> - '  + listType + '</span>';                                                                      
                  List<String> setmembers = new List<String>();                                                                                 
                if(mapOfAdditionalMembers.containsKey(member.GPSContact__c)){
                    setmembers = mapOfAdditionalMembers.get(member.GPSContact__c);
                }                                                           
               
                
                //12/20/10 Chetan Garg; PR-07536 - AP: Show actions of other Target List Member owners
                if(member.Target_List__r.User__c == member.User_who_left_Voicemail_del__c){
                  setmembers.add('<span class="additional-detail">Warm-up Call</span>');    
                }
                
                if(member.Target_List__r.User__c == member.user_who_confirmed_ballot_received__c){
                  memberName +='<br/><span class="additional-detail">Ballot Received</span>'; 
                }
                
                if(member.Target_List__r.User__c == member.User_Who_Called_the_Contact__c){
                  memberName +='<br/><span class="additional-detail">Called Contact</span>';  
                }
                
                if(member.Target_List__r.User__c == member.User_who_confirmed_Vote_Last__c){
                  memberName +='<br/><span class="additional-detail">Confirmed vote</span>';  
                }
                 setmembers.add(memberName);
                mapOfAdditionalMembers.put(member.GPSContact__c , setmembers);
          }
          
          
           for(Id conId : mapOfAdditionalMembers.keySet()){
             mapListcontacts.get(conId).additionaldetail = mapOfAdditionalMembers.get(conId);
           }
    }
    
    public void setcurrentpageno(integer pageno)
     {
         if(pageno==0)
           {
            pageno =1;
           }
         CurrentPageNumber =pageno;
     }
    public void setpagesize()
    {
        if(currentpagesize == '25')
          {
            RECORD_PAGE_SIZE = 25;
          }
         else if(currentpagesize == '50')
          {
            RECORD_PAGE_SIZE = 50;
          }
         else if(currentpagesize == '100')
          {
            RECORD_PAGE_SIZE = 100;
          }/*
        else
          {
            RECORD_PAGE_SIZE = listTargetMemberSet.getResultSize();
            
          }*/
          
        
    }
    
   public Integer gotoPageNumber {get;set;}
   public String  gotoPageRange  {get;set;}
    public void goToPage(){
        system.debug('________________next mehtod start__________');
        //24-Jan-2011
        integer currentpagesizeint = double.valueOf(currentpagesize).intValue(); 
        integer rangelastdigit = double.valueOf(gotoPageRange.substring(gotoPageRange.lastIndexOf('-')+1)).intValue();
        integer rangefirstdigit = double.valueOf(gotoPageRange.substring(0,gotoPageRange.lastIndexOf('-'))).intValue();
        if(rangelastdigit == listTargetMemberSet.getResultSize()){
            rangelastdigit = rangelastdigit +(currentpagesizeint-((rangelastdigit-rangefirstdigit)+1));
        }
        gotoPageNumber = (rangelastdigit)/currentpagesizeint;//24-Jan-2011
        system.debug('gotoPageNumberrrrrrrrrr'+gotoPageNumber);
        
        listTargetMemberSet.setPageNumber(gotoPageNumber);        
        updateContactsList();
        buildWrapperMembers();
        
    }
   
   public void first() {
      listTargetMemberSet.first();
      updateContactsList();
      buildWrapperMembers();
    }
    
    public void last() {
        listTargetMemberSet.last();
        updateContactsList();
        buildWrapperMembers();
    }
    public void previous() {
        listTargetMemberSet.previous();
        updateContactsList();
        buildWrapperMembers();
    }
    public void next() {
        system.debug('________________next mehtod start__________'+listTargetMemberSet);
        system.debug('________________next mehtod start__________');
        listTargetMemberSet.next();
        system.debug('________________next mehtod end__________');
        updateContactsList();
        buildWrapperMembers();
    }
    public Boolean hasNext {
        get{
          if(listTargetMemberSet == null) return false;
          return listTargetMemberSet.getHasNext();
        }
        set;
    }
    
     public Boolean hasPrevious {
        get {
            if(listTargetMemberSet == null) return false;
            return listTargetMemberSet.getHasPrevious();
        }
        set;
    }
     public Boolean isFirst{
        get{
           if(listTargetMemberSet == null) return true;
           return (listTargetMemberSet.getPageNumber() == 1);
        }
        set;
   }
    
    
   public Integer recordStartNumber{
       get{
           if(listTargetMemberSet == null) return 0;
           return ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1;
        }
   }
   
   public Integer recordEndNumber{
       get{
           if(listTargetMemberSet == null) return 0;
           if(isLast == true){
             return TotalRecords;
           }else{
             return CurrentPageNumber * RECORD_PAGE_SIZE;
           }
        }
   } 
    
    
    
    public Integer TotalPage{
        get{
            if(listTargetMemberSet == null) return 0;
            Integer resultSize = listTargetMemberSet.getResultSize();
            Integer pageSize = listTargetMemberSet.getPageSize();
            system.debug('_______Email list________TotalPage_____________pageSize'+ pageSize);
            system.debug('_______Email list________TotalPage_____________resultSize'+ resultSize);
            if(pageSize == 0 || resultSize == 0) return 0;
            Integer totalPages = resultSize/pageSize;
            if(pageSize*totalPages == resultSize){
                return totalPages;
            }else{
                return totalPages + 1;
            }
        }
    }
    
    
    public Integer TotalRecords{
        get{
            if(listTargetMemberSet == null) return 0;
            return listTargetMemberSet.getResultSize();
        }
    }
    
     public Boolean isLast{
        get {
            if(listTargetMemberSet == null) return true;
            Integer resultSize = listTargetMemberSet.getResultSize();
            Integer pageSize = listTargetMemberSet.getPageSize();
            Integer totalPages = resultSize/pageSize;
            if(resultSize == 0){
                return true;
            }
            if(pageSize*totalPages == resultSize){
                return listTargetMemberSet.getPageNumber() == totalPages;
            }else{
                return listTargetMemberSet.getPageNumber() == totalPages + 1;
            }
        }
        set;
    } 
     
     public Pagereference removeMembersFromList(){
        system.debug('updateRemoveReason-->');
        system.debug('#reason-->'+reason);
        List<Target_List_Member__c> membersToUpdate = new List<Target_List_Member__c>();
        if(reason != null && reason != ''){
            for(memberWrapper wrapper : listOfMyTarget){
                if(wrapper.isSelected == true ){
                   membersToUpdate.add( new Target_List_Member__c(id = wrapper.listMember.id,Removed_Reason__c = reason ,Viewed_by_User__c= true,Reassigned_By__c = null));
                }
            }
              
            if(membersToUpdate.size() > 0){ 
                update membersToUpdate;
            }
            reason ='';
            selectedId =''; 
            GetMemberList(); 
        }
        return null;
    }
    
    //Action Functions 
    
    public Pagereference RemoveEmailOnly(){
       List<Target_List_Member__c> updateList = new List<Target_List_Member__c> ();
       for(memberWrapper mw : listOfMyTarget ){
            if(mw.isSelected){
                mw.listMember.Removed_Reason__c = null;
                if(!mw.listMember.Viewed_by_User__c)
                 {
                     unviewedCount--;
                 }
                updateList.add(mw.listMember);
            }
       }
       if(updateList.size()>0){
        update updateList;
       }
         
       //GetMemberList();
       return null;
    }
    
    //ChangeLanguage
    public Pagereference changeContactIILanguage(){
        system.debug('updateRemoveReason-->');
        system.debug('#selectedId -->'+selectedContactId );
        system.debug('#reason-->'+selectedLang);
        if(selectedContactId != null && selectedContactId != ''){
            GPSContact__c selectedMember= new GPSContact__c(id = selectedContactId);
            selectedMember.II_Language__c = selectedLang;
            update selectedMember;
        }
        selectedContactId ='';  
        selectedLang= '';  
        GetMemberList();  
       
        return null;
    }
    
    
    
    public class memberWrapper{
        public Boolean isSelected {get;set;}
        public Target_List_Member__c listMember {get;set;}
        public List<String> additionaldetail {get;set;}
        
        Public List<Voter_Recommendation__c> voterRecommendations{get;set;}
        public boolean showMore{get;set;}
                
        public memberWrapper(Boolean isSelected , Target_List_Member__c listMember){
            this.isSelected = isSelected;
            this.listMember = listMember;
            this.additionaldetail = new List<String>();
            showMore=false;
           
        }
    }
}