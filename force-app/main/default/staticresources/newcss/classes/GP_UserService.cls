/***************************************************************************************************************
*
*  GP USER SERVICE - this is used by the global parking front end for user related calls
*
*  Changelog:
*
*  8/23/15 - MRM Created
*
****************************************************************************************************************/
public without sharing class GP_UserService {

     
    public GP_UserService(GP_ApplictionDataService controller){
        
    }
    
    /***************************************************************************************************************
    *
    *  getUserDetails 
    *
    ****************************************************************************************************************/
    @RemoteAction  
    public static GP_JSON.userDetails getUserDetails (String messageIn){
        
        GP_JSON.UserDetails message;
        GP_JSON.inputId request;
        
        system.debug('message in: '+ messageIn);
        
        if (messageIn == '')
            messageIn = '{}';
            
        if (messageIn != null)
            request = (GP_JSON.inputId) System.JSON.deserialize(messageIn, GP_JSON.InputId.class);
    
        Employee__c e;
    
        if (request.id == null){
            User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
            e = [Select e.Work_Phone__c, Job_City_Dsc_Job__c, e.Name, e.Global_Parking_Level__c, Emp_ID__c From Employee__c e where emp_id__c = :u.emp_id__c];
        }
        else{
            e = [Select e.Work_Phone__c, Job_City_Dsc_Job__c, e.Name, e.Global_Parking_Level__c, Emp_ID__c From Employee__c e where emp_id__c = :request.id];
        }
        

       
        message = new GP_JSON.UserDetails(e.name, e.global_parking_level__c, e.emp_id__c, e.work_phone__c, e.job_city_dsc_job__c);
        
        system.debug('*** Return:' + message); 
        
        return message;
        
    }
    
    /***************************************************************************************************************
    *
    *  getDelegates - This returns a list of employees of where the logged in user is a delegate
    *
    ****************************************************************************************************************/
    
    @RemoteAction 
    public static List<GP_JSON.delegate> getDelegates(){
        
        List<GP_JSON.delegate> message = new List<GP_JSON.delegate>();
        
        /*
        [{
            "id": "0",
            "name": "Ian Worley"
    
        },{
            "id": "1",
            "name": "James Spahr"
    
        }]
        
        */
        
        User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        
        Employee__c e = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c, e.Country_Dsc_Home__c From Employee__c e where emp_id__c = :u.emp_id__c];
        
        List<Employee_Delegate__c> dList = new List<Employee_Delegate__c>();
        dList = [select 
                  employee__r.name 
                 ,status__c
                 ,employee__r.emp_id__c
                from Employee_Delegate__c 
                where delegate__c = :e.Id
                and application__c = 'Global Parking'
                and status__c in ('Approved','Submitted')
                order by employee__r.first_name__c
               ];
        
        for(Employee_Delegate__c d:dList){
            message.add(new GP_JSON.delegate(d.id,d.employee__r.emp_id__c,d.employee__r.name,d.status__c));
        }
        
        system.debug(message);
        
        return message;
    }
    
    /***************************************************************************************************************
    *
    *  getMyDelegates - List of employees that I have approved to be my delegate
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static List<GP_JSON.delegate> getMyDelegates(){
        
        
       List<GP_JSON.delegate> message = new List<GP_JSON.delegate>();
        
        /*
        [{
            "id": "0",
            "name": "Ian Worley"
    
        },{
            "id": "1",
            "name": "James Spahr"
    
        }]
        
        */
       
        User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        
        Employee__c e = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c, e.Country_Dsc_Home__c From Employee__c e where emp_id__c = :u.emp_id__c];
        
        List<Employee_Delegate__c> dList = new List<Employee_Delegate__c>();
        dList = [select 
                  delegate__r.name
                 ,delegate__r.emp_id__c
                 ,status__c
                from Employee_Delegate__c 
                where employee__c = :e.Id
                and application__c = 'Global Parking'
                and status__c = 'Approved' 
               ];
        
        List<Map<String,String>> listMap = new List<Map<String,String>>();
               
          for(Employee_Delegate__c d:dList){
            message.add(new GP_JSON.delegate(d.id,d.delegate__r.emp_id__c,d.delegate__r.name,d.status__c));
        }
        
        system.debug(message);
        
        return message;
        
        
    }
    /***************************************************************************************************************
    *
    *  getRequestForDelegation - this is a list of the requests the logged in user needs to approve or reject
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static List<GP_JSON.delegationRequest> getRequestsForDelegation(){
        
        
        List<GP_JSON.delegationRequest> message = new List<GP_JSON.delegationRequest>();
        
        /*
        [{
            "delegationRequestId": "12121",
            "name": "John Smith"
        }, {
            "delegationRequestId": "12122",
            "name": "John Smith Jnr"
        }]
        */
        
        
        User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        
        Employee__c e = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c, e.Country_Dsc_Home__c From Employee__c e where emp_id__c = :u.emp_id__c];
        
        List<Employee_Delegate__c> dList = new List<Employee_Delegate__c>();
        dList = [select 
                  delegate__r.name
                 ,status__c
                from Employee_Delegate__c 
                where employee__c = :e.Id
                and application__c = 'Global Parking'
                and status__c = 'Submitted'
               ];
        
               
        
        for(Employee_Delegate__c d:dList){
            message.add(new GP_JSON.delegationRequest(d.id,d.delegate__r.name));
        }
        
        
        system.debug(message);
        
        return message;
    }
    
    /***************************************************************************************************************
    *
    *  approveDelegation
    *
    ****************************************************************************************************************/
   
    @RemoteAction 
    public static GP_JSON.resultName approveDelegation(String messageIn){
        
        GP_JSON.resultName message;
        /*
        
        {
            "name": "John Smith"
        }
        */
        
        GP_JSON.inputId request = (GP_JSON.inputId) System.JSON.deserialize(messageIn, GP_JSON.inputId.class);
        
        Employee_Delegate__c d = [select id, delegate__r.name from Employee_Delegate__c where id = :request.id];
        d.status__c = 'Approved';
        update d;
                
        message = new GP_JSON.resultName(d.delegate__r.name);
                
        return message;
    }
    /***************************************************************************************************************
    *
    *  rejectDelegation
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static GP_JSON.resultName rejectDelegation(String messageIn){
        
        GP_JSON.resultName message;
        
        GP_JSON.inputId request = (GP_JSON.inputId) System.JSON.deserialize(messageIn, GP_JSON.inputId.class);
        
        Employee_Delegate__c d = [select id, delegate__r.name from Employee_Delegate__c where id = :request.id];
        d.status__c = 'Rejected';
        update d;
        
        message = new GP_JSON.resultName(d.delegate__r.name);
        
        return message;
    }
    /***************************************************************************************************************
    *
    *  removeDelegate
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static GP_JSON.resultName removeDelegate(String messageIn){
        
        GP_JSON.resultName message;
        
        GP_JSON.inputId request = (GP_JSON.inputId) System.JSON.deserialize(messageIn, GP_JSON.inputId.class);
         
        Employee_Delegate__c d = [select id, delegate__r.name from Employee_Delegate__c where id = :request.id];
        delete d;
        
        message = new GP_JSON.resultName(d.delegate__r.name);
        
        return message;
        
    }
    /***************************************************************************************************************
    *
    *  addDelegate - make this person a delegate without a request to be a delegate
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static GP_JSON.resultId addDelegate(String messageIn){
         
        GP_JSON.resultId message;
         
        GP_JSON.inputMSID request = (GP_JSON.inputMSID) System.JSON.deserialize(messageIn, GP_JSON.inputMSID.class);
         
        Employee__c delegate  = [select id from Employee__c where emp_id__c = :request.msid];
        
        User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        
        Employee__c loggedInEmployee = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c, e.Country_Dsc_Home__c From Employee__c e where emp_id__c = :u.emp_id__c];
        
        Employee_Delegate__c ed = new Employee_Delegate__c(
                 delegate__c = delegate.id
                ,employee__c = loggedInEmployee.id
                ,application__c = 'Global Parking'
                ,status__c = 'Approved' );
        insert ed;
        
        message = new GP_JSON.resultId(ed.id);
        
        return message;
        
    }
    
    /***************************************************************************************************************
    *
    *  requestDelegate - this is a request to be a delegate for another person
    *
    ****************************************************************************************************************/
    @RemoteAction 
    public static GP_JSON.resultId requestDelegate(String messageIn){
        
        GP_JSON.resultId message;
        
        GP_JSON.inputMSID request = (GP_JSON.inputMSID) System.JSON.deserialize(messageIn, GP_JSON.inputMSID.class); 
         
        Employee__c employeeToBeDelegateFor  = [select id from Employee__c where emp_id__c = :request.msid];
        
        User u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        
        Employee__c loggedInEmployee = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c, e.Country_Dsc_Home__c From Employee__c e where emp_id__c = :u.emp_id__c];
        
        Employee_Delegate__c ed = new Employee_Delegate__c(
                 delegate__c = loggedInEmployee.id
                ,employee__c = employeeToBeDelegateFor.id
                ,application__c = 'Global Parking'
                ,status__c = 'Submitted' );
        insert ed;
        
        message = new GP_JSON.resultId(ed.id);
        
        return message;
    }
    /***************************************************************************************************************
    *
    *  searchUsers
    *
    ****************************************************************************************************************/
  
    @RemoteAction 
    public static List<GP_JSON.searchResult> searchEmployees(String messageIn){
                
        List<GP_JSON.searchResult> message = new List<GP_JSON.searchResult>();
        
        GP_JSON.searchTermWrapper searchTerm = (GP_JSON.searchTermWrapper) System.JSON.deserialize(messageIn, GP_JSON.searchTermWrapper.class);
                
        String searchString  = searchTerm.searchTerm + '%';
        
        List<Employee__c> eList = [select name, emp_id__c from Employee__c where name like :searchString or emp_id__c = :searchTerm.searchTerm limit 25];
        for (Employee__c e:eList){
            message.add(new GP_JSON.searchResult(e.emp_id__c,e.name));
        }
                
        return message;
    }
   
}