@istest(seeAllData=false)

public class Testsearchutilitycontroller {
    
    public static PageReference pageRef = Page.searchUtility;
    
    @testSetup static void setupData(){
        
        List<GPSAccount__c> testAccts= new List<GPSAccount__c>();
        
        for(integer i=0;i<50;i++){
            
            testAccts.add(new GPSAccount__c(Name='Test Account'+ i,Trading_Name_ID__c='Trading'+i));
        }
        
        insert testAccts;
    
    
        List<GPSContact__c> testcons= new List<GPSContact__c>();
        
        for(integer i=0;i<50;i++){
            
            testcons.add(new GPSContact__c(FirstName__c='Test'+i,LastName__c='Contact',Trading_Name_ID__c=testAccts[i].Trading_Name_ID__c,Email__c='testContact@test.com',Account_Name__c=testAccts[i].Name,GPSAccount__c=testAccts[i].Id,CIS_Contact_Id__c='CIS'+i));
        }
        insert testcons;
        system.debug(testcons[0]);
    }
    
    @isTest static void nullSearch(){
        
        Test.startTest();
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='';
        
        control.lookup();       
        
        system.assert(ApexPages.getMessages().get(0).getDetail()=='Please enter text to search');
        
        Test.stopTest();
    }
    
      @isTest static void specialCharSearch(){
        
        Test.startTest();
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='--tt';
        
        control.lookup();       
        
        system.assert(ApexPages.getMessages().get(0).getDetail()=='For a valid search please put atleast 3 valid characters');
        
        Test.stopTest();
    }
    
      @isTest static void combinedSearch(){
        
        Test.startTest();
          
        Map<Id,GPSContact__c> contacts= new Map<Id,GPSContact__c>([Select Id from GPSContact__c where Name like 'Test%' limit 5]);  
          
		Map<Id,GPSAccount__c> accounts= new Map<Id,GPSAccount__c>([Select Id from GPSAccount__c where Name like 'Test%' limit 5]);            
          
        List<Id> fixedsearchresults= new List<Id>(contacts.keySet());
		
		fixedsearchresults.addAll(accounts.keySet()) ;          
                  
        Test.setFixedSearchResults( fixedsearchresults);
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='Test';
        
        control.isShowMOreAccounts=false;
          
        control.isShowMoreContacts=false;  
        
        control.lookup();
          
        system.assertEquals(5, control.con.size()) ;       
       
          
        system.assert(control.acc.size()==5);
          
        system.assert(control.isShowMoreContacts==false) ;
          
        system.assert(control.isShowMOreAccounts==false) ; 
              
        system.assert(control.currentOffset==0);
          
        system.assertEquals(false,control.hasNext);
          
        system.assert(control.hasPrev==false);            
        
        Test.stopTest();
    }
    
      @isTest static void showAllaccountsearch(){
        
        Test.startTest();
          
        
          
		Map<Id,GPSAccount__c> accounts= new Map<Id,GPSAccount__c>([Select Id from GPSAccount__c where Name like 'Test%' limit 26]);            
          
        List<Id> fixedsearchresults= new List<Id>(accounts.keySet());
		
		          
                  
        Test.setFixedSearchResults( fixedsearchresults);
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='test';       
          
        control.isShowMOreAccounts=true;
          
        control.isShowMoreContacts=false;  
          
        control.lookup();
          
        system.assert(control.acc.size()==25);  
        
        system.assert(control.hasNext==true);
          
        system.assert(control.hasPrev==false);  
        
        Test.stopTest();
    }
    
     @isTest static void showAllcontactsearch(){
        
        Test.startTest();
         
        Map<Id,GPSContact__c> contacts= new Map<Id,GPSContact__c>([Select Id from GPSContact__c where Name like 'Test%' limit 26]);  
          
		
          
        List<Id> fixedsearchresults= new List<Id>(contacts.keySet());
		
		
                  
        Test.setFixedSearchResults( fixedsearchresults);
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='Test';       
          
        control.isShowMoreContacts=true;
         
        control.isShowMOreAccounts=false; 
          
        control.lookup();
          
        system.assert(control.con.size()==25);  
        
        system.assert(control.hasNext==true);
          
        system.assert(control.hasPrev==false);  
        
        Test.stopTest();
    }
    
      @isTest static void testnextandprev(){
        
        Test.startTest();
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='Account';       
          
        control.isShowMoreContacts=true;
        
        control.isShowMOreAccounts=false;  
          
        control.lookup();
          
		control.next();
          
        system.assertEquals(true,control.hasPrev);
        
        control.prev();
          
        system.assert(control.hasPrev==false);
          
        Test.stopTest();
    }
    
        
    @isTest static void noresults(){
        
        Test.startTest();
        
        test.setCurrentPage(pageRef);
        
        searchutilitycontroller control= new searchutilitycontroller();
        
        control.searchstring='zzzzz';
        
        control.lookup();       
        
        system.assert(ApexPages.getMessages().get(0).getDetail()=='Search Returned no Results');
        
        Test.stopTest();
    }
}