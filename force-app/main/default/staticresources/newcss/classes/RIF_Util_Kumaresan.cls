public class RIF_Util_Kumaresan {
    
    public static List<Severance_And_Release__c> updateSnROnContentManagementforSet(set<ID> srSet, 
                                                                                    set<String> CongaTemplateSet){
        
        system.debug('******************INSIDE RIF_Util_Kumaresan.updateSnROnContentManagementforSet METHOD');
        system.debug('******************srSet:'+srSet);
        system.debug('******************CongaTemplateSet:'+CongaTemplateSet);
        Set<String> SNRStringSet = new Set<String>();
        for(ID s: srSet){
            SNRStringSet.add(string.valueof(s));
        }
        system.debug('******************SNRStringSet:'+SNRStringSet);
        List<Severance_And_Release__c> srListAllFields = new List<Severance_And_Release__c> ();
        List<Severance_And_Release__c> returnSnRList = new List<Severance_And_Release__c> ();
        
        srListAllFields = RIF_Util_Kumaresan.getAllFieldsFromSObject(new Severance_And_Release__c(),'',
                                                                     'statisIds',SNRStringSet);
        system.debug('******************srListAllFields :'+srListAllFields );
                                                             
        returnSnRList = RIF_Util_Kumaresan.updateSnROnContentManagement(CongaTemplateSet,srListAllFields);
        system.debug('******************returnSnRList :'+returnSnRList );
        // 19-Jan-2017 : ALM#1874 : Issue with generating release agreement from 'Step-2'
        //srListAllFields.clear();
        
        return returnSnRList;
    }
    
    public static List<Severance_And_Release__c> updateSnROnContentManagement(set<string> CongaTemplateSet,
                                                                              List<Severance_And_Release__c> SrRecords){
        Map<String,string> srFields=new Map<String,string>();
        Map<string,Map<string,string>> ContentMap=new Map<string,Map<string,string>>();
        String employeeClause='';
        map<string,string> empClause =new map<string,string>();
        
        Map<string,Schema.SobjectField> fieldResults = Severance_And_Release__c.getSObjectType().getDescribe().fields.getMap(); 
        for(string f:FieldResults.keySet()){
            srFields.put(FieldResults.get(f).getDescribe().getName(),
                            String.ValueOf(FieldResults.get(f).getDescribe().getType()));
        }
        fieldResults.clear();

        if(CongaTemplateSet != null && CongaTemplateSet.size() >0 && SrRecords != null && SrRecords.size() >0 ){
            for(Conga_Content_Management__c c: [select id,name,Conga_Content__c,Conga_Template__c,
                                                        Conga_Template__r.Document_Name__C from Conga_Content_Management__c 
                                                        where Conga_Template__c IN: CongaTemplateSet AND 
                                                        Conga_Template__r.Is_this_having_content_management__c=true AND 
                                                        Conga_Template__r.APXTConga4__Template_Group__c='RIF Template' AND 
                                                        Conga_Template__r.APXTConga4__Template_Type__c ='Document'] ){
                if(ContentMap.containsKey(c.Conga_Template__r.Document_Name__C)){
                    ContentMap.get(c.Conga_Template__r.Document_Name__C).put(c.name,c.Conga_Content__c);
                }
                else{
                    Map<string,string> con=new Map<string,string>();
                    con.put(c.name,c.Conga_Content__c);
                    ContentMap.put(c.Conga_Template__r.Document_Name__C,con);
                }
            }
            //system.debug('******************ContentMap'+ContentMap);
            Set<String> empIdSet = new Set<String>();
                
            // 16-Oct-17 : JIRA#RIF-106 : Get the latest Unvested Equity for the employee
            for(Severance_And_Release__c emp:SrRecords){
                empIdSet.add(emp.employee__c);
            }
            
            // the map will get the latest unvested equity details for the employee
            Map<String,Unvested_Equity__c> empEquityMap = new Map<String,Unvested_Equity__c>();
            List<Unvested_Equity__c> equityList = [SELECT Id, Employee_temp__c, Date_as_of__c, Unvested_total_balance__c FROM Unvested_Equity__c WHERE Employee_temp__c IN : empIdSet];
            if(equityList != null && !equityList.isEmpty()){
                for(Unvested_Equity__c eq : equityList){
                    empEquityMap.put(eq.Employee_temp__c, eq);
                }
            }
            
            if(ContentMap != null && ContentMap.keyset() != null && ContentMap.keyset().size() >0){

                Map<ID,Employee__c>  empMap = new Map<ID,Employee__c>([SELECT id, emp_ID__c, name, State_Home__c,
                                                                            Job_State_Job__c, Building_State_Directory__c
                                                                            FROM employee__C WHERE Id IN:empIdSet]);
                
                Map<string,string> stateToClauseMap= new  Map<string,string> ();
                // 4-Aug-2016 : Commenting the below code as the state-clause template will now be stored in an object
                /*
                List<RIF_TemplateCLAUSETag__c> customsettingRecordList = new List<RIF_TemplateCLAUSETag__c> ();
                customsettingRecordList = RIF_TemplateCLAUSETag__c.getAll().values();
                for(RIF_TemplateCLAUSETag__c customsettingRecord: customsettingRecordList){
                    stateToClauseMap.put(customsettingRecord.name,customsettingRecord.clause__c);   
                }
                */
                List<RIF_Template_Clause_Tag__c> templateClauseObjList = [SELECT Name,Clause__c FROM RIF_Template_Clause_Tag__c];
                for(RIF_Template_Clause_Tag__c each : templateClauseObjList){
                    stateToClauseMap.put(each.Name, each.Clause__c);
                }
                system.debug('Custom Settings State Clause:'+stateToClauseMap);
                
                for(Severance_And_Release__c emp:SrRecords){
                    
                    employeeClause='';
                    String homeClause='';
                    String stateClause='';
                    
                    // ISSUE HERE IS THAT STATE_HOME__C FIELD IS ENCRYPTED
                    if(empMap != null ){//&& empMap.size() ==1
                        if(emp.State_Home__c != null && stateToClauseMap != null && 
                                        stateToClauseMap.containsKey(emp.State_Home__c)){    
                            homeClause = stateToClauseMap.get(emp.State_Home__c);
                        } 
                        system.debug('***************stateToClauseMap:homeClause#####'+homeClause);
                        if(empMap.get(emp.employee__c).Job_State_Job__c != null  && stateToClauseMap != null && 
                                            stateToClauseMap.containsKey(empMap.get(emp.employee__c).Job_State_Job__c)){
                            stateClause=stateToClauseMap.get(empMap.get(emp.employee__c).Job_State_Job__c );
                        }
                        system.debug('***************home and State clauses:'+homeClause+'--'+stateClause);
                        
                        if(emp.State_Home__c != null && empMap.get(emp.employee__c).Job_State_Job__c != null && 
                                    emp.State_Home__c == empMap.get(emp.employee__c).Job_State_Job__c && 
                                    homeClause!='' && stateClause!= '') {// homeClause != null && stateClause != null &&
                            employeeClause=homeClause;
                        } else if(emp.State_Home__c != null && empMap.get(emp.employee__c).Job_State_Job__c != null && 
                                    emp.State_Home__c != empMap.get(emp.employee__c).Job_State_Job__c && 
                                    stateClause != '' && homeClause!='') { 
                            employeeClause = homeClause +', ' + stateClause;
                        } else if(emp.State_Home__c != null && homeClause != ''  && 
                                    (stateClause == '' || empMap.get(emp.employee__c).Job_State_Job__c == null)) { 
                            employeeClause = homeClause;
                        } else if(empMap.get(emp.employee__c).Job_State_Job__c != null && stateClause != ''  && 
                                    (homeClause == '' || emp.State_Home__c == null)){ 
                            employeeClause = stateClause;
                        }                                             
                        system.debug('*****EmpID:'+ emp.Employee__c + ' **EmpClause :'+employeeClause  + '*****CA Flag'+ emp.CA_Flag__c);
                        
                        if(emp.CA_Flag__c && !employeeClause.contains(stateToClauseMap.get('CA')))
                            employeeClause += ', ' + stateToClauseMap.get('CA');
                        
                        emp.o_template1_clause__c = employeeClause;
                        empClause.put(emp.Employee__c,employeeClause);                            
                    }
                    
                }
                
                for(String temp:ContentMap.keyset()){
                    Map<string,String> conMap=ContentMap.get(temp);
                    if(conMap != null && conMap.keyset() != null){
                        for(String str:conMap.keyset()){
                            for(Severance_And_Release__c sr:SrRecords){
                                if(srFields.containsKey(str+'__c') && srFields.containsKey('O_'+str+'__c')){
                                    if(sr.get(str+'__c') != null && Boolean.ValueOf(sr.get(str+'__c')) ==true){
                                        sr.put('O_'+str+'__c',
                                                RIF_Util_Kumaresan.getActualContent(srFields,empClause,sr,
                                                                                    conMap.get(str),
                                                                                    '{'+str.substring(str.lastindexOf('_'))+'}'));
                                        system.debug('***********************SR Values changed:'+ sr.get('O_'+str+'__c'));
                                    } else {
                                        sr.put('O_'+str+'__c','');
                                    }
                                }                                  
                            }
                        }
                    }
                }
                //update SrRecords;
                ContentMap.clear();
                srFields.clear();
                empClause = null;
                empMap.clear();
            }
            // 16-Oct-17 : JIRA#RIF-106 : Get the latest Unvested Equity for the employee
            // check if this employee has any unvested equity, if yes , then get copy it again to the SNR
            for(Severance_and_Release__c snr : SrRecords){
                // employee has unvested amount and the unvested equity record also exists for the employee
                if(snr.Employee__r.HasEquity__c == true && empEquityMap != null && !empEquityMap.isEmpty() && empEquityMap.containsKey(snr.Employee__c)){
                    RIF_DataUtil.copyFieldsToSRFromUnvestedEquity(snr, empEquityMap.get(snr.Employee__c));
                    snr.Has_Unvested_Total_Balance__c = true;
                }
                // the employee previously (during SNR creation) had unvested amount and now does not
                if(snr.Employee__r.HasEquity__c == false && snr.Has_Unvested_Total_Balance__c == true){ //&& !empEquityMap.containsKey(snr.Employee__c) ){
                    snr.Conga_Total_Unvested_Value__c = '';
                    snr.Unvested_As_of_Date__c = null;
                    snr.Has_Unvested_Total_Balance__c = false;
                }                
            }
        }
        
        system.debug('Returning sr records: '+ srRecords);
        return SrRecords;
    }
    
    public static List<Severance_And_Release__c> updateSnROnContentManagement_New(set<string> CongaTemplateSet,
                                                                                  List<Severance_And_Release__c> SrRecords){
        Map<String,string> srFields=new Map<String,string>();
        Map<string,string> ContentMap=new Map<string,string>();
        String employeeClause='';
        map<string,string> empClause =new map<string,string>();
        
        map<string,set<String>> subContentMap =new map<string,set<String>>();
        map<string,String> subContentValues =new map<string,String>();
        
        Map<string,Schema.SobjectField> fieldResults = Severance_And_Release__c.getSObjectType().getDescribe().fields.getMap(); 
        for(string f:FieldResults.keySet()){
            srFields.put(FieldResults.get(f).getDescribe().getName(),
                         String.ValueOf(FieldResults.get(f).getDescribe().getType()));
        }
        if(CongaTemplateSet != null && CongaTemplateSet.size() >0 && SrRecords != null && SrRecords.size() >0 ){
            List<Conga_Content_Management__c> CongaContentsRecords=[select id,name,Child_Contents__c,Conga_Content__c,
                                                                    Conga_Template__c,Content_Criteria__c,
                                                                    Conga_Template__r.Document_Name__C,
                                                                    Conga_Template__r.Conga_Query__c,
                                                                    Conga_Template__r.APXTConga4__Name__c,
                                                                    Conga_Template__r.APXTConga4__Template_Group__c,
                                                                    Conga_Template__r.APXTConga4__Template_Type__c 
                                                                    FROM Conga_Content_Management__c WHERE 
                                                                    Conga_Template__c IN: CongaTemplateSet AND 
                                                                    Conga_Template__r.Is_this_having_content_management__c=true 
                                                            AND Conga_Template__r.APXTConga4__Template_Group__c='RIF Template' 
                                                            AND Conga_Template__r.APXTConga4__Template_Type__c ='Document']; 
            If(CongaContentsRecords != null && CongaContentsRecords.size() >0){
                for(Conga_Content_Management__c c:CongaContentsRecords ){
                    ContentMap.put(c.name,c.Conga_Content__c);
                    
                    set<string> subList=new set<String>();
                    if(c.Child_Contents__c != null){
                        subList.addAll(c.Child_Contents__c.split(';'));
                    }       
                    if(subList.size() >0){                 
                        subContentMap.put(c.name,subList);
                    }
                }
            }
            
            if(ContentMap != null && ContentMap.keyset() != null && ContentMap.keyset().size() >0){
                if(subContentMap != null && subContentMap.keyset() != null){
                    for(String s:subContentMap.keyset()){
                        for(String str:subContentMap.get(s)){
                            if(subContentMap.containsKey(str)){
                                //Error... more than 1 level of hierarchy not allowed..,
                            }  
                            else if(ContentMap.get(s) != null){
                                system.debug('***************before'+ContentMap.get(s)+'-'+str);
                                ContentMap.get(s).replaceAll(str,ContentMap.get(str));
                                system.debug('***************after'+ContentMap.get(s));
                            }              
                        }
                    }
                }
            }
            
            if(ContentMap != null && ContentMap.keyset() != null){            
                
                for(Severance_And_Release__c emp:SrRecords){
                    
                    List<Employee__C> empList=[select id,emp_ID__c,name,State_Home__c,Job_State_Job__c,
                                               Building_State_Directory__c from employee__C where Id=:emp.Employee__c];
                    employeeClause='';
                    RIF_TemplateCLAUSETag__c homeClause;
                    RIF_TemplateCLAUSETag__c stateClause;
                    
                    if(empList != null && empList.size() ==1){
                        //system.debug('***************'+empList[0].Building_State_Directory__c
                        //+'--'+empList[0].Job_State_Job__c);
                        Map<string,RIF_TemplateCLAUSETag__c> test=RIF_TemplateCLAUSETag__c.getAll();
                        //system.debug('***************test'+test+'--'+empList[0].State_Home__c+'--'+test.containsKey(empList[0].State_Home__c));
                        //String state=prepareEscapedSoslQuery(empList[0].State_Home__c);
                        //system.debug('********************'+state);
                        
                        if(empList[0].Building_State_Directory__c != null && test != null && 
                                        test.containsKey(empList[0].Building_State_Directory__c)) {
                            homeClause=test.get(empList[0].Building_State_Directory__c);
                        }
                        if(empList[0].Job_State_Job__c != null  && test != null && 
                                        test.containsKey(empList[0].Job_State_Job__c)) {
                            stateClause=test.get(empList[0].Job_State_Job__c );
                        }
                        
                        if(empList[0].Building_State_Directory__c != null && homeClause != null){
                            system.debug('*****sa');
                            employeeClause=homeClause.clause__c;
                        }
                        
                        //system.debug('***************'+homeClause+'--'+stateClause);
                        
                        if(empList[0].Building_State_Directory__c != null && empList[0].Job_State_Job__c != null && 
                                homeClause != null && stateClause != null){
                            system.debug('*****');
                            employeeClause+=', '+stateClause.clause__c;
                        }
                        else if(empList[0].Job_State_Job__c != null && stateClause != null){
                            system.debug('****dsa*');
                            employeeClause=stateClause.clause__c;
                        }
                        
                        if(empList[0].Building_State_Directory__c != null && empList[0].Job_State_Job__c != null &&  
                                homeClause != null && stateClause != null && 
                                empList[0].Building_State_Directory__c == empList[0].Job_State_Job__c){
                            employeeClause=homeClause.clause__c;
                        }
                        empClause.put(emp.Employee__c,employeeClause);                            
                    }
                }
                
                
                for(String str:ContentMap.keyset()){
                    for(Severance_And_Release__c sr:SrRecords){
                        system.debug('****************sr'+sr);
                        if(srFields.containsKey(str+'__c') && srFields.containsKey('O_'+str+'__c')){
                            system.debug('****************sr.get');
                            if(sr.get(str+'__c') != null && Boolean.ValueOf(sr.get(str+'__c')) ==true){
                                sr.put('O_'+str+'__c',
                                       RIF_Util_Kumaresan.getActualContent(srFields,empClause,sr,
                                                                           ContentMap.get(str),
                                                                           '{'+str.substring(str.lastindexOf('_'))+'}'));
                            }
                            else{
                                sr.put('O_'+str+'__c','');
                            }
                        }                                  
                    }
                }
            }
            
            
        }
        return SrRecords;
        
    }
    
    public static set<String> getAccessableSRrecord(String Proj){
        set<String> validSR=new set<String>();
        
        if(Proj != null){
            Map<Id,Permissionset> sysAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset 
                                                                                   where name='RIF_System_Admin']);
            List<permissionsetAssignment> isSysadmin=[select id,assigneeid,permissionsetid from permissionsetAssignment 
                                                      where permissionsetid IN:sysAdminPermissionMap.keyset() AND 
                                                      assigneeid=:userinfo.getuserID() ];
            sysAdminPermissionMap.clear();
            ///           Employee__c  empObj=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,
            //Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where 
            //User__c=:Userinfo.getuserID()];
            Employee__c  empObj=[select id from Employee__c where User__c=:Userinfo.getuserID() limit 1];
            
            List<Coverage_Entitlement__c> covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,
                                                                                   Coverage_Entitlement_Type__c,
                                                                                   Coverage_Entitlement_Org_Code_Derived__c 
                                                                                   from HR_Coverage_Orgs__r),HR_EmpID__c 
                                                             from Coverage_Entitlement__c where HR_Name__c=:empObj.id limit 1];
            
            Map<string,Severance_And_Release__c> srlist=new Map<string,Severance_And_Release__c>([select id,Super_Division__c,
                                                                                                  Division__c,
                                                                                                  Super_Department__c,
                                                                                                  Department__c,
                                                                                                  Sub_Department__c,
                                                                                                  Sub_Department_2__c,
                                                                                                  Cost_Center__c from 
                                                                                                  Severance_And_Release__c 
                                                                                                  where Project__c=:proj 
                                                                                                  Order by First_Name__c ASC]);
            
            if(srlist != null && srlist.keyset() != null && srlist.keyset().size() >0 && covEntitlementObj != null && 
               covEntitlementObj.size() >0 && ( covEntitlementObj[0].HR_Coverage_Orgs__r ==null || 
                                               (covEntitlementObj[0].HR_Coverage_Orgs__r != null && 
                                                covEntitlementObj[0].HR_Coverage_Orgs__r.size()==0)) ){
                validSR.addAll(srlist.keyset());
            }
            else if(isSysadmin != null && isSysadmin.size() >0){
                validSR.addAll(srlist.keyset());
            }
            else if(srlist != null && srlist.keyset() != null && srlist.keyset().size() >0 && 
                    covEntitlementObj!=null && covEntitlementObj.size() >0 && 
                    covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size()>0){
                Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
                for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj[0].HR_Coverage_Orgs__r){
                    if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                        set<String> lst=new set<String>();
                        lst.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,lst);
                    }  
                    else{
                        covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c).add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c.toLowercase()); 
                    }   
                }
                for(Severance_And_Release__c sr:srlist.values()){
                    //System.debug('### sr'+sr);
                    //System.debug('####covTypeToCodeMap####'+covTypeToCodeMap);
                    if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null 
                       && covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c.toLowercase()))  
                        validSR.add(sr.Id);  
                    else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null 
                            && covTypeToCodeMap.get('Division').contains(sr.Division__c.toLowercase()) )  
                        validSR.add(sr.Id);  
                    else if( covTypeToCodeMap.containsKey('Super Department') && 
                            covTypeToCodeMap.get('Super Department') != null && 
                            covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c.toLowercase()) )  
                        validSR.add(sr.Id);   
                    else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null
                            && covTypeToCodeMap.get('Department').contains(sr.Department__c.toLowercase()) )  
                        validSR.add(sr.Id);  
                    else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null
                            && covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c.toLowercase()) )    
                        validSR.add(sr.Id);  
                    else if( covTypeToCodeMap.containsKey('Sub Department 2') &&
                            covTypeToCodeMap.get('Sub Department 2') != null &&
                            covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c.toLowercase()) )      
                        validSR.add(sr.Id);  
                    else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null
                            && covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c.toLowerCase()) )   
                        validSR.add(sr.Id);             
                }
                covTypeToCodeMap.clear();
            }
            covEntitlementObj.clear();
            srlist.clear();
        }    
        System.debug('### validSR'+validSR);                
        return validSR;
    }
    
    public static List<Severance_And_Release__c> getFullQueryFromSobject(Sobject SobjectName,string SobjectId,
                                                                         string objType,set<String> srStaticSet){
        set<String> srIds=new set<String>();
        string queryString='';
        List<Severance_And_Release__c> SrRecs;
        
        if(SobjectName != null){
            Map<string,Schema.SobjectField> fieldResults = SobjectName.getSObjectType().getDescribe().fields.getMap(); 
            queryString=queryString+'select ';
            for(string f:fieldResults.keySet()){
                queryString=queryString+fieldResults.get(f).getDescribe().getName()+', ';
            }  
            
            queryString = queryString + ' employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,Employee__r.HasEquity__c,'
                +'Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c ';
            
            
            if(queryString.endsWith(', ')){
                queryString=queryString.removeEnd(', ');
            }            
            
            
            queryString=queryString+' from '+SobjectName.getSobjectType();
            
            if(SobjectId != null && SobjectId != '' ){
                if(objType=='sr'){
                    queryString=queryString+' where id=\''+SobjectId+'\' Order by First_Name__c ASC';
                }
                else if(objType=='proj'){
                    srIds=RIF_Util_Kumaresan.getAccessableSRrecord(SobjectId);
                    queryString=queryString+' where ID IN:srIds Order by First_Name__c ASC';
                }                
            }
            
            if(objType=='statisIds'){
                queryString=queryString+' where ID IN:srStaticSet Order by First_Name__c ASC';
            }
            
            SrRecs=(List<Severance_And_Release__c>)Database.Query(queryString);
            If(SrRecs != null && SrRecs.size() >0){
                SrRecs.sort();
            }
        }
        system.debug('************queryString'+queryString);
        return SrRecs;
    }
    
    public static string getActualContent(Map<String,string> srFields,map<string,string> empClause,
                                          Severance_And_Release__c SR,string content,string symbol){
        if(SR != null && content != null && content != ''){
            for(String st:srFields.keyset()){
                //system.debug('******* Replacing: ' + st);
                //system.debug('content:' + content);
                if(content.contains('{'+st+'}')){
                    //system.debug('continuing');
                    if(SR.get(st) != null ){
                        if(String.ValueOf(srFields.get(st)) =='Date' || String.ValueOf(srFields.get(st)) =='DateTime'){
                            //system.debug('replacing date');
                            content=content.replaceAll('\\{'+st+'\\}',
                                                       datetime.newInstance(Date.ValueOf(SR.get(st)).year(),
                                                                            Date.ValueOf(SR.get(st)).month(),
                                                                            Date.ValueOf(SR.get(st)).day()).format('MMMM d, yyyy'));                        
                        }
                        else {
                            //system.debug('really replacing');
                            content=content.replaceAll('\\{'+st+'\\}',String.ValueOf(SR.get(st)));
                        }
                    }
                    //Lets keep the merge fields which is not having value at SR record level.
                    /*else{
content=content.replaceAll('\\{'+st+'\\}','');
}*/ 
                }
            }
            if(content.contains('{TODAY}')){
                content=content.replaceAll('\\{TODAY\\}',System.today().format());
            }
            if(content.contains('{NOW}')){
                content=content.replaceAll('\\{NOW\\}',System.Now().format());
            }
            //if(content.contains('CLAUSE') || content.contains('clause') || content.contains('Clause')){  
            if(content.containsIgnoreCase('{o_template1_clause__c}') )   {
                //content.tolowercase();
                if(empClause != null && empClause.containsKey(SR.employee__C)){       
                    content=content.replaceAll('\\{o_template1_clause__c\\}',empClause.get(SR.employee__C));
                    system.debug('**********************EMP State Clause :'+empClause.get(SR.employee__C));
                }
            }
        }
        else if(SR != null && (content == null || content == '')){
            content=symbol;
        }
        
        system.debug('************Final content'+content);
        return  content;
    }
    
    
    public static List<Severance_And_Release__c> getAllFieldsFromSObject(Sobject SobjectName,string SobjectId,
                                                                         string objType,set<String> srStaticSet){
        set<String> srIds=new set<String>();
        string queryString='';
        List<Severance_And_Release__c> SrRecs;
        
        if(SobjectName != null){
            Map<string,Schema.SobjectField> fieldResults = SobjectName.getSObjectType().getDescribe().fields.getMap(); 
            queryString=queryString+'select ';
            for(string f:fieldResults.keySet()){
                queryString=queryString+fieldResults.get(f).getDescribe().getName()+', ';
            }  
            
            queryString = queryString + ' employee__r.Emp_ID__c,employee__r.age__c,employee__r.Name,employee__r.hasEquity__c'
                + ',Project_Decisional_Org_Level__r.name,Decisional_Unit__r.Decisional_Unit_Name__c ';
            
            
            if(queryString.endsWith(', ')){
                queryString=queryString.removeEnd(', ');
            }            
            
            
            queryString=queryString+' from '+SobjectName.getSobjectType();
            
            if(SobjectId != null && SobjectId != '' ){
                if(objType=='sr'){
                    queryString=queryString+' where id=\''+SobjectId+'\' Order by First_Name__c ASC';
                }
                else if(objType=='proj'){
                    //srIds=RIF_Util_Kumaresan.getAccessableSRrecord(SobjectId);
                    queryString=queryString+' where ID IN:srStaticSet Order by First_Name__c ASC';
                }                
            }
            
            if(objType=='statisIds'){
                queryString=queryString+' where ID IN:srStaticSet Order by First_Name__c ASC';
            }
            
            SrRecs=(List<Severance_And_Release__c>)Database.Query(queryString);
            If(SrRecs != null && SrRecs.size() >0){
                SrRecs.sort();
            }
        }
        system.debug('************getAllFieldsFromSObject: queryString:->'+queryString);
        return SrRecs;
    }
    
}