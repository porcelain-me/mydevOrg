public class RIF_Share_S_R {
    public List <Project_Decisional_Unit__c> eligibleReadOnlyPDU_TO_Share{get;set;}
    public List <Project_Decisional_Unit__c> eligibleReadWritePDU_TO_Share{get;set;}
    public List <Severance_And_Release__c> eligibleS_R_TO_Share{get;set;}
    //private Id projectID;
    public Project__c proj{get;set;}
    
    public Project__share  projectshareRecord{get;set;}
    private User loggedInUser;
    private permissionsetAssignment currentCovUser;
    public RIF_Share_S_R(ApexPages.StandardController controller) { 
        //projectID=ApexPages.currentpage().getparameters().get('Id');
        proj= (Project__c )controller.getRecord();
        proj=[select id,name,OwnerId from project__c where id=:proj.id]; 
        
        
    }
    
    public void shareSR_PDU_OnProjectLoad(){  
        Map<Id,Permissionset> CoveragePermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Coverage']);
        if(CoveragePermissionMap != null && CoveragePermissionMap.keyset() != null && CoveragePermissionMap.keyset().size() > 0){
           
            currentCovUser=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:CoveragePermissionMap.keyset() AND assigneeid=:UserInfo.getUserID()];
               // coverageUsers.add(covUser.assigneeid);
           
        }
        if( (proj!=null) && (proj.ownerID <> UserInfo.getuserID()) && (currentCovUser!=null)){
            //projectshareRecord= new Project__share ();
            System.debug('### Enter into function shareSROnProjectLoad()');
            Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:Userinfo.getuserID()];
            
            projectshareRecord=[select id,parentid,userorgroupid,AccessLevel from project__share where parentid=:proj.id and userorgroupid=:Userinfo.getuserID()];
            eligibleS_R_TO_Share=new List <Severance_And_Release__c>();
            Coverage_Entitlement__c covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
            if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                System.debug('### covEntitlementObj.HR_Coverage_Orgs__r'+covEntitlementObj.HR_Coverage_Orgs__r);
                Map <string,string> covTypeToCodeMap= new Map <string,string> ();
                for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                    covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covEntOrg.Coverage_Entitlement_Org_Code_Derived__c );       
                }
                for(Severance_And_Release__c sr:[select id,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c from Severance_And_Release__c where Active_Project__c=:proj.id]){
                    //|| (covTypeToCodeMap.containsKey('Division'))|| (covTypeToCodeMap.containsKey('Division'))
                    System.debug('### sr'+sr);
                    System.debug('####covTypeToCodeMap####'+covTypeToCodeMap);
                    if( (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').equalsIgnoreCase(sr.Super_Division__c)) )  
                         eligibleS_R_TO_Share.add(sr);  
                    else if( (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').equalsIgnoreCase(sr.Division__c)) )  
                         eligibleS_R_TO_Share.add(sr); 
                    else if( (covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').equalsIgnoreCase(sr.Super_Department__c)) )  
                         eligibleS_R_TO_Share.add(sr);    
                    else if( (covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').equalsIgnoreCase(sr.Department__c)) )  
                         eligibleS_R_TO_Share.add(sr);  
                    else if( (covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').equalsIgnoreCase(sr.Sub_Department__c)) )    
                         eligibleS_R_TO_Share.add(sr); 
                    else if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').equalsIgnoreCase(sr.Sub_Department_2__c)) )      
                        eligibleS_R_TO_Share.add(sr);
                    else if( (covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').equalsIgnoreCase(sr.Cost_Center__c)) )   
                        eligibleS_R_TO_Share.add(sr);  
                      
                }
                
                System.debug('### eligibleS_R_TO_Share'+eligibleS_R_TO_Share);
                eligibleReadOnlyPDU_TO_Share= new  List <Project_Decisional_Unit__c> (); 
                eligibleReadWritePDU_TO_Share= new List <Project_Decisional_Unit__c> (); 
                for(Project_Decisional_Unit__c pduObj:[select id,Project__c,project__r.ownerID from Project_Decisional_Unit__c where Project__c=:proj.id]){
                     System.debug('### pduObj'+pduObj);
                     if(projectshareRecord!=null){
                         if(projectshareRecord.accesslevel=='Read') 
                             eligibleReadOnlyPDU_TO_Share.add(pduObj);
                         else if(projectshareRecord.accesslevel=='Edit')
                             eligibleReadWritePDU_TO_Share.add(pduObj); 
                     }   
                }
                //eligibleS_R_TO_Share=new List <Severance_And_Release__c>([select id from Severance_And_Release__c where Active_Project__c=:projectID AND Division__c=:empObj.Division_Org__c AND Super_Division__c=:empObj.Super_Division__c]);
                try{
                    if(eligibleS_R_TO_Share!=null && eligibleS_R_TO_Share.size()>0){
                        list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                        //pageMessage =RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit');
                        //system.debug('errormsg: '+pageMessage);
                        RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit');
                    }
                    if(eligibleReadOnlyPDU_TO_Share!=null && eligibleReadOnlyPDU_TO_Share.size()>0){
                        list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                        //pageMessage =RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit');
                        //system.debug('errormsg: '+pageMessage);
                        RIF_Sharing.Share_PDU_From_Project(eligibleReadOnlyPDU_TO_Share,Userinfo.getuserID(),'Read');
                    }
                    if(eligibleReadWritePDU_TO_Share!=null && eligibleReadWritePDU_TO_Share.size()>0){
                        list<ApexPages.Message> pageMessage = new list<ApexPages.Message>();
                        //pageMessage =RIF_Sharing.Share_S_R_From_Project(eligibleS_R_TO_Share,Userinfo.getuserID(),'Edit');
                        //system.debug('errormsg: '+pageMessage);
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
        
        }
        if( (proj!=null) && (proj.ownerID ==UserInfo.getuserID())){
            List <Project_Decisional_Unit__c> pduListToShare=new List <Project_Decisional_Unit__c>([select id,Project__c,project__r.ownerID from Project_Decisional_Unit__c where Project__c=:proj.id and ownerid!=:UserInfo.getuserId()]);
            RIF_Sharing.Share_PDU_From_Project(pduListToShare,Userinfo.getuserID(),'Edit'); 
        
        }
        
    }

}