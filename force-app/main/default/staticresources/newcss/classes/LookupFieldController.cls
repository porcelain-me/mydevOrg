public class LookupFieldController {

     @AuraEnabled 
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText,String employeeType ){
        
            String Emp_ID = 'Emp_ID__c';
            String Level_Job = 'Level_Job__c';
            String Level_Dsc_Job = 'Level_Dsc_Job__c';
            String Super_Division_Dsc_Org = 'Super_Division_Dsc_Org__c';
            String Division_Dsc_Org = 'Division_Dsc_Org__c';	
            String Login_Id_Directory = 'Login_Id_Directory__c';                             
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
		
        String query ='';
        if(employeeType == 'Terminated Employee'){
           query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+' ,'+Emp_ID+' ,'+Level_Job+' ,'+Level_Dsc_Job+' ,'+Super_Division_Dsc_Org+' ,'+Division_Dsc_Org+' ,'+Login_Id_Directory+
            			' FROM '+objectName+
            				' WHERE '+fld_API_Search+' LIKE '+searchText+ ' AND Job_Region_Code__c != \'NA\' AND Status__c != \'Active\' AND Job_Region_Code__c !=  \'EU\' '+ 
            			' LIMIT '+lim;                                 
         } 
         else{
             query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+' ,'+Emp_ID+' ,'+Level_Job+' ,'+Level_Dsc_Job+' ,'+Super_Division_Dsc_Org+' ,'+Division_Dsc_Org+' ,'+Login_Id_Directory+
                 ' FROM '+objectName+
                 ' WHERE '+fld_API_Search+' LIKE '+searchText+ 
                 ' LIMIT '+lim;
        }                             
        
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            obj.EmpID = String.valueOf(s.get(Emp_ID))  ;
            obj.LevelJob = String.valueOf(s.get(Level_Job))  ;
            obj.LevelDscJob = String.valueOf(s.get(Level_Dsc_Job))  ;
            obj.SuperDivisionDscOrg = String.valueOf(s.get(Super_Division_Dsc_Org))  ;
            obj.DivisionDscOrg = String.valueOf(s.get(Division_Dsc_Org))  ;
            obj.LoginIdDirectory = String.valueOf(s.get(Login_Id_Directory))  ;
            lstRet.add(obj);
        } 
          system.debug('------>'+JSON.serialize(lstRet));                            
         return JSON.serialize(lstRet) ;
    }
    
    public class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String val{get;set;}
        public String EmpID  {get;set;}
        public String LevelJob  {get;set;}
        public String LevelDscJob  {get;set;}
        public String SuperDivisionDscOrg  {get;set;}
        public String DivisionDscOrg  {get;set;}	
        public String LoginIdDirectory  {get;set;}

    }
    
     @AuraEnabled
    public static String detailDB(string sobjectname, string recordId){
        String query = 'SELECT '+ getAllFields(sobjectname) +
            			' FROM '+sobjectname+' WHERE ID = \''+recordId+'\'';
        List<sObject> sobjList = Database.query(query);
        return JSON.serialize(sobjList);
    }
    
    public static String getAllFields(String sobjectname){
  		if(!Schema.getGlobalDescribe().containsKey(sobjectname)) return 'Invalid object name';
    	Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
  
    	List<String> accessiblefields = new List<String>();
  
    	for(Schema.SObjectField field : fields.values()){
      		if(field.getDescribe().isAccessible())
        		accessiblefields.add(field.getDescribe().getName());
    	}
  
    	String allfields='';
  
    	for(String fieldname : accessiblefields)
      		allfields += fieldname+',';
  
    	allfields = allfields.subString(0,allfields.length()-1);
    
    	return allfields;
  	}
}