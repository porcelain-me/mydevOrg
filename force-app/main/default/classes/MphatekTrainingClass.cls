/*This is a sample Class
     * Written By : Saurabh 
     * Date : 20/11/2019
     * User Story : Training 
     */
public class MphatekTrainingClass {
    
    /*This is a static method
     * Written By : Saurabh 
     * Date : 20/11/2019
     * User Story : Training 
     */
    public static void myFirstMethod(){
        string firstString = 'saurabh';
        double firstDouble = 12.4564;
        datetime currentTime = System.now();
        date todaysDate = System.today();
        integer mySalary = 12;
       
        
        //Bulkifying the Code 
        List<Lead> leadList = new List<Lead>();
       
        
        
        //Creating new Instance of Lead Object
        Lead ld = new Lead();
        //Assigning some value to Lead Fields
         ld.LastName = 'MphatekTest';
         ld.Company = 'Mphatek';
         ld.City = 'Pune';
         ld.porcelain__Birth_Date__c = system.today();
         // Insert ld;bad way of doing DML
         leadList.add(ld); // Bulkified Way
        
         Lead ld1 = new Lead();
        //Assigning some value to Lead Fields
         ld1.LastName = 'MphatekTest1';
         ld1.Company = 'Mphatek1';
         ld1.City = 'Pune1';
         ld1.porcelain__Birth_Date__c = system.today();
         // Insert ld1;bad way 
        leadList.add(ld1);
        
        
        Insert leadList;
        
        
        //Collection Examples
        List<String> strLst = new List<String>();
        strLst.add('1');
        system.debug('listValues'+strLst+'multiple string'+strLst);
        
        Set<Integer> intSet = new Set<Integer>();
        intSet.add(1);
        system.debug('SetValues'+intSet);
        
        Map<String,Integer> strIntMap = new Map<String,Integer>();
        strIntMap.put('Saurabh',10);
        system.debug('MapValues'+strIntMap);
        
        
        system.debug('hello world'+mySalary);
        
        
        
        
        //simple Soql Example in Apex
       List<Lead> leadFromSoql = new List<Lead>([Select id, LastName from Lead limit 1]);
        //leadFromSoql = [Select id, LastName, Email from Lead where Email = 'Test@test.com'];
       string dummyname = leadFromSoql[5].LastName; 
        system.debug('stringName'+dummyname);
        
        List<Lead> leadsforUpdate = new List<Lead>();
        for(Lead leadElement : leadFromSoql ){
            leadElement.LastName = 'TestModify';
            leadsforUpdate.add(leadElement);
        }
       
        Update leadsforUpdate;
        
        
    }

}