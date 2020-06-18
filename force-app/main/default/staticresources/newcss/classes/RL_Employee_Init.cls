/*************************************************************************
* MRM - 5/7/14 Created Page
* 
*   This controller supports the employee facing Reference Letter request 
*   page.
*
* Change log:
* 06/24/2015 - Avinash Munaga
* 				methods added to support exception page handling
*
****************************************************************************/
public without sharing class RL_Employee_Init {
    
    
    public Employee__c requestorEmp {get;set;}   //requestor
    public String Regiondesc{get;set;}
    public User u {get;set;}
    
    public Boolean isContingent {get;set;}
    public Boolean isNA {get;set;}
    public Boolean isAsiaJV {get;set;}
    
    public boolean Button1{get;set;}
    public Boolean showAPACSLA {get;set;}
    public Boolean showEMEASLA {get;set;}
    
    public string e {get;set;}
    public string exceptionCause {get;set;}
    public string exceptionDetail {get;set;}
    public string exceptionLineNum {get;set;}
    public String timeX {get;set;}
    public String devInfo {get;set;}
    
    public String showInstance{get; set;}
    
    /*****************************************************************
    * Constructor
    *
    ******************************************************************/
    public RL_Employee_Init(){
    	
    	isContingent = false;
    	isNA = false;
    	isAsiaJV = false;
    	
    	Button1 = false;
    	
    	String urlVal = System.Label.ORG_ENVIRONMENT;
        // System.debug('Page URL: ' + urlVal);
        // if(!urlVal.contains('PROD') && !urlVal.contains('prod')){
            // showInstance = 'DEV';
        showInstance = urlVal;
        /*} else if(urlVal.contains('qa')) {
            showInstance = 'QA';
        } else if(urlVal.contains('uat')) {
            showInstance = 'UAT';
        }*/
        
        /* find the employee id for example 59XYZ */
        try{
        	u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
        
            requestorEmp = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c
            				, Job_Title__c, Status__c, Division_Org__c, Super_Division__c, Country_Dsc_Home__c, CC_Region_Org__c
            				, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
                            , Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c
                            , job_region_code__c, Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from employee__c 
                            where emp_id__c = :u.Emp_id__c];
            
            // Checking whether employee is contingent
            //added by sanjib
            if(requestorEmp.Empl_Class_Job__c=='A' || requestorEmp.Empl_Class_Job__c=='I' || requestorEmp.Empl_Class_Job__c=='U'
               || (requestorEmp.Empl_Class_Job__c=='C' && requestorEmp.Employee_Sub_Class__c=='R')) {
                   isContingent = false;
               } else {
                   system.debug('****************'+isContingent);
                   isContingent = true;
               }
            
            // to show NA user Disclaimer for the user
            isNA = false;
            if(requestorEmp.get('Job_Region_Code__c') == 'NJ' || requestorEmp.get('Job_Region_Code__c')== 'JA'){
            	if(requestorEmp.Job_Country_Job__c == 'CHN' 
            			&& requestorEmp.Division_Org__c == '94150' 
            			&& requestorEmp.Super_Division__c=='10100') {
            		showAPACSLA = false;
	                showEMEASLA = false;
	                
	                isAsiaJV = true;
                	isContingent = false;
            	} else {
            		showAPACSLA = true;
                	showEMEASLA = false;
                	Button1 = true;
            	}
            } else if(requestorEmp.get('Job_Region_Code__c')== 'EU') {
                showAPACSLA = false;
                showEMEASLA = true;
                Button1 = true;
            } else if(requestorEmp.Job_Region_Code__c == 'NA') {
                showAPACSLA = false;
                showEMEASLA = false;
                
                isNA = true;
                isContingent = false;
            }
            
            e = ApexPages.currentPage().getParameters().get('e');
            exceptionCause = ApexPages.currentPage().getParameters().get('cause');
            exceptionDetail = ApexPages.currentPage().getParameters().get('message');
            exceptionLineNum = ApexPages.currentPage().getParameters().get('lineNum');
     		devInfo = ApexPages.currentPage().getParameters().get('devInfo');
     		DateTime now = system.now();
     		timeX = now.format();
            
        } catch(Exception e){
            System.debug('Exception in requestorEmp' + e);
        }
    }
    
    /*****************************************************************
     * 06/24/2015
     * goHome
     * Return to Home page
     * used in RL_Sys_Exception page
     ******************************************************************/
    public pageReference goHome(){
        
        String url='/apex/RL_Home';
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
    }
    
    /*****************************************************************
     * 06/24/2015
     * emailNotification
     * email sent with excpetion details
     * used in RL_Sys_Exception page
     ******************************************************************/
    public void emailNotification() {
    	
    	String emailSubject = System.Label.ORG_ENVIRONMENT + ' - Exception Notification'; 
    	
    	String emailContent = '<html><div>';
    	emailContent += '<span>User:' + u.name + ' </span><br/>';
    	emailContent += '<span>Time:' + timeX + '</span><br/><br/>';
    	if(e != null || e != '')
    		emailContent += '<span>Exception: ' + e + ' </span><br/>';
    	if(exceptionCause != null && exceptionCause != '')
    		emailContent += '<span>Root Cause: ' + exceptionCause + ' </span><br/>';
		if(exceptionDetail != null && exceptionDetail != '')
    		emailContent += '<span>Exception Detail: ' + exceptionDetail + '</span><br/>';
    	emailContent += '<span>Developer Info: ' + devInfo;
    	if(exceptionLineNum != null && exceptionLineNum != '')
    		emailContent += 'at line ' + exceptionLineNum + '</span><br/>';
    	else 
    		emailContent += '</span><br/>';
    	emailContent += '</div></html>';
    	
    	// instantiate SendMailHelperClass
    	SendMailHelperClass mailHelper = new SendMailHelperClass();
    	
    	// build SingleEmailMessage instance by calling method from helper class
    	Messaging.SingleEmailMessage email = mailHelper.createEmailInstance(emailContent, emailSubject);
    	
    	// send mail calling method from helper class
    	if(email != null){
    		mailHelper.sendEmail(email);
    	}
    }
}