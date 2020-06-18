public class WV_PreviewContentController    {
    
    public string selectedSchemeId;    
    public string page1Content {get; set;}
    public string page2Content {get; set;}
    public string page3Content {get; set;}
    public string descriptionContent{get; set;}
    public string IntroductionContent{get; set;}
    public string TCContent{get; set;}
    public string linksContent {get;set;}
    
    public boolean showPage1 {get; set;}
    public boolean showPage2 {get; set;}
    public boolean showPage3 {get; set;}
    public boolean showDescription {get; set;}
    public boolean showIntro {get; set;}
    public boolean showTC {get; set;}
    public boolean showlinks {get;set;}
    public Map<Id,Scheme__c> MyEligibleSchemes;
    public Scheme__c MyScheme {get; set;}
    public string inputText {get; set;}
    public boolean isTermsChecked {get; set;}
    public boolean isopen {get; set;}   
    private final string tableCss=Label.WV_homepage_content_tabelcss;
    private final string thCss=Label.WV_homepage_content_thCss;
    private final string tdCss_Text=Label.WV_homepage_content_tdCss_Text;
    private final string tdCss_Number=Label.WV_homepage_content_tdCss_Number;
    private Map<string,string> employeeTagsMap;
    private final string testEmployeeId=Label.WV_previewcontent_testdataFormat;
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}            
    
    public string getThisYear(){
        return String.ValueOf(system.today().year());
    }
    
    public WV_PreviewContentController  (){
        try{
            List<employee__c> employeeList;
            Map<String,List<Wav_Custom_data__c>> customdataMap;
            Map<String,Map<string,String>> fileMap;
            Map<String,Map<string,List<String>>> fileMapTemp;
            Map<String,String> fileTypeMap;
            String employeeObjectQuery;
            Sobject employee;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null; 
            isopen=false;   
            Employee__c LoggedinEmployee;   
            User LoggedInUser;  
            List<String> argsDecimal = new String[]{'0','number',Label.WV_Homepage_NumberFormat};   
            OrgName=Label.ORG_ENVIRONMENT;   
            List<Wav_Content__c> wavPreviewContent ;
            inputText=null;
            isTermsChecked=false;
 
            employeeTagsMap=new  Map<string,string>();
            List<Waiver_Employeetag__c> empTags=Waiver_Employeetag__c.getall().values();
            if(empTags != null && empTags.size() >0){
                for(Waiver_Employeetag__c ColumnMap:empTags){
                        employeeTagsMap.put(ColumnMap.Name,ColumnMap.Field_API_Name__c);
                } 
            }                            
            
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('schemeId');
            LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());
            if(LoggedInUser !=null){
                LoggedinEmployee = WV_Utility.getLoggedinEmployeeDetails(LoggedInUser.Emp_Id__c);                
            }      
                 
            if(LoggedinEmployee != null && LoggedinEmployee.Id!= null){
                employee=new employee__c();
                employeeObjectQuery=WV_Utility.getFullQueryFromSobject(employee,LoggedinEmployee.Id);
                employeeList=(List<employee__c>)WV_Utility.getQueryResults(employeeObjectQuery);
            }
            
            page1Content='';
            page2Content='';
            page3Content='';
            
            descriptionContent='';
            IntroductionContent='';
            TCContent='';
            linksContent='';
            
            showPage1=false;
            showPage2 =false;
            showPage3 =false;
            showDescription=false;
            showIntro=false;
            showTC=false;
            showlinks = false;
            
            if(selectedSchemeId != null && selectedSchemeId.trim() != ''){  
                wavPreviewContent = WV_Utility.getPageContentManagementData(selectedSchemeId); 
            }
              
            if(wavPreviewContent != null && wavPreviewContent.size() > 0 && wavPreviewContent.size() > 0){
                MyEligibleSchemes=WV_Utility.getSchemeDetails(new set<string>{selectedSchemeId});
                if(MyEligibleSchemes.keyset().size()>0){
                    MyScheme=MyEligibleSchemes.get(selectedSchemeId);
                }
                for(Wav_Content__c w:wavPreviewContent){
                    if(w.Content_Type__c == 'Description'){
                        descriptionContent=w.Content__c;
                        showDescription=true;
                    }
                    else if(w.Content_Type__c == 'Introduction'){
                        IntroductionContent=w.Content__c;
                        showIntro=true;
                    }
                    else if(w.Content_Type__c == 'Terms & Conditions'){
                        TCContent=w.Content__c;
                        showTC=true;
                    }
                    else if(w.Content_Type__c == 'Links'){
                        linksContent=w.Content__c;
                        showlinks=true;
                    }
                }
                if(MyScheme.term__C=='open'){
                    isopen=true;
                }
                fileMap=WV_Utility.getCustomDataFileMaps(selectedSchemeId);
                fileMapTemp=WV_Utility.getCustomDataFileMapsNew(selectedSchemeId);
                fileTypeMap=WV_Utility.getCustomFileUploadType(selectedSchemeId);
                if(fileMap != null && fileMap.keyset() != null && fileMap.keyset().size() >0){ 
                    customdataMap=WV_Utility.getCustomDataMaps(fileMap.keyset(),testEmployeeId);  
                }
                      
                if(employeeList != null && employeeList.size() ==1 ){                    
                    if(employeeTagsMap != null && employeeTagsMap.keySet().size() >0 ){
                        for(string empStr:employeeTagsMap.keySet()){
                            if(employeeTagsMap.containsKey(empStr) && employeeList[0].get(employeeTagsMap.get(empStr)) != null){
                                string dummy=String.ValueOf( employeeList[0].get(employeeTagsMap.get(empStr)) );
                                if(descriptionContent != null && descriptionContent != '' && descriptionContent.contains(empStr) && dummy != null){                                    
                                    descriptionContent=descriptionContent.replaceAll(empStr,dummy);
                                }
                                if(IntroductionContent != null && IntroductionContent != '' && IntroductionContent.contains(empStr) && dummy != null){                                    
                                    IntroductionContent=IntroductionContent.replaceAll(empStr,dummy);
                                }
                                if(TCContent != null && TCContent != '' && TCContent.contains(empStr) && dummy != null){                                    
                                    TCContent=TCContent.replaceAll(empStr,dummy);
                                }
                            }
                        }
                    }        
                }
                                        
                if(customdataMap != null && fileMap != null && fileTypeMap != null && fileMapTemp != null){
                    for(String s:fileMap.keyset()){
                        if(fileTypeMap.containsKey(s) && fileTypeMap.get(s) != null && fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >0 && fileTypeMap.get(s).split(',')[0] =='Text' && fileMapTemp.containsKey(s) && fileMapTemp.get(s) != null && fileMapTemp.get(s).containsKey('ordered')){
                            for(string s1:fileMapTemp.get(s).get('ordered')){                                        
                                if(customdataMap.containsKey(s) && fileMap.containsKey(s) && fileMap.get(s) != null && fileMap.get(s).containsKey(s1) && fileMap.get(s).get(s1) != null && customdataMap.get(s) != null && customdataMap.get(s).size() >0 && customdataMap.get(s)[0].get(fileMap.get(s).get(s1)) != null){
                                    String ActualValue=String.ValueOf(customdataMap.get(s)[0].get(fileMap.get(s).get(s1)));                                    
                                    if(ActualValue != null){
                                        if(descriptionContent != null && descriptionContent != '' && descriptionContent.contains(s1)){
                                            descriptionContent = descriptionContent.replaceAll(s1,ActualValue);
                                        }
                                        if(IntroductionContent != null && IntroductionContent != '' && IntroductionContent.contains(s1) && customdataMap.containsKey(s) && fileMap.containsKey(s) && fileMap.get(s).containsKey(s1) && fileMap.get(s).get(s1) != null && customdataMap.get(s)[0].get(fileMap.get(s).get(s1)) != null){
                                            IntroductionContent= IntroductionContent.replaceAll(s1,ActualValue);
                                        }
                                        if(TCContent != null && TCContent != '' && TCContent.contains(s1) && customdataMap.containsKey(s) && fileMap.containsKey(s) && fileMap.get(s).containsKey(s1) && fileMap.get(s).get(s1) != null && customdataMap.get(s)[0].get(fileMap.get(s).get(s1)) != null){
                                            TCContent= TCContent.replaceAll(s1,ActualValue);
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(fileTypeMap.containsKey(s) && fileTypeMap.get(s) != null && fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >0 && fileTypeMap.get(s).split(',')[0] =='Table'){
                            string outputtext='';
                            if(fileMapTemp.containsKey(s) && fileMapTemp.get(s) != null && fileMapTemp.get(s).size() > 0 && fileMapTemp.get(s).containsKey('unordered') && fileMapTemp.get(s).get('unordered') != null && customdataMap.containsKey(s) && customdataMap.get(s) != null){
                                outputtext=outputtext+'<table style="'+tableCss+'"><thead><tr>';
                                Integer i=0;
                                List<String> dummyFileMap=fileMapTemp.get(s).get('unordered');
                                for(string s3:dummyFileMap){
                                    if(s3 != 'MSID'){
                                        outputtext=outputtext+'<th style="'+thCss+'">'+s3.replaceAll('_',' ')+'</th>';
                                    }  
                                    i++;
                                }
                                outputtext=outputtext+'</thead></tr>';                                
                                for(Wav_Custom_data__c data:customdataMap.get(s)){
                                    outputtext=outputtext+'<tr>';  
                                    for(string s4:dummyFileMap){ 
                                        if(fileMap.containsKey(s) && fileMap.get(s) != null && fileMap.get(s).containsKey(s4) && fileMap.get(s).get(s4) != 'MSID__c'){ 
                                            if(data.get(fileMap.get(s).get(s4)) != null){   
                                                string mystr=String.ValueOf(data.get(fileMap.get(s).get(s4)));
                                                string mystrDummy=mystr;
                                                try{                                                             
                                                    if(mystr != null && mystr.trim() != ''){
                                                        mystr=mystr.replaceAll(',','').trim();
                                                        try{ 
                                                            outputtext=outputtext+'<td style="'+tdCss_Number+'">'+String.format(Integer.Valueof(mystr).format(),argsDecimal)+'</td>'; 
                                                        }
                                                        Catch(Exception e1){
                                                            outputtext=outputtext+'<td style="'+tdCss_Number+'">'+String.format(Decimal.ValueOf(mystr).format(),argsDecimal)+'</td>';
                                                        }             
                                                    } 
                                                    else{
                                                        outputtext=outputtext+'<td style="'+tdCss_Text+'"></td>';   
                                                    }                                       
                                                }
                                                Catch(Exception e1){
                                                    outputtext=outputtext+'<td style="'+tdCss_Text+'">'+mystrDummy+'</td>';
                                                }
                                            }
                                            else{
                                                outputtext=outputtext+'<td style="'+tdCss_Text+'"> </td>';
                                            }   
                                        } 
                                    }  
                                    outputtext=outputtext+'</tr>';   
                                } 
                                outputtext=outputtext+'</table>';                               
                            }   
                            
                            if(fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >1  && outputtext != ''){
                                string ActualTableContent=fileTypeMap.get(s).split(',')[1];
                                if(descriptionContent != null && descriptionContent != '' && descriptionContent.contains(fileTypeMap.get(s).split(',')[1])){
                                    descriptionContent =descriptionContent.replaceAll(ActualTableContent,outputtext);
                                } 
                                if(IntroductionContent != null && IntroductionContent != '' && IntroductionContent.contains(fileTypeMap.get(s).split(',')[1])){
                                    IntroductionContent=IntroductionContent.replaceAll(ActualTableContent,outputtext);
                                } 
                                if(TCContent != null && TCContent != '' && TCContent.contains(fileTypeMap.get(s).split(',')[1])){
                                    TCContent=TCContent.replaceAll(ActualTableContent,outputtext);
                                }  
                            }                         
                        }
                    }
                }
                             
            }
        }
        Catch(Exception e){
            system.debug('****Exception in WV_PreviewContentController  constructor '+e.getmessage()+'-'+e.getlinenumber());
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,PAGE_ERROR);
            ApexPages.addMessage(errormsg);
            exp=e;
        }
    } 
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Scheme Content Preview page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }    
}