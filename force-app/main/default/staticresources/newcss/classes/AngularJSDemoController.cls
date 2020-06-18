// Modified by Avinash on 02/03/2016
// looks like a class created for some random testing

@isTest
public with sharing class AngularJSDemoController{ 
    
    public transient String AccountList { get; set; }
    
    //Subclass : Wrapper Class 
    public class Accountwrap {
        //Static Variables 
        public string id;
        public string name;
        public string emp_id;
        
        //Wrapper  Class Controller
        Accountwrap() {
            emp_id = '';
        }
        
    }
       
    //Method to bring the list of Account and Serialize Wrapper Object as JSON
    public  static String getlstAccount() {
        List < Accountwrap > lstwrap = new List < Accountwrap > ();
        List < Employee__c> lstacc = [SELECT Id, Name, emp_id__c
                                   FROM Employee__c limit 50000 
                                  ];
        for (Employee__c a: lstacc) {
            Accountwrap awrap = new Accountwrap();
            awrap.id = a.id;
            awrap.name = a.name;
            if (a.emp_id__c!= null) {
                awrap.emp_id = a.emp_id__c;
            }
            lstwrap.add(awrap);
        }
        return JSON.serialize(lstwrap);
     }
    
}