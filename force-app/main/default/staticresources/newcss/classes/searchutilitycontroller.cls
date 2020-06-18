/*
 * 
 *  @File				: searchUtility
 * 	@LastChanged		: 
 * 	@Purpose			:   HR does not have global search feature available
					  		which limits the ability of certain campaign users
					  		to search and target the Contacts.This Controller 
							is part of Page designed to facilitate the search feature.
 * 	@Author				:  Amit Tripathi, CapGemini
 * 	@History			:  SOSl to SOQL as too many results were returned.
 * 						:  Added Phone, Email TN Id in search.
 * 						:  Removed Phone, Email TN Id from query.  
 * 						:  Updated to begins with search instead of contains.
 *						:  Added sortOrder and order by feature on columns.
						:  Reverted to SOSL	and used in Sidebar fields to allow search on Email and CIS ID fields.
 *
 *
 */

public class searchutilitycontroller {
    
    public string searchstring {get;set;}
    
    public string sortOrder {get;set;}
    
    public string orderBy {get;set;}
    
    public list<GPSContact__c> con {get;set;}
    
    public list<GPSAccount__c> acc {get;set;}
    
    public string searchKey {get;set;}
    
    public boolean isShowMoreContacts {get;set;}
        
    public boolean isShowMOreAccounts {get;set;}
    
    public integer currentOffset {get;set;}
    
    public boolean hasNext {get;set;}
    
    public boolean hasPrev {get;set;}
    
    public list<string> splitString {get;set;}
    
    public boolean showHeaderTabs {get;set;}
    
    private final integer pageSize=25; 
    
    public String iTrakUserName { get; set; }
    
    public searchutilitycontroller(){
        
        currentOffset=0;
        
        hasNext=false;
        
        hasPrev=false;
        
        isShowMoreContacts=false;
        
        isShowMOreAccounts=false;
        
        sortOrder='asc';
        
        orderBy='Name';
        
        showHeaderTabs = true;
        iTrakUserName = Userinfo.getUserName();
        
        if(ApexPages.currentPage().getParameters().get('showheadertabs') != null){
        	if (ApexPages.currentPage().getParameters().get('showheadertabs') == 'false'){
        		showHeaderTabs = false;
        	}        	
        }
    }
    
    public pagereference lookup(){
        
        try{           
            
       	system.debug('currentOffset='+currentOffset);
        //initialize the list, also works as nullifying the list of previous results.
       	con=new list<GPSContact__c>();
        
        acc= new list<GPSAccount__c>();
            
        splitString=new List<string>();    
        
        if(searchstring=='' || searchstring== null){
            
			apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please enter text to search'))	;		
            
        }   
     
		 searchKey=searchstring.replaceAll('\\(','\\(').replaceAll('\\)','\\)').trim();
	        
	     system.debug('search for='+searchKey);
	        
	     searchKey=searchKey.remove('+').remove('(').remove(')').remove('-').remove('*');   
	     
	            
	            
	     searchKey=string.escapeSingleQuotes(searchKey);
	            
	     if(searchKey.length()<3){
	                
	        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'For a valid search please put atleast 3 valid characters'));
	               
	        return null;  
	                
	      }            
	      
	     
		 searchKey=searchKey+'*';
	        
	     String query='Find :searchKey  in SIDEBAR FIELDS returning '   ;
	        
	     String contactQuery=' GPSContact__c(Id,Name,Account_Name__c,Phone__c,Email__c,Trading_Name_Id__c,CIS_Contact_Id__c,Active_Flag__c  ';   
	        
	     string accountQuery=' GPSAccount__c(Id,Name,Trading_Name_Id__c,PSL_NA_Core__c  ' ; 
     
        
                    
		//Check if the search contains spaces then consider them as separate terms.
      /*if(searchKey.containsWhitespace()) {
         system.debug('in whitespace block');       
         splitString=searchKey.split(' ');
                
      }     
        		
             string query='Select ';
                    
             String contactQuery = ' Id,Name,Account_Name__c,Phone__c,Email__c,'+
                                    'Trading_Name_Id__c,CIS_Contact_Id__c,Active_Flag__c from GPSContact__c ';
                                    
                                 
                 					 
                 
             string accountQuery = ' Id,Name,Trading_Name_Id__c,Phone__c from GPSAccount__c ';
                                    
                 					
           
            
            system.debug(splitString.size());          
            
            
            if(splitString.size()>0){
                
                contactQuery+=' where';
                    
                accountQuery+=' where ';
                system.debug('Inside split string block');
                
                string clause1=' ';
                
                string clause2=' ';
                
                string clause3='';
                
                string clause4='';
                
                for(string s: splitString){                    

                   
                    if(s.deleteWhitespace().length()>0){
                        
                        clause1+=' Name like \'%'+s+'%\' ';
                        
                        clause2+=' Account_Name__c like \'%'+s+'%\'';
                
               			accountQuery+=' Name like \'%'+s+'%\''; 
                        
                    } 
                    
                    clause1+=' or ';
                    
                    clause2+=' or ';
                    
                    accountQuery+=' or ';
                } 
                
                
                
                system.debug('Query='+clause1);
            
             	system.debug('Query='+clause2);
                
                //contactQuery=contactQuery.removeEndIgnoreCase('or');
                
                clause1=clause1.removeEndIgnoreCase(' or ');
                    
                clause2=clause2.removeEndIgnoreCase(' or ');
                
                contactQuery+=' ('+clause1+') and ('+ clause2+') ';
                    
                accountQuery=accountQuery.removeEndIgnoreCase(' or ');
                
                system.debug('Query='+contactQuery);
            
             	system.debug('Query='+accountQuery);
                
                system.debug('currentOffset='+currentOffset);
            }
            else{
                
                system.debug(' else block for single word search');
                
                contactQuery+=' where Name like \''+searchKey+'%\' or Account_Name__c like \''+searchKey+'%\' or Email__c like \''+searchKey+'%\'  or CIS_Contact_Id__c like \''+searchKey+'%\'';
                    
                accountQuery+=' where Name like \''+searchKey+'%\'';    
                
            }*/
            
            contactQuery+= ' order by '+ orderBy +' ' +sortOrder+' limit 5 offset 0 )';
                
            accountQuery+= ' order by Name '+sortOrder+' limit 5 offset 0 )' ; 
            
            system.debug('Query='+contactQuery);
            
            system.debug('Query='+accountQuery);
            
            
            if(isShowMoreContacts) {
                
	            system.debug('currentOffset='+currentOffset);
	            
	            contactQuery=query+contactQuery.replace('limit 5','limit 26').replace('offset 0','offset '+currentOffset);
	            
	            system.debug('Query='+contactQuery);
	            
	            //con=database.query(contactQuery);
	            
	            con=(list<GPSContact__c>)search.query(contactQuery)[0];
	            
	            hasNext=con.size()>pageSize?true:false ;
	            
	            if(con.size()>pageSize)
	                
	                con.remove(pageSize);
	            
	         	hasPrev=currentOffset==0?false:true;
	            
	         	system.debug('hasNext='+hasNext);
	            
	         	system.debug('hasPrev='+hasPrev);               
            
        } 
        
        else if(isShowMoreAccounts){
            
            system.debug('currentOffset='+currentOffset);
            
            accountQuery=query+accountQuery.replace('limit 5','limit 26').replace('offset 0','offset '+currentOffset);            
            
            system.debug('Query='+accountQuery);
            
            //acc=database.query(accountQuery);
            
            acc=(list<GPSAccount__c>)search.query(accountQuery)[0];
            
            hasNext=acc.size()>pageSize?true:false ;
            
            if(acc.size()>pageSize)
                
                acc.remove(pageSize);
            
            hasPrev=currentOffset==0?false:true;
            
            system.debug('hasNext='+hasNext);
            
            system.debug('hasPrev='+hasPrev);
            
            
        }
        
        else{
            
            query=query+contactQuery+' , '+accountQuery;
            
            List<List<sObject>> searchResults=search.query(query);
            
            acc= ((list<GPSAccount__c>)searchResults[1]) ; 

			con= ((list<GPSContact__c>)searchResults[0]) ; 
            
            /*contactQuery=query + contactQuery;
            
            system.debug('Query='+contactQuery);
            
            accountQuery=query + accountQuery;
            
            system.debug('Query='+accountQuery);
            
            acc=database.query(accountQuery);
            
            con=database.query(contactQuery);*/
            
            
            system.debug('isShowMoreContacts='+isShowMoreContacts);
            
            system.debug('isShowMoreAccounts='+isShowMoreAccounts);
            //If no results returned show message
            if(acc.size()==0 && con.size()==0){
                
               apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Search Returned no Results'))	;		
                
            }
        }   
        
     		return null;  
            
        } 
        catch(Exception e){
            
            apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Error,e.getMessage()))	;
            
            return null;
        }
    }
    // Called when Next is clicked, sets the offset and then call look up method.
    public pagereference next(){
        
        currentOffset=currentOffset+pageSize;
        
        if(currentOffset<2000)
        
        	lookup();
        
        else
            
            apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Info,' You have reached Limit for search Results, please refine search and try again'))	;
            
        
        return null;
        
    }
    //Called when previous is clicked, sets the offset and then call look up method.
    public pagereference prev(){
        
        currentOffset=currentOffset-pageSize;        
        
        lookup();
        
        return null;
        
    }

}