public class RIF_test {
    public string noOfTimes {get; set;}
    public List<project__c>  project;
    public string isAll {get; set;}
    public List<String> congaConductors {get; set;}
    public string RIFText {get; set;}
    public string RIFText1 {get; set;}
    
    public RIF_test(){
        noOfTimes='2';
        string projId=ApexPages.currentPage().getHeaders().get('Id');
        isAll =ApexPages.currentPage().getHeaders().get('isAll');
        project=[select id,Is_Locked_By_Conga__c from project__c where id=:projId];
        congaConductors =new List<String>();
        RIFText= '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
        RIFText1='«TableStart:QueryData»«Severance_And_Release_DocVersion»«TableEnd:QueryData»';
    }
    
    public pageReference callBatch(){
        
        try{
            if(project != null && project.size() >0 && project[0].Is_Locked_By_Conga__c ==false){
                  set<string> srList=RIF_Util_Kumaresan.getAccessableSRrecord(project[0].Id);  
                  set<String> StaticDocumentSet=new set<string>();
                  
                   if(srList != null && srList.size() >0){
                       List<Severance_And_Release__c > scope=[select id,name,Decisional_Unit__c,Conga_flag__c,Conga_flag2__c,Is_this_record_shared_with_running_user__c,Decisional_Unit__r.Project__c,Project__c from Severance_And_Release__c where Id IN:srList];
                       List<Severance_And_Release__c > otherscopes=[select id,name,Decisional_Unit__c,Conga_flag__c,Conga_flag2__c,Is_this_record_shared_with_running_user__c,Decisional_Unit__r.Project__c,Project__c from Severance_And_Release__c where Id Not IN:srList and Project__c =:project[0].Id];
                       if(otherscopes != null && otherscopes.size() >0){
                           for(Severance_And_Release__c  er:otherscopes){
                               er.Is_this_record_shared_with_running_user__c=false;
                               er.Conga_flag__c=false;
                               er.Conga_flag2__c=false;
                           }
                           update otherscopes;
                       }
                       
                       Map<string,List<Attachment>> decisionalunitDocs=new Map<String,List<Attachment>>();
                       Map<string,String> SRMap=new Map<String,String>();
                       Set<String> decisionalUnits=new Set<String>();
                       List<Attachment> AllAttachments=new List<Attachment>();
                       set<String> temp=new set<String>();
                       for(Severance_And_Release__c s:scope){
                           SRMap.put(s.Id,s.Decisional_Unit__c);
                           decisionalUnits.add(s.Decisional_Unit__c);  
                           s.Is_this_record_shared_with_running_user__c=true;
                           s.Conga_flag__c=false;
                           s.Conga_flag2__c=false;                         
                       }
                       
                       if(isAll != null && isAll=='y' && SRMap.keyset() != null && SRMap.keyset().size() >0){
                            List<Attachment> attachDecisionalUnit=[select id,name,body,parentid,contentType from attachment where parentid IN:decisionalUnits];
                            List<Attachment> SRDocument=[select id,name,parentId,body,contentType from Attachment where parentId IN:StaticDocumentSet];
                            
                            if(attachDecisionalUnit != null && attachDecisionalUnit.size() >0){
                                for(Attachment li:attachDecisionalUnit){
                                    Attachment attach=li.clone();
                                    if(decisionalunitDocs.containsKey(attach.parentid)){
                                        decisionalunitDocs.get(li.parentId).add(attach);
                                    }
                                    else{
                                        List<Attachment> aList=new List<Attachment>();
                                        aList.add(attach);
                                        decisionalunitDocs.put(li.parentId,aList);
                                    }
                                }
                                
                                for(Severance_And_Release__c s1:scope){
                                    if(decisionalunitDocs.containsKey(s1.Decisional_Unit__c)){
                                        for(Attachment att:decisionalunitDocs.get(s1.Decisional_Unit__c)){
                                            Attachment attachNew=att.clone();
                                            attachNew.parentId=s1.Id;
                                            AllAttachments.add(attachNew);
                                        }
                                        if(SRDocument != null && SRDocument.size() >0){
                                            for(Attachment d:SRDocument){
                                                Attachment each=d.clone();
                                                each.parentid=s1.Id;
                                                AllAttachments.add(each);
                                            }   
                                        }
                                    }               
                                }
                                
                                update scope;
                                
                                if(AllAttachments.size() >0){
                                    insert AllAttachments;
                                    AllAttachments.clear();
                                    decisionalunitDocs=null; 
                                    SRDocument=null;                     
                                }
                            }
                        }
                   }        
            }
        }
        Catch(Exception e){
                        
        }
        return null;
    }
}