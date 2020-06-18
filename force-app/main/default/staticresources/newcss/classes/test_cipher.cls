/*************************************************************************
* MRM - 5/7/14 Created Page
* 
*   This controller supports the employee facing Reference Letter request 
*   page.
*
*
****************************************************************************/
public without sharing class test_cipher {    
    
        
     
    public Employee__c e {get;set;}
    public String gender {get;set;}
    
     
    /*****************************************************************
    * Constructor
    *  
    ******************************************************************/
    public test_cipher(){
        
       e = [select gender_dsc__c from Employee__c where id = 'a00f0000005q97f'];
       
    }
    
     public void setGender(){
     	
     	system.debug('setting gender to:' + gender);
     	if (gender == 'Male')
     		system.debug('is male');
     	else
     	if (gender == 'Female')
     		system.debug('is female');
     	
     	update e;
     		
     }
}