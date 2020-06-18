public class referenceLetterRequestCntrl {
	
    public referenceLetterRequestCntrl(){
        wrapperClass returnwrapperClass = new  wrapperClass ();    
        returnwrapperClass.ReferenceLetterRequest = new Reference_Letter_Request__c();
    }    
    public class wrapperClass{
        @AuraEnabled public Reference_Letter_Request__c ReferenceLetterRequest {get;set;}
        @AuraEnabled public List<sObject> lstsObject{get;set;}

    }
    @AuraEnabled
    public static String getAvailableLetters(string letterSelectedType, String employeeDetails, string forEmployee){
        List<Reference_Letter__c> refList = new List<Reference_Letter__c>();
        List<selectOption> availableLetters = new  List<selectOption>();
        List<string> availableLettersList = new List<string>(); 
        availableLetters.add(new selectOption('','---Choose a Letter---'));
        list<string> empID = new list<string>();
        try{
        String soql = '';
        system.debug('********************'+employeeDetails);
        List<Employee__c> empList =   (List<Employee__c>)System.JSON.deserialize(employeeDetails, List<Employee__c>.class);
        for(Employee__c emp : empList){
            empID.add(emp.Emp_ID__c);
        }
        if(letterSelectedType == 'Terminated Employee' && forEmployee != null){
            soql += 'SELECT Id, Name FROM Reference_Letter__c where Employment_Status__C = \'InActive\' ORDER BY Name LIMIT 4000';
            refList = Database.query(soql);
            for (Reference_Letter__c r:refList){
                availableLetters.add(new selectOption(r.id,r.name));  
                availableLettersList.add(r.id+'---@@@@---'+r.name);
            }  
            system.debug('***********availableLetters : '+availableLetters);
        }
        else {
            
            /*various condition for letter type*/
            List<Employee__C> resultSet = [select CC_Region_Org__c, Region_Dsc_Org__c,
                                           Job_Country_Job__c, Dept_Org__c, Subdept_Org__c,
                                           Job_Region_Code__c from Employee__C 
                                           where emp_id__c IN :empID limit 1];
             system.debug('###########-->resultSet : '+resultSet);
            for(Employee__c requesteeEmp : empList){
            for(Employee__C re: resultSet) {
                system.debug('###########-->'+re.get('Job_Region_Code__c'));
                        if((re.get('Job_Region_Code__c') == 'NJ' || re.get('Job_Region_Code__c') == 'JA') && 
                                !(requesteeEmp.Job_Country_Job__c == 'CHN' && requesteeEmp.Division_Org__c == '94150' 
                                && requesteeEmp.Super_Division__c == '10100')){
                            soql = 'SELECT Id, Name FROM Reference_Letter__c';
                            /*if(requestorEmp.get('Dept_Org__c') == System.Label.RL_HR_VALUE){
                                soql += ' WHERE ( Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                            } else {*/
                            soql += ' WHERE Employment_Status__C = \'Active\' AND Requestor__c includes(\'Employee\')';
                            //}
                            soql += ' AND ( Location__c includes(\'asia\')';
                                                                     
                            if(re.get('Job_Country_Job__c') == 'HKG')
                                soql += ' OR Location__c includes(\'Hong Kong\'))';
                            else if(re.get('Job_Country_Job__c') == 'SGP')
                                soql += ' OR Location__c includes(\'Singapore\'))';
                            else if(re.get('Job_Country_Job__c') == 'AUS')
                                soql += ' OR Location__c includes(\'Australia\'))';
                            else if(re.get('Job_Country_Job__c') == 'IND')
                                soql += ' OR Location__c includes(\'India\'))';
                            else if(re.get('Job_Country_Job__c') == 'IDN')
                                soql += ' OR Location__c includes(\'Indonesia\'))';
                            else if(re.get('Job_Country_Job__c') == 'THA')
                                soql += ' OR Location__c includes(\'Thailand\'))';
                            else if(re.get('Job_Country_Job__c') == 'VNM')
                                soql += ' OR Location__c includes(\'Vietnam\'))';
                            else if(re.get('Job_Country_Job__c') == 'PHL')
                                soql += ' OR Location__c includes(\'Philippines\'))';
                            else
                                soql += ')';
                        } else if(re.get('Job_Region_Code__c')== 'EU') {
                            soql += 'SELECT Id, Name FROM Reference_Letter__c';
                            /*if(re.get('Dept_Org__c') == System.Label.RL_HR_VALUE){
                                soql += ' WHERE (Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                            } else {*/
                            soql += ' WHERE Requestor__c includes(\'Employee\')';
                            //}
                            soql += ' AND Location__c includes(\'EMEA\')';
                            /*if(re.get('Job_Country_Job__c') == 'UK')
                                soql += ' OR Location__c includes(\'England\'))';*/
                        }
                        soql += ' ORDER BY Name';
                    }
            }
            System.debug('Request for Letters : ' + soql);
            refList = Database.query(soql);
            for (Reference_Letter__c r:refList){
                availableLetters.add(new selectOption(r.id,r.name));
                availableLettersList.add(r.id+'---@@@@---'+r.name);
            }
         }   
        }
        catch (Exception e) {
            System.debug('Exception in letter types : ' + e);
        }
        
        return JSON.serialize(availableLettersList);   
    }
    
     @AuraEnabled
    public static string getloggedInUserDetails(String sobjectname){
        String query = 'SELECT '+ LookupFieldController.getAllFields(sobjectname) +
            			' FROM '+sobjectname+' WHERE Status__c = \'active\' AND User__r.ID =\''+UserInfo.getUserId()+'\'';
        List<sObject> sobjList = Database.query(query);
        return JSON.serialize(sobjList);

    }
     @AuraEnabled
    public static list<Reference_Letter__c> getLetterDetails(String rId){
     //   list<Reference_Letter__c> sobjList = [SELECT ID, Name, Reference_Letter_Code__c from Reference_Letter__c  WHERE ID =: rId LIMIT 1];
        return [SELECT ID, Name, Reference_Letter_Code__c from Reference_Letter__c  WHERE ID =: rId LIMIT 1];

    }
     @AuraEnabled
    public static sObject saveRecordCntrl(sObject insertObj){
    	system.debug('**********Insert OBJ: '+insertObj);
        reference_letter_request__c refReq = new reference_letter_request__c();
        refReq = (reference_letter_request__c)insertObj;
        map<string,id> queuepopulation=new map<string,id>();
        string queueSObjectType='Reference_Letter_Request__c';   
        for (QueueSobject  q : [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType=:queueSObjectType ]) {
            queuepopulation.put(q.Queue.Name,q.Queue.ID);
        }
        Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c where id = :refReq.reference_letter__c];
        user u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
        Employee__c requestorEmp = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c, Status__c
                        , Country_Dsc_Home__c, CC_Region_Org__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
                        , Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c, Job_Region_Code__c
                        , Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from employee__c where emp_id__c = :u.Emp_id__c];
        
        refReq.requesting_employee__c = requestorEmp.id;
        List<RecordType> rTypeList = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Reference_Letter_Request__c'];
        
        Map<String,ID> rTypeMap = new Map<String,ID>();
        for (RecordType r:rTypeList)
            rTypeMap.put(r.developername,r.id);
        if (rL.reference_letter_code__c  == 'RL0023') {
            refReq.recordtypeid = rTypeMap.get('Bank_Account_Request_Letter');
        }
        refReq.status__c = 'Created';
        
        if(refReq.Receipient_Name__c == null || refReq.Receipient_Name__c == ''){
            refReq.Receipient_Name__c = 'To Whom It May Concern';
        }
        if(refReq.Address_by_Reference__c == 'Address Only'){
            refReq.Address_by_Reference__c = 'Address_Only';
        } else if(refReq.Address_by_Reference__c == 'Name and Address'){
            refReq.Address_by_Reference__c = 'Name_and_Address';
        }
        system.debug('*******refReq : '+refReq);
        try{ 
            if (refReq.id == null){  
                insert refReq;
            } else {
                update refReq;
            }
        } catch(DMLException e){
				system.debug('*******error : '+e);
           
        }
        return null;

    }
}