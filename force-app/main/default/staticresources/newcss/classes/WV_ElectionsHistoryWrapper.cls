public class WV_ElectionsHistoryWrapper{
        public string ElectionId{get; set;}
        public string CreatedDate{get; set;}  
        public string LastModifiedDate{get; set;}  
        public datetime LastModifiedDateDt {get; set;}
        public string EmployeeId{get; set;}  
        public string SchemeId{get; set;}  
        public string SchemeName{get; set;}
        public string SourceId{get; set;}        
        public string SourceName  {get; set;}
        public decimal SourceOrder{get; set;}  
        public string DeferralId  {get; set;} 
        public string DeferralName  {get; set;} 
        public string TemplateName {get; set;}   
        public string schemeCurrency  {get; set;}
        public string schemeCurrency_Code {get; set;}
        public string TemplateId {get; set;}    
        public List<Response__c> Responses{get; set;} 
        public Election__c Election{get; set;}
        public string year{get; set;} 
        public string enddate {get; set;} 
        public Map<string,List<string>> MulilistValueOrder {get; set;}
        public List<String> argsDecimal;

        public Map<String,List<WV_multiListWrapper>> getSecondaryList(){
           
             Map<String,List<WV_multiListWrapper>> multiListMap=new Map<String,List<WV_multiListWrapper>>();
             
             try{
                if(Responses != null && Responses.size() > 0){               
                    for(Response__c r:Responses){
                        if(r.Value_New__c != null && r.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'  && !MulilistValueOrder.containsKey(r.Input_Controls_Mapping__c)){ 
                            if(r.Input_Controls_Mapping__r.Custom_Data_Values__c != null){
                                string dummy=r.Input_Controls_Mapping__r.Custom_Data_Values__c.replaceAll('\r\n','\n');
                                List<string> allListNew=dummy.split('\n');
                                List<string> allList=new List<string>();
                                if(allListNew != null && allListNew.size() >0){
                                    for(string str:allListNew){
                                        allList.add(str.trim());
                                    }
                                    allListNew.clear();
                                }
                                MulilistValueOrder.put(r.Input_Controls_Mapping__c,allList);    
                            }                        
                        }
                   }
                   
                   if(MulilistValueOrder != null && MulilistValueOrder.keyset() != null && MulilistValueOrder.keyset().size()>0){                
                        for(string s:MulilistValueOrder.keyset()){
                            for(string s1:MulilistValueOrder.get(s)){
                                for(Response__c r1:Responses){
                                    if(r1.Input_Controls_Mapping__c == s && r1.Value_New__c != null && r1.MultiListName__c != null && r1.MultiListName__c.trim() == s1.trim() && r1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
                                            WV_multiListWrapper multieach=new WV_multiListWrapper();   
                                            multieach.name=r1.MultiListName__c.trim();                            
                                            multieach.value=r1.Value_New__c;     
                                            multieach.controltype=r1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                            multieach.showCurrency=r1.Input_Controls_Mapping__r.Show_Currency__c;
                                            if(multiListMap.containsKey(r1.Input_Controls_Mapping__c)){   
                                                multiListMap.get(r1.Input_Controls_Mapping__c).add(multieach);  
                                            }
                                            else{
                                                List<WV_multiListWrapper> multiList=new List<WV_multiListWrapper>();
                                                multiList.add(multieach);  
                                                multiListMap.put(r1.Input_Controls_Mapping__c,multiList);  
                                            }
                                            break;
                                    }
                                }
                            }
                        }
                        
                        for(Response__c r2:Responses){
                            if(MulilistValueOrder.containskey(r2.Input_Controls_Mapping__c) && MulilistValueOrder.get(r2.Input_Controls_Mapping__c)!=null && r2.Value_New__c != null && r2.MultiListName__c != null && r2.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
                                    Set<string> allVals=new set<string>(MulilistValueOrder.get(r2.Input_Controls_Mapping__c));
                                    if(allVals != null && allVals.size()>0 && !allVals.contains(r2.MultiListName__c)){
                                        WV_multiListWrapper multieach=new WV_multiListWrapper();   
                                        multieach.name=r2.MultiListName__c.trim();                            
                                        multieach.value=r2.Value_New__c;     
                                        multieach.controltype=r2.Input_Controls_Mapping__r.Input_Control_Type__c;
                                        multieach.showCurrency=r2.Input_Controls_Mapping__r.Show_Currency__c;
                                        if(multiListMap.containsKey(r2.Input_Controls_Mapping__c)){   
                                            multiListMap.get(r2.Input_Controls_Mapping__c).add(multieach);  
                                        }
                                        else{
                                            List<WV_multiListWrapper> multiList=new List<WV_multiListWrapper>();
                                            multiList.add(multieach);  
                                            multiListMap.put(r2.Input_Controls_Mapping__c,multiList);  
                                        }
                                    }
                            }
                        }
                    }   
                }               
            }
            Catch(Exception e){            
                system.debug('****Exception inside WV_ElectionsHistoryWrapper class-->getSecondaryList()'+e.getlinenumber()+'-'+e.getmessage());       
            }                  
            return multiListMap;
        }
        
        public List<String> getSecondaryListOrder(){
            List<String> multiList=new List<string>();
            try{
                set<string> validList=new set<string>();
                if(Responses != null && Responses.size() > 0){                
                    for(Response__c r:Responses){
                        if(!validList.contains(r.Input_Controls_Mapping__c) && r.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){
                            multiList.add(r.Input_Controls_Mapping__c);
                            validList.add(r.Input_Controls_Mapping__c);
                        }
                    }                    
                }
            }
            Catch(Exception e){            
                system.debug('****Exception inside WV_ElectionsHistoryWrapper class-->getSecondaryListOrder()'+e.getlinenumber()+'-'+e.getmessage());       
            }   
            return multiList;
        }
        
        public Map<String,string> getMultilistNameMaps(){
            Map<String,string> MultiListMaps=new Map<String,string>();
            try{
                if(Responses != null && Responses.size() > 0){                
                    for(Response__c r:Responses){
                        if(r.Value_New__c != null && r.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                     
                            MultiListMaps.put(r.Input_Controls_Mapping__c,r.Input_Controls_Mapping__r.Name);
                        }
                    }
                }  
            }
            Catch(Exception e){            
                system.debug('****Exception inside WV_ElectionsHistoryWrapper class-->getMultilistNameMaps()'+e.getlinenumber()+'-'+e.getmessage());       
            }   
            return MultiListMaps;        
        }
        
        public List<Response__c> getUpdatedResponses(){
            try{
                if(Responses != null && Responses.size() > 0){ 
                    for(Response__c response:Responses){   
                        if(response.Value_New__c != null && (response.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' || response.Input_Controls_Mapping__r.Input_Control_Type__c=='List Capture') ){           
                            if(response.IsNumberControl_Internal_Use__c==true && response.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' ){
                                try{
                                    response.Value_New__c=String.format(Decimal.Valueof(response.Value_New__c.trim()).format(),argsDecimal);
                                }
                                Catch(exception e){
                                }
                            }
                        }
                    }
                }  
            }
            Catch(Exception e){            
                system.debug('****Exception inside WV_ElectionsHistoryWrapper class-->getUpdatedResponses()'+e.getlinenumber()+'-'+e.getmessage());       
            }          
            return Responses;    
        }
            
        public WV_ElectionsHistoryWrapper(){
            this.MulilistValueOrder=new Map<string,List<string>>();
            this.argsDecimal = new String[]{'0','number',Label.WV_Homepage_NumberFormat};
        }
}