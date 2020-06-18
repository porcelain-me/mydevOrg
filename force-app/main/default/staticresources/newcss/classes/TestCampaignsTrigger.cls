/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCampaignsTrigger {

    static testMethod void ContactLanguageSyncTest() 
    {
         T1C_CustomSettingsManager.createChatterSetting(); 
   		 CM_TestClassUtilities.SetCamapignLimitSettings();
   		 T1C_CustomSettingsManager.setAllTriggerOn(); 
        
        List<GPSContact__c> lstContact = new List<GPSContact__c>();
        
        Set<Id> setcons = new Set<Id>();
        GPSAccount__c acc = new GPSAccount__c();
        acc.Name = 'firstName';
        acc.Trading_Name_ID__c = 'LT'+ Datetime.now().format('ddhhmmss');
        insert acc;
        // 01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
        GPSContact__c con = Common_ContactUtil.createContact(acc.id,  0, 'English Only');
        con.II_Language__c = 'English';
        lstContact.add(con);
        
        
        GPSContact__c con1 = Common_ContactUtil.createContact(acc.id, 1, 'Japanese Only' );
        con1.II_Language__c = 'Japanese';
        lstContact.add(con1);
       
        
        GPSContact__c con3 = Common_ContactUtil.createContact(acc.id, 2, 'Japanese Only');
        con3.II_Language__c = 'Japanese Only';
        lstContact.add(con3);
        
        
        GPSContact__c con4 = Common_ContactUtil.createContact(acc.id, 3, 'English Only');
        con4.II_Language__c = 'English Only';
        lstContact.add(con4);
        
        
        insert lstContact;
        for(GPSContact__c c: lstContact)
          {
            setcons.add(c.id);
          }
        
        Map<Id,GPSContact__c> mapContact = new Map<Id,GPSContact__c>([select id,Language_Preference__c,II_Language__c from GPSContact__c where id in: setcons]);
        
        //GPS Language is set to English Only
        system.assertEquals('English Only',mapContact.get(con.id).Language_Preference__c);
        
        //GPS Language is set to Japanese Only
        system.assertEquals('Japanese Only',mapContact.get(con1.id).Language_Preference__c);
        
        //iiLanguage is set to Japanese.
        system.assertEquals('Japanese',mapContact.get(con3.id).II_Language__c);
       
        //iiLanguage is set to English.
        system.assertEquals('English',mapContact.get(con4.id).II_Language__c);
        
       mapContact = new Map<Id,GPSContact__c>() ;  
       
       List<GPSContact__c> lstupcontact = [select id,Language_Preference__c,II_Language__c from GPSContact__c where id in: setcons];
       
       for(GPSContact__c c : lstupcontact)
       {
         if(c.II_Language__c =='English')
            c.II_Language__c ='Japanese';
         
         else
            c.II_Language__c ='English';
        }
            
      update lstupcontact;
      
      GPSContact__c c1 = [select id,Language_Preference__c,II_Language__c from GPSContact__c where Language_Preference__c =: 'English Only' limit 1];
      c1.Language_Preference__c = 'Japanese Only';
      update c1;
      
      c1 = [select id,Language_Preference__c,II_Language__c from GPSContact__c where Language_Preference__c =: 'Japanese Only' limit 1];
      c1.Language_Preference__c = 'English Only';
      update c1;
    }
    
    static testMethod void testUpdateDListItemActiveFlag() {
       T1C_CustomSettingsManager.createChatterSetting(); 
   		 CM_TestClassUtilities.SetCamapignLimitSettings();
   		 T1C_CustomSettingsManager.setAllTriggerOn(); 
        
        GPSAccount__c testAccount = new GPSAccount__c() ;
        testAccount.Name = 'test Account test' ;
        testAccount.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
        insert testAccount ;
        
        GPSContact__c testContact  = Common_ContactUtil.createContact((string)testAccount.Id, 1);
        insert testContact ;
        
        Distribution_List__c testList = new Distribution_List__c() ;
        testList.list_id__c = 'test id' ;
        insert testList ;
        
        DistributionListItem__c testItem = new DistributionListItem__c() ;
        testitem.DistributionList__c = testList.Id ;
        //02/02/2012 UV : added this primary key
        testitem.Primary_Key__c = testContact.id + '|' + testList.Id + '|';
        insert testItem ;    
        
        DistributionListItem__c item = [Select contact_active_flag__c from DistributionListItem__c where id = :testItem.Id] ;
        System.assertEquals(true,item.Contact_Active_Flag__c) ;
        
        
        testItem.GPSContact__c = testContact.Id ;
        update testItem ;
        
        item = [Select contact_active_flag__c from DistributionListItem__c where id = :testItem.Id] ;
        System.assertEquals(true,item.Contact_Active_Flag__c) ;
        
        testContact.Active_Flag__c = false ;
        update testContact ;
        
        item = [Select contact_active_flag__c from DistributionListItem__c where id = :testItem.Id] ;
        System.assertEquals(false,item.Contact_Active_Flag__c) ;

        delete testContact ;
        
        item = [Select contact_active_flag__c from DistributionListItem__c where id = :testItem.Id] ;
        System.assertEquals(false,item.Contact_Active_Flag__c) ;
        
    }
}