// 08/06/2013 : MG : Utility class to create test data for RIF App.
@isTest
public without sharing class RIF_TestClassUtilities {

    public static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
    public static User getALLMSUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        
        User tempUser = new User(alias = 'newUser', email='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '+hr@ms.com');
  
        return tempUser;
    }
    
    public static User getOtherUser(){
        Profile p = [SELECT Id FROM Profile WHERE name !='System Administrator' limit 1];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
  
        return tempUser;
    }
    
     public static void setAllTriggerOn() { 
        Trigger_Switch__c dSwitch = Trigger_Switch__c.getInstance();
        // Updated to resolve UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record.
        if(dSwitch != null){
            //delete dSwitch;
            dSwitch = null;
        }       
        dSwitch = new Trigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
        
        dSwitch.Is_RIF_SeveranceAndReleaseTriggerOff__c = false; 
        dSwitch.Is_RIF_Project_Trigger_Off__c = false; 
        dSwitch.RIF_ValidateOrgDeptFieldsinSnRTrigger__c = true;
        
        insert dSwitch;
    }
    
    public static Employee__c createTestEmployee(Integer indx, String empId, String Country, String MSSB, String jobLevelDsc, String jobLevel){
        Employee__c emp = new Employee__c(Name = 'Test Employee_' + indx, 
                                          emp_Id__c = empId, 
                                          Job_Country_Job__c = Country,
                                          MS_MSSB__c = MSSB, 
                                          Level_Dsc_Job__c = jobLevelDsc, 
                                          Covenant_Date__c = Date.today(), 
                                          Level_Job__c = jobLevel, 
                                          Super_Division__c= 'Super Division' + indx,
                                          Super_Depart_Org__c ='Super Department' + indx,
                                          Subdept_Org__c = 'Sub Department' + indx,
                                          Division_Org__c = 'Division' + indx,
                                          Dept_Org__c = 'Department' + indx,
                                          Sub_Depart2_Org__c = 'Sub Department 2' + indx,
                                          Cost_Center__c = 'Cost Center' + indx );
        return emp;
    }
    
    public static Project__c createTestProject(Integer indx, Id recordTypeId){
        Project__c proj = new Project__c (Name= 'test Project_'+ indx,
                                            RecordTypeId = recordTypeId, 
                                            Status__c ='Active', 
                                            Super_Division__c = 'Super Division 1',
                                            Primary_Key__c = 'test_'+ indx);
        return proj;
    }
    
    public static Severance_Parameters__c createTestSeveranceParameter(Integer indx, String country, String MSSB, String levelDsc, 
                                                                        String level){
        Severance_Parameters__c sp = new Severance_Parameters__c();
        sp.Country__c = country;
        sp.MS_MSSB__c = MSSB;
        sp.Level_Dsc__c = levelDsc;
        sp.Level__c = level;
        sp.Primary_Key__c = 'test_' + indx;
        return sp;
    }
    
    public static Project_Level__c createTestProjectLevel(Id projectId, Id SeveranceParamId){
        Project_Level__c pl = new Project_Level__c(Project__c = projectId, 
                                  Severance_Parameters__c = SeveranceParamId);
        return pl;
    }
    
    /*public static Comp_Data__c createTestCompData(Integer indx, String empId, String additionalComp, String currentBase){
        Comp_Data__c compData = new Comp_Data__c();
        compData.Name = 'testCompData_'+indx;
        compData.Emp_Id__c = empId;
        CompData.Additional_Comp__c = additionalComp;
        CompData.Current_Base_Local__c = currentBase;
        return compData;
    }*/
    
    //(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
    /*public static Covenant_Parameters__c createTestCovenantParam(String country, String MSSB, String levelDsc){
        Covenant_Parameters__c cp = new Covenant_Parameters__c(Country__c = country, 
                                                               MS_MSSB__c = MSSB,  
                                                               Level_Dsc__c = levelDsc);
        return cp;
    }*/
    
    public static Severance_And_Release__c createTestSR(Id projLevelId, Id empId, Id recordTypeId){
        Severance_And_Release__c sr = new Severance_And_Release__c(
                                      Project_Level__c = projLevelId, 
                                      Employee__c = empId,
                                      recordTypeId = recordTypeId,
                                      Status__c = 'Selected' );
        return sr;
    }

    public static Project_Decisional_Unit__c createTestProjDecisionalUnit(String decisionalUnitValue, String decisionalUnitType, Id projectId){
        Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
        //pdu.Decisional_Unit__c = decisionalUnitValue;
        pdu.Project__c = projectId;
        //pdu.Decisional_Unit_Type__c = decisionalUnitType;
        return pdu;
    }
    
    public static Accrual_Information__c createTestAccrualInfo(String empId, String createdById){
        Accrual_Information__c accInfo = new Accrual_Information__c(Emp_Id__c = empId, Additional_Severance__c = '1000', 
                                                            Basic_Severance__c = '1000',
                                                            Benefits__c = '1000',
                                                            Buy_Out_Of_Termination__c = '1000', 
                                                            enhanced_severance_lcl__c = '1000',
                                                            Ex_Gracia_Cash_Payment__c = '1000', 
                                                            Notice_Amount__c = '1000',
                                                            pay_in_lieu_of_ben_lcl__c = '1000',
                                                            Pension_Contribution__c = '1000', 
                                                            Social_Insurance__c = '1000', 
                                                            Statutory_Redundancy_Pay__c = '1000', 
                                                            Termination_Bonus__c = '1000', 
                                                            createdByID__c = createdById,
                                                            Communicated_Date__c = Date.today());
        return accInfo;
    }
    
    
}