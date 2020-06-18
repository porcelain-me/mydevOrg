public without sharing class RIF_Custom_Project_Controller{
   //Getter-Setters
   public Project__c proj{get;set;}
   public boolean enableStandardPDUList{get;set;}
   public boolean enableCustomPDUList{get;set;}
   public List <Project_Decisional_Unit__c> eligibleReadOnlyPDU_TO_Share{get;set;}
   public List <Project_Decisional_Unit__c> eligibleReadWritePDU_TO_Share{get;set;}
   public List <Severance_And_Release__c> accessible_SRRecords{get;set;}
   public integer totalEligibleSRToShare{get;set;}
   //Variables
   private permissionsetAssignment currentCovUser;
   // 3-Apr-2017 : Added checks for Coverage and Generic users
   private List<PermissionSetAssignment> userPSAssignment;
   public Boolean isCoverageUser = false;
   public Boolean isGenericUser = false;
   // 8-Apr-2017  : Added the checks for Compensation and Operations user
   public Boolean isCompUser = false;
   public Boolean isOpsUser = false;
    
    
   private Project__share  projectshareRecord;
   
    public RIF_Custom_Project_Controller(ApexPages.StandardController controller) {
        //recordId = controller.getId();
        enableStandardPDUList=false;
        enableCustomPDUList=false;
        proj= (Project__c )controller.getRecord();
        // 17-July-17 : RIF-93 : Show message for a MODEL project,
        // added Status field to the query
        proj=[select id,name,OwnerId,Status__c from project__c where id=:proj.id]; 
    }
   
    public pageReference redirect() {
            List <Severance_And_Release__c>  eligibleS_R_TO_Share = new List <Severance_And_Release__c>();
            Map<Id,Permissionset> CoveragePermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Coverage']);
        	// 3-Apr-2017 : Added to fetch the PS details of RIF Generic User
        	Map<Id,Permissionset> genericPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_Generic_User']);
        	// 8-Apr-2017 : Added to fetch the PS details of RIF Compensation User and RIF Operations User
        	Map<Id,Permissionset> compPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']);
        	Map<Id,Permissionset> opsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
         	Map <string,set <string>> covTypeToCodeMap; //MSN
            try{
                  //MSN: RIF#54 Coverage Entitlement PDU sharing
                  covTypeToCodeMap= new Map <string,set <string>> (RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode(Userinfo.getuserID()));
                //currentCovUser=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:CoveragePermissionMap.keyset() AND assigneeid=:UserInfo.getUserID()];
                // 3-Apr-2017 : Check the user's PS - should be Coverage or Generic user
                userPSAssignment = [SELECT id,assigneeid,permissionsetid from permissionsetAssignment WHERE AssigneeId =: UserInfo.getUserID()];
                if(userPSAssignment != null && !userPSAssignment.isEmpty()){
                    for(PermissionSetAssignment psAsgn : userPSAssignment){
                        if(CoveragePermissionMap != null && !CoveragePermissionMap.isEmpty() && CoveragePermissionMap.containsKey(psAsgn.permissionsetid)){
                            isCoverageUser = true;
                        }
                        else if(genericPermissionMap != null && !genericPermissionMap.isEmpty() && genericPermissionMap.containsKey(psAsgn.permissionsetid)){
                            isGenericUser = true;
                        }
                        // 8-Apr-2017 : Checks for Compensation and Operations user
                        else if(compPermissionMap != null && !compPermissionMap.isEmpty() && compPermissionMap.containsKey(psAsgn.permissionsetid)){
                            isCompUser = true;
                        }
                        else if(opsPermissionMap != null && !opsPermissionMap.isEmpty() && opsPermissionMap.containsKey(psAsgn.permissionsetid)){
                            isOpsUser = true;
                        }
                    }
                }
			}
            catch(Exception e){
                System.debug(e);
            }
            //if(proj.ownerID <> UserInfo.getuserID()){
                accessible_SRRecords=new List <Severance_And_Release__c>(RIF_DataUtil.getAccessibleSRRecords(proj.id));
                for(Severance_And_Release__c sr: accessible_SRRecords){
                    if(sr.ownerID!=UserInfo.getUserId()){
                        eligibleS_R_TO_Share.add(sr);   
                    }   
                }
                System.debug('###eligibleS_R_TO_Share#####'+eligibleS_R_TO_Share);
                System.debug('###size of eligibleS_R_TO_Share#####'+eligibleS_R_TO_Share.size());
                if(accessible_SRRecords!=null && accessible_SRRecords.size()>0){
                    System.debug('####accessible_SRRecords in custom project controller###'+accessible_SRRecords);
                    System.debug('####size of accessible_SRRecords size in custom project controller###'+accessible_SRRecords.size());
                    totalEligibleSRToShare=accessible_SRRecords.size();
                }
            //}
            System.debug('####Before entry into IF loop for sharing proj.id###'+proj.id+'currentCovUser'+currentCovUser);
            //if( (proj!=null)  && (currentCovUser != null || currentGenericUser != null )){  //&& (proj.ownerID <> UserInfo.getuserID())
            if( (proj!=null)  && (isCoverageUser || isGenericUser || isCompUser || isOpsUser)){    
                 System.debug('### Enter into function shareSROnProjectLoad()');
                 Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:Userinfo.getuserID()];
            	//  3-Apr-2017 : Changes for Generic users
                if(isCoverageUser){
                    projectshareRecord=[select id,parentid,userorgroupid,AccessLevel from project__share where parentid=:proj.id and userorgroupid=:Userinfo.getuserID()];
                    
                    //System.debug('### eligibleS_R_TO_Share'+eligibleS_R_TO_Share);
                    eligibleReadOnlyPDU_TO_Share= new  List <Project_Decisional_Unit__c> ();  
                    eligibleReadWritePDU_TO_Share= new List <Project_Decisional_Unit__c> (); 
                    System.debug('### projectshareRecord#####$$$$$$'+projectshareRecord.accesslevel); 
                    for(Project_Decisional_Unit__c pduObj:[select id,(select id, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c  from Procject_Decisional_Units__r),Project__c,project__r.ownerID,Decisional_Unit_Name__c,Employees__c,Employee__c,HR_Signatory__c,lastmodifiedBy.Name,lastmodifiedDate from Project_Decisional_Unit__c where Project__c=:proj.id]){
                        System.debug('### pduObj'+pduObj);
                        //MSN:RIF#54 Changes -Starts
                       	Boolean tempFlag=false;
                        for(Child_Project_Decisional_Unit__c childPDU : pduObj.Procject_Decisional_Units__r)
                        {
                            if(childPDU.Decisional_Unit_Type__c =='Employee')
                            {
                                if(covTypeToCodeMap!=null &&  (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(childPDU.Employee__r.Super_Division__c)) ){  
                                    tempFlag=true;
                                    break;
                                }
                                else if(covTypeToCodeMap!=null && (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(childPDU.Employee__r.Division_Org__c)) ){
                                    tempFlag=true;
                                     break;
                                }
                                else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(childPDU.Employee__r.Super_Depart_Org__c) )){
                                    tempFlag=true;
                                     break;
                                } 
                                else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(childPDU.Employee__r.Dept_Org__c))) {                 
                                    tempFlag=true;
                                     break;
                                } 
                                else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(childPDU.Employee__r.Subdept_Org__c)) ) { 
                                    tempFlag=true;  
                                     break;
                                }
                                else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Employee__r.Sub_Depart2_Org__c)) ) { 
                                    tempFlag=true;
                                     break;
                                } 
                                else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(childPDU.Employee__r.Cost_Center__c)) ) { 
                                    tempFlag=true;
                                     break;
                                }
                            }
                            else
                            {
                                if(covTypeToCodeMap!=null && covTypeToCodeMap.containsKey(childPDU.Decisional_Unit_Type__c) && covTypeToCodeMap.get(childPDU.Decisional_Unit_Type__c).contains(childPDU.Decisional_Unit_Derived__c) ){  
                                    tempFlag=true;
                                    break;
                                }  
                            }
                        }
                        //MSN:RIF#54 Changes -Ends
                        if(projectshareRecord!=null){
                            if(projectshareRecord.accesslevel=='Read') {
                                enableStandardPDUList=false;
                                enableCustomPDUList=true;
                                if(tempFlag)  //MSN : Added if cond
                                	eligibleReadOnlyPDU_TO_Share.add(pduObj);
                            }
                            else if( (projectshareRecord.accesslevel=='Edit') || (projectshareRecord.accesslevel=='All') ){
                                enableStandardPDUList=true;
                                enableCustomPDUList=false;
                                if(tempFlag)   //MSN : Added if cond
                                	eligibleReadWritePDU_TO_Share.add(pduObj); 
                            }    
                        }   
                    }
                    if(eligibleReadOnlyPDU_TO_Share.size()==0 && eligibleReadWritePDU_TO_Share.size()==0){ 
                        enableStandardPDUList=true;
                        enableCustomPDUList=false;  
                    }
                    
                    
                    try{
                        
                        if(eligibleS_R_TO_Share!=null && eligibleS_R_TO_Share.size()>0){
                            System.debug('INSIDE TRY::'+eligibleS_R_TO_Share);
                            list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                            if(projectshareRecord.accesslevel=='Read') {
                                System.debug('INSIDE READ ONLY::'+eligibleS_R_TO_Share);
                                RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Read'); 
                            }
                            else if( (projectshareRecord.accesslevel=='Edit') || (projectshareRecord.accesslevel=='All') ){
                                RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit');   
                            }
                            
                        } 
                        if(eligibleReadOnlyPDU_TO_Share!=null && eligibleReadOnlyPDU_TO_Share.size()>0){
                            list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                            RIF_Sharing.Share_PDU_From_Project(eligibleReadOnlyPDU_TO_Share,Userinfo.getuserID(),'Read');
                        }
                        if(eligibleReadWritePDU_TO_Share!=null && eligibleReadWritePDU_TO_Share.size()>0){
                            list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                            System.debug('###eligibleReadWritePDU_TO_Share###'+eligibleReadWritePDU_TO_Share);
                            RIF_Sharing.Share_PDU_From_Project(eligibleReadWritePDU_TO_Share,Userinfo.getuserID(),'Edit');
                        }
                        /*if(!pageMessage.isEmpty()){
                        ApexPages.getMessages().clear();
                        for(ApexPages.Message msg : pageMessage){
                        ApexPages.addMessage(msg);
                        } 
                        
                        }*/
                    }
                    catch(DmlException e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Apex sharing recalculation threw the exception: ' +e.getMessage()));
                    }   
                    
                }
                else if(isGenericUser){
                    try{
                        // ** TODO **
                        // 1. Check if the Generic users will have explicit access to all Projects or the Projects has to be shared
                        // 2. Check the access of the PDUs on the project
                        // all the PDUs under the project should be READ ONLY to the logged in user
                        eligibleReadOnlyPDU_TO_Share= new  List <Project_Decisional_Unit__c>(); 
                        if(proj.id != null){
                            for(Project_Decisional_Unit__c pduObj : [select id,(select id, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c  from Procject_Decisional_Units__r),Project__c,project__r.ownerID,Decisional_Unit_Name__c,Employees__c,Employee__c,HR_Signatory__c,lastmodifiedBy.Name,lastmodifiedDate from Project_Decisional_Unit__c where Project__c=:proj.id]){
                                //MSN:RIF#54 Changes -Starts
                                Boolean tempFlag=false;
                                for(Child_Project_Decisional_Unit__c childPDU : pduObj.Procject_Decisional_Units__r)
                                {
                                    if(childPDU.Decisional_Unit_Type__c =='Employee')
                                    {
                                        if(covTypeToCodeMap!=null &&  (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(childPDU.Employee__r.Super_Division__c)) ){  
                                            tempFlag=true;
                                            break;
                                        }
                                        else if(covTypeToCodeMap!=null && (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(childPDU.Employee__r.Division_Org__c)) ){
                                            tempFlag=true;
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(childPDU.Employee__r.Super_Depart_Org__c) )){
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(childPDU.Employee__r.Dept_Org__c))) {                 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(childPDU.Employee__r.Subdept_Org__c)) ) { 
                                            tempFlag=true;  
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Employee__r.Sub_Depart2_Org__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(childPDU.Employee__r.Cost_Center__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        if(covTypeToCodeMap!=null && covTypeToCodeMap.containsKey(childPDU.Decisional_Unit_Type__c) && covTypeToCodeMap.get(childPDU.Decisional_Unit_Type__c).contains(childPDU.Decisional_Unit_Derived__c) ){  
                                            tempFlag=true;
                                            break;
                                        }  
                                    }
                                }
                                //MSN:RIF#54 Changes -Ends
                                enableStandardPDUList = false;
                                enableCustomPDUList = true;
                                if(tempFlag)  //MSN: added if cond
                                	eligibleReadOnlyPDU_TO_Share.add(pduObj);
                            }   
                        }
                        if(eligibleReadOnlyPDU_TO_Share != null && !eligibleReadOnlyPDU_TO_Share.isEmpty()){
                            RIF_Sharing.Share_PDU_From_Project(eligibleReadOnlyPDU_TO_Share,Userinfo.getuserID(),'Read');
                        }
                        
                        // 3. Show all SNRs that fall under the logged in user's coverage entitlements
                        if(eligibleS_R_TO_Share != null && !eligibleS_R_TO_Share.isEmpty()){
                            System.debug('INSIDE GENERIC TRY::'+eligibleS_R_TO_Share);
                            RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Read'); 
                        } 
                        
                    }
                    catch(Exception exp){
                        system.debug(' -- EXCEPTION FOR GENERIC USER -- ' + exp.getMessage());
                    }
                    
                }
                else if(isCompUser){
                    try{
                        eligibleReadOnlyPDU_TO_Share= new  List <Project_Decisional_Unit__c>(); 
                        if(proj.id != null){
                            for(Project_Decisional_Unit__c pduObj : [select id,(select id, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c  from Procject_Decisional_Units__r),Project__c,project__r.ownerID,Decisional_Unit_Name__c,Employees__c,Employee__c,HR_Signatory__c,lastmodifiedBy.Name,lastmodifiedDate from Project_Decisional_Unit__c where Project__c=:proj.id]){
                                //MSN:RIF#54 Changes -Starts
                                Boolean tempFlag=false;
                                for(Child_Project_Decisional_Unit__c childPDU : pduObj.Procject_Decisional_Units__r)
                                {
                                    if(childPDU.Decisional_Unit_Type__c =='Employee')
                                    {
                                        if(covTypeToCodeMap!=null &&  (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(childPDU.Employee__r.Super_Division__c)) ){  
                                            tempFlag=true;
                                            break;
                                        }
                                        else if(covTypeToCodeMap!=null && (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(childPDU.Employee__r.Division_Org__c)) ){
                                            tempFlag=true;
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(childPDU.Employee__r.Super_Depart_Org__c) )){
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(childPDU.Employee__r.Dept_Org__c))) {                 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(childPDU.Employee__r.Subdept_Org__c)) ) { 
                                            tempFlag=true;  
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Employee__r.Sub_Depart2_Org__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(childPDU.Employee__r.Cost_Center__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        if(covTypeToCodeMap!=null && covTypeToCodeMap.containsKey(childPDU.Decisional_Unit_Type__c) && covTypeToCodeMap.get(childPDU.Decisional_Unit_Type__c).contains(childPDU.Decisional_Unit_Derived__c) ){  
                                            tempFlag=true;
                                            break;
                                        }  
                                    }
                                }
                                //MSN:RIF#54 Changes -Ends
                                enableStandardPDUList = false;
                                enableCustomPDUList = true;
                                if(tempFlag)  //MSN: added if cond
                                	eligibleReadOnlyPDU_TO_Share.add(pduObj);
                            }   
                        }
                        if(eligibleReadOnlyPDU_TO_Share != null && !eligibleReadOnlyPDU_TO_Share.isEmpty()){
                            RIF_Sharing.Share_PDU_From_Project(eligibleReadOnlyPDU_TO_Share,Userinfo.getuserID(),'Read');
                        }
                        
                        // Show all SNRs that fall under the logged in user's coverage entitlements
                        if(eligibleS_R_TO_Share != null && !eligibleS_R_TO_Share.isEmpty()){
                            System.debug('INSIDE COMPENSATION TRY::'+eligibleS_R_TO_Share);
                            RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Read'); 
                        } 
                        
                    }
                    catch(Exception exp){
                        system.debug(' -- EXCEPTION FOR COMPENSATION USER -- ' + exp.getMessage());
                    }
                    
                }
                else if(isOpsUser){
                    try{
                        eligibleReadOnlyPDU_TO_Share= new  List <Project_Decisional_Unit__c>(); 
                        if(proj.id != null){
                            for(Project_Decisional_Unit__c pduObj : [select id,(select id, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c  from Procject_Decisional_Units__r),Project__c,project__r.ownerID,Decisional_Unit_Name__c,Employees__c,Employee__c,HR_Signatory__c,lastmodifiedBy.Name,lastmodifiedDate from Project_Decisional_Unit__c where Project__c=:proj.id]){
                                //MSN:RIF#54 Changes -Starts
                                Boolean tempFlag=false;
                                for(Child_Project_Decisional_Unit__c childPDU : pduObj.Procject_Decisional_Units__r)
                                {
                                    if(childPDU.Decisional_Unit_Type__c =='Employee')
                                    {
                                        if(covTypeToCodeMap!=null &&  (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').contains(childPDU.Employee__r.Super_Division__c)) ){  
                                            tempFlag=true;
                                            break;
                                        }
                                        else if(covTypeToCodeMap!=null && (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').contains(childPDU.Employee__r.Division_Org__c)) ){
                                            tempFlag=true;
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').contains(childPDU.Employee__r.Super_Depart_Org__c) )){
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').contains(childPDU.Employee__r.Dept_Org__c))) {                 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').contains(childPDU.Employee__r.Subdept_Org__c)) ) { 
                                            tempFlag=true;  
                                            break;
                                        }
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').contains(childPDU.Employee__r.Sub_Depart2_Org__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        } 
                                        else if( covTypeToCodeMap!=null &&(covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').contains(childPDU.Employee__r.Cost_Center__c)) ) { 
                                            tempFlag=true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        if(covTypeToCodeMap!=null && covTypeToCodeMap.containsKey(childPDU.Decisional_Unit_Type__c) && covTypeToCodeMap.get(childPDU.Decisional_Unit_Type__c).contains(childPDU.Decisional_Unit_Derived__c) ){  
                                            tempFlag=true;
                                            break;
                                        }  
                                    }
                                }
                                //MSN:RIF#54 Changes -Ends
                                enableStandardPDUList = false;
                                enableCustomPDUList = true;
                                if(tempFlag)  //MSN: added if cond
                                	eligibleReadOnlyPDU_TO_Share.add(pduObj);
                            }   
                        }
                        if(eligibleReadOnlyPDU_TO_Share != null && !eligibleReadOnlyPDU_TO_Share.isEmpty()){
                            RIF_Sharing.Share_PDU_From_Project(eligibleReadOnlyPDU_TO_Share,Userinfo.getuserID(),'Read');
                        }
                        
                        // Show all SNRs that fall under the logged in user's coverage entitlements
                        if(eligibleS_R_TO_Share != null && !eligibleS_R_TO_Share.isEmpty()){
                            System.debug('INSIDE OPERATIONS TRY::'+eligibleS_R_TO_Share);
                            RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit'); 
                        } 
                        
                    }
                    catch(Exception exp){
                        system.debug(' -- EXCEPTION FOR OPERATIONS USER -- ' + exp.getMessage());
                    }
                    
                }
                return null;
            } 
            else{
                 PageReference standardcustomPage =  Page.RIF_StandardProjectPage;
                 standardcustomPage.setRedirect(true);
                 standardcustomPage.getParameters().put('id', proj.Id);
                 standardcustomPage.getParameters().put('totalSRRecords', string.valueof(totalEligibleSRToShare));  
                 return standardcustomPage ;
            }
        
    }
}