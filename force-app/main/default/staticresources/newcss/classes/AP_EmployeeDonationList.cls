/******************************************************************************************
* Annual Pledge Emploee Donation List Controller   
*
* Used for the email complonenet
*
* ChangeLog:
*
*   8/19/2016 - Created by Mark R. Moser
*   
*   
*******************************************************************************************/
public with sharing class AP_EmployeeDonationList {
	
	public Employee__c e {get;set;}
	public List<Employee_Giving__c> employeeDonationList {get;set;}
	public String currencyText {get;set;}
	public List<wrapDonations> wrapDonationList {get;set;}

	/* Standard Controller */
	public AP_EmployeeDonationList() {
    	
    	User u = [select emp_id__c from User where id = :UserInfo.getUserId()];
    	e = [select id from Employee__c where emp_id__c = :u.emp_id__c];
  	
  		wrapDonationList = new List<wrapDonations>();
  		
  		loadDonationList();	
    }
    
    /********************************************************************************************************
      	Load the dontaion list for this year
    ********************************************************************************************************/
    
    public void loadDonationList(){
    	 
    	String year = string.valueOf(date.today().year());
    	Decimal total = 0;
    	
    	employeeDonationList = [select amount_text__c
    								,charity__r.name
    								,currency__c
    								,amount__c
    							from Employee_Giving__c
    							where employee__c = :e.id
    							and year__c = :year
    							order by charity__r.name
    							];
    	
    	if (!employeeDonationList.isEmpty())
    		currencyText = employeeDonationList[0].currency__c;
    		
    	for (Employee_Giving__c g:employeeDonationList){
    		wrapDonationList.add(new wrapDonations(g.amount_text__c, g.charity__r.name,currencyText, g.amount__c));
    		total += g.amount__c;
    	}
    	
    	wrapDonationList.add(new wrapDonations(String.valueOf(total), 'Total', currencyText, total));
    
    }
 	/********************************************************************************************************
      	Wrap Donations
    ********************************************************************************************************/
   
	 public class wrapDonations {

        public String amountText {get;set;}
        public String name {get;set;}
        public String curr {get;set;}
        public Decimal amount {get;set;}
     
     
    	public wrapDonations(String amountText, String name, String curr, Decimal amount){
    		this.amountText = amountText;
    		this.name = name;
    		this.curr = curr;
    		this.amount = amount;
    	} 
       
    }
     
}