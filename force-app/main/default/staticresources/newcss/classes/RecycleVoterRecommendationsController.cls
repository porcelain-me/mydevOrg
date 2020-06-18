/**********************************************************************************

02/09/2011 Urminder : Removed Team_uses_Analyst_Buddies__c from query (line# 82)
02/22/2011 Urminder : Created new Property lstPriCon and contactPriority and updated class VoterRecommendation constructor (line# 30,42)
                      Added the logic to fetch set of priority Contacts (line# 66)
                      Added method to sort contacts as per priority (line# 165)
//02/23/2011 Parth : Refactored method sortAsPriority 
//03/05/2011 Urminder : updated the query to fetch priority contacts from current list only (line#85)
                        and added a set to get contacts from current list(line#75)
//03/07/2011 Urminder : remove limit from query (line#88)   
//03/09/2011  Urminder : updated the Last_Added_Date__c of Voter to be Restored(line #270) 
//03/10/2011 Svatka Simpson:     Adding where clause to getAllPriorityContacts
//                               show priority contacts with relationship type = P
//03/11/2011 Svatka Simpson:     Adding Pure_MSID__c to Candidate query. It's formula field and replacing the priority contact query to include this one over MSID__c             
***********************************************************************************/
public with sharing class RecycleVoterRecommendationsController {

    public Integer sizeOfList { get; set;}
    public String voterIds{get;set;}
    public List<Voter_Recommendation__c> deletedRecommendations { get; set; }
    // Commented by Swapnd on 18-feb-2016 for Campaign Migration
    //public Target_List_Member__c tMember {get;set;}
    public String targetMemberID;
    public String sortOrderClause{get;set;}
    public String sortOrder{get;set;}
    public Boolean isListEmpty{get;set;}
    public List<String> ShowRecordsOnPage {get;set;}
    public ApexPages.StandardSetController deletedVoterRecomendations{get;set;}
    public Integer RECORD_PAGE_SIZE =25;
    public Integer CurrentPageNumber {get;set;}
    public List<String> pageIndexNumber {get;set;}
    public String currentPageSize{get;set;}
     public Team__c candidateTeam {get;set;}
    static string TestTitlePrefix = 'TestCandidate' ; 
    public String selectedCandidate  {get;set;}
    public String  gotoPageRange  {get;set;}
    private User userTimeZoneInfo {get;set;}
    
    public List<Priority_Contacts__c> lstPriCon;
    
    
   public List<VoterRecommendation>  lstVoterRecommendations  {get;set;}
     
   private final integer MAX_UI_QUERY_LIMIT = 1499;  
     
    public class VoterRecommendation{
        public boolean toRestore{get;set;}
        public string firstName{get;set;}
        public string lastName{get;set;}
        public string deletedDateTime{get;set;}
        public Voter_Recommendation__c objVoterRec{get;set;}
        //02/22/2011 Urminder : Added to store the Priority of Contact 
        public boolean contactPriority{get;set;}
        public VoterRecommendation(){
            toRestore = false;
            firstName = '';
            lastName = '';
            deletedDateTime ='';
            objVoterRec=null;
            contactPriority = false; 
        }
        
        public VoterRecommendation(boolean contactPriority,string strFName,string strLName,string deletedDt,Voter_Recommendation__c voterRec){
            toRestore = false;
            firstName = strFName;
            lastName = strLName;
            deletedDateTime = deletedDt;
            objVoterRec = voterRec;
            this.contactPriority = contactPriority;
        }
        
    }
    
    public void fillVoterRecommendationsList(List<Voter_Recommendation__c> lstVR){
        
        
        lstVoterRecommendations = new  List<VoterRecommendation>();
        //02/22/2011 Urminder : added the logic to fetch set of priority Contacts 
        Candidate_Information__c candidateInfo = new Candidate_Information__c();
        //03/05/2011 Urminder : added set of Contacts having all contacts of list
        Set<Id> contacts = new Set<Id>();
        for(Voter_Recommendation__c voter: lstVR) {
            contacts.add(voter.GPSContact__c); 
        }
             for(Candidate_Information__c canInfo : [Select id ,MSID__c, Pure_MSID__c from Candidate_Information__c where id =:selectedCandidate limit 1]){
                    candidateInfo = canInfo;
                }
              Set<Id> setPriCon = new Set<Id>();
              system.debug('============setPriCon========='+candidateInfo);
              lstPriCon = new List<Priority_Contacts__c>();
              //03/05/2011 Urminder : updated the query to fetch priority contacts from the contacts of current list only.
              //03/10/2011 Svatka: updated where clause AND Relationship_Type__c = 'P' 
              for(Priority_Contacts__c pricon :[Select p.MS_Id__c, p.GPSEmployee__r.MS_ID__c, p.GPSEmployee__c, p.GPSContact__c From Priority_Contacts__c p
                                   where Relationship_Type__c = 'P' AND (p.GPSEmployee__r.MS_ID__c =:candidateInfo.Pure_MSID__c or GPSEmployee__r.User__r.Emp_ID__c =:candidateInfo.Pure_MSID__c) And p.GPSContact__c IN : contacts])
                {
                             setPriCon.add(pricon.GPSContact__c);
                }
              system.debug('============setPriCon========='+setPriCon);
              
         
        for(Voter_Recommendation__c voterRec: lstVR){
            //System.debug('___DeletedDate______' + voterRec.LastModifiedDate);
            
            String userTimeZoneDateStr = voterRec.LastModifiedDate.format('MMM dd yyyy HH:mm a',userTimeZoneInfo.TimeZoneSidKey); 
            //MMM DD YYYY HH:MM AM/PM 
            
            lstVoterRecommendations.add(new VoterRecommendation(setPriCon.contains(voterRec.GPSContact__c),voterRec.Contact_First_Name__c, voterRec.Contact_Last_Name__c,userTimeZoneDateStr,voterRec));
        }
    }
    
    
    public RecycleVoterRecommendationsController() {
         selectedCandidate = Apexpages.currentPage().getParameters().get('candidateId');
         Id currentUserId = ApexPages.currentPage().getParameters().get('UId');
         
         if(currentUserId == null)
             currentUserId = UserInfo.getUserId();
             
         userTimeZoneInfo = [Select u.TimeZoneSidKey, u.LocaleSidKey From User u where id= :currentUserId];
         
         gotoPageRange = '';      
        String selectedTeamName = '';
            for(Candidate_Information__c candidate : [Select Team_Name__c From Candidate_Information__c c Where id=:selectedCandidate ]){
                selectedTeamName = candidate.Team_Name__c;
            }
        
            for(Team__c team : [Select Team_Region__r.Name,Fan_Club_Setup__c
                                                FROM Team__c 
                                                where Name =:selectedTeamName limit 1]){
            candidateTeam = team; 
                                                                                 
                }
           
           
     pageIndexNumber = new List<String>();
     targetMemberID = Apexpages.currentPage().getParameters().get('id');
     String candidateId = Apexpages.currentPage().getParameters().get('candidateId');
     sortOrder = '1';//Apexpages.currentPage().getParameters().get('sortOrder');
     sortOrderClause = 'Contact__Name';//Apexpages.currentPage().getParameters().get('sortOn');
     ShowRecordsOnPage = new String[]{'25','50','100'};
     currentPageSize = '25';
     CurrentPageNumber = 1;
     deletedRecommendations = new List<Voter_Recommendation__c>();
    
     String qry =  'Select Name,  GPSContact__c, Contact_First_Name__c, Contact_Last_Name__c, IsDeleted ,Account__c,LastModifiedDate,Active_Flag__c,User_Who_Inactivated__c,Is_Analyst_Buddy__c' +
                                             ' From Voter_Recommendation__c    where' +  
                                             ' Active_Flag__c = false   and   User_Who_Inactivated__c <> null ';                                                                 
        if(candidateTeam<>null){
            qry += ' and Candidate_Information__c = :selectedCandidate ';
        }
        if(Test.isRunningTest()) {
            qry = qry + ' and Candidate_Information__r.Candidate_Name__c like \'%' + TestTitlePrefix +'%\'';
        }
        // userTargetList = select iiCampaign__c From Target_List__c where User__c =: System.Userinfo.getUserId() 
        //voter recommendation  = where Candidate_Information__r.iiCampaign__c = userTargetList.iiCampaign__c
        qry += ' order by GPSContact__r.Name  ASC ' ;
        
        
        
        System.debug('======================='+qry);
        deletedVoterRecomendations = new ApexPages.StandardSetController(Database.query(qry));
        deletedVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);
        deletedRecommendations = deletedVoterRecomendations.getRecords();
        sizeOfList = deletedRecommendations.size();
        if(sizeOfList == 0) {
            isListEmpty = true;
        }
                   
        System.debug('===del==========='+deletedRecommendations);
        Integer totalPages = deletedVoterRecomendations.getResultSize() / RECORD_PAGE_SIZE;
        for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(deletedVoterRecomendations.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
         fillVoterRecommendationsList(deletedRecommendations);
         
     }
     //02/22/2011 Urminder : Added method to sort contacts as per priority
     /*public void sortAsPriority() {
        List<VoterRecommendation> tempVoterList = lstVoterRecommendations;
        lstVoterRecommendations = new  List<VoterRecommendation>();
        if(sortOrder == '1') {
            for(VoterRecommendation voter : tempVoterList) {
                if(voter.contactPriority) {
                    lstVoterRecommendations.add(voter);
                }
            }
            for(VoterRecommendation voter : tempVoterList) {
                if(!voter.contactPriority) {
                    lstVoterRecommendations.add(voter);
                }
            }
        } else {
            for(VoterRecommendation voter : tempVoterList) {
                if(!voter.contactPriority) {
                    lstVoterRecommendations.add(voter);
                }
            }
            for(VoterRecommendation voter : tempVoterList) {
                if(voter.contactPriority) {
                    lstVoterRecommendations.add(voter);
                }
            }
        }
     }*/
     
     //02/23/2011 Parth : Refactored method to sort contacts as per priority
     
     public void sortAsPriority() {
        List<VoterRecommendation> tempPriorityVoterList = new  List<VoterRecommendation>();
        List<VoterRecommendation> tempNonPriorityVoterList = new  List<VoterRecommendation>();
        //lstVoterRecommendations = new  List<VoterRecommendation>();
        for(VoterRecommendation voter : lstVoterRecommendations) {
            if(voter.contactPriority) {
                tempPriorityVoterList.add(voter);
            }else{
                tempNonPriorityVoterList.add(voter);
            }
        }
        lstVoterRecommendations = new  List<VoterRecommendation>();
        if(sortOrder == '1') {
            lstVoterRecommendations.addAll(tempPriorityVoterList);
            lstVoterRecommendations.addAll(tempNonPriorityVoterList);
            
        } else {
            lstVoterRecommendations.addAll(tempNonPriorityVoterList);
            lstVoterRecommendations.addAll(tempPriorityVoterList);
        }
     }
     
     
     public Integer gotoPageNumber {get;set;}
     public void goToPage(){
         system.debug('________________next mehtod start__________');
        
         system.debug('gotoPageRangeeeee'+gotoPageRange);
        integer currentpagesizeint = double.valueOf(currentpagesize).intValue(); 
        integer rangelastdigit = double.valueOf(gotoPageRange.substring(gotoPageRange.lastIndexOf('-')+1)).intValue();
        integer rangefirstdigit = double.valueOf(gotoPageRange.substring(0,gotoPageRange.lastIndexOf('-'))).intValue();
        if(rangelastdigit == deletedVoterRecomendations.getResultSize()){
            rangelastdigit = rangelastdigit +(currentpagesizeint-((rangelastdigit-rangefirstdigit)+1));
        }
        gotoPageNumber = (rangelastdigit)/currentpagesizeint;
        system.debug('gotoPageNumberrrrrrrrrr'+gotoPageNumber);
        deletedVoterRecomendations.setPageNumber(gotoPageNumber);        
        updateVotersList();
    }
    
     public void restoreVoterRecommendations() {
       /* List<String> voterIdList; 
        Set <String> setOfIds = new Set<String>();
        if(voterIds.length() > 0) {
            voterIdList = voterIds.split(';');
        }
        
        setOfIds.addAll(voterIdList);
        setOfIds.remove('');
        setOfIds.remove(null);
       */
        
       // system.debug('____________________setOfIds ____' + setOfIds);
        List<Voter_Recommendation__c> votersRestoredList = new List<Voter_Recommendation__c>();
       // for(Voter_Recommendation__c voterRestored : deletedRecommendations) {
       //03/09/2011  Urminder : updated the Last_Added_Date__c of Voter to be Restored
       for(VoterRecommendation voter : lstVoterRecommendations) {
       
            //if(setOfIds.contains(voterRestored.Id) ){
            if(voter.toRestore == true){
                voter.objVoterRec.Active_Flag__c = true;
                voter.objVoterRec.User_Who_Inactivated__c = null;
                voter.objVoterRec.Is_Analyst_Buddy__c = false;
                voter.objVoterRec.Last_Added_Date__c  = Datetime.now();
                votersRestoredList.add(voter.objVoterRec);
                
            }
            
        } 
        update votersRestoredList;
        System.debug('====updated===='+votersRestoredList);
        
     }
      public void setpagesize()    {
         if(currentPageSize == '25')
          {
            RECORD_PAGE_SIZE = 25;
          }
         else  if(currentPageSize == '50')
          {
            RECORD_PAGE_SIZE = 50;
          }
         else if(currentPageSize == '100')
          {
            RECORD_PAGE_SIZE = 100;
          }
      }
      
     public Pagereference sortContacts() {
        deletedRecommendations = new List<Voter_Recommendation__c>();
        String Query = 'Select Name, GPSContact__c, Contact_First_Name__c, Contact_Last_Name__c, IsDeleted ,Account__c,LastModifiedDate,Active_Flag__c,User_Who_Inactivated__c' +
                                            ' From Voter_Recommendation__c  where '+
       
                                            ' Active_Flag__c = false   and   User_Who_Inactivated__c <> null';
       
        if(candidateTeam<>null){
            Query += ' and Candidate_Information__c = :selectedCandidate ';
        }
        
      if(Test.isRunningTest()) {
            Query += ' and Candidate_Information__r.Candidate_Name__c like \'%' + TestTitlePrefix +'%\' ';
        }                                            
         
         if(sortOrderClause=='Contact__Name'){
                Query += ' order by GPSContact__r.Name ' ;
         } 
         else{                              
            Query += ' order by ' + sortOrderClause;
         } 
        
        if(sortOrder == '1') {
            Query += ' ASC';
        } else {
            Query += ' DESC';
        } 
        //if(Test.isRunningTest()) {
            //Query += ' limit 10000 ';
        //  }           
        System.debug('===============qry====='+Query);                                   
        deletedVoterRecomendations = new ApexPages.StandardSetController(Database.query(Query));
        deletedVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);
        deletedVoterRecomendations.setPageNumber(CurrentPageNumber);
        deletedRecommendations = deletedVoterRecomendations.getRecords();
        fillVoterRecommendationsList(deletedRecommendations);
        return null;
     }
     
     public void updateVotersList(){
        deletedRecommendations = (List<Voter_Recommendation__c>)deletedVoterRecomendations.getRecords();
        CurrentPageNumber = deletedVoterRecomendations.getPageNumber();
        fillVoterRecommendationsList(deletedRecommendations);
        
        
    }
     
    public void first() {
      deletedVoterRecomendations.first();
      updateVotersList();
    }
    
    public void last() {
        deletedVoterRecomendations.last();
        updateVotersList();
    }
    public void previous() {
        deletedVoterRecomendations.previous();
        updateVotersList();
    }
    public void next() {
       
        deletedVoterRecomendations.next();
       
        updateVotersList();
    }
    public Boolean hasNext {
        get{
          if(deletedVoterRecomendations == null) return false;
          return deletedVoterRecomendations.getHasNext();
        }
        set;
    }
    
     public Boolean hasPrevious {
        get {
            if(deletedVoterRecomendations == null) return false;
            return deletedVoterRecomendations.getHasPrevious();
        }
        set;
    }
     public Boolean isFirst{
        get{
           if(deletedVoterRecomendations == null) return true;
           return (deletedVoterRecomendations.getPageNumber() == 1);
        }
        set;
   }
    
    
   public Integer recordStartNumber{
       get{
           if(deletedVoterRecomendations == null) return 0;
           system.debug('recordStartNumberrrrrrrrrrrr'+ ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1);
           system.debug('CurrentPageNumberrrrrrrrrrrrr'+ CurrentPageNumber);
           system.debug('RECORD_PAGE_SIZErrrrrrrrrrrr'+  RECORD_PAGE_SIZE);
           return ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1;
        }
   }
   
   public Integer recordEndNumber{
       get{
           if(deletedVoterRecomendations == null) return 0;
           if(isLast == true){
             return TotalRecords;
           }else{
             return CurrentPageNumber * RECORD_PAGE_SIZE;
           }
        }
   } 
    
    
    
    public Integer TotalPage{
        get{
            if(deletedVoterRecomendations == null) return 0;
            Integer resultSize = deletedVoterRecomendations.getResultSize();
            Integer pageSize = deletedVoterRecomendations.getPageSize();
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
            if(deletedVoterRecomendations == null) return 0;
            return deletedVoterRecomendations.getResultSize();
        }
    }
    
     public Boolean isLast{
        get {
            if(deletedVoterRecomendations == null) return true;
            Integer resultSize = deletedVoterRecomendations.getResultSize();
            Integer pageSize = deletedVoterRecomendations.getPageSize();
            Integer totalPages = resultSize/pageSize;
            if(resultSize == 0){
                return true;
            }
            if(pageSize*totalPages == resultSize){
                return deletedVoterRecomendations.getPageNumber() == totalPages;
            }else{
                return deletedVoterRecomendations.getPageNumber() == totalPages + 1;
            }
        }
        set;
    }
     public void updateNewPagesize() {
        setpagesize(); 
        deletedVoterRecomendations.setPageSize(Integer.valueOf(currentPageSize));
        
        System.debug('==============size========'+currentPageSize);
        deletedVoterRecomendations.setPageNumber(1);
         
         pageIndexNumber.clear();
         for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
          if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(deletedVoterRecomendations.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
        updateVotersList();
     }
     
    
}