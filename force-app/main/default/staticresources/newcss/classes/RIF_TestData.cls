@isTest(seeAlldata=true)
public class RIF_TestData {
    public static Project__c createTestProject(){
    
        /*****************Insert Record type****************/
        
        //Schema.DescribeSObjectResult projSchema = Schema.SObjectType.project__c; 
        //Map<String,Schema.RecordTypeInfo> projRecordTypeInfo = projSchema.getRecordTypeInfosByName();
       
        
        /***********Creating ORG COde******************/
        Org_Codes__c orgcodeHR = new Org_Codes__c(Code__c = '81200' , Code_Type__c = 'Department', Description__c='Human Resources');
        insert orgcodeHR;
        
        Org_Codes__c orgcodeemp = new Org_Codes__c(Code__c = '10910' , Code_Type__c = 'Super Division', Description__c='Global Wealth Management Group');
        insert orgcodeemp ;
        /*****************Create Severance Parameter*********************/
        
        /*Severance_Parameters__c sevparam = new Severance_Parameters__c (Country__c = 'USA' ,MS_MSSB__c = 'MSSB' , Level_Dsc__c = 'Professional', Level__c = '01test123', OutPlacement__c = '6 Months');//Primary_Key__c = String.valueOf('Test4569'+DateTime.now().getTime())
        insert sevparam ;*/
        
        
        /*****************Creating Employee****************************/
        List<Employee__c> lstEmp = new List<Employee__c>();
        for(Integer i=0; i < 20; i++){
            Employee__c emp = new Employee__c();
            emp.emp_id__c = 'MS12'+i;
            emp.name = 'Test'+i + ' Test456';
            emp.Level_Dsc_Job__c = 'Professional';
            emp.Level_Job__c = '30';
            emp.MS_MSSB__c = 'MSSB';
            emp.Job_Country_Job__c  = 'USA';
            emp.Status__c = 'active';
            emp.Super_Division__c = '10910';
            lstEmp.add(emp);
        }
        insert lstEmp;
        
        /************* Create Coverage Entitlement******************/
       List<Coverage_Entitlement__c> coverageEntitlement = new List<Coverage_Entitlement__c>();
       for(Employee__c emp: lstEmp){
           Coverage_Entitlement__c e = new  Coverage_Entitlement__c ();
           e.HR_Name__c =   emp.id ;
           coverageEntitlement.add(e);
       }
       insert coverageEntitlement;
       
       /********************Create Entitlement Org Level*****************/
       List<Coverage_Entitlement_Org__c> entitlementOrg = new  List<Coverage_Entitlement_Org__c>();
        for(Coverage_Entitlement__c ce: coverageEntitlement ){
           Coverage_Entitlement_Org__c ceo = new Coverage_Entitlement_Org__c();
           ceo.Coverage_Entitlement__c =  ce.id ;
           ceo.Coverage_Entitlement_Org_Code__c = orgcodeemp.id;
           ceo.Coverage_Entitlement_Type__c = 'Super Division';
           entitlementOrg.add(ceo);
        }
        insert entitlementOrg ;
        
        /*******Create Unvested Equity*************/
        
        List<Unvested_Equity__c> unvequitylist = new List<Unvested_Equity__c>(); 
        //for (Employee__c emp: [SELECT id,emp_id__c,name,Level_Dsc_Job__c,Level_Job__c,MS_MSSB__c,Job_Country_Job__c from Employee__c where Job_Country_Job__c='USA' AND Level_Dsc_Job__c='Professional' AND Level_Job__c='30' AND MS_MSSB__c='MSSB' AND Super_Division__c='10910' AND Status__c='active' order by name  Limit 20 ] )  {
        for (Employee__c emp: lstEmp)  {
            Unvested_Equity__c unvequity = new Unvested_Equity__c();
            unvequity.current_holdings__c = '';
            unvequity.Date_as_of__c = Date.Today();    
            unvequity.Employee_temp__c = emp.id;
            unvequity.total_cash_balance__c = '15127.76';
            unvequity.total_balance__c = '15127.76';
            unvequity.total_equity_balance__c = '0.00';
            unvequity.unvested_cash_balance__c = '15127.76';
            unvequity.Unvested_Equity_Balance__c = '0.00';
            unvequity.unvested_holdings__c = 't';
            unvequity.Unvested_total_balance__c = '15127.76' ;
            unvequitylist.add(unvequity);
           
        }
        insert unvequitylist;
        
        /******Create Project *************/
        
        Project__c proj = new Project__c();
        //getting multiple proj rec type id
        //Id rtId = projRecordTypeInfo.get('Project_Based_Termination').getRecordTypeId();
        proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        //PROJ.RecordTypeId  = rtId;
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        //proj.Partner_Server_URL__c = 'https://morganstanleyhr----Dev-cs16-my-salesforce-com.ccg-dev.ms.com/services/Soap/u/29.0/00Df0000002K0p7_290' ;
        insert proj ;
        
        
        /**********************Create PDU **********************/
        
        //Employee__c objEmpTemp = new Employee__c(Name = 'Test3456 test', emp_id__c = 'ts569', MS_MSSB__c = 'MS', Job_Country_Job__c = 'USA', Status__c = 'active', Dept_Org__c = '81200');
        //insert objEmpTemp;
        
        Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
        pdu.Decisional_Unit_Name__c = 'Test PDU';
        pdu.Project__c = proj.id;
       Employee__c tempEmp=[SELECT id,emp_id__c,name,Level_Dsc_Job__c,Level_Job__c,MS_MSSB__c,Job_Country_Job__c from Employee__c where Job_Country_Job__c='USA' AND Dept_Org__c='81200' AND Status__c='active' Limit 1 ];
        pdu.Employee__c = tempEmp.id ;
        pdu.HR_Signatory__c = tempEmp.id ;
        insert pdu ;
        
        /***************************Create PDU Org Level*******************************/
        
        Child_Project_Decisional_Unit__c pduOrgLevel = new Child_Project_Decisional_Unit__c ();
        //pduOrgLevel.name='test org pdu';
        pduOrgLevel.Project_Decisional_Unit__c = pdu.id ;
        pduOrgLevel.Decisional_Unit_Type__c = 'Super Division'; 
        pduOrgLevel.Decisional_Unit_Code__c = orgcodeemp.id ;  
        insert pduOrgLevel ;
        
        
        /*********************Create severance & Release **********************/ 
        
        List<Severance_And_Release__c>  SnRList = new List<Severance_And_Release__c>();
        
        //for (Employee__c emp: [SELECT id,emp_id__c,name,Level_Dsc_Job__c,Level_Job__c,MS_MSSB__c,Job_Country_Job__c from Employee__c where Job_Country_Job__c='USA' AND Level_Dsc_Job__c='Professional' AND Level_Job__c='30' AND MS_MSSB__c='MSSB' AND Super_Division__c='10910' AND Status__c='active' order by name  Limit 20 ] )  {
        for (Employee__c emp: lstEmp)  {
            Severance_And_Release__c SnR = new Severance_And_Release__c();
            SnR.Project__c = proj.id ;
            SnR.Employee__c = emp.id ; 
            SnRList.add(SnR);
        } 
        insert SnRList;
        System.debug('******************Project Details*******************'+proj);   
         
        return proj ;
    }
    
}