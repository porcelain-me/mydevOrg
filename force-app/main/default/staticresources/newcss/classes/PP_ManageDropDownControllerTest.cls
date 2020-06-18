@isTest (SeeAllData = false) 
public class PP_ManageDropDownControllerTest {
list<Building_Locations__c> TempValueList{get;set;}
List<PP_categoryWrapper> categories {get;set;}
    
    static testmethod void PPRecord()
      {
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser)
         {
                  
           	 Building_Locations__c BL=new Building_Locations__c(name = 'MyBuilding1', Address1__c='Address1',Address2__c='Address2',CITY_DESCRIPTION__c  ='City',InScopeFrom__c=false,PROPERTY_STATUS__c='ACTIVE');
             insert BL;
           	 system.debug('----------------- Building Location ---------------'+BL);           
           	
             
             //Building_Locations__c TempValueList = [select id,name from Building_Locations__c where id = :BL.id];
			 
             
             PP_ManageDropDownController MD = new PP_ManageDropDownController();
             
             MD.getFromLeftList();
             
             Building_Locations__c BL1=new Building_Locations__c(name = 'MyBuilding1', Address1__c='Address1',Address2__c='Address2',CITY_DESCRIPTION__c  ='City',InScopeFrom__c=true,PROPERTY_STATUS__c='ACTIVE');
             insert BL1;
           	 system.debug('----------------- Building Location ---------------'+BL1);
             
             
             Building_Locations__c TempValueList = [select id,Name, Address1__c,Address2__c,CITY_DESCRIPTION__c  
                             from Building_Locations__c where InScopeFrom__c = true 
                             and PROPERTY_STATUS__c='ACTIVE' and id = :BL1.id order by name asc limit 1];
             MD.getRegionOptions();
             MD.regionFilter();
             MD.getFromRightList();
             MD.cancel();
             MD.ClickLeft();
             MD.ClickRight();             
             MD.ManageFrom();
             MD.goBackToAdminPage();
             MD.first();
             MD.last();
             MD.previous();
             MD.next();
             MD.getCategories();
             MD.hasNext = true;
             MD.hasPrevious = true;
             MD.pageNumber=2;
         }
          Test.stopTest();
           Integer i = [SELECT COUNT() FROM Building_Locations__c];
            System.assertEquals(i, 2); 
      }
    
}