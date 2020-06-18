//Modified :- Appirio Offshore(Kapil Choudhary) 29-July-2007 added a Field while querying from Target_List_Member__c [PR-05602]
//Modified :- Appirio Offshore(Kapil Choudhary) 29-July-2007 added a Field while querying from Target_List_Member__c [PR-05615]
// 29 JUL 2010    Rahul Jain      Related PR-05759 Making Vote pop-up wider and accomodate a new field
//                                Added fields (Candidate_Information__r.Additional_Text__c, Candidate_Information__r.Candidate_Name__c)
//                                in the candidate sector query written. 
// 12 Aug 2010   Kapil Choudhary  Voting a contact according to Login As User in target list. [PR-05772] 
// 19 Aug 2010   Kapil Choudhary  Added two field to populate "Send Ballot Request Email" functionality. [PR-05901]
// 19 Aug 2010   Kapil Choudhary  Added a where condition while fetching record from Candidate_Sector__c [PR-05902]
// 20 Aug 2010   Kapil Choudhary  Added a where condition. [PR-05924]
// 14 Sep 2010   Chetan Garg     Changes for 
//                                      PR-06187: Add iiLanguage to the Vote pop-up              
//                                      PR-06189: Make iiLanguage configurable
// 02 Nov 2010  Kapil Choudhary Modification made in insertVote function for [PR-06928]              
// 08 Nov 2010  ParthT          PR-07002 (Get "Contact has been Called" working like other options )
// 09 Nov 2010  Chetan Garg     PR-07010: Contacts marked Not II Friendly - set contact as ineligible for email
//                              1. all owners of that contact should have that contact's eligible for email flag changed to NO (regardless of TLM syncing mode setting)
//                              2. if contact has additional owners, and that contact is on an email list for one or more of those owners, remove that contact (contact should not be on email only list and have email flagged unchecked).  In this case, set the Removed Reason to "Email Only - Not Eligible for Email" 
// 12 Nov 2010  Kapil Choudhary Added 'Enter Call Notes' string for [PR-07081]. 
//  10 Dec,2010  Kapil Choudhary    Updated for Inactivate Voter Recommendations instead of deleting [PR-07419].
// 1/4/11 Chetan Garg     Added field in the query Target_List_Call_Notes_Info__c (PR-07730)
// 01/07/2011 Chetan Garg PR-07815 - Smart List PR - UI and Functional Updates to Bulk Add Interests
//02/21/2011    Urminder : updated the query  to fetch Use_Recommendations_in_Campaign? from Candidate Information
//                          and updated the Logic to Add Voter Recommedations (line# 167,370).
//03/31/2011    Urminder : change sorting order of Candidate_Sector__c from iiSector__c to Candidate_Name__c (line#173-187) 
//07/13/2011  Andrey Volosevich: multiple updates for story http://jira2.ms.com/jira/browse/CRMGPS-169
//11/27/2012    Jitendra:   CRMGPS-2884 II Campaign - Voting Panel Enhancement
//04 July 2013 RP : CRMGPS 4215 Remove already recommended analysts/ analyst teams from UI
//VM Added Voted_in_II_Campaign__c for Jira 4499 , Couple/Decouple functionality

public class MyListVoteController{
    
    //Target List Member Contact ID
    private String targetMemberID {get;set;}
    private String currentUserLoginId;
    public Target_List_Member__c tMember {get;set;}
    private Map<Id, String> mapCandidateInfoIDWhyText;
    public List<CandidateSectorWrapper> listOfCandidateWrapper {get;set;}
    
    public Set<String> setOfDeletedVoterRec;
    public Boolean hasVote {get;set;}    
    public Boolean leftVoicemail {get;set;}
    public Boolean contactReveal {get;set;}
    public Boolean blanketVote {get;set;}
    public Boolean leftVoicemailEditable {get;set;}
    public Boolean isPageLoad {get;set;}
    private Boolean previousVoteCheckBox {get;set;}
    private Set<ID> setOfVoteSector {get;set;}
    public String newLanguagePref {get;set;}
    public Boolean contact_has_been_called {get;set;}
    public Boolean not_II_Friendly {get;set;}
    public Boolean ballot_Received {get;set;}
    public Boolean ballot_Received_Editable {get;set;}
    public Boolean not_II_Friendly_Editable {get;set;}
    public Boolean called_Contact_Editable {get;set;}  //11/8/2010 ParthT: PR-07002 (Get "Contact has been Called" working like other options )
    public Integer sizeOfCandidateWrapperList{get; private set;} //25/07/2011 AndreyV: [JIRA: CRMGPS-192] - property used to contain the size of the list of Candidate Sectors.
    public List<Voter_Recommendation__c> allVoterRecommendations = new List<Voter_Recommendation__c>();
    //public List<Voter_Recommendation__c> activeVoterRecommendations = new List<Voter_Recommendation__c>();
    map<String , Voter_Recommendation__c> mapCandidateVoter = new map<String , Voter_Recommendation__c>();//04 July 2013 RP : CRMGPS 4215 
    public MyListVoteController(){
        hasVote = false;
        newLanguagePref = '';
        setOfVoteSector = new Set<ID>();
        setOfDeletedVoterRec = new Set<String>();
        contactReveal = true;
        isPageLoad = false;
        leftVoicemailEditable = true;
        ballot_Received_Editable = not_II_Friendly_Editable = called_Contact_Editable= true;
        //Initialize 
        listOfCandidateWrapper = new List<CandidateSectorWrapper>();
        mapCandidateInfoIDWhyText = new Map<Id, String>();
        
        /********************JIRA-4815 by Sudarshan K. on 3rd May 2016***********************/
        if(Apexpages.currentPage().getParameters().get('UId') != null && Apexpages.currentPage().getParameters().get('UId') != ''){
        	currentUserLoginId = Apexpages.currentPage().getParameters().get('UId');
        }else{
        	currentUserLoginId = System.UserInfo.getUserId();
        }
        /************************End Code*****************************/
        
        //If Member contact ID exists.
        if(Apexpages.currentPage().getParameters().get('id') != null && Apexpages.currentPage().getParameters().get('id') != ''){
            targetMemberID = Apexpages.currentPage().getParameters().get('id');
            tMember = [Select Target_List_Status__c,GPSContact__r.II_Language__c,Call_Notes__c,t.User_who_left_Voicemail_del__c,t.GPSContact__r.Phone__c,Voted_in_II_Campaign__c,t.User_who_left_Voicemail_del__r.firstname,
                        t.User_who_left_Voicemail_del__r.Preferred_Name__c, t.User_who_left_Voicemail_del__r.lastname, t.User_Email__c, t.Name, t.Id, t.Contact_would_not_reveal_vote__c,
                        t.GPSContact__c, t.Called_about_II__c, t.Blanket_Voter__c,t.Target_List__r.iiCampaign__r.Campaign_uses_warm_up_calls__c,
                        t.Target_List__r.iiCampaign__r.Allow_voting__c ,Target_List__r.User__c,Target_List__r.iiCampaign__c,
                        t.Target_List__r.iiCampaign__r.Ballot_Request_Email__c,
                        t.Target_List__r.iiCampaign__r.Ballot_Request_Email_Subject__c,Target_List__r.iiCampaign__r.Campaign_is_Multilingual__c,
                        t.Target_List__r.iiCampaign__r.Show_Ballot_Request_Email__c,t.Target_List__r.iiCampaign__r.Synch_Target_List_Member_Statuses__c,
                        Contact_has_been_called__c,Not_II_Friendly__c,Ballot_Received__c,
                        t.Target_List__r.iiCampaign__r.Show_Ballot_Received__c,
                        t.Target_List__r.iiCampaign__r.Show_Not_II_Friendly__c,
                        t.Target_List__r.iiCampaign__r.Show_Contact_has_been_Called__c,
                        t.Target_List__r.iiCampaign__r.Not_Interested_Checkbox_Text__c,
                        t.Target_List__r.iiCampaign__r.Blanket_Vote_Checkbox_Text__c,
                        t.Target_List__r.iiCampaign__r.Show_Blanket_Vote_Checkbox__c, 
                        t.Target_List__r.iiCampaign__r.Show_Not_Interested_Checkbox__c,
                        t.Target_List__r.iiCampaign__r.Call_2_Text__c, t.Target_List__r.iiCampaign__r.Contact_Has_Been_Called_Text__c, //11/27/2012    Jitendra:   CRMGPS-2884
                        User_Who_Confirmed_Non_II_Friendly__c,user_who_confirmed_ballot_received__c,
                        user_who_confirmed_ballot_received__r.FirstName, user_who_confirmed_ballot_received__r.Preferred_Name__c, user_who_confirmed_ballot_received__r.LastName,
                        User_Who_Confirmed_Non_II_Friendly__r.FirstName, User_Who_Confirmed_Non_II_Friendly__r.Preferred_Name__c, User_Who_Confirmed_Non_II_Friendly__r.LastName,
                        User_Who_Called_the_Contact__c,Target_List__r.iiCampaign__r.Target_List_Call_Notes_Info__c,
                        Target_List__r.iiCampaign__r.Users_Can_Add_Recommendations__c,Removed_Reason__c, 
                        User_Who_Called_the_Contact__r.FirstName,User_Who_Called_the_Contact__r.Preferred_Name__c,User_Who_Called_the_Contact__r.LastName //11/8/2010 ParthT: PR-07002 (Get "Contact has been Called" working like other options )
                        
                      From Target_List_Member__c t where Id =: targetMemberID limit 1];
            System.debug('========tMember=======: '+ tMember);
            isPageLoad = true;
            blanketVote = tMember.Blanket_Voter__c;
            leftVoicemail = tMember.Called_about_II__c;
            contactReveal = tMember.Contact_would_not_reveal_vote__c;
            previousVoteCheckBox = tMember.Voted_in_II_Campaign__c;
            contact_has_been_called = tMember.Contact_has_been_called__c;
            not_II_Friendly = tMember.Not_II_Friendly__c;
            ballot_Received = tMember.Ballot_Received__c;
            
            if(tMember.User_who_left_Voicemail_del__c != null) {
                if(tMember.User_who_left_Voicemail_del__c != currentUserLoginId) {
                    leftVoicemailEditable = false;
                }
            }
            
            if(tMember.user_who_confirmed_ballot_received__c != null) {
                if(tMember.user_who_confirmed_ballot_received__c != currentUserLoginId) {
                    ballot_Received_Editable = false;
                }
            }
            
            if(tMember.User_Who_Confirmed_Non_II_Friendly__c != null) {
                if(tMember.User_Who_Confirmed_Non_II_Friendly__c != currentUserLoginId) {
                    not_II_Friendly_Editable = false;
                }
            }
            //11/8/2010 ParthT : Added for User who called Contact - PR-07002 (Get "Contact has been Called" working like other options )
            if(tMember.User_Who_Called_the_Contact__c != null) {
                if(tMember.User_Who_Called_the_Contact__c != currentUserLoginId) {
                    called_Contact_Editable = false;
                }
            }
            
            hasVote = tMember.Blanket_Voter__c;
            GetVoterRecommendation();   
            GetCandidateSector();
            
            if(tmember.Call_Notes__c == '' || tmember.Call_Notes__c == null){
                            tmember.Call_Notes__c = 'Enter Call Notes';
            }   
        }
    }
    
    
    
    //Populate Candidate Sector
    private void GetCandidateSector(){
        
        // List<CastVote>
        // --- if -> true and false 
        // false ->    Contact__c = : tMember.Contact__c  Target_List_member__c = tMember.id
        List<Vote__c> listCastVote = new List<Vote__c>();   
        if(tMember.Target_List__r.iiCampaign__r.Synch_Target_List_Member_Statuses__c == true){
            listCastVote = [Select v.Candidate_Sector__c From Vote__c v 
                                             where GPSContact__c = : tMember.GPSContact__c 
                                             AND iiCampaign__c = : tMember.Target_List__r.iiCampaign__c
                                             and Candidate_Sector__r.Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                                                                                     
        }else{
            listCastVote = [Select v.Candidate_Sector__c From Vote__c v 
                                             where Target_List_Member__c  =: tMember.id
                                             AND iiCampaign__c = : tMember.Target_List__r.iiCampaign__c 
                                             and Candidate_Sector__r.Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
        }
        
        for(Vote__c castVote : listCastVote)  {
            setOfVoteSector.add(castVote.Candidate_Sector__c);
        }  
        List<Candidate_Sector__c> listOfRecommendateSector = new List<Candidate_Sector__c>();
         List<Candidate_Sector__c> listOfDeletedRecommendateSector = new List<Candidate_Sector__c>();
        List<Candidate_Sector__c> listOfSector = new List<Candidate_Sector__c>();
        //02/21/2011    Urminder : updated the query  to fetch Use_Recommendations_in_Campaign? from Candidate Information
        for(Candidate_Sector__c candidateSector : [Select c.iiSector__c, 
                                                   c.Promotion_Text__c, 
                                                   c.Id, 
                                                   c.Candidate_Name__c,
                                                   Candidate_Information__c,Candidate_Information__r.Use_Recommendations_in_Campaign__c,
                                                   Candidate_Information__r.Promotion_Text__c,
                                                   Candidate_Information__r.Additional_Text__c, Candidate_Information__r.Candidate_Name__c 
                                                   From Candidate_Sector__c c
                                                   where Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c
                                                   Order by Candidate_Name__c asc nulls last]){
            if(mapCandidateInfoIDWhyText.containsKey(candidateSector.Candidate_Information__c)){
              //  listOfCandidateWrapper.add(new CandidateSectorWrapper(true,candidateSector, mapCandidateInfoIDWhyText.get(candidateSector.Candidate_Information__c),setOfVoteSector.contains(candidateSector.id),false));
                listOfRecommendateSector.add(candidateSector);
            }
            //ELSE IF IN SET //THEN DELETED ALREADY
            else if(setOfDeletedVoterRec.contains(candidateSector.Candidate_Information__c)) {
                //listOfCandidateWrapper.add(new CandidateSectorWrapper(false,candidateSector,null,setOfVoteSector.contains(candidateSector.id),true));
                listOfDeletedRecommendateSector.add(candidateSector);
            }
            else{
               // listOfCandidateWrapper.add(new CandidateSectorWrapper(false,candidateSector, null,setOfVoteSector.contains(candidateSector.id),false));
                listOfSector.add(candidateSector);
            } 
        }
           
         for(Candidate_Sector__c candidateSector : listOfRecommendateSector){                                                         
            listOfCandidateWrapper.add(new CandidateSectorWrapper(true,candidateSector, mapCandidateInfoIDWhyText.get(candidateSector.Candidate_Information__c),setOfVoteSector.contains(candidateSector.id),false,false));
        }
         
         for(Candidate_Sector__c candidateSector : listOfSector){
            listOfCandidateWrapper.add(new CandidateSectorWrapper(false,candidateSector, null,setOfVoteSector.contains(candidateSector.id),false,false));
        }
        for(Candidate_Sector__c candidateSector : listOfDeletedRecommendateSector){                                                         
            listOfCandidateWrapper.add(new CandidateSectorWrapper(false,candidateSector,null,setOfVoteSector.contains(candidateSector.id),true,false));
        }
        if(setOfVoteSector.size() > 0){
            hasVote = true;
        }
        
        sizeOfCandidateWrapperList = listOfCandidateWrapper.size();  //25/07/2011 AndreyV: [JIRA: CRMGPS-192] - set property used to contain the size of the list of Candidate Sectors.
    }
    
    //creating a new voter Recommendation
   /* private void newVoterRecommednation() {
        Voter_Recommendation__c voter = new Voter_Recommendation__c();
        voter.Contact__c = tMember.Contact__c;
        voter.Added_from_myIIList_Page__c = true;
        voter.Active_Flag__c = true;
        //voter.Candidate_Information__c = listOfCandidateWrapper.candidateSector.Candidate_Information__c;
     }
     
    //Checking if already voter recommendation Exists for Contact
    private boolean isVoterRecommendationDeleted() {
        for(Voter_Recommendation__c deletedVoter:[select Contact__c from Voter_Recommendation__c where isDeleted = true]) {
            if(deletedVoter.Contact__c == tMember.Contact__c) {
                return true;
            }
                
        }
        return false;
    }*/
    //Populate setOfCandidateInfoIDByVoterRecom By Member Contact ID
    private void GetVoterRecommendation(){  
        allVoterRecommendations = [Select Candidate_Information__c, Why__c ,Active_Flag__c ,User_Who_Inactivated__c
                                             From Voter_Recommendation__c 
                                             Where GPSContact__c =:tMember.GPSContact__c
                                             and Use_Recommendations_in_Campaign__c <> 'No'
                                             and Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                                                
        for(Voter_Recommendation__c voter : allVoterRecommendations){
           mapCandidateVoter.put(voter.Candidate_Information__c , voter); //04 July 2013 RP : CRMGPS 4215 created map to check if we need to update or create voter recommendation record
            
            //SET 
            //IF and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null) TRUE 
            if((voter.Active_Flag__c == true) || (voter.Active_Flag__c == false && voter.User_Who_Inactivated__c == null)) {
                 mapCandidateInfoIDWhyText.put(voter.Candidate_Information__c, voter.Why__c);
            } else {
                setOfDeletedVoterRec.add(voter.Candidate_Information__c);
            }
            //MAP
            //ELSE 
            //SET 
        }         
    }
    
    private void updateAllContactInCampaign(String targetUser,List<Vote__c> listOfVoteToInsert){
        if((leftVoicemail != tMember.Called_about_II__c) 
                                    || (contactReveal != tMember.Contact_would_not_reveal_vote__c) 
                                    || listOfVoteToInsert.size() > 0 
                                    || (previousVoteCheckBox != tMember.Voted_in_II_Campaign__c) 
                                    || (blanketVote != tMember.Blanket_Voter__c)
                                    || (ballot_Received != tMember.Ballot_Received__c
                                    || (contact_has_been_called != tMember.Contact_has_been_called__c)
                                    || (not_II_Friendly != tMember.Not_II_Friendly__c)
                                    )
                 ) {
                List<Target_List_Member__c> targetMembers = [SELECT Id,Target_List_Status__c, name, Called_about_II__c, Contact_would_not_reveal_vote__c,Removed_Reason__c, Blanket_Voter__c 
                from Target_List_Member__c where GPSContact__c =: tMember.GPSContact__c AND Id !=: tMember.Id 
                AND Target_List__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                
                string str = 'SELECT Id, name, Called_about_II__c, Contact_would_not_reveal_vote__c,Removed_Reason__c from Target_List_Member__c where GPSContact__c ='+ tMember.GPSContact__c +'AND Id !='+ tMember.Id+'AND Target_List__r.iiCampaign__c = '+ tMember.Target_List__r.iiCampaign__c+'';
                
                for(Target_List_Member__c tm : targetMembers) {
                  if(tm.Removed_Reason__c == 'Email Only' || tm.Removed_Reason__c == null) {  
                    if(tMember.Called_about_II__c != leftVoicemail) {
                        if(tMember.Called_about_II__c) {
                            tm.Called_about_II__c = true;
                            tm.User_who_left_Voicemail_del__c = targetUser;//System.Userinfo.getUserId();   12 Aug 2010 [PR-05772]
                        }else {
                            tm.Called_about_II__c = false;
                            tm.User_who_left_Voicemail_del__c = null;
                        }
                    }
                    //Modified By Chetan 9/28/10 Contact_would_not_revel_vote is set each time
                    /**
                    if(contactReveal != tMember.Contact_would_not_reveal_vote__c) {
                        tm.Contact_would_not_reveal_vote__c = true;
                    }                   
                    **/                 
                    tm.Contact_would_not_reveal_vote__c = tMember.Contact_would_not_reveal_vote__c;
                    
                    tm.User_who_confirmed_Vote_Last__c = tMember.User_who_confirmed_Vote_Last__c;
                    
                    tm.user_who_confirmed_ballot_received__c = tMember.user_who_confirmed_ballot_received__c;
                    tm.Ballot_Received__c = tMember.Ballot_Received__c;
                    tm.Contact_has_been_called__c = tMember.Contact_has_been_called__c;
                    //11/8/2010 ParthT: Synch User_Who_Called_the_Contact__c- PR-07002 (Get "Contact has been Called" working like other options )
                    tm.User_Who_Called_the_Contact__c = tMember.User_Who_Called_the_Contact__c;
                    
                    tm.Not_II_Friendly__c = tMember.Not_II_Friendly__c;
                    tm.User_Who_Confirmed_Non_II_Friendly__c = tMember.User_Who_Confirmed_Non_II_Friendly__c;
                    //VM Added Voted_in_II_Campaign__c for Jira 4499 , Couple/Decouple functionality
                    tm.Voted_in_II_Campaign__c = tMember.Voted_in_II_Campaign__c;
                    tm.Call_Notes__c = tMember.Call_Notes__c;
                    //all owners of that contact should have that contact's eligible for email flag changed to NO (regardless of TLM syncing mode setting)
                    if(tMember.Not_II_Friendly__c == true){
                      tm.Eligible_for_email__c = false;
                      //if contact has additional owners, and that contact is on an email list for one or more of those owners, 
                      //remove that contact (contact should not be on email only list and have email flagged unchecked).  
                      //In this case, set the Removed Reason to "Email Only - Not Eligible for Email" 
                      if(tm.Removed_Reason__c == 'Email Only'){
                        tm.Removed_Reason__c = 'Email Only - Not Eligible for Email';
                      }
                    }
                    
                    if(listOfVoteToInsert.size() > 0) {
                       //04/20/2011 Urminder : Added a condition to update  Voted_in_II_Campaign__c
                        if(tm.Removed_Reason__c == 'Email Only' || tm.Removed_Reason__c == null || tm.Removed_Reason__c == ''){
                            tm.Voted_in_II_Campaign__c = true;  
                        }
                       tm.User_who_confirmed_Vote_Last__c = targetUser;//System.Userinfo.getUserId(); 12 Aug 2010 [PR-05772]
                    }else if(previousVoteCheckBox != tMember.Voted_in_II_Campaign__c) {
                        if(!tMember.Voted_in_II_Campaign__c) {
                            tm.User_who_confirmed_Vote_Last__c = null;
                        }
                    }
                    if(blanketVote != tMember.Blanket_Voter__c) {
                        if(tMember.Blanket_Voter__c) {
                            tm.Blanket_Voter__c = true;
                        }else {
                            tm.Blanket_Voter__c = false;
                        }
                    }
                }
               }
               targetMembers.add(tMember);
                
                update targetMembers;
            }else{
                update tMember; 
            }
    }
    // Insert Vote and update TargetList Member
    public PageReference insertVote(){      
        try{
            if(tmember.Call_Notes__c == 'Enter Call Notes'){
                    tmember.Call_Notes__c = '';
                }
            String targetUser = tMember.Target_List__r.User__c;
            
            //Update Language Preference
            //If this campaigns is set Campaign_is_Multilingual__c = true and Language Preference is changed then 
            // Update contact's Language Preferenc field
            if(tMember.Target_List__r.iiCampaign__r.Campaign_is_Multilingual__c){
                if(newLanguagePref != '' && newLanguagePref <> tMember.GPSContact__r.II_Language__c){
                     GPSContact__c con = new GPSContact__c(id = tMember.GPSContact__c);
                     con.II_Language__c = newLanguagePref;
                     update con;
                }
            }
            
            List<Vote__c> listOfVoteToInsert = new List<Vote__c>();
            //NEW VOTER RECOMMEDATIONS
            List<Voter_Recommendation__c> listNewVoterRecommendations = new List<Voter_Recommendation__c>();
            Set<ID> setOfSectoreIdToRemoveVote = new Set<ID>();
            Set<ID> setOfCandidateInformationIds = new Set<ID>();
            for(CandidateSectorWrapper candidateobj : listOfCandidateWrapper){
                 if(candidateobj.isVoteAlready == false && candidateobj.isSelected){
                    listOfVoteToInsert.add(new Vote__c(GPSContact__c = tMember.GPSContact__c,
                                                        Candidate_Sector__c = candidateobj.candidateSector.id
                                                        ,Target_List_Member__c = tMember.id
                                                        ,iiCampaign__c =  tMember.Target_List__r.iiCampaign__c)); 
                    setOfVoteSector.add(candidateobj.candidateSector.id);
                                        
                }else  if(candidateobj.isSelected == false && candidateobj.isVoteAlready == true){
                   setOfSectoreIdToRemoveVote.add(candidateobj.candidateSector.id);
                    setOfVoteSector.remove(candidateobj.candidateSector.id);
                }
                system.debug('__________candidateobj'+candidateobj);
                 //Logic to Add Voter Recommedations
                 //02/21/2011   Urminder : updated the Logic to Add Voter Recommedations
                 //03/03/2011  Chetan : populate Last_Added__c field whrn voter recommendation is added 
                if(candidateobj.isVoterRecommend == true && candidateobj.isVoterRecommendAlready == false && candidateobj.candidateSector.Candidate_Information__r.Use_Recommendations_in_Campaign__c <> 'No'){ 
                    if(!setOfCandidateInformationIds.contains(candidateobj.candidateSector.Candidate_Information__c)){ 
                        if(!mapCandidateVoter.containsKey(candidateobj.candidateSector.Candidate_Information__c)){
                            listNewVoterRecommendations.add(new Voter_Recommendation__c(
                                    GPSContact__c = tMember.GPSContact__c,
                                    Added_from_myIIList_Page__c = true,
                                    Active_Flag__c = true,
                                    Why__c = '',
                                    User_Who_Inactivated__c = null,
                                    Last_Added_Date__c = datetime.now(),
                                    Candidate_Information__c = candidateobj.candidateSector.Candidate_Information__c));
                                    setOfCandidateInformationIds.add(candidateobj.candidateSector.Candidate_Information__c);
                        }
                        else{//04 July 2013 RP : CRMGPS 4215 Added condition to check if Voter recommendation already exist, if yes then we just need to set active flag = true
                            Voter_Recommendation__c tempVoter = mapCandidateVoter.get(candidateobj.candidateSector.Candidate_Information__c);
                            tempVoter.Active_Flag__c = true;
                            tempVoter.User_Who_Inactivated__c = null;
                            listNewVoterRecommendations.add(tempVoter);
                            setOfCandidateInformationIds.add(candidateobj.candidateSector.Candidate_Information__c);
                        }
                    }       
                }//04 July 2013 RP : CRMGPS 4215 Added condition to remove voter recommendation
                else if(candidateobj.isRemovedVote == true && candidateobj.candidateSector.Candidate_Information__r.Use_Recommendations_in_Campaign__c <> 'No'){
                    if(mapCandidateVoter.containsKey(candidateobj.candidateSector.Candidate_Information__c)){
                        Voter_Recommendation__c tempVoter = mapCandidateVoter.get(candidateobj.candidateSector.Candidate_Information__c);
                        tempVoter.Active_Flag__c = false;
                        tempVoter.User_Who_Inactivated__c = currentUserLoginId;
                        listNewVoterRecommendations.add(tempVoter);
                    }
                }
            }            
              
            if(tMember.Target_List__r.iiCampaign__r.Users_Can_Add_Recommendations__c){
                upsert listNewVoterRecommendations;
            }
            //Remove Votes
            if(setOfSectoreIdToRemoveVote.size()> 0){
                List<Vote__c> listVoteToDelete = new List<Vote__c>();   
                if(tMember.Target_List__r.iiCampaign__r.Synch_Target_List_Member_Statuses__c == true){
                        listVoteToDelete = [Select v.Candidate_Sector__c From Vote__c v 
                                                         where GPSContact__c = : tMember.GPSContact__c 
                                                         AND iiCampaign__c = : tMember.Target_List__r.iiCampaign__c
                                                         AND Candidate_Sector__c IN :  setOfSectoreIdToRemoveVote
                                                         AND Candidate_Sector__r.Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                                                                                                 
                    }else{
                        listVoteToDelete = [Select v.Candidate_Sector__c From Vote__c v 
                                                         where Target_List_Member__c  =: tMember.id
                                                         AND iiCampaign__c = : tMember.Target_List__r.iiCampaign__c 
                                                         AND Candidate_Sector__c IN :  setOfSectoreIdToRemoveVote
                                                         AND Candidate_Sector__r.Candidate_Information__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                    }
                
                                    // IICampign__c -->
                                    /// TOGGLEING 
                delete  listVoteToDelete;               
                
            }
            
            if(listOfVoteToInsert.size() > 0){
                insert listOfVoteToInsert;
            }
            
            //11/27/2012    Jitendra:   CRMGPS-2884
            if(tMember.Ballot_Received__c && tMember.Contact_has_been_called__c && !tMember.Not_II_Friendly__c) {
                tMember.Blanket_Voter__c = true;
            }
            
            //If This contact vote then set Contact_would_not_reveal_vote__c = true
            if(listOfVoteToInsert.size() > 0){
                //tMember.Contact_would_not_reveal_vote__c = true;
            //04/20/2011 Urminder : Added a condition to update  Voted_in_II_Campaign__c
                if(tMember.Removed_Reason__c == null || tMember.Removed_Reason__c == 'Email Only') {
                    tMember.Voted_in_II_Campaign__c = true; 
                } 
                
                tMember.User_who_confirmed_Vote_Last__c = targetUser;//System.Userinfo.getUserId(); 12 Aug 2010 [PR-05772]
            }else if(setOfVoteSector.size() == 0) {
                
                /* block below added 27 Jul 2011 - Andrey Volosevich [JIRA: CRMGPS-193] 
                if(tMember.Contact_would_not_reveal_vote__c == true){
                    tMember.User_who_confirmed_Vote_Last__c = targetUser;
                }
                else{
                    tMember.User_who_confirmed_Vote_Last__c = null;
                }
                */
                
                
                //block below added 27 Jul 2011 - Andrey Volosevich [JIRA: CRMGPS-193] 
                if(tMember.Contact_would_not_reveal_vote__c == true || tMember.Blanket_Voter__c == true){
                    tMember.User_who_confirmed_Vote_Last__c = targetUser;
                }
                else{
                    tMember.User_who_confirmed_Vote_Last__c = null;
                }
                
                if(tMember.Blanket_Voter__c == true){
                    tMember.Voted_in_II_Campaign__c = true;
                }
                else{
                    tMember.Voted_in_II_Campaign__c = false;
                }
                //end
                
            }
            if(tMember.Called_about_II__c != leftVoicemail) {
                if(tMember.Called_about_II__c) {
                    tMember.User_who_left_Voicemail_del__c = targetUser;//System.Userinfo.getUserId();  12 Aug 2010 [PR-05772]
                }else {
                    tMember.User_who_left_Voicemail_del__c = null;
                }
            }
            if(tMember.Ballot_Received__c != ballot_Received) {
                if(tMember.Ballot_Received__c) {
                    tMember.user_who_confirmed_ballot_received__c = targetUser;//System.Userinfo.getUserId();   12 Aug 2010 [PR-05772]
                }else {
                    tMember.user_who_confirmed_ballot_received__c = null;
                }
            }
            
            //11/8/2010 ParthT: Set user who called contact -PR-07002 (Get "Contact has been Called" working like other options )
            if(tMember.Contact_has_been_called__c != contact_has_been_called) {
                if(tMember.Contact_has_been_called__c) {
                    tMember.User_Who_Called_the_Contact__c = targetUser;
                }else {
                    tMember.User_Who_Called_the_Contact__c = null;
                }
            }
            
            if(tMember.Not_II_Friendly__c != not_II_Friendly) {
                if(tMember.Not_II_Friendly__c) {
                    tMember.User_Who_Confirmed_Non_II_Friendly__c = targetUser;//System.Userinfo.getUserId();   12 Aug 2010 [PR-05772]
                    tMember.Eligible_for_email__c =false;
                }else {
                    tMember.User_Who_Confirmed_Non_II_Friendly__c = null;
                }
            }
            
            //Call to set Target List Member status 
            SetTragetListStatus();
            ///if true 
            if(tMember.Target_List__r.iiCampaign__r.Synch_Target_List_Member_Statuses__c == true){
                updateAllContactInCampaign(targetUser,listOfVoteToInsert);
            }else{
                
                // If This is Non-synch TLM mode and Changed value for Not_II_Friendly__c field then update all TLM for this contact 
                // else update only this contact
                if(not_II_Friendly != tMember.Not_II_Friendly__c){
                  List<Target_List_Member__c> otherListTargetMembers = [SELECT Id,Removed_Reason__c, name, Called_about_II__c, Contact_would_not_reveal_vote__c 
                    from Target_List_Member__c where GPSContact__c =: tMember.GPSContact__c AND Id !=: tMember.Id 
                    AND Target_List__r.iiCampaign__c = : tMember.Target_List__r.iiCampaign__c];
                        
                    for(Target_List_Member__c otherTargetMember : otherListTargetMembers){
                        if(otherTargetMember.Removed_Reason__c == 'Email Only' || otherTargetMember.Removed_Reason__c == null) {
                          otherTargetMember.Not_II_Friendly__c = tMember.Not_II_Friendly__c;
                          otherTargetMember.User_Who_Confirmed_Non_II_Friendly__c = tMember.User_Who_Confirmed_Non_II_Friendly__c;
                          
                          //all owners of that contact should have that contact's eligible for email flag changed to NO (regardless of TLM syncing mode setting)
                          if(tMember.Not_II_Friendly__c == true){
                            otherTargetMember.Eligible_for_email__c = false;
                            //if contact has additional owners, and that contact is on an email list for one or more of those owners, 
                            //remove that contact (contact should not be on email only list and have email flagged unchecked).  
                            //In this case, set the Removed Reason to "Email Only - Not Eligible for Email" 
                            if(otherTargetMember.Removed_Reason__c == 'Email Only'){
                              otherTargetMember.Removed_Reason__c = 'Email Only - Not Eligible for Email';
                            }
                      }
                    }
                }
                    otherListTargetMembers.add(tMember);
                    update otherListTargetMembers;
                }else{
                  update tMember;   
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        return null;
    }
    
    // Set Target List Member Status
    private void SetTragetListStatus(){
        // Call & Confirm vote = This is the DEFAULT Value
        if(tMember.Target_List_Status__c == null){
            tMember.Target_List_Status__c = 'Call & Confirm vote';
        }
        
        //Confirmed vote = Change to this status when they either 1) Record a Vote or 2) Mark the ballot as Contact would or could not reveal vote
                 
        if(tMember.Contact_would_not_reveal_vote__c == true || tMember.Blanket_Voter__c == true){ // if(tMember.Contact_would_not_reveal_vote__c == true ||tMember.Blanket_Voter__c == true){     -- //replaced by line below  25 Jul 2011 - Andrey Volosevich [JIRA: CRMGPS-193]
            tMember.Target_List_Status__c  = 'Confirmed vote';
        }else{
            if(tMember.Voted_in_II_Campaign__c == true){
                tMember.Target_List_Status__c  = 'Confirmed vote';
            //Made Warm-up Call = Change the status to this when they check off the "Made Warm-up Call" box
            }else if(tMember.Called_about_II__c == true){
                tMember.Target_List_Status__c  = 'Made Warm-up Call';
            }else{
                tMember.Target_List_Status__c = 'Call & Confirm vote';
            }
        }
    }
     
    
    
    public class CandidateSectorWrapper{        
        public Boolean isSelected {get;set;}
        public Candidate_Sector__c candidateSector {get;set;}
        public Boolean isVoterRecommend {get;set;}
        public String whyText {get;set;}
        public Boolean isVoteAlready {get;set;}
        public Boolean isDeleted{get;set;}
        public Boolean isVoterRecommendAlready {get;set;}
        public Boolean isRemovedVote {get;set;}
        
        public CandidateSectorWrapper(Boolean isVoterRecommend,Candidate_Sector__c candidateSector, String whyText, Boolean isVoteAlready, Boolean isDeleted, Boolean isRemovedVote){
            isSelected = false;
            this.whyText = whyText;
            this.candidateSector = candidateSector;
            this.isVoterRecommend = this.isVoterRecommendAlready = isVoterRecommend;
            this.isVoteAlready = isVoteAlready; 
            isSelected = (isVoteAlready == true)?this.isVoteAlready : isSelected;
            this.isDeleted = isDeleted;
            this.isRemovedVote = isRemovedVote;//04 July 2013 RP : CRMGPS 4215 Added this field to track if a voter recommendation is removed
        }       
        
    }
}