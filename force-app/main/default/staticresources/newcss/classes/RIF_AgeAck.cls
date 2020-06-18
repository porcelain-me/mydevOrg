/******************************************************************************************
* RIF Age Acknowledgement Controller 
*
* This will generate the data for the age ack process
*
* ChangeLog:
*
*   9/16/16- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public class RIF_AgeAck { 
    
    public Project__c p {get;set;}
   
    public Integer batchSize {get;set;}
    public List<wrapEmployee> wList {get;set;}
    public String runningPDU {get;set;}
    public Boolean done {get;set;}
    public Integer totalAdded {get;set;}
    public Integer currentCriteria {get;set;} 
    public Boolean showConductorButton {get;set;}
    public Boolean started {get;set;}
    public Integer over40count {get;set;}
    Integer criteriaSize = 0;
    Integer deleteSize = 0;
    boolean firstTime = true;
    List<RIF_Age_Ack_Work__c> criteriaList;
    Map<Integer,Integer> criteriaCountMap = new Map<Integer,Integer>();
    Map<Integer,Integer> criteriaProcessedMap = new Map<Integer,Integer>();
    List<Employee__c> eList = new List<Employee__c>();
    List<Employee__c> eListCount = new List<Employee__c>();
    List<Employee__c> terminatedEmpList = new List<Employee__c>();
    Integer deleteCount;
    public List<selectoption> pduNameList {get; set;}  //MSN: RIF#148 Changes 16 March 18
    public String selectedPDU {get;set;}  //MSN: RIF#148 Changes 16 March 18
    /****************************
    *STANDARD CONTROLLER  
    *
    ****************************/
    public RIF_AgeAck(ApexPages.StandardController controller) {
      pduNameList = new List<selectoption>(); //MSN: RIF#148 Changes 2 April 18
    	deleteCount = 0;
    	batchSize = 350;
    	done=false;
    	totalAdded = 0;
    	currentCriteria = 0;
    	showConductorButton = false;
    	started=false;
    	over40Count = 0;
    	
    	p = (Project__c) controller.getRecord();
    	
    	p = [select communication_date__c,name  from Project__c where id = :p.id];
    	
    	wList = new List<wrapEmployee>();
    	
    	List<RIF_Age_Ack_Work__c> temp = [	select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and selected__c = true and conductor_processed__c = false];
    	if (temp.size() > 0)
    		showConductorButton = true;
    
    	runningPDU = 'Starting up....one moment please!';
    	
    	/* see if any criteria on the project...*/
    	List<Child_Project_Decisional_Unit__c> testList = [
			select id, decisional_unit_code__r.code__c, decisional_unit_type__c, project_decisional_unit__c , projectid__c , employee__c
			from child_project_decisional_unit__c where projectid__c = :p.id];
			
		if (testList.size() == 0){
			done = true;
			over40Count = 0;
		}
          //MSN: RIF#148 Changes 2nd April 18 - Starts
            List<Project_Decisional_Unit__c> pduList = RIF_UserLevelData.getPDUs(p.id);
            if(pduList!=null && !pduList.isEmpty())
            {
                pduNameList.add(new SelectOption('','--Select PDU--'));
                pduNameList.add(new SelectOption('All','All'));
                for(Project_Decisional_Unit__c pdu : pduList )
                {
                    pduNameList.add(new SelectOption(pdu.ID,pdu.Decisional_Unit_Name__c));
                }
            }
            else
            {
                pduNameList.add(new SelectOption('','--PDU(No access)--'));
                started=true;
                done = true;
            }
         //MSN: RIF#148 Changes 2nd April 18 - Ends
    }
  
    /******************************************************************************
    *
    * Process Each Batch of Records until no more records
    *
    *******************************************************************************/
    public pageReference processBatch(){
        
        
            
            
            /* Generate the criteria records and delete the old data */
            if(firstTime){
                batchSize=5000;
                currentCriteria=0;
                generate();
                if (deleteSize > 0)
                    firstTime = true;
                else
                    firstTime=false;
                return null;
            }
            
            batchSize=350;
            
            /* Save the data */	
            if (wList != null){
                if (wList.size() > 0){
                    saveData(wList);
                    wList = new List<wrapEmployee>();
                    if (currentCriteria == criteriaSize){  
                        done=true;
                        List<RIF_Age_Ack_Work__c> temp = [	select employee__c 
                                                          from RIF_Age_Ack_Work__c 
                                                          where project__c = :p.id and Has_Manual_Age_Disclosure__c = false and selected__c = true and age_at_termination__c >= '40'];
                        if (temp.size() > 500)
                            showConductorButton = true;
                        
                        over40Count=temp.size();	
                        return null;
                    }
                }
            }
            
            getEmployees();
            
            /* keep counters to track if your done */
            if (criteriaCountMap.get(currentCriteria) == null){
                criteriaCountMap.put(currentCriteria,eListCount.size()+terminatedEmpList.size());
                
            }
            
            eListCount.clear();
            terminatedEmpList.clear();
            
            if (criteriaProcessedMap.get(currentCriteria) == null)
                criteriaProcessedMap.put(currentCriteria,eList.size());
            else{
                
                criteriaProcessedMap.put(currentCriteria,criteriaProcessedMap.get(currentCriteria) + eList.size());
            }
            
            
            /* wrap them up for the page */	
            for (Employee__c e:eList){	
                wList.add(new wrapEmployee(e,criteriaList[currentCriteria]));
            }	
            
            child_project_decisional_unit__c t = [select name
                                                  ,decisional_unit_code__r.code__c
                                                  ,decisional_unit_type__c
                                                  ,Org_Hierarchy_Code__c
                                                  ,employee__r.name
                                                  from child_project_decisional_unit__c 
                                                  where id = : criteriaList[currentCriteria].Project_Decisional_Org_Level__c];
            
            /* some status notifications to the user */
            
            if (runningPDU.contains('tart') || runningPDU.contains('eletin'))
                if (t.decisional_unit_type__c == 'Employee')
                runningPDU = t.name + ' - ' + t.decisional_unit_type__c + ':' + t.employee__r.name + '(Count-' + criteriaCountMap.get(currentCriteria)  + ')';
            
            else
                runningPDU = t.name + ' - ' + t.decisional_unit_type__c + ':' + t.Org_Hierarchy_Code__c + ' (Count-' + criteriaCountMap.get(currentCriteria)  + ')';
            else
                if (!runningPDU.contains(t.name))	
                if (t.decisional_unit_type__c == 'Employee')
                runningPDU += '; ' + t.name + ' - ' + t.decisional_unit_type__c + + ':' + t.employee__r.name + ' (Count-' + criteriaCountMap.get(currentCriteria)  + ')';
            else
                runningPDU += '; ' + t.name + ' - ' + t.decisional_unit_type__c + ':' + t.Org_Hierarchy_Code__c + ' (Count-' + criteriaCountMap.get(currentCriteria)  + ')';
            
            /* increment critera to process after done with last criteria */
            if (criteriaCountMap.get(currentCriteria) == criteriaProcessedMap.get(currentCriteria))
                currentCriteria++;
            
            
            system.debug('************ count map: ' + criteriaCountMap + '************ processed map: ' + criteriaProcessedMap);
      
        return null;
    }
    /******************************************************************************
    *
    * GET EMPLOYEES
    *
    *******************************************************************************/
  	public void getEmployees(){
  		
  		/*Gather the employees that match the criteria */
    	eList = new List<Employee__c>();
   		eListCount = new List<Employee__c>(); 	
    	terminatedEmpList = new List<Employee__c>();
    	
		/**************************
		* DEPARTMENT
		**************************/
		if (criteriaList[currentCriteria].level__c == 'Department' && criteriaList[currentCriteria].dept_org__c != null){
			// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
			if (criteriaProcessedMap.get(currentCriteria) == null)
				eListCount = [select id
    			 from Employee__c
    			 where dept_org__c = :criteriaList[currentCriteria].dept_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c = 'North America'
    			 //and name like 'Aa%'
    			];
			// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure	
    		eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where dept_org__c = :criteriaList[currentCriteria].dept_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and dept_org__c = :criteriaList[currentCriteria].dept_org__c )
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 //and name like 'Aa%'
    			 limit :batchsize
    			];
    			
    		terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where dept_org__c = :criteriaList[currentCriteria].dept_org__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and dept_org__c = :criteriaList[currentCriteria].dept_org__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
    			
   				)];
	
		}
    	/**************************
		* SUPER DIVISION
		**************************/
		if (criteriaList[currentCriteria].level__c == 'Super Division' && criteriaList[currentCriteria].super_division__c != null){
            // 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
    				 from Employee__c
    				 where super_division__c = :criteriaList[currentCriteria].super_division__c and (status__c = 'Active' OR Status__c = 'Pending')
    				 //and global_parking_level__c <> 'CO - Contractor'
    				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    				and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 	and Job_Country_Job__c = 'USA' 
    			 	and Region_Dsc_Org__c ='North America'
    				//and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where super_division__c = :criteriaList[currentCriteria].super_division__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and super_division__c = :criteriaList[currentCriteria].super_division__c)
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'//and name like 'Aa%'
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where super_division__c = :criteriaList[currentCriteria].super_division__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			  //and name like 'Aa%'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in 
    			 (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and super_division__c = :criteriaList[currentCriteria].super_division__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   				)];
		}		   
		
		/**************************
		* DIVISION
		**************************/	
    	if (criteriaList[currentCriteria].level__c == 'Division' && criteriaList[currentCriteria].division_org__c != null){
            // 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
    				 from Employee__c
    				 where division_org__c = :criteriaList[currentCriteria].division_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    				 //and global_parking_level__c <> 'CO - Contractor'
    				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    				 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    				 and Job_Country_Job__c = 'USA' 
    				 and Region_Dsc_Org__c ='North America'//and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure		
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where division_org__c = :criteriaList[currentCriteria].division_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and division_org__c = :criteriaList[currentCriteria].division_org__c)
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 //and name like 'Aaron%'
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where division_org__c = :criteriaList[currentCriteria].division_org__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data'
    			 and division_org__c = :criteriaList[currentCriteria].division_org__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   				 )];
    			
    	}
    	/**************************
		* SUPER DEPARTMENT
		**************************/
    	if (criteriaList[currentCriteria].level__c == 'Super Department' && criteriaList[currentCriteria].super_depart_org__c != null){
            // 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
    				 from Employee__c
    				 where super_depart_org__c = :criteriaList[currentCriteria].super_depart_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    				 //and global_parking_level__c <> 'CO - Contractor'
    				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
                     and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    				 and Job_Country_Job__c = 'USA' 
    				 and Region_Dsc_Org__c ='North America'//and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure					
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where super_depart_org__c = :criteriaList[currentCriteria].super_depart_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data'
    			 and super_depart_org__c = :criteriaList[currentCriteria].super_depart_org__c)
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 //and name like 'Aaron%'
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where super_depart_org__c = :criteriaList[currentCriteria].super_depart_org__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and super_depart_org__c = :criteriaList[currentCriteria].super_depart_org__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   				 )];
    	}
    	/**************************
		* SUB DEPARTMENT
		**************************/
    	if (criteriaList[currentCriteria].level__c == 'Sub Department' && criteriaList[currentCriteria].subdept_org__c != null){
            // 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
    				 from Employee__c
    				 where subdept_org__c = :criteriaList[currentCriteria].subdept_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    				 //and global_parking_level__c <> 'CO - Contractor'
    				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    				 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    				 and Job_Country_Job__c = 'USA' 
    				 and Region_Dsc_Org__c ='North America'//and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure	
    			eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where subdept_org__c = :criteriaList[currentCriteria].subdept_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
                 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and subdept_org__c = :criteriaList[currentCriteria].subdept_org__c)
    			 //and name like 'Aaron%'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where subdept_org__c = :criteriaList[currentCriteria].subdept_org__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
                 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and subdept_org__c = :criteriaList[currentCriteria].subdept_org__c
    			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
    			)];
    	}
    	/**************************
		* SUB DEPARTMENT 2
		**************************/
    	if (criteriaList[currentCriteria].level__c == 'Sub Department 2' && criteriaList[currentCriteria].sub_depart2_org__c != null){
            // 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
    				 from Employee__c
    				 where sub_depart2_org__c = :criteriaList[currentCriteria].sub_depart2_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    				 //and global_parking_level__c <> 'CO - Contractor'
    				 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    				 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    				 and Job_Country_Job__c = 'USA' 
    				 and Region_Dsc_Org__c ='North America' 
    				 
    			 	//and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where sub_depart2_org__c = :criteriaList[currentCriteria].sub_depart2_org__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and sub_depart2_org__c = :criteriaList[currentCriteria].sub_depart2_org__c )
    			 //and name like 'Aaron%'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America' 
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where sub_depart2_org__c = :criteriaList[currentCriteria].sub_depart2_org__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
				 and sub_depart2_org__c = :criteriaList[currentCriteria].sub_depart2_org__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   	  		
   				)];
    	}
    	/**************************
		* COST CENTER
		**************************/
    	if (criteriaList[currentCriteria].level__c == 'Cost Center' && criteriaList[currentCriteria].cost_center__c != null){
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added to the disclosure
				if (criteriaProcessedMap.get(currentCriteria) == null)
					eListCount = [select id
   		 			 from Employee__c
   		 			 where cost_center__c = :criteriaList[currentCriteria].cost_center__c and (status__c = 'Active' OR Status__c = 'Pending')
   		 			 //and global_parking_level__c <> 'CO - Contractor'
   		 			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
   		 			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    				 and Job_Country_Job__c = 'USA' 
    				 and Region_Dsc_Org__c ='North America'
    				 //and name like 'Aa%'
    				];
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added to the disclosure				
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where cost_center__c = :criteriaList[currentCriteria].cost_center__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' and cost_center__c = :criteriaList[currentCriteria].cost_center__c)
    			 //and name like 'Aaron%'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where cost_center__c = :criteriaList[currentCriteria].cost_center__c and status__c = 'Terminated'
    			 //and global_parking_level__c <> 'CO - Contractor'
    			 // 15-Jan-17 : JIRA#RIF-128 : Remove 'Interns' from Age Disclosure
    			 and Empl_Class_Dsc_Job__c IN ('Permanent Employee') // ,'Intern'
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and cost_center__c = :criteriaList[currentCriteria].cost_center__c
   	  			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   		)];
    	}
    	/**************************
		* EMPLOYEE
		**************************/
    	if (criteriaList[currentCriteria].level__c == 'Employee' && criteriaList[currentCriteria].employee__c != null){
				// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				eListCount = [select id
    			 from Employee__c
    			 where id  = :criteriaList[currentCriteria].employee__c and (status__c = 'Active' OR Status__c = 'Pending')
                               and Empl_Class_Dsc_Job__c IN ('Permanent Employee') //RIF#128
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 //and name like 'Aaron%'
    			];
    			// 9-Oct-17 : JIRA#82 : Get all 'Pending' employees (emps who are on leave) so that they are added in the disclosure
				eList = [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where id = :criteriaList[currentCriteria].employee__c and (status__c = 'Active' OR Status__c = 'Pending')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data')
                         and Empl_Class_Dsc_Job__c IN ('Permanent Employee') //RIF#128
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
    			 //and name like 'Aaron%'
    			 limit :batchsize
    			];
    			
    			terminatedEmpLIst =  [select emp_id__c, birth_date__c, Empl_Class_Dsc_Job__c, rif_job_title__c
    			 from Employee__c
    			 where id = :criteriaList[currentCriteria].employee__c and status__c = 'Terminated' 
    			 and Job_Country_Job__c = 'USA' 
    			 and Region_Dsc_Org__c ='North America'
                                       and Empl_Class_Dsc_Job__c IN ('Permanent Employee') //RIF#128
    			 and id in (select employee__c from Severance_And_Release__c where project__c = :p.id and status__c = 'Selected')
    			 and id not in (select employee__c from RIF_Age_Ack_Work__c where project__c = :p.id and type__c = 'Data' 
    			 and level__c = 'Employee'
    			 and project_decisional_org_level__c = :criteriaList[currentCriteria].project_decisional_org_level__c
   				)];
    	}
    	
    	system.debug('pdu: ' + criteriaList[currentCriteria].project_decisional_org_level__c);
    	system.debug('eListCount: ' + eListCount);
    	system.debug('eList Size: ' + eList.size());
    	system.debug('Terminated : ' + terminatedEmpList.size());
    	
    	
    	if (!terminatedEmpList.isEmpty()){
    		eList.addAll(terminatedEmpList);
    	}
    	
    	system.debug('eList size at end: ' + eList.size());
  	}
    /******************************************************************************
    *
    * SAVE
    *
    *******************************************************************************/
    public void saveData(List<wrapEmployee> wList) {
   		
    	List<RIF_Age_Ack_Work__c> iList = new List<RIf_Age_Ack_Work__c>();
    	
    	Set<String> empSet = new Set<String>();
    	/* get a set of employee ids */
    	for (wrapEmployee we2:wList){
    		empSet.add(we2.e.id);	
    	}
    	
    	Map<String,String> srEmpMap = new Map<String,String>();

    	List<Severance_And_Release__c> sList = new List<Severance_And_Release__c>();
    	sList = [select id, employee__c
    		, project_decisional_org_level__c
    		, communication_date__c
    		, Manual_Age_Disclosure_Doc_Id__c
    		from Severance_And_Release__c 
    		where employee__c in :empSet 
    		and project__c = :p.id
    		and status__c = 'Selected'];
    	Map<String,Boolean> manAgeMap = new Map<String,Boolean>();
    	Map<String,String> srAgeDocMap = new Map<String,String>();
    	for (Severance_And_Release__c s:sList){
    		srEmpMap.put(string.valueOf(s.employee__c) + string.valueOf(s.project_decisional_org_level__c),s.id);
    		srAgeDocMap.put(s.id,s.Manual_Age_Disclosure_Doc_Id__c);
    		if (s.Manual_Age_Disclosure_Doc_Id__c != null)
    			manAgeMap.put(s.Manual_Age_Disclosure_Doc_Id__c,false);
    	}
        
    	List<Attachment> aList = [Select id from Attachment where id in :manAgeMap.keySet()];
    	
    	for (Attachment a:aList){
    		if (manAgeMap.get(a.id) != null)
    			manAgeMap.put(a.id,true);
    	}
    	
    	
    	system.debug('Man age map: ' + managemap);
    		
    	
    	for(wrapEmployee we:wList){
    		//if (we.e.global_parking_level__c.contains('Contractor'))
    			//continue;  //get out of loop
    		RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c();
    		
    		we.w.type__c = 'Data';
    		we.w.employee__c = we.e.id;	
    		w = we.w.clone();
    		w.severance_and_release__c = srEMpMap.get(string.valueOf(w.employee__c) + w.project_decisional_org_level__c) ;
    		system.debug('srmap is: ' + srEmpMap);
    		String myId = srEmpMap.get(string.valueOf(w.employee__c) + w.project_decisional_org_level__c);
    		system.debug ('my id:' + myId);
    		
    		if (manAgeMap.get(srAgeDocMap.get(myId)) == true)
    			w.Has_Manual_Age_Disclosure__c = true;
    	
    		//w.title__c = we.e.global_parking_level__c;
    		w.title__c = we.e.rif_job_title__c;
    		Decimal age = decimal.valueOf(we.ageAtTermination);
    		w.age_at_Termination__c = string.valueOf(integer.valueOf(age));
    			
    		iList.add(w);
    	}
    		
   		if (!iList.isEmpty())
   	 		insert iList;
   	 	
   	 	totalAdded = totalAdded + iList.size();
   	 	
   	 	 
    }
    
    /****************************
    *    
    *Generate Data 
    *
    ****************************/
    public pageReference generate(){
   
    	/* get rid of all work records for this project */
    	
    	List<RIF_Age_Ack_Work__c> dList = [select id from RIF_Age_Ack_Work__c where project__c = :p.id limit 1000];
    	
    	if (!dList.isEmpty())
    	 	delete dList;
    	 	
    	deleteCount = deleteCount + dList.size();
    		 	
    	dList = [select id from RIF_Age_Ack_Work__c where project__c = :p.id limit 1];
    	
    	deleteSize = dList.size();
    	
    	if (dList.size() > 0){
    		runningPDU = 'Deleting old data.... - ' + deleteCount;
    		return null;
    	}	
    	
    	/* get a list of all the pdu; specified for the project */
        //MSN:RIF#148 Added If-else condition for calculating specific PDU 2nd April 2018
        List<Child_Project_Decisional_Unit__c> myList;
        if(selectedPDU=='All')
        {
            myList = [
                select id 
                , decisional_unit_code__r.code__c
                , Org_Hierarchy_Code__c
                , decisional_unit_type__c
                , project_decisional_unit__c
                , employee__r.Empl_Class_Dsc_Job__c
                , projectid__c 
                , employee__c
                from child_project_decisional_unit__c where projectid__c = :p.id];
        }
        else
        {
            myList = [
                select id 
                , decisional_unit_code__r.code__c
                , Org_Hierarchy_Code__c
                , decisional_unit_type__c
                , project_decisional_unit__c 
                , employee__r.Empl_Class_Dsc_Job__c
                , projectid__c 
                , employee__c
                from child_project_decisional_unit__c where Project_Decisional_Unit__c = :selectedPDU];
        }
		
		Set<String> departmentSet = new Set<String>();
		
    	criteriaList = new List<RIf_Age_Ack_Work__c>();
		
        if(mylist!=null && !mylist.isEmpty())
        {
            for(Child_Project_Decisional_Unit__c c:mylist){
               	if(c.employee__r.Empl_Class_Dsc_Job__c != 'Intern' )    //MSN:RIF#148 Added If condition for not intern 18 June 2018
                {
                    RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c();
                    String code = '';
                    
                    // 18-Apr-2017 : JIRA#RIF-22 :put checks for Employee type of Org PDU to prevent error/exceptions
                    if(c.decisional_unit_type__c != 'Employee'){
                        List<String> sList = c.org_hierarchy_code__c.split('-');
                        code = sList[0].trim();
                    }
                    
                    if (c.decisional_unit_type__c == 'Department'){
                        w.dept_org__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Super Division'){
                        w.super_division__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Division'){
                        w.division_org__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Super Department'){
                        w.super_depart_org__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Sub Department'){
                        w.subdept_org__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Sub Department 2'){
                        w.sub_depart2_org__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Cost Center'){
                        w.cost_center__c = code;
                    }
                    if (c.decisional_unit_type__c == 'Employee'){
                        w.employee__c = c.employee__c;
                    }
                    
                    
                    w.project__c = p.id;
                    w.Project_Decisional_Org_Level__c = c.id;
                    w.Project_Decisional_Unit__c = c.Project_Decisional_Unit__c;
                    w.org_codes__c = c.decisional_unit_code__c;
                    w.level__c = c.decisional_unit_type__c;
                    w.type__c = 'Criteria';
                    criteriaList.add(w);
                }
            }
        }
    		 	
    	if (!criteriaList.isEmpty())
    		insert criteriaList;
   
   		criteriaSize = criteriaList.size();
    	
    	return null;
    }
    /**********************************************************************************************
    *
    * WRAP EMPLOYEE
    *
    ************************************************************************************************/ 
    public class wrapEmployee{
    
        public Employee__c e {get;set;}
        public RIF_Age_Ack_Work__c w {get;set;}
        public String ageAtTermination {get;set;}
         
        public wrapEmployee(Employee__c e, RIF_Age_Ack_Work__c w){
           
            this.e = e;
            this.w = w;
             
        }
    }
      
    /******************************************************************************
    *
    * EXIT
    *
    *******************************************************************************/
    
    public pageReference exit(){
    	
    	PageReference p = new PageReference('/' + p.id);
        p.setRedirect(true);
        return p;  
		       
    }
    
    /******************************************************************************
    *
    * START
    *
    *******************************************************************************/
    
    public pageReference start(){
        //MSN:RIF#148 Added If condition for checking Blank 2nd April 2018 -Start
    	if(String.isBlank(selectedPDU))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Please select PDU'));
            return null;
        }
        
    	started=true;
    	return null;
		       
    }
}