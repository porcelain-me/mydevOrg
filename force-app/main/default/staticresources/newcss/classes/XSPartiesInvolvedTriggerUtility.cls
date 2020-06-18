public class XSPartiesInvolvedTriggerUtility {
  @future(callout = true)
  public static void activateInactiveUser(set<Id> EmpID) {
         list<user> userActiveList = new list<user>();  
        for(Employee__c check :[select User__c, User__r.isActive from Employee__c where Id IN :EmpID]){
            if(check.User__r.isActive == false) {
                user objuser = new user(Id = check.User__c);
                objuser.isActive = true;
                userActiveList.add(objuser);
            }
         }
        if(userActiveList.size() > 0)
        update userActiveList;                    
    }
    
    @future(callout = true)
    public static void xSellShareDML(list<id> newRecordIDsList, set<ID> EmployeeIDs, list<string> DivisionNames, set<ID> ParentXSellIDs) {
       list<Cross_Sell__Share> XSellShareList = new list<Cross_Sell__Share>();
       list<Cross_Sell__c> XSellList = new list<Cross_Sell__c>();
       list<Cross_Sell__c> updatesXsellList = new list<Cross_Sell__c>();
       list<Group> GroupList = new list<Group>();
       list<Cross_Sell_Parties_Involved__c> newRecordObjList = new list<Cross_Sell_Parties_Involved__c >();
       List<Employee__c> EmployeeList = [select User__c, User__r.isActive
                                          from Employee__c where Id IN :EmployeeIDs];
        
        
        GroupList = [select Id from Group where Name IN :DivisionNames];
        newRecordObjList = [SELECT ID, Cross_Sell__c, Party_Name__c FROM Cross_Sell_Parties_Involved__c WHERE ID IN : newRecordIDsList];
        
        for( Cross_Sell_Parties_Involved__c c : newRecordObjList) {
            // iterate through employee list
            for(Employee__c Emp:EmployeeList) {
              //  if(Emp.User__r.isActive) {
                    Cross_Sell__Share XSShare =  new Cross_Sell__Share();
                    XSShare.UserorGroupId = Emp.User__c;
                    
                    XSShare.AccessLevel = 'Edit';
                    XSShare.ParentId = c.Cross_Sell__c;
                    XSShare.RowCause = 'Manual';
                    XSellShareList.add(XSShare);
                   
            //    }
            }
            
            // iterate through group list
            for(Group G:GroupList) {
                
                Cross_Sell__Share XSShare =  new Cross_Sell__Share();
                XSShare.UserorGroupId = G.Id;                
                XSShare.AccessLevel = 'Edit';
                XSShare.ParentId = c.Cross_Sell__c;
                XSShare.RowCause = 'Manual';
                XSellShareList.add(XSShare);
             
            }
        }
        
        // insert share to share cross sell with parties invlolved
        if(XSellShareList.size() > 0) {
            insert XSellShareList;
           
        }
        
        // add beneficairy name to cross sell 
        XSellList = [select id,Beneficiary_Full_Name_s__c from Cross_Sell__c where Id IN :ParentXSellIDs];
        for(Cross_Sell__c XSell: XSellList) {
            for( Cross_Sell_Parties_Involved__c c : newRecordObjList) {
                if(c.Cross_Sell__c == XSell.Id) {
                    if(XSell.Beneficiary_Full_Name_s__c == null) {
                        XSell.Beneficiary_Full_Name_s__c = c.Party_Name__c;
                    } else {
                        XSell.Beneficiary_Full_Name_s__c += '; ' + c.Party_Name__c;
                    }
                }
            }
            updatesXsellList.add(XSell);
        }
        
        update updatesXsellList;
                             
    }
}