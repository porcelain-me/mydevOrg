public class RIF_Create_Project_Decisional_Org_Level {
    //Variables
    private Map<string,string> decisionType_EmpFields ;
    public boolean saveAndNewRecordFlag{get;set;}
    public  Project_Decisional_Unit__c pdu{get;set;}
    //Getter-Setters
    public Child_Project_Decisional_Unit__c childDecUnitRecord{get;set;}
    public string dmlErrorMessages{get;set;}
    public RIF_Create_Project_Decisional_Org_Level(ApexPages.StandardController controller) {
        dmlErrorMessages='';
        saveAndNewRecordFlag=false;
        string pduID='';
        if(ApexPages.currentPage().getParameters().get('CF00Nf00000014uU3_lkid')!=null){
            pduID=ApexPages.currentPage().getParameters().get('CF00Nf00000014uU3_lkid');
            pdu=[select id,project__c,name,Decisional_Unit_Name__c from Project_Decisional_Unit__c where id=:pduID];
        }
        //else
            //pduID=ApexPages.currentPage().getParameters().get('id');
        
        
        childDecUnitRecord=(Child_Project_Decisional_Unit__c)controller.getRecord();
        if(childDecUnitRecord!=null && childDecUnitRecord.id!=null){ 
            childDecUnitRecord=[select id,ProjectID__c,createdbyID,lastmodifiedbyID,name,Employee__c,Total_Employees__c,Emp_ID__c ,Project__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c,Decisional_Unit_Code__c,Decisional_Unit__c,Project_Decisional_Unit__c,Project_Decisional_Unit__r.Decisional_Unit_Name__c,Project_Decisional_Unit__r.Project__c from Child_Project_Decisional_Unit__c where id=:childDecUnitRecord.id];
            
        }
    }
    
    public Pagereference save(){
        if(childDecUnitRecord.Decisional_Unit_Type__c=='Employee'){
                childDecUnitRecord.Total_Employees__c=1;
                 
        }
        /*else{
            decisionType_EmpFields = new Map<string,string>();   
            
            String criteriafieldName='';
            
            if(childDecUnitRecord.Decisional_Unit_Type__c=='Super Division')
                criteriafieldName='Super_Division__c';    
            String queryString='select id from employee__C where '+criteriafieldName+'=\''+childDecUnitRecord.Decisional_Unit__c+'\'';
            
            RIF_Batch_Create_Proj_Dec_Org_Level batchObj= new RIF_Batch_Create_Proj_Dec_Org_Level (queryString,childDecUnitRecord);
            Database.executeBatch(batchObj);
        
        
        }*/
        
        
        if( (childDecUnitRecord.id!=null) && (saveAndNewRecordFlag==false)){
            //try{
            	List<ApexPages.Message> pageMessages = RIF_DataUtil.upsertResult( new List <Child_Project_Decisional_Unit__c>{childDecUnitRecord});
            	system.debug('######org level pdu edit messages####'+pageMessages);
		        if(!pageMessages.isEmpty()){
		           for(ApexPages.Message msg : pageMessages){ 
		               dmlErrorMessages=msg.getSummary();
		               //ApexPages.addMessage(msg);
		            }         
		            return null;
		        }   
            //}
            return new pagereference('/'+childDecUnitRecord.id);
        }
        else{
            //return new pagereference('/apex/RIF_Detail_Project_Decisional_Org_Level');
            childDecUnitRecord.id=null; 
            childDecUnitRecord.ProjectID__c=pdu.project__c;
            childDecUnitRecord.Decisional_Unit__c=pdu.id;
            //childDecUnitRecord.Project1__c=Project_Decisional_Unit__r.Project__r.id;
            //insert childDecUnitRecord;
            List<ApexPages.Message> pageMessages = RIF_DataUtil.insertResult( new List <Child_Project_Decisional_Unit__c>{childDecUnitRecord});
            system.debug('######org level pdu insert messages####'+pageMessages);
	        if(!pageMessages.isEmpty()){
	           for(ApexPages.Message msg : pageMessages){
	               //ApexPages.addMessage(msg);
	                dmlErrorMessages=msg.getSummary();
	            }         
	            return null;
	        } 
        }
        return new pagereference('/'+pdu.id);
    }
    
    public void saveAndNew(){
        /*if(childDecUnitRecord.Decisional_Unit_Type__c=='Employee'){
                childDecUnitRecord.Total_Employees__c=1;
                 
        } */
        childDecUnitRecord.id=null;  
        
        /*if(childDecUnitRecord.id!=null){
            upsert childDecUnitRecord;
            //return new pagereference('/'+childDecUnitRecord.id);
        }
        else*/
            //return new pagereference('/apex/RIF_Detail_Project_Decisional_Org_Level');
        //insert childDecUnitRecord;
        List<ApexPages.Message> pageMessages = RIF_DataUtil.insertResult( new List <Child_Project_Decisional_Unit__c>{childDecUnitRecord});
        system.debug('######org level pdu insert messages####'+pageMessages);
        if(!pageMessages.isEmpty()){
           for(ApexPages.Message msg : pageMessages){
               //ApexPages.addMessage(msg);
                dmlErrorMessages=msg.getSummary();
            }         
            //return null;
        } 
        saveAndNewRecordFlag=true;
        childDecUnitRecord.Decisional_Unit_Type__c=''; 
        childDecUnitRecord.Decisional_Unit_Code__c=null; 
        //return null;
    }

}