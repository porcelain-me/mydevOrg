// Original 11 Nov 2013: FFAP_CongaManager class
// 
// 11/11/2013: RA: generateDocuments() used as webservice in "Generate Commitment Package Documents - API" custom button on FFAP_Agreement object.
// 12/078/2013: Dharmesh : createHTMLGrid() used for Retiement's Summary Form.
// 23 may 2014 : Jaipal : Updated for QC 335. 
// 06/11/2014 : MRM Remove check for gui id

global class FFAP_CongaManager {
    public static Employee__c returnCongaActiveManagerForCurrentEmployee(Employee__c emp){
        // Identify next upper level of manager from emp.Manager        
        Id branchManagerId = returnCongaBranchManagerForCurrentEmployee(emp);
        
        list<Employee__c> lstEmp = FFAP_DataUtil.getEmployeeDetailsOnId(new Set<Id>{branchManagerId});
        if(lstEmp.size() > 0)
            return lstEmp[0];
        return null;        
    }
    public static List<String> validateEmployee(Employee__c emp, String details, boolean isSent){
        List<String> errors = new List<String>();
        if(emp != null){
        system.debug('+++++++++++++'+details);
            details = details + '(' + emp.Name + ' - ' + emp.Emp_Id__c + ')';       
            if(emp.Status__c != 'Active'){          
                errors.add(details + ' is not Active.');
            }           
            if(emp.Email__c == null || emp.Email__c == ''){
                errors.add('Email address for ' + details + ' is not available.');            
            }           
            //if(isSent && (emp.DocuSign_GUID__c == null || emp.DocuSign_GUID__c == '')){
            //    errors.add('Docusign Account for ' + details + ' is not created yet.');            
            //}
        }
        return errors;
    }
    
    public static List<String> validateEmployees(List<Employee__c> empList){
        List<String> errors = new List<String>();
        for(Employee__c emp : empList){
            errors.addAll(validateEmployee(emp, 'Employee', true));
        }
        return errors;
    }
    public static Id returnCongaBranchManagerForCurrentEmployee(Employee__c emp){
        // Identify next upper level of manager from emp.Manager 
        Id nextManagerId = (emp.Complex_Manager__c != null? emp.Complex_Manager__c : emp.Regional_Director__c);
        Id branchManagerId = emp.Override_Branch_Manager__c != null? emp.Override_Branch_Manager__c : (emp.Manager__c!= null?emp.Manager__c:emp.Complex_Manager__c );
        set<string> empIds = new set<string> {emp.Id, branchManagerId};
        
        
        if(branchManagerId == null){
        	branchManagerId = nextManagerId;	
        }       
        return branchManagerId;    
    }
    
   public static FA_Account__c createHTMLGrid(String faAccountId, String retiredEmpRecordId){
        system.debug('RA_faAccountId: '+ faAccountId + ' retiredEmpRecordId: '+ retiredEmpRecordId);
        Boolean isSucess = false;
        list<string> lstKey = new list<string>();
        if (faAccountId == null) return New FA_Account__c(Id = faAccountId); 
        if(retiredEmpRecordId == null) retiredEmpRecordId = '';
        
        map<id, Employee__c> mapEmp = new map<id, Employee__c>();
        list<id> lstEmpRecordId = new list<id>();
        if(retiredEmpRecordId != ''){
            lstEmpRecordId.add(retiredEmpRecordId);
        }
        // Map of map<Production_Period__c.Coverage_Period_Temp__c, map<empRecordId, FA_Account_Production_Period_Association__c>>
        map<string, map<id, FA_Account_Production_Period_Association__c>> mapFAProdPrdAssociation = new map<string, map<id, FA_Account_Production_Period_Association__c>>(); 
        for(FA_Account_Production_Period_Association__c fa : FFAP_DataUtil.getFAAccProdPeriodAssociationOnJPNForHTML(faAccountId)){
            if(!mapFAProdPrdAssociation.containsKey(fa.Production_Period__r.Coverage_Period_Temp__c)){
                mapFAProdPrdAssociation.put(fa.Production_Period__r.Coverage_Period_Temp__c, new map<id, FA_Account_Production_Period_Association__c>());
                lstKey.add(fa.Production_Period__r.Coverage_Period_Temp__c);
            }
            
            mapFAProdPrdAssociation.get(fa.Production_Period__r.Coverage_Period_Temp__c).put(fa.FA_Account_Association__r.Financial_Advisor__c, fa);
            if(!mapEmp.containsKey(fa.FA_Account_Association__r.Financial_Advisor__c)){
                mapEmp.put(fa.FA_Account_Association__r.Financial_Advisor__c, fa.FA_Account_Association__r.Financial_Advisor__r);
                if(retiredEmpRecordId != fa.FA_Account_Association__r.Financial_Advisor__c)
                    lstEmpRecordId.add(fa.FA_Account_Association__r.Financial_Advisor__c);
            }
        }
        
        system.debug('RA_mapEmp '+ mapEmp);
        system.debug('RA_lstEmpRecordId '+ lstEmpRecordId);
        
        if(mapEmp.isEmpty() || mapFAProdPrdAssociation.isEmpty()){
            return New FA_Account__c(Id = faAccountId);
        }
        
        string advisorDetails = ''; 
        String htmlBody;
        string Table;
        String tableHeader = '';
        String tableSubHeader = '';
        String tableRow = '';
        Set<String> columnIds = New Set<String>();
        table = '<table border="1" cellpadding="3px" cellspacing="0" bordercolor="#000000">@tableHeader@tableSubHeader@tableRow</table>';
        //tableHeader = '<tr><th align="center"><b> Production Months <br/> (MM/YY) </b></th><th align="center" colspan="'+lstEmpRecordId.size()+'"><b>Financial Advisor</b></th></tr>';
        tableSubHeader = '<tr><th align="center"><b> Production Months  </b></th>';
        
        for(id empId : lstEmpRecordId ){
            string InitalStr = ((empId == retiredEmpRecordId || mapEmp.get(empId).Status__c == 'Retired') ? 'FFA': 'Active FA'); 
            
            advisorDetails = advisorDetails != ''? advisorDetails + ' and ' : advisorDetails;
            
            advisorDetails = advisorDetails + ' ' + InitalStr + ' ' + mapEmp.get(empId).First_Name__c + ' '+ mapEmp.get(empId).Last_Name__c + ' ('+mapEmp.get(empId).Financial_Advisor_Number__c+')';
            
            tableSubHeader = tableSubHeader + '<th align="center"><b> Percentage to ' + InitalStr + '<br/>'
                       + mapEmp.get(empId).First_Name__c + ' '+ mapEmp.get(empId).Last_Name__c + ' <br/>('+mapEmp.get(empId).Financial_Advisor_Number__c+')'
                   +'</b></th>';
        }
        tableSubHeader = tableSubHeader+'</tr>';
        
        for(string str : lstKey){
            map<id, FA_Account_Production_Period_Association__c> mapEmpFAPrd = mapFAProdPrdAssociation.get(str);
            system.debug('RA_Str: '+ str);
            system.debug('RA_mapEmpFAPrd: '+ mapEmpFAPrd);
            string startPrd = mapEmpFAPrd.get(lstEmpRecordId[0]).Production_Period__r.Start_Month__c + '/' + mapEmpFAPrd.get(lstEmpRecordId[0]).Production_Period__r.Start_Year__c.subString(2);
            string endPrd = mapEmpFAPrd.get(lstEmpRecordId[0]).Production_Period__r.End_Month__c + '/' + mapEmpFAPrd.get(lstEmpRecordId[0]).Production_Period__r.End_Year__c.subString(2);
            
            tableRow = tableRow + '<tr><td align="center">'+startPrd+'-'+endPrd+'</td>';
            for(id empId : lstEmpRecordId ){
                tableRow = tableRow + '<td align="center">' + mapEmpFAPrd.get(empId).FFAP_Split_Percent__c+' %'
                   +'</td>';
            }
            tableRow = tableRow+'</tr>';
        }
        
        htmlBody = table.replace('@tableHeader', tableHeader).replace('@tableSubHeader', tableSubHeader).replace('@tableRow', tableRow);
        system.debug('RA_ '+ htmlBody);
        return New FA_Account__c(Id = faAccountId, HTML_Grid__c = htmlBody, Conga_JPN_Advisor_Details__c = advisorDetails);
    }
    public static FFAP_Document_Recipient__c returnDocuRecipient(Id sourceId, String packageType, Integer signingOrder, Id recipientId, String generatedDocumentName){
        FFAP_Document_Recipient__c docuRecipient = new FFAP_Document_Recipient__c();
        String objectAPIName;
        if(sourceId != null){
            objectAPIName = sourceId.getSObjectType().getDescribe().getName();
        }
        if(objectAPIName == 'FFAP_Agreement__c'){
            docuRecipient.FFAP_Agreement__c = sourceId;
        }else if(objectAPIName == 'JPN_Change__c'){
            docuRecipient.JPN_Change__c = sourceId;
        }
        docuRecipient.Package_Type__c = packageType;
        docuRecipient.Signing_Order__c = signingOrder;
        docuRecipient.Recipient__c = recipientId;
        docuRecipient.Name = generatedDocumentName;
        return docuRecipient;
    } 
}