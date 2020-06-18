public class MCAPortal_NewAreaRequestController_Mayur {
public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public boolean noProxyAllowed {get; set;}
    public string proxyUserId {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.MCA_Exception_Admin;
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    public List<SelectOption> countryList {get; set;}
    public String country {get; set;}
    public List<SelectOption> CityList {get; set;}
    public String city {get; set;}
    public List<SelectOption> BuildingList {get; set;}
    public String building {get; set;}
    public List<SelectOption> AreaList {get; set;}
    public String area {get; set;}
    public String RequestorEmployee{get;set;}
    public Employee__c requestorEmp {get;set;}
    public MCARequest__c requestDetails{get;set;}
    public Boolean showReqPopup{get;set;}
    public String RequesteeEmployee{get;set;}
    public boolean msgError1 {get;set;}
    public String CurrentManager{get;set;}            
    public String currentManagerId{get;set;}  
    public String msgError{get;set;}
    public list<Employee__C> EmployeeList{get;set;}
    Public Boolean ReturnDate{get;set;}
    public string dummyFlagforDatePicker {get; set;}
    public string returnDateDt{get; set;}
    public string startDateDt{get; set;}
    Public Boolean isApprover{get;set;} 
    public MCAPortal_NewAreaRequestController_Mayur (){
    
        //try{
            customPageMessage =null;
        	ReturnDate= false;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;
            OrgName=Label.ORG_ENVIRONMENT; 
             dummyFlagforDatePicker='loaded';
            //LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());
            proxyUserId= ApexPages.Currentpage().getParameters().get('uid');
            isApprover = false;
            
            LoggedInUser = PP_Util.getLoggedinUserRecord();
            if(LoggedInUser == NULL) {
                return;
            }
            requestorEmp  = PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c);
            if(requestorEmp == NULL) {
                system.debug('**************NO EMPLOYEE FOUND WITH EMPID:'+LoggedInUser.Emp_Id__c);
                return;
            }      
        requestDetails = new MCARequest__c();
            requestDetails.Employee_Requestor_Name__c = requestorEmp.id; 
            requestDetails.Employee_Requestee_Name__c = requestorEmp.id; 
            RequestorEmployee=requestorEmp.name;  
		          
            
            countryList = new List<SelectOption>();
            countryList.add(new SelectOption('', 'Please Select...'));
            String countryString;
            for( AggregateResult countryResult :  [SELECT COUNTRY_DESCRIPTION__c FROM Building_Locations__c GROUP BY COUNTRY_DESCRIPTION__c ORDER BY COUNTRY_DESCRIPTION__c ASC] ) {
                countryString = (String)countryResult.get('COUNTRY_DESCRIPTION__c');
                countryList.add(new SelectOption(countryString, countryString ));
            }
            
        //}
        /*Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            system.debug('****Exception inside WV_ElectionsHistoryController()'+e.getlinenumber()+'-'+e.getmessage()); 
            exp=e;
            ApexPages.addMessages(e);
        }*/
        
    }

    public pageReference selectCountry() {
        cityList = new List<SelectOption>();
        cityList.add(new SelectOption('', 'Please Select...'));
        String cityString;
        for( AggregateResult cityResult :  [SELECT CITY_DESCRIPTION__c FROM Building_Locations__c WHERE COUNTRY_DESCRIPTION__C = :country GROUP BY CITY_DESCRIPTION__c ORDER BY CITY_DESCRIPTION__c ASC] ) {
            cityString= (String)cityResult.get('CITY_DESCRIPTION__c');
            cityList.add(new SelectOption(cityString, cityString));
        }
        building = null;
        buildingList = new List<SelectOption>();
        buildingList.add(new SelectOption('', 'Please Select...'));
        area = null;
        AreaList = new List<SelectOption>();
        AreaList.add(new SelectOption('', 'Please Select...'));
        //area = null;
        return null;
    }

    public pageReference selectCity() {
        building = null;
        buildingList = new List<SelectOption>();
        buildingList.add(new SelectOption('', 'Please Select...'));
        for( Building_Locations__c buildingLocation :  [SELECT Id, Name FROM Building_Locations__c WHERE COUNTRY_DESCRIPTION__C = :country and CITY_DESCRIPTION__c = :city ORDER BY Name ASC] ) {
            buildingList.add(new SelectOption(buildingLocation.Name, buildingLocation.Name));
        }
        area = null;
        AreaList = new List<SelectOption>();
        AreaList.add(new SelectOption('', 'Please Select...'));
        return null;
    }
    
    public pageReference selectBuilding() {
        area = null;
        AreaList = new List<SelectOption>();
        AreaList.add(new SelectOption('', 'Please Select...'));
        //throw new RecordNotFoundException('hi--'+building);
        if(!String.isBlank(building))
        {
            for( Access_Clearance_Area__c area :  [SELECT Id, Name FROM Access_Clearance_Area__c WHERE Building__r.Name = :building ORDER BY Name ASC] ) {
                AreaList.add(new SelectOption(area.Name, area.Name));
            }
        }
        //area = null;
        return null;
    }

    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureExceptionFuture('My Card Access','My Card Access New Request page-->Constructor()','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside MCAPortal_NewRequestController-->sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    } 
    
     Public pagereference SearchEmployee(){
        //RequesteeEmployee=null;
        //EmployeeList=null;
        //msgError1 = false;
        //msgError = null;
        showReqPopup=true;
        return null;
    }
    
    public Pagereference CloseWindow(){
        showReqPopup=false;
        return null;
    }
    
     Public pagereference FilterRequestorEmployee(){
        if((RequesteeEmployee!=null || RequesteeEmployee!='') && (RequesteeEmployee!=null && RequesteeEmployee.length()<=2) ){
           msgError1=true;
           msgError='Please enter a minimum of 3 characters.';
        }
        else if((RequesteeEmployee==null || RequesteeEmployee=='') ){
            msgError1=true;
            msgError='Please enter a minimum of 3 characters.';
        }
        else {
            EmployeeList=null;
            msgError1 = false;
            msgError=null;
            String Query='select id,emp_id__c,Officer__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
        if(RequesteeEmployee!=null || RequesteeEmployee!=''){        
            if(RequesteeEmployee.length()<=2){
                msgError1=true;
               msgError='Please enter a minimum of 3 characters.';
            }else{
             Query+=' (name like \'%'+RequesteeEmployee+'%\' OR emp_id__c=\''+RequesteeEmployee +'\') and status__c=\'Active\'';
            }
        }
        
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            EmployeeList=null;
        }
        else{
            Query+='  order by name asc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
            if(EmployeeList.size() > 20){
                    msgError='Too many search results found. Please narrow your search criteria and try again.';
                    msgError1 = true;
                    EmployeeList=null;
                    return null;
            }
        }
       }
        return null;
    }
    Public pagereference SelectedEmployee(){
        //system.debug('----------inside selected employee-------------');
        requestorEmp=null;
        showReqPopup=false;
        //requestDeatils.Location111__c=null;
        //List<Employee__c> empDetails = PP_Util.getEmployeeRecordbyID(requestDetails.Employee_Requestee_Name__c);
        //requestorEmp = empDetails[0];
       	List<Employee__c> empDetails = PP_Util.getEmployeeRecordbyID(requestDetails.Employee_Requestee_Name__c);
        requestorEmp = empDetails[0];
        return null;
    }
    
     public pagereference RemovalType(){
        if(requestDetails.Additional_access_timing__c=='Temporary'){
            dummyFlagforDatePicker='loaded';
            ReturnDate=true;
        }
        else{
            ReturnDate=false;
        }
        return null;
    }
    
    public pagereference submitRequest()
    {
        if(ReturnDate==true && (returnDateDt == null || returnDateDt.trim()=='')){
            requestDetails.End_Date__c=null;
        }
        else if(ReturnDate==false){
            requestDetails.End_Date__c=null;
        }
        else if(ReturnDate==true && returnDateDt == 'NaN/NaN/NaN')
        {
            returnDateDt = null;
            requestDetails.End_Date__c=null;
        }else
        {
            requestDetails.End_Date__c=date.parse(returnDateDt);
        }
        
        if(ReturnDate==true && (startDateDt == null || startDateDt.trim()=='')){
            requestDetails.Start_Date__c=null;
        }
        else if(ReturnDate==false){
            requestDetails.Start_Date__c=null;
        }
        else if(ReturnDate==true && startDateDt == 'NaN/NaN/NaN')
        {
            startDateDt = null;
            requestDetails.Start_Date__c=null;
        }else
        {
            requestDetails.Start_Date__c=date.parse(startDateDt);
        }
       	requestDetails.Status__c = 'Submitted';
        requestDetails.submitted_date__c = System.Today();
        if(country == 'UNITED STATES OF AMERICA'){
                //CurrentManager='Americas_Data_Center_Approvers';
                //requestDetails.MCA_Approver__c='MCA_Americas_Approvers';
            }
        
        insert requestDetails;
        isApprover = true;
        Approval.ProcessResult result = null;
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(requestDetails.id); 
        result  =   Approval.process(request); 
        
        PageReference pr = Page.MCA_RequestHome;
        pr.setRedirect(true);
        return pr;
    }
     Public pagereference approveRequest() {
         return null;
     }
     Public pagereference takeAction() {
         return null;
     }
        
      
}