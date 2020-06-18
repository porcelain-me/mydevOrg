@isTest
public class RIF_RegionalAccrualsUploadControllerTest{

    public static testmethod void regionalAccrualUploadTest1(){
    
        
        
       Test.startTest();        
        RIF_RegionalAccrualsUploadController accUpldctrlr = new RIF_RegionalAccrualsUploadController();
     
 
          accUpldctrlr.fileNameCSV= '';
       	//String content = '924RP,GBR,500,CAN,15,GBR,Y,08/05/2016,1234,OPERATIONS PROD MGMT-TFR,750,98342,Corporate Services,82000,81000,25,GBR,3/22/2016,N,114,Test,10100,Institutional Securities,05/22/2016,Y,Y,300,GBR,15,GBR,300,GBR,50,GBR,340000,USD,300,CAN,34000,CAN,11/04/2012,11/05/2016,11,7948,230,GBR,800,CAN,Y,N,10/02/2016,Active';    
	  accUpldctrlr.csvFileBody = Blob.valueOf('Accrual_Information__c.Emp_ID__c,'+'Accrual_Information__c.BASE_CURRENCY__C,'+'Accrual_Information__c.BENEFITS__C,'+'Accrual_Information__c.Curr_Benefits__c,'+'Accrual_Information__c.Buy_Out_of_Notice_Per_Lcl__c,'+'Accrual_Information__c.Curr_Buyout_of_Notice_Pd__c,'+'Accrual_Information__c.COMMUNICATED__C,'+'Accrual_Information__c.COMMUNICATED_DATE__C,'+'Accrual_Information__c.COST_CENTER__C,'+'Accrual_Information__c.COST_CENTER_DESC__C,'+'Accrual_Information__c.DAILY_RATE__C,'+'Accrual_Information__c.DEPARTMENT__C,'+'Accrual_Information__c.DEPARTMENT_DESC__C,'+'Accrual_Information__c.DIVISION__C,'+'Accrual_Information__c.DIVISION_DESC__C,'+'Accrual_Information__c.Enhanced_Severance_Lcl__c,'+'Accrual_Information__c.Curr_Enh__c,'+'Accrual_Information__c.LAST_DAY_ON_PREMISES__C,'+'Accrual_Information__c.SEVERANCE_PACKAGE_COMMUNICATED__C,'+'Accrual_Information__c.SUPER_DEPARTMENT__C,'+'Accrual_Information__c.SUPER_DEPARTMENT_DESC__C,'+'Accrual_Information__c.SUPER_DIVISION__C,'+'Accrual_Information__c.SUPER_DIVISION_DESC__C,'+'Accrual_Information__c.TERMINATION_DATE__C,'+'Accrual_Information__c.VOLUNTARY_INVOLUNTARY_FLG__C,'+'Accrual_Information__c.WORK_REQUIREMENT_FOR_SEVERANCE__C,'+'Accrual_Information__c.PIL,'+'Accrual_Information__c.Currency_PIL,'+'Accrual_Information__c.Buy_Out_of_Termination__c,'+'Accrual_Information__c.Curr_Buyout_of_Term__c,'+'Accrual_Information__c.EX_GRACIA_CASH_PAYMENT__C,'+'Accrual_Information__c.Curr_ExGCsh__c,'+'Accrual_Information__c.PENSION_CONTRIBUTION__C,'+'Accrual_Information__c.Curr_PenCont__c,'+'Accrual_Information__c.SOCIAL_INSURANCE__C,'+'Accrual_Information__c.Curr_SocialIns__c,'+'Accrual_Information__c.STATUTORY_REDUNDANCY_PAY__C,'+'Accrual_Information__c.Curr_StatRed__c,'+'Accrual_Information__c.TERMINATION_BONUS__C,'+'Accrual_Information__c.Curr_TermBon__c,'+'Accrual_Information__c.CONSULTATION_START_DATE__C,'+'Accrual_Information__c.CONSULTATION_END_DATE__C,'+'Accrual_Information__c.NOTICE_DAYS__C,'+'Accrual_Information__c.NOTICE_AMOUNT__C,'+'Accrual_Information__c.BASIC_SEVERANCE__C,'+'Accrual_Information__c.Cur_Basic_Severance__c,'+'Accrual_Information__c.ADDITIONAL_SEVERANCE__C,'+'Accrual_Information__c.Curr_Additional_Severance__c,'+'Accrual_Information__c.Signed_Release_Returned__c ,'+'Accrual_Information__c.EVENT_RELATED_TERM__C,'+'Accrual_Information__c.Latest_Payroll_Sent_Date__c,'+'Accrual_Information__c.Accrual_Type\n'+
                                                ' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,');   
        accUpldctrlr .importCSVFile();
        accUpldctrlr .refreshPage();
        //accUpldctrlr.createErrorMessageWithMSID('row[1]', ' ,','Please Upload a CSV file.');
        accUpldctrlr.errorMessageString=null;
        //accUpldctrlr.test_method();
        
         RIF_RegionalAccrualsUploadController.wrapperError wrpprErr = new RIF_RegionalAccrualsUploadController.wrapperError ('0','error','empid');
         wrpprErr.empID=null ;
         wrpprErr.errorMessage='string';
         wrpprErr.rowNumber='0';  
        
        Test.stopTest();
    
    }
        public static testmethod void regionalAccrualUploadTest2(){
    
            
        RIF_RegionalAccrualsUploadController accUpldctrlr = new RIF_RegionalAccrualsUploadController();
        accUpldctrlr.fileNameCSV='abc.csv';
       	//String content = '924RP,GBR,500,CAN,15,GBR,Y,08/05/2016,1234,OPERATIONS PROD MGMT-TFR,750,98342,Corporate Services,82000,81000,25,GBR,3/22/2016,N,114,Test,10100,Institutional Securities,05/22/2016,Y,Y,300,GBR,15,GBR,300,GBR,50,GBR,340000,USD,300,CAN,34000,CAN,11/04/2012,11/05/2016,11,7948,230,GBR,800,CAN,Y,N,10/02/2016,Active';    
	  accUpldctrlr.csvFileBody = Blob.valueOf('Accrual_Information__c.Emp_ID__c,'+'Accrual_Information__c.BASE_CURRENCY__C,'+'Accrual_Information__c.BENEFITS__C,'+'Accrual_Information__c.Curr_Benefits__c,'+'Accrual_Information__c.Buy_Out_of_Notice_Per_Lcl__c,'+'Accrual_Information__c.Curr_Buyout_of_Notice_Pd__c,'+'Accrual_Information__c.COMMUNICATED__C,'+'Accrual_Information__c.COMMUNICATED_DATE__C,'+'Accrual_Information__c.COST_CENTER__C,'+'Accrual_Information__c.COST_CENTER_DESC__C,'+'Accrual_Information__c.DAILY_RATE__C,'+'Accrual_Information__c.DEPARTMENT__C,'+'Accrual_Information__c.DEPARTMENT_DESC__C,'+'Accrual_Information__c.DIVISION__C,'+'Accrual_Information__c.DIVISION_DESC__C,'+'Accrual_Information__c.Enhanced_Severance_Lcl__c,'+'Accrual_Information__c.Curr_Enh__c,'+'Accrual_Information__c.LAST_DAY_ON_PREMISES__C,'+'Accrual_Information__c.SEVERANCE_PACKAGE_COMMUNICATED__C,'+'Accrual_Information__c.SUPER_DEPARTMENT__C,'+'Accrual_Information__c.SUPER_DEPARTMENT_DESC__C,'+'Accrual_Information__c.SUPER_DIVISION__C,'+'Accrual_Information__c.SUPER_DIVISION_DESC__C,'+'Accrual_Information__c.TERMINATION_DATE__C,'+'Accrual_Information__c.VOLUNTARY_INVOLUNTARY_FLG__C,'+'Accrual_Information__c.WORK_REQUIREMENT_FOR_SEVERANCE__C,'+'Accrual_Information__c.PIL,'+'Accrual_Information__c.Currency_PIL,'+'Accrual_Information__c.Buy_Out_of_Termination__c,'+'Accrual_Information__c.Curr_Buyout_of_Term__c,'+'Accrual_Information__c.EX_GRACIA_CASH_PAYMENT__C,'+'Accrual_Information__c.Curr_ExGCsh__c,'+'Accrual_Information__c.PENSION_CONTRIBUTION__C,'+'Accrual_Information__c.Curr_PenCont__c,'+'Accrual_Information__c.SOCIAL_INSURANCE__C,'+'Accrual_Information__c.Curr_SocialIns__c,'+'Accrual_Information__c.STATUTORY_REDUNDANCY_PAY__C,'+'Accrual_Information__c.Curr_StatRed__c,'+'Accrual_Information__c.TERMINATION_BONUS__C,'+'Accrual_Information__c.Curr_TermBon__c,'+'Accrual_Information__c.CONSULTATION_START_DATE__C,'+'Accrual_Information__c.CONSULTATION_END_DATE__C,'+'Accrual_Information__c.NOTICE_DAYS__C,'+'Accrual_Information__c.NOTICE_AMOUNT__C,'+'Accrual_Information__c.BASIC_SEVERANCE__C,'+'Accrual_Information__c.Cur_Basic_Severance__c,'+'Accrual_Information__c.ADDITIONAL_SEVERANCE__C,'+'Accrual_Information__c.Curr_Additional_Severance__c,'+'Accrual_Information__c.Signed_Release_Returned__c ,'+'Accrual_Information__c.EVENT_RELATED_TERM__C,'+'Accrual_Information__c.Latest_Payroll_Sent_Date__c,'+'Accrual_Information__c.Accrual_Type\n'+
                                                '924RP,'+'GBR,'+'500,'+'CAN,'+'15,'+'GBR,'+'Y,'+'08/05/2016,'+'1234,'+'OPERATIONS PROD MGMT-TFR,'+'750,'+'98342,'+'Corporate Services,'+'82000,'+'81000,'+'25,'+'GBR,'+'3/22/2016,'+'N,'+'114,'+'Test,'+'10100,'+'Institutional Securities,'+'05/22/2016,'+'Y,'+'Y,'+'300,'+'GBR,'+'15,'+'GBR,'+'300,'+'GBR,'+'50,'+'GBR,'+'340000,'+'USD,'+'300,'+'CAN,'+'34000,'+'CAN,'+'11/04/2012,'+'11/05/2016,'+'11,'+'7948,'+'230,'+'GBR,'+'800,'+'CAN,'+'Y,'+'N,'+'10/02/2016,'+'Active');
            
            
       
         // Accrual_Information__c ai = RIF_TestClassUtilities.createTestAccrualInfo('empid','Diksha');   
        RIF_RegionalAccrualsUploadController.wrapperError wrpprErr = new RIF_RegionalAccrualsUploadController.wrapperError ('row','error','924RP,');
        
         wrpprErr.empID='924RP';
         wrpprErr.errorMessage='string';
         wrpprErr.rowNumber='0';  
            
            
        accUpldctrlr .importCSVFile();
        accUpldctrlr .refreshPage();
        //accUpldctrlr.createErrorMessageWithMSID('row[0]', '924RP', 'Please Upload a CSV file.');
        accUpldctrlr.errorMessageString='Please Upload a CSV file.';
       // accUpldctrlr.test_method();
        
    
    }

    public static testmethod void regionalAccrualUploadTest3(){
        
      RIF_RegionalAccrualsUploadController accUpldctrlr = new RIF_RegionalAccrualsUploadController();
        accUpldctrlr.fileNameCSV=' ';
       	//String content = '924RP,GBR,500,CAN,15,GBR,Y,08/05/2016,1234,OPERATIONS PROD MGMT-TFR,750,98342,Corporate Services,82000,81000,25,GBR,3/22/2016,N,114,Test,10100,Institutional Securities,05/22/2016,Y,Y,300,GBR,15,GBR,300,GBR,50,GBR,340000,USD,300,CAN,34000,CAN,11/04/2012,11/05/2016,11,7948,230,GBR,800,CAN,Y,N,10/02/2016,Active';    
	  accUpldctrlr.csvFileBody = Blob.valueOf('Accrual_Information__c.Emp_ID__c,'+'Accrual_Information__c.BASE_CURRENCY__C,'+'Accrual_Information__c.BENEFITS__C,'+'Accrual_Information__c.Curr_Benefits__c,'+'Accrual_Information__c.Buy_Out_of_Notice_Per_Lcl__c,'+'Accrual_Information__c.Curr_Buyout_of_Notice_Pd__c,'+'Accrual_Information__c.COMMUNICATED__C,'+'Accrual_Information__c.COMMUNICATED_DATE__C,'+'Accrual_Information__c.COST_CENTER__C,'+'Accrual_Information__c.COST_CENTER_DESC__C,'+'Accrual_Information__c.DAILY_RATE__C,'+'Accrual_Information__c.DEPARTMENT__C,'+'Accrual_Information__c.DEPARTMENT_DESC__C,'+'Accrual_Information__c.DIVISION__C,'+'Accrual_Information__c.DIVISION_DESC__C,'+'Accrual_Information__c.Enhanced_Severance_Lcl__c,'+'Accrual_Information__c.Curr_Enh__c,'+'Accrual_Information__c.LAST_DAY_ON_PREMISES__C,'+'Accrual_Information__c.SEVERANCE_PACKAGE_COMMUNICATED__C,'+'Accrual_Information__c.SUPER_DEPARTMENT__C,'+'Accrual_Information__c.SUPER_DEPARTMENT_DESC__C,'+'Accrual_Information__c.SUPER_DIVISION__C,'+'Accrual_Information__c.SUPER_DIVISION_DESC__C,'+'Accrual_Information__c.TERMINATION_DATE__C,'+'Accrual_Information__c.VOLUNTARY_INVOLUNTARY_FLG__C,'+'Accrual_Information__c.WORK_REQUIREMENT_FOR_SEVERANCE__C,'+'Accrual_Information__c.PIL,'+'Accrual_Information__c.Currency_PIL,'+'Accrual_Information__c.Buy_Out_of_Termination__c,'+'Accrual_Information__c.Curr_Buyout_of_Term__c,'+'Accrual_Information__c.EX_GRACIA_CASH_PAYMENT__C,'+'Accrual_Information__c.Curr_ExGCsh__c,'+'Accrual_Information__c.PENSION_CONTRIBUTION__C,'+'Accrual_Information__c.Curr_PenCont__c,'+'Accrual_Information__c.SOCIAL_INSURANCE__C,'+'Accrual_Information__c.Curr_SocialIns__c,'+'Accrual_Information__c.STATUTORY_REDUNDANCY_PAY__C,'+'Accrual_Information__c.Curr_StatRed__c,'+'Accrual_Information__c.TERMINATION_BONUS__C,'+'Accrual_Information__c.Curr_TermBon__c,'+'Accrual_Information__c.CONSULTATION_START_DATE__C,'+'Accrual_Information__c.CONSULTATION_END_DATE__C,'+'Accrual_Information__c.NOTICE_DAYS__C,'+'Accrual_Information__c.NOTICE_AMOUNT__C,'+'Accrual_Information__c.BASIC_SEVERANCE__C,'+'Accrual_Information__c.Cur_Basic_Severance__c,'+'Accrual_Information__c.ADDITIONAL_SEVERANCE__C,'+'Accrual_Information__c.Curr_Additional_Severance__c,'+'Accrual_Information__c.Signed_Release_Returned__c ,'+'Accrual_Information__c.EVENT_RELATED_TERM__C,'+'Accrual_Information__c.Latest_Payroll_Sent_Date__c,'+'Accrual_Information__c.Accrual_Type\n'+
                                                ' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+'  ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,'+' ,');
            
      /*   User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
         Employee__c emp = new Employee__c();
             emp.Name = 'Test Employee' ; 
                                         emp.emp_Id__c = emp.Id;
                                          emp.Covenant_Date__c = Date.today(); 
                                         emp.User__c=thisUser.id;
                                          emp.Super_Division__c= 'Super Division' ;
                                          emp.Super_Depart_Org__c ='Super Department';
                                          emp.Subdept_Org__c = 'Sub Department';
                                          emp.Division_Org__c = 'Division' ;
                                          emp.Dept_Org__c = 'Department';
                                          emp.Sub_Depart2_Org__c = 'Sub Department 2';
                                          emp.Cost_Center__c = 'Cost Center' ;
        insert emp;
       
      
        Accrual_Information__c accInfo = new Accrual_Information__c();
           accInfo.Emp_Id__c = emp.Id; 
            accInfo.Additional_Severance__c = '000';
                                                            accInfo.Basic_Severance__c = '0';
                                                            accInfo.Benefits__c = '000';
                                                            accInfo.Buy_Out_Of_Termination__c = '000'; 
                                                            accInfo.enhanced_severance_lcl__c = '000';
                                                            accInfo.Ex_Gracia_Cash_Payment__c = '000'; 
                                                            accInfo.Notice_Amount__c = '000';
                                                            accInfo.pay_in_lieu_of_ben_lcl__c = '000';
                                                            accInfo.Pension_Contribution__c = '000'; 
                                                            accInfo.Social_Insurance__c = '000'; 
                                                            accInfo.Statutory_Redundancy_Pay__c = '0'; 
                                                            accInfo.Termination_Bonus__c = '000'; 
                                                            accInfo.createdByID__c = thisUser.id;
                                                            accInfo.Communicated_Date__c = Date.today();
        insert accInfo;*/
    
    
       
        
        accUpldctrlr .importCSVFile();
        accUpldctrlr .refreshPage();
         accUpldctrlr.createErrorMessageWithMSID('Row', 'null', 'Error:Emp_Id__c shouldn\'t be blank');
        accUpldctrlr.errorMessageString='Error:Emp_Id__c shouldn\'t be blank';
        //accUpldctrlr.test_method();
        
       
         RIF_RegionalAccrualsUploadController.wrapperError wrpprErr = new RIF_RegionalAccrualsUploadController.wrapperError ('0','error','empid');
         wrpprErr.empID='' ;
         wrpprErr.errorMessage='string';
         wrpprErr.rowNumber='0';  
    
    }

}