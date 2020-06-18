public class SNRSharingtTest {
    
    public static void testSNT()
    {
        List<User> listofUsers =[select id, name, emp_id__c from user where emp_id__c in ('28BKL','93MFN','81MYR','01NVK','02NFC','09NGF','39NPV','88JYB','29PKH','42PHC')];
        
        List<Severance_And_Release__c> listofSNRS = [Select ownerid,id,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c];
        
        Map <string,Map<String,set <string>>> covTypeToCodeMap = new Map <string,Map<String,set <string>>>();
        Set<String> setEmpID = new Set<String>();
        List<Severance_And_Release__Share>  snrShareInsertList = new List<Severance_And_Release__Share> ();
            
        List<Employee__c>  empObjList=[select user__c, id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where emp_id__c in ('28BKL','93MFN','81MYR','01NVK','02NFC','02NFB','09NGF','39NPV','88JYB','29PKH','42PHC')];
        
        for(Employee__c emp : empObjList)
        {
            setEmpID.add(emp.id);
        }
        
        List<Coverage_Entitlement__c> covEntitlementObjList=[select id,HR_Name__r.user__c,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:setEmpID];
        
        for(Coverage_Entitlement__c covEntitlementObj : covEntitlementObjList )
        {
            if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                    if(!covTypeToCodeMap.containsKey(covEntOrg.HR_EmpID__c))
                    {
                        Map<String,set <string>> covCodeMap=new Map<String,set <string>>();
                        set<String> covCodeSet=new set<String>();
                        covCodeSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        covCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covCodeSet);
                        covTypeToCodeMap.put(covEntOrg.HR_EmpID__c,covCodeMap);
                    }  
                    else{
                        Map<String,set <string>> covCodeMap=new Map<String,set <string>>();
                        covCodeMap = covTypeToCodeMap.get(covEntOrg.HR_EmpID__c);
                        if(!covCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c))
                        {
                            set<String> covCodeSet=new set<String>();
                            covCodeSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covCodeSet);
                            covTypeToCodeMap.put(covEntOrg.HR_EmpID__c,covCodeMap); 
                        }
                        else
                        {
                            set<String> covCodeSet = new set<String>(covCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c));
                            covCodeSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covCodeSet);
                            covTypeToCodeMap.put(covEntOrg.HR_EmpID__c,covCodeMap); 
                        }
                    }       
                }
            }
        }
        System.debug('--covTypeToCodeMap0--'+covTypeToCodeMap);
        for(User u: listofUsers)
        {
            for(Severance_And_Release__c sr: listofSNRS)
            {
                Boolean tempFlag=false;
                if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && (covTypeToCodeMap.get(u.emp_id__c).get('Super Division').contains(sr.Super_Division__c)) ){  
                    tempFlag=true;
                }
                else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Division')!=null && (covTypeToCodeMap.get(u.emp_id__c).get('Division').contains(sr.Division__c)) ){  
                    tempFlag=true;
                }
                 else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Super Department')!=null && (covTypeToCodeMap.get(u.emp_id__c).get('Super Department').contains(sr.Super_Department__c)) ){  
                    tempFlag=true;
                }
                 else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Department')!=null && (covTypeToCodeMap.get(u.emp_id__c).get('Department').contains(sr.Department__c)) ){  
                    tempFlag=true;
                }
                 else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Sub Department')!=null && (covTypeToCodeMap.get(u.emp_id__c).get('Sub Department').contains(sr.Sub_Department__c)) ){  
                    tempFlag=true;
                }
                 else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Sub Department 2')!=null && (covTypeToCodeMap.get(u.emp_id__c).get('Sub Department 2').contains(sr.Sub_Department_2__c)) ){  
                    tempFlag=true;
                }
                 else if( (covTypeToCodeMap.containsKey(u.emp_id__c)) && covTypeToCodeMap.get(u.emp_id__c).get('Cost Center')!=null &&  (covTypeToCodeMap.get(u.emp_id__c).get('Cost Center').contains(sr.Cost_Center__c)) ){  
                    tempFlag=true;
                }
                
                
                if(tempFlag)
                {
                    if(sr.ownerid != u.id)
                    {
                        Severance_And_Release__Share srShr = new Severance_And_Release__Share ();
                        srShr.UserOrGroupId = u.id;
                        srShr.AccessLevel = 'Edit';
                        srShr.ParentId =  sr.id;
                        srShr.RowCause = Schema.Severance_And_Release__Share.Rowcause.ScriptSharing__c;
                        snrShareInsertList.add(srShr);
                    }
                }
                
            }
            
        }
        
        insert snrShareInsertList;
        
        System.debug('--snrShareInsertList--'+snrShareInsertList.size());
        
        
        
        
        
        
        
        
        
    }
}