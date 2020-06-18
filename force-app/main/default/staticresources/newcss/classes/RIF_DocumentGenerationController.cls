/**
    THIS CLASS IS USED FOR GENERATING PACKAGES FOR SINGLE SEVERANCE AND RELEASE RECORD USING CONGA-COMPOSER. FOR BULK GENERATION REFER RIF_SELECTSR_PRINT CLASS.
    
**/

public class RIF_DocumentGenerationController {
    
    public List<selectoption> documentsList {get; set;}
    public List<String> selectedDocs { get; set;}
    set<string> selectedItems;
    
    public String serverURL;
    public string sessionID;
    public string selectedVersion {get; set;}
    
    private string SRId;
    private Map<String,String> congaDocs;
    
    private static  String EXHIBIT_A_UNDER_40 = 'ExhibitA(U40)'; //ExhibitA_U40
    private static  String EXHIBIT_A_OVER_40 = 'ExhibitA(O40)';//;ExhibitA_O40
    //public Decimal empage {get;set;}
    public Employee__c e {get;set;}
    
 	public String projectStatus {get;set;}
    
    public RIF_DocumentGenerationController (){
        
        documentsList=new List<Selectoption>();
        documentsList.add(new selectoption('All','All'));
        documentsList.add(new selectoption('Release Agreement','Release Agreement'));
        documentsList.add(new selectoption('Separation Summary','Separation Summary'));
        documentsList.add(new selectoption('Exhibit A','Exhibit A')); 
        documentsList.add(new selectoption('Exec Comp Overview','Exec Comp Overview'));
        documentsList.add(new selectoption('Important Contacts','Important Contacts'));
        documentsList.add(new selectoption('Benefits Memo','Benefits Memo'));
        documentsList.add(new selectoption('Benefits FAQ','Benefits FAQ'));
        documentsList.add(new selectoption('Age Disclosure','Age Disclosure'));
        documentsList.add(new selectoption('Code of Conduct','Code of Conduct'));
        documentsList.add(new selectoption('LHH','LHH'));
        documentsList.add(new selectoption('Lifeworks','Lifeworks'));
        
        selectedVersion = 'Draft';
        selectedDocs=new List<String> {'All'};       
        set<String> staticDocs=new set<String>();
        congaDocs=new Map<String,String>();        

        SRId=ApexPages.currentPage().getParameters().get('SRId');        
        serverURL=ApexPages.currentPage().getParameters().get('serverUrl'); //serverUrl
        sessionID=ApexPages.currentPage().getParameters().get('sessionId');
		projectStatus = '';
        /*  don't get rid of my code - mark */ 
        // 21-Jul-17 : JIRA#RIF-89 : Added project status to the query
        Severance_And_Release__c temp = [select employee__c,Project__r.Status__c from Severance_And_Release__c where id = :SRid];
        if(temp != null){
            projectStatus = temp.Project__r.Status__c;
        }
            
        e = [select age__c from Employee__c where id = :temp.employee__c];
       
        List<APXTConga4__Conga_Template__c > congaTemp=[select id, APXTConga4__Name__c from APXTConga4__Conga_Template__c where APXTConga4__Template_Group__c='RIF Template']; 
        if(congaTemp != null && congaTemp.size() >0){
            for(APXTConga4__Conga_Template__c t:congaTemp){
                congaDocs.put(t.APXTConga4__Name__c,t.Id);
            }
        }
    }
    
    /**
        THIS CODE IS CALLED WHEN GENERATE BUTTON IS CLICKED FROM POPUP WINDOW.
    **/
    public pageReference Generate(){
        
        Set<String> staticDocs=new Set<String>();
        List<Severance_And_Release__c> srList;
        String urlParameters='';
        List<Attachment> SRDocument;
        set<String> congaTemp=new set<String>();
        
        // 20-Jul-17 : JIRA#RIF-89 : check if the project is a MODEL project and the document version is FINAL  
        if(projectStatus.equalsIgnoreCase('Model') && selectedVersion.equalsIgnoreCase('Final')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.RIF_Model_Projects_Doc_Type_Error);
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(selectedDocs != null && selectedDocs.size() >0){ 
            selectedItems=new set<String>(selectedDocs);
            
            if(selectedItems.contains('All')){
                selectedItems=new set<String>{'Separation Summary','Exec Comp Overview','Important Contacts','Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH','Lifeworks','Exhibit A'};
            }
            
            if(selectedItems.size() >0){
               if(selectedItems.contains('Exec Comp Overview')){
                   staticDocs.add(congaDocs.get('Exec Comp Overview'));
               } 
               if(selectedItems.contains('Important Contacts')){
                   staticDocs.add(congaDocs.get('Important Contacts'));
               } 
               if(selectedItems.contains('Benefits Memo')){
                   staticDocs.add(congaDocs.get('Benefits Memo'));
               } 
               if(selectedItems.contains('Benefits FAQ')){
                   staticDocs.add(congaDocs.get('Benefits FAQ'));
               } 
               if(selectedItems.contains('Code of Conduct')){
                   staticDocs.add(congaDocs.get('Code of Conduct'));
               } 
               if(selectedItems.contains('LHH')){
                    staticDocs.add(congaDocs.get('LHH ED'));
                    staticDocs.add(congaDocs.get('LHH MD'));
                    staticDocs.add(congaDocs.get('LHH Other'));
               } 
               if(selectedItems.contains('Lifeworks')){
                   staticDocs.add(congaDocs.get('Lifeworks'));
               }              
            }   
            
            if(SRId != null && SRId.trim() != ''){ 
                srList=RIF_Util_Kumaresan.getFullQueryFromSobject(new Severance_And_Release__c(),SRId,'sr',null);
            }
            // 15-Dec-2016 : ALM#1860 : Process the documents only for those SNRs that are 'Selected'
            if(!srList.isEmpty()){
                for(Severance_and_Release__c s : srList){
                    if(s.Status__c != 'Selected'){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot Generate the document(s) for employees with Severance Status equals Not Selected.');
                       ApexPages.addMessage(myMsg);
                       return null;
                    }
                }
            }            
            
            if(srList != null && srList.size() >0){
                   
                   if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary') || selectedItems.contains('Exhibit')) && (selectedVersion==null || selectedVersion=='')){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose Document version.');
                       ApexPages.addMessage(myMsg);
                       return null;
                   }
                   
                   Map<string,List<Attachment>> decisionalunitDocs=new Map<String,List<Attachment>>();
                   Map<string,String> SRMap=new Map<String,String>();
                   Set<String> decisionalUnits=new Set<String>();
                   List<Attachment> AllAttachments=new List<Attachment>();
                   
                       for(Severance_And_Release__c  s: srList){
                           //19-Dec-2016 : ALM#1862 : Change the doc generation status of the SNR
                           if(selectedVersion =='Draft'){
                               s.DocVersion__c='Draft Version';
                               s.Document_Generation_Status__c='Draft';
                           }
                           else{
                               s.DocVersion__c='';
                               s.Document_Generation_Status__c='Official';
                           }
                           
                              /** For Testing NON CCG Env, commenting below **/
                               //urlParameters='https://composer-congamerge-com.ccg-dev.ms.com?'+'&sessionId='+sessionID+'&serverUrl='+serverURL+'&id='+s.Id+'&TemplateId='; 
                              // urlParameters='https://composer-congamerge-com.ccg-dev.ms.com?'+'&sessionId='+sessionID+'&serverUrl='+serverURL+'&id='+s.Id+'&DS7=0&TemplateId='; 

                          if( (selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary')
                                || selectedItems.contains('Exhibit A'))){ 

                            //Need to Define a Custom Label for Conga-Compose Label.RIF_CongaComposerURL
                            urlParameters=Label.RIF_CongaComposerURL+'?sessionId='+sessionID+'&serverUrl='+serverURL+'&id='+s.Id+'&DS7=1&TemplateId=';
                           
                           If(selectedItems.contains('Release Agreement') && congaDocs.containsKey('Release Agreement')){
                             /*If(empAge  < 40)
                                    s.over_40__c = false;
                               else
                                    s.over_40__c = true; */
                               // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- STARTS
                               if(selectedVersion =='Final'){
                                   urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'+congaDocs.get('Release Agreement')+',';
                               }
                               else if(selectedVersion =='Draft'){
                                   urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_07_Release+Agreement]'+congaDocs.get('Release Agreement')+',';
                               }
                               congaTemp.add(congaDocs.get('Release Agreement'));
                           }
                           if(selectedItems.contains('Separation Summary')){
                               if(selectedVersion =='Final'){
                                   urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'+congaDocs.get('Separation Summary')+',';
                               }
                               else if(selectedVersion =='Draft'){
                                   urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_01_Separation+Summary]'+congaDocs.get('Separation Summary')+',';
                               }
                               congaTemp.add(congaDocs.get('Separation Summary'));
                           }
							// 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- ENDS                           
                           system.debug('***** why is this not showing?'); 
                           //system.debug('******** empAge2: ' + empAge);
                           system.debug('******* selectedItems:' + selectedItems);
                           system.debug('exhimbit a:' + s.exhibit_a__c);
                            if(selectedItems.contains('Exhibit A'))
                                system.debug('found a');
                            if (congaDocs.containsKey('Exhibit A'))
                                system.debug('found a2');   
                           //EXHIBIT A
                           if(selectedItems.contains('Exhibit A') && s.exhibit_A__c){
                                system.debug('ugh'); 
                                If(!s.Over_40__c){
                                    system.debug('under 40 path');
                                    //s.over_40__c = false;
                                    // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- STARTS
                                    if(selectedVersion =='Final'){
                                        urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                            +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                    }
                                    else if(selectedVersion =='Draft'){
                                        urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                            +congaDocs.get(EXHIBIT_A_UNDER_40)+',';
                                    }
                                    congaTemp.add(congaDocs.get(EXHIBIT_A_UNDER_40));
                                    system.debug('conga temp:' + congaTemp);
                                }
                               If(s.Over_40__c){
                                    system.debug('******************************** over 40');
                                    //s.over_40__c = true;
                                    
                                    if(selectedVersion =='Final'){
                                        urlParameters+='['+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                            +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                    }
                                    else if(selectedVersion =='Draft'){
                                        urlParameters+='[Draft_'+s.Last_Name__c+'_'+s.First_Name__c+'_11_Exhibit+A]'
                                            +congaDocs.get(EXHIBIT_A_OVER_40)+',';
                                    }
                                   // 16-Oct-17 : JIRA#RIF-111 : Remove 'CC_' prefix from the generated documents --- ENDS
                                    congaTemp.add(congaDocs.get(EXHIBIT_A_OVER_40));
                                    system.debug('conga temp:' + congaTemp);
                                }
                           }                        
                           if(urlParameters.EndsWith(',')){
                               urlParameters=urlParameters.removeEnd(',');
                           }
                           
                           if(selectedVersion=='Draft'){
                               urlParameters+='&DefaultPDF=0&ZipFiles=0&LG3=1'; //&DS7=1
                           }
                           else if(selectedVersion=='Final'){
                               // 7-Aug-2017 : The final doc should be generated in docx format
                               //urlParameters+='&DefaultPDF=1&ZipFiles=0&APDF=0&LG3=1'; //&DS7=1
                               urlParameters+='&DefaultPDF=0&ZipFiles=0&APDF=0&LG3=1';
                           }
                        }
                           
                       if( (s.Over_40__c) &&(selectedItems.contains('Age Disclosure'))){ 
                            SRMap.put(s.Id,s.Decisional_Unit__c);
                            decisionalUnits.add(s.Decisional_Unit__c); 
                        } 
                   }
                       
                    if(selectedItems.contains('Exhibit A') && !selectedItems.contains('Release Agreement') && !selectedItems.contains('Separation Summary') && !srList[0].exhibit_A__c){
                          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                         'Please Select ExhibitA checkbox on Serveance and Release to generate ExhibitA documents for selected or all records.');
                         ApexPages.addMessage(myMsg);
                        // errorFlag=true;
                         return null;
                        
                    }
                       
                   //system.debug('********************* empage: ' + empage);
                        
                   if(selectedItems.contains('Release Agreement') || selectedItems.contains('Separation Summary') || selectedItems.contains('Exhibit A')){
                        if (selectedItems.contains('Release Agreement')){  //need to recalc all over 40 indicators before replacement
                            system.debug('over 40');
                            update srList;
                            srList=RIF_Util_Kumaresan.getFullQueryFromSobject(new Severance_And_Release__c(),SRId,'sr',null);
                        }
                        system.debug('in here');
                        
                        System.debug('sr list before update: ' + srList);
                        srList=RIF_Util_Kumaresan.updateSnROnContentManagement(congaTemp,srList);
                        system.debug('*********SrList:'+ srList);
                        update srList;
                   }
                       
                   system.debug('*******************Finally urlParameters:'+urlParameters);
                   
                   set<String> staticDocset=new set<String>(); 
                   
                   if(selectedItems.contains('Age Disclosure') && SRMap.keyset() != null && SRMap.keyset().size() >0){
                        List<Attachment> attachDecisionalUnit=[select id,name,body,parentid,contentType from attachment
                                             where parentid IN:decisionalUnits  order By LastModifiedDate DESC];
                        
                        System.debug('Attachment size: ' + attachDecisionalUnit.size());
                         
                        if(attachDecisionalUnit != null && attachDecisionalUnit.size() > 0){
                            List<Attachment> aList=new List<Attachment>();
                            
                            for(Attachment li:attachDecisionalUnit){
                                Attachment attach=li.clone();
                                if(decisionalunitDocs.containsKey(attach.parentid)){
                                } else {                               
                                    aList.add(attach);
                                }
                                
                                decisionalunitDocs.put(new List<String>(decisionalUnits).get(0), aList);
                            }
                        }
                    }
                    
                   if(staticDocs != null && staticDocs.size() >0){
                       SRDocument=[select id,name,parentId,body,contentType from Attachment where parentId IN:staticDocs order By LastModifiedDate DESC];                       
                   }
                   /**************************
                   //THIS MAY COME AS ENCRYPTED, NEED TO REVIST IT AGAIN..
                   boolean unVestedEqty = true;
                   List<Unvested_Equity__c> unVestedEqtyLst = [SELECT Id, Name, Emp_Id__c, Unvested_total_balance__c from Unvested_Equity__C where Emp_Id__c =: srList[0].Emp_Id__c];
                   if(unVestedEqtyLst != null && unVestedEqtyLst.size() > 0 ){
                            unVestedEqty =( Double.valueOf(unVestedEqtyLst[0].Unvested_total_balance__c) > 0);
                   }
                   system.debug('****unVestedEqtyLst:'+unVestedEqtyLst);
                   system.debug('****unVestedEqty:'+unVestedEqty);
                   ********************************/
                   
                   for(Severance_And_Release__c s1:srList){
                        if( (decisionalunitDocs != null) && (decisionalunitDocs.containsKey(s1.Decisional_Unit__c)) && (s1.Over_40__c)        ){
                            
                            for(Attachment att:decisionalunitDocs.get(s1.Decisional_Unit__c)){
                                Attachment attachNew=att.clone();
                                attachNew.parentId=s1.Id;
                                attachNew.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_06_Age Disclosure.pdf'; 
                                AllAttachments.add(attachNew);
                            }
                        }
                    
                        if(SRDocument != null && SRDocument.size() >0){
                            for(Attachment d:SRDocument){
                                if(!staticDocset.contains(d.parentId)){
                                    Attachment each=d.clone();
                                    each.parentid=s1.Id;
                
                                                if(each.name.contains('Exec Comp Overview') && s1.employee__r.hasEquity__c){                                    
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_02_'+each.name;
                                }
                                if(each.name.contains('Important Contacts')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_03_'+each.name;
                                }
                                if(each.name.contains('Benefits Memo')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_04_'+each.name;
                                }
                                if(each.name.contains('Benefits FAQ')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_05_'+each.name;
                                }
                                if(each.name.contains('Code of Conduct')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_08_'+each.name;
                                }
                                if(s1.Outplacement__c != null && s1.Outplacement__c != '' && each.name.contains('LHH')){
                                   
                                    if(s1.Outplacement__c.contains('3 Months') && each.name.contains('LHH ED')){
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';
                                    } else if(s1.Outplacement__c.contains('6 Months') && each.name.contains('LHH MD')){
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';
                                    } else if(s1.Outplacement__c.contains('Milestone Seminar') && each.name.contains('LHH Other')){                                
                                        each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_09_'+'LHH.pdf';  
                                    }   
                                }                                
                                if(each.name.contains('LifeWorks')){
                                    each.name=s1.Last_Name__c+'_'+s1.First_Name__c+'_10_'+each.name;
                                }
                
                                    
                                    AllAttachments.add(each);
                                    staticDocset.add(d.parentId);
                                }
                            }   
                        }   
                        staticDocset=new set<String>();            
                    }
                    
                    List<Severance_And_Release__c> srManualList = new List<Severance_And_Release__c>(); 
                    if(AllAttachments.size() >0){
                        
                        insert AllAttachments;
                        
                        for (attachment a:AllAttachments){
                        if (a.name.toLowerCase().contains('age') && a.name.toLowerCase().contains('disclosure')){
                            Severance_And_Release__c sr = new Severance_And_Release__c(id=a.parentId, Manual_Age_Disclosure_Doc_Id__c = string.valueOf(a.id));
                            srManualList.add(sr);
                        }
                        if (!srManualList.isEmpty())
                            update srManualList;
                    }
                        List<Attachment> attListTobeDeleted = [Select id,name,parentId from Attachment where parentId in:SRList and (name like 'LHH%' or name like 'Exec Comp Overview%')];
                        if(attListTobeDeleted != null && attListTobeDeleted.size()>0)
                            delete attListTobeDeleted ;
                        
                        decisionalunitDocs=null;  
                        SRDocument=null;                
                    }
                    if(urlParameters == '') {//Means only static documents have been generated, the present user with pageMessage
                        if(AllAttachments.size() >0){
                        
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'Static document(s) generated. Please visit S&R record to see the document in Notes & Attachments section.');
                            ApexPages.addMessage(myMsg);
                        }
                        else {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'No document(s) matches the criteria. Please choose some other documents to generate.');
                            ApexPages.addMessage(myMsg);
                        }
                        
                }
                AllAttachments.clear();
           }
           else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No SnR records found for this project.');
               ApexPages.addMessage(myMsg);
               return null;
           }
            

           if(urlParameters != null && urlParameters.trim() != '' && SRId != null && SrId.trim() != ''){
               PageReference pg1=new PageReference(urlParameters);
               pg1.setredirect(true);
               return pg1;    
           }           
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose documents and choose version (if applicable)');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
}