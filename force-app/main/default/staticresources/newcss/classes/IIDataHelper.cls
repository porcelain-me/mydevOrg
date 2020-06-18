/***
* 
*   (c) 2009 Appirio, Inc.
*
*   Data Helper class II Application  
*
*   03 March 2011     Chetan Garg       Original
*   09 March 2011     Parth Tamhaney    Added loop to avoid Too Many Ids retrieved Error
*   10 March 2011     Svatka Simpson    Adding where clause to getAllPriorityContacts ->
*                                       show priority contacts with relationship type = P
*   14 March 2011 	 Urminder			Rename method getAllPriContacts to getUniquePriContacts
*   28 Sept 2011	Parth T				Added limit to query in getAllPriorityContacts
*   18/03/2016:		Swapnd				Replaced Employee__c with GPSEmployee__c by Swapnd
**/
public class IIDataHelper {

  //Return all priotity contacts for Canidate's MsId
  //Param @msId => Candidate's MsId
  public static List<Priority_Contacts__c> getAllPriorityContacts(String msId){     
     return [Select GPSEmployee__r.MS_ID__c,GPSEmployee__c, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name, GPSContact__r.II_Company__c,
                GPSContact__r.FirstName__c, GPSContact__r.LastName__c, GPSContact__c,Active_Flag__c               
            From Priority_Contacts__c
            Where Active_Flag__c = true AND (GPSEmployee__r.MS_ID__c =:msId or GPSEmployee__r.User__r.Emp_ID__c = :msId )
            AND Relationship_Type__c = 'P' 
            order by GPSContact__r.Name limit :(Limits.getLimitQueryRows()- Limits.getQueryRows()) 
            ];
    
  }
  
  //Dummy Company:- This account is refered for the contacts whose account = null 
  //and ii_Company__c =<somecompany> and created by ad-hoc contact dialog
  private static GPSAccount__c dummyCompany;
  //Return Dummy Company Account
  public static GPSAccount__c getDummyCompany(){
  	if(dummyCompany == null){
  		for(GPSAccount__c acc :[select id, name from GPSAccount__c where Name = 'Dummy Company']){
  			dummyCompany = acc;
  		}
  	}
  	return dummyCompany;
  }
  
  
   //Return all Unique priotity contacts for Canidate's MsId
  //Param @msId => Candidate's MsId
  public static List<GPSContact__c> getUniquePriContacts(String msId){ 
     Set<Id> conIds = new Set<Id>();
     return  [Select Name, GPSAccount__r.Name, II_Company__c, id, FirstName__c, LastName__c
              FROM GPSContact__c 
              Where id in (Select GPSContact__c             
                            From Priority_Contacts__c
                            Where Active_Flag__c = true AND Relationship_Type__c = 'P'
                            AND (GPSEmployee__r.MS_ID__c =:msId or GPSEmployee__r.User__r.Emp_ID__c = :msId )
                            ) 
              order by Name];
    
  }
}