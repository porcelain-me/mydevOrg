// 
//   (c) 2010 Appirio, Inc.
//
//   MyListReassignmentController (Controller class for MyListReassignment)
//	 Display Target List users od the iiCampians
//
//   27 Jul 2010   Chetan Garg    Original (R-05520).	
//   28 Oct 2010   Added query string parameter 'listType' for [PR-06854].

public with sharing class MyListReassignmentController {
	 public List<Target_List__c> targetLists {get;set;}
	 public Target_List__c currentTargetList {get;set;}
	 public ApexPages.StandardSetController stdSetCon {get;set;}
	 public String targetListId{get;set;}
	 public String searchText {get;set;}
	 public String result {get;set;}
	 public String action{get;set;}
	 public List<Integer> pageIndexList{ get; set;}
	 public Integer currentPage{ get; set;}
	 public String listtype {get;set;}
	 
	 public MyListReassignmentController(){
	 	  result ='';
	      action = 'next';
	      targetLists = new List<Target_List__c>();
	      pageIndexList = new Integer[3];
	      
	      system.debug('*******************MyListReassignmentController***********');
	      
	      system.debug('*******************MyListReassignmentController***********');
	  
	  if(Apexpages.currentPage().getParameters().get('listType') != null && Apexpages.currentPage().getParameters().get('listType') != ''){
	 		listtype = Apexpages.currentPage().getParameters().get('listType');
			}    
	 	
	 	if(Apexpages.currentPage().getParameters().get('list') != null 
	 							&& Apexpages.currentPage().getParameters().get('list') != ''){
	 		targetListId = Apexpages.currentPage().getParameters().get('list');
	 		system.debug('*******************targetListId***********'+targetListId);
	 			
	 		for(Target_List__c target : [Select id, iiCampaign__c from Target_List__c Where id =: targetListId]){
	 			currentTargetList = target;
	 		}
	 		system.debug('*******************currentTargetList***********'+currentTargetList);
	 		if(currentTargetList != null){
	 			doSearch();
	 		}
	 	}
	 }
	 
	 public void doSearch(){
	 	String searchUser = '';
	 	if(searchText == null){
	 		searchUser ='%';
	 	}else{
          searchUser = searchText.replaceAll('\'','\\\'');
          searchUser = '%' + searchText +'%';
	 	}
	 	
	          
	 	String soql =  'Select id, iiCampaign__c, User__c,User__r.Name, Preferred_User__c ' + 
  					   ' From Target_List__c ' +
  					   ' Where iiCampaign__c =\''+currentTargetList.iiCampaign__c+'\' AND User__c != null ' + 
  					   ' AND ID <> \''+ currentTargetList.id+ '\'  AND Preferred_User__c like \''+searchUser +'\'' +
  					   ' Order BY User__r.Name asc';
	      stdSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
	      updateCurrentPage();
	 }
	 
	  
	  private void updateCurrentPage(){
	      currentPage = stdSetCon.getPageNumber();
	      targetLists = (List<Target_List__c>)stdSetCon.getRecords();
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
	  
	  
	  
	  public void first() {
	      stdSetCon.first();
	      updateCurrentPage();
	   }
	    
	    public void last() {
	        stdSetCon.last();
	        updateCurrentPage();
	    }
	    public void previous() {
	        stdSetCon.previous();
	        updateCurrentPage();
	    }
	    public void next() {
	        stdSetCon.next();
	        updateCurrentPage();
	    }
	    public void getRecordByPageNo() {
	        stdSetCon.setPageNumber(currentPage);
	        updateCurrentPage();
	    }
	    public Boolean hasNext {
	        get{
	        	if(stdSetCon==null) return false;
	          return stdSetCon.getHasNext();
	        }
	        set;
	    }
	    
	     public Boolean hasPrevious {
	        get {
	        	if(stdSetCon==null) return false;
	            return stdSetCon.getHasPrevious();
	        }
	        set;
	    }
	     public Boolean isFirst{
	        get{
	        	if(stdSetCon==null) return false;
	           return (stdSetCon.getPageNumber() != 1);
	        }
	        set;
	    }
	    
	     public Boolean isLast{
	        get {
	        	if(stdSetCon==null) return false;
	           return (stdSetCon.getPageNumber()!= (stdSetCon.getResultSize()/stdSetCon.getPageSize()));
	        }
	        set;
	    }
	    
	  
	  private void populatePageIndexList() {
	    Integer totalResult  = stdSetCon.getResultSize();
	    Integer pageSize = stdSetCon.getPageSize();
	    pageIndexList.clear();
	    
	    Integer sPage;
	      Integer ePage;
	      Integer cPage = stdSetCon.getPageNumber();
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