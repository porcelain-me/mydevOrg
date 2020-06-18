global class WV_EnrolmentResponses implements Comparable{

    public string SchemeId{get; set;} 
    public string SchemeName{get; set;}    
    public string ElectionId{get; set;} 
    public string EnrolmentName {get; set;}   
    public datetime EnrolmentStartDate {get; set;}
    public datetime EnrolmentEndDate {get; set;}    
    public string EnrolmentEndDate_Str {get; set;}
    public string EnrolmentEndDate_Str_CalenderFormat {get; set;}
    public string EnrolmentEndDateDay_Str_CalenderFormat {get; set;}    
    public string enrolmentId {get; set;}
    public List<Response__c> Responses_New{get; set;}
    public boolean isActive {get; set;}    
    public string LastModifiedDate {get; set;}  
    public string LastModifiedDate_calender {get; set;}
    public datetime LastModifiedDateDt {get; set;}
    public string LastModifiedBy {get; set;}    
    public boolean isOnFocus {get; set;}
    public boolean showCurrency {get; set;}
    public boolean showMultiList {get; set;}
    public boolean isFutureOne {get; set;}
    public boolean isPast {get; set;}
    public string currentYears {get; set;}
    public boolean flagMultiListControl {get; set;}
    public boolean isSecondaryControlsPresent {get; set;}
    public Map<string,List<string>> MulilistValueOrder {get; set;}
    public List<String> argsDecimal;    
    public List<string> OrderedControlsList {get; set;}
    
    public string getCurrentyear(){
        return String.ValueOf(system.today().year());
    }    
    
    public Map<String,List<WV_multiListWrapper>> getSecondaryList(){
        Map<String,List<WV_multiListWrapper>> multiListMap=new Map<String,List<WV_multiListWrapper>>();            
        try{
            if(Responses_New != null && Responses_New.size() > 0){   
                          
                for(Response__c r:Responses_New){
                    if(r.Value_New__c != null && r.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r.Input_Controls_Mapping__r.Input_Control_Type__c!='Multi Value Option Capture'){                                                                            
                            WV_multiListWrapper multieach=new WV_multiListWrapper();   
                            multieach.name=r.MultiListName__c;                            
                            multieach.value=r.Value_New__c;                              
                                        
                            if(r.IsNumberControl_Internal_Use__c==true && r.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' ){
                                try{
                                    multieach.value=String.format(Decimal.Valueof(r.Value_New__c.trim()).format(),argsDecimal);
                                }
                                Catch(exception e){                                                
                                }
                            }   
                                        
                            multieach.controltype=r.Input_Controls_Mapping__r.Input_Control_Type__c;
                            multieach.showCurrency=r.Input_Controls_Mapping__r.Show_Currency__c;
                            multieach.currencycode=r.Show_Currency_Percentage__c;
                            if(multiListMap.containsKey(r.Input_Controls_Mapping__c)){   
                                multiListMap.get(r.Input_Controls_Mapping__c).add(multieach);  
                            }
                            else{
                                List<WV_multiListWrapper> multiList=new List<WV_multiListWrapper>(); 
                                WV_multiListWrapper multieachLabel=new WV_multiListWrapper();   
                                multieachLabel.name='Label';                                
                                multieachLabel.controltype=r.Input_Controls_Mapping__r.Input_Control_Type__c;
                                multieachLabel.showCurrency=r.Input_Controls_Mapping__r.Show_Currency__c;
                                multieachLabel.currencycode=r.Show_Currency_Percentage__c;
                                multieachLabel.value=r.Input_Controls_Mapping__r.name; 
                                multiList.add(multieachLabel);
                                multiList.add(multieach);  
                                multiListMap.put(r.Input_Controls_Mapping__c,multiList);  
                            }
                    }
                }
                
                for(string s:MulilistValueOrder.keyset()){
                    for(string s1:MulilistValueOrder.get(s)){
                        for(Response__c r1:Responses_New){
                            if(r1.Input_Controls_Mapping__c == s && r1.Value_New__c != null && r1.MultiListName__c != null && r1.MultiListName__c.trim() == s1.trim() && r1.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
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
                                        WV_multiListWrapper multieachLabel=new WV_multiListWrapper();   
                                        multieachLabel.name='Label';                                
                                        multieachLabel.controltype=r1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                        multieachLabel.showCurrency=r1.Input_Controls_Mapping__r.Show_Currency__c;
                                        multieachLabel.value=r1.Input_Controls_Mapping__r.name; 
                                        multiList.add(multieachLabel);
                                        multiList.add(multieach);  
                                        multiListMap.put(r1.Input_Controls_Mapping__c,multiList);  
                                    }
                                    break;
                            }
                        }
                    }
                }
                
                for(Response__c v1:Responses_New){
                    if(v1.Value_New__c != null && v1.MultiListName__c != null && MulilistValueOrder.containskey(v1.Input_Controls_Mapping__c) && MulilistValueOrder.get(v1.Input_Controls_Mapping__c)!=null && v1.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && v1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
                            Set<string> allVals=new set<string>(MulilistValueOrder.get(v1.Input_Controls_Mapping__c));
                            if(allVals != null && allVals.size()>0 && !allVals.contains(v1.MultiListName__c)){
                                WV_multiListWrapper multieach=new WV_multiListWrapper();   
                                multieach.name=v1.MultiListName__c.trim();                            
                                multieach.value=v1.Value_New__c;     
                                multieach.controltype=v1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                multieach.showCurrency=v1.Input_Controls_Mapping__r.Show_Currency__c;
                                if(multiListMap.containsKey(v1.Input_Controls_Mapping__c)){   
                                    multiListMap.get(v1.Input_Controls_Mapping__c).add(multieach);  
                                }
                                else{
                                    List<WV_multiListWrapper> multiList=new List<WV_multiListWrapper>(); 
                                    WV_multiListWrapper multieachLabel=new WV_multiListWrapper();   
                                    multieachLabel.name='Label';                                
                                    multieachLabel.controltype=v1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                    multieachLabel.showCurrency=v1.Input_Controls_Mapping__r.Show_Currency__c;
                                    multieachLabel.value=v1.Input_Controls_Mapping__r.name; 
                                    multiList.add(multieachLabel);
                                    multiList.add(multieach);  
                                    multiListMap.put(v1.Input_Controls_Mapping__c,multiList);  
                                }
                          }
                    }
                }
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnrolmentResponses class-->getSecondaryList()'+e.getlinenumber()+'-'+e.getmessage());       
        }
        return multiListMap;
    }
    
    public Map<String,List<WV_multiListWrapper>> getMultiLists(){
        Map<String,List<WV_multiListWrapper>> multiListMap=new Map<String,List<WV_multiListWrapper>>();
        
        try{
            if(Responses_New != null && Responses_New.size() > 0){   
                
                if(MulilistValueOrder != null && MulilistValueOrder.keyset() != null && MulilistValueOrder.keyset().size()>0){   
                    for(string s:MulilistValueOrder.keyset()){
                        for(string s1:MulilistValueOrder.get(s)){
                            for(Response__c r1:Responses_New){
                                if(r1.Input_Controls_Mapping__c == s && r1.Value_New__c != null && r1.MultiListName__c != null && r1.MultiListName__c.trim() == s1.trim() && r1.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
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
                                            WV_multiListWrapper multieachLabel=new WV_multiListWrapper();   
                                            multieachLabel.name='Label';                                
                                            multieachLabel.controltype=r1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                            multieachLabel.showCurrency=r1.Input_Controls_Mapping__r.Show_Currency__c;
                                            multieachLabel.value=r1.Input_Controls_Mapping__r.name; 
                                            multiList.add(multieachLabel);
                                            multiList.add(multieach);  
                                            multiListMap.put(r1.Input_Controls_Mapping__c,multiList);  
                                        }
                                        break;
                                }
                            }
                        }
                    }
                
                    for(Response__c r1:Responses_New){
                        if(MulilistValueOrder.containskey(r1.Input_Controls_Mapping__c) && MulilistValueOrder.get(r1.Input_Controls_Mapping__c)!=null &&  r1.Value_New__c != null && r1.MultiListName__c != null && r1.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
                                Set<string> allVals=new set<string>(MulilistValueOrder.get(r1.Input_Controls_Mapping__c));
                                if(allVals != null && allVals.size()>0 && !allVals.contains(r1.MultiListName__c)){
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
                                        WV_multiListWrapper multieachLabel=new WV_multiListWrapper();   
                                        multieachLabel.name='Label';                                
                                        multieachLabel.controltype=r1.Input_Controls_Mapping__r.Input_Control_Type__c;
                                        multieachLabel.showCurrency=r1.Input_Controls_Mapping__r.Show_Currency__c;
                                        multieachLabel.value=r1.Input_Controls_Mapping__r.name; 
                                        multiList.add(multieachLabel);
                                        multiList.add(multieach);  
                                        multiListMap.put(r1.Input_Controls_Mapping__c,multiList);  
                                   }
                             }
                        }
                    }
                }
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnrolmentResponses class-->getMultiLists()'+e.getlinenumber()+'-'+e.getmessage());       
        }
        return multiListMap;
    }
    
    public Map<string,string> getValueControls(){
        Map<string,string> valueMap=new Map<string,string>();
        try{
            if(Responses_New != null && Responses_New.size() > 0){ 
                for(Response__c r:Responses_New){
                    if( r.Value_New__c != null &&  r.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' && (r.Input_Controls_Mapping__r.Control_Visibility__c=='Primary' ||  r.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary')){
                        if(r.IsNumberControl_Internal_Use__c==true){
                            try{
                                String str=String.format(Decimal.Valueof(r.Value_New__c.trim()).format(),argsDecimal);
                                valueMap.put(r.Input_Controls_Mapping__c,str);
                            }
                            Catch(exception e){
                                valueMap.put(r.Input_Controls_Mapping__c,r.Value_New__c);
                                system.debug('****Exception inside Decimal conversion');
                            }
                        }
                        else{
                            valueMap.put(r.Input_Controls_Mapping__c,r.Value_New__c);
                        }
                    }
                }
            }   
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnrolmentResponses class-->getValueControls()'+e.getlinenumber()+'-'+e.getmessage());       
        }
        return valueMap;    
    }
    
    public List<Response__c> getUpdatedResponses(){
        List<Response__c> newResponsesList=new List<Response__c>();
        try{
            Response__c response;
            if(Responses_New != null && Responses_New.size() > 0){ 
                for(Response__c r:Responses_New){   
                    response=r.clone();
                    if(response.Value_New__c != null && (response.Input_Controls_Mapping__r.Control_Visibility__c=='Primary' ||  response.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary') && (response.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' || response.Input_Controls_Mapping__r.Input_Control_Type__c=='List Capture') ){           
                        if(response.IsNumberControl_Internal_Use__c==true && response.Input_Controls_Mapping__r.Input_Control_Type__c=='Value Capture' ){
                            try{
                                response.Value_New__c=String.format(Decimal.Valueof(response.Value_New__c.trim()).format(),argsDecimal);
                            }
                            Catch(exception e){
                                system.debug('****exception inside formatting number'+e.getmessage()+'-'+e.getlinenumber());
                            }
                        }
                        newResponsesList.add(response);
                        response=null;
                    }
                }
            }  
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnrolmentResponses class-->getUpdatedResponses()'+e.getlinenumber()+'-'+e.getmessage());       
        }
        return newResponsesList;    
    }
    
    public List<String> getOrderedControls(){
        List<string> OrderedList=new List<string>();
        set<string> UniqueIDs=new set<String>();
        try{
            if(Responses_New != null && Responses_New.size() > 0){   
               for(Response__c r:Responses_New){
                    if(r.Value_New__c != null && r.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r.Input_Controls_Mapping__r.Input_Control_Type__c!='Multi Value Option Capture'){                                                                            
                        if(!UniqueIDs.contains(r.Input_Controls_Mapping__c)){
                            OrderedList.add(r.Input_Controls_Mapping__c);
                            UniqueIDs.add(r.Input_Controls_Mapping__c);
                        }
                    }    
               } 
               for(Response__c r1:Responses_New){
                    if(r1.Value_New__c != null && r1.MultiListName__c != null && r1.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && r1.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'){                                                                            
                        if(!UniqueIDs.contains(r1.Input_Controls_Mapping__c)){
                            OrderedList.add(r1.Input_Controls_Mapping__c);
                            UniqueIDs.add(r1.Input_Controls_Mapping__c);
                        }
                    }    
               } 
                UniqueIDs.clear();
            } 
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnrolmentResponses class-->getOrderedControls()'+e.getlinenumber()+'-'+e.getmessage());       
        }
        return OrderedList;    
    }
    
    public WV_EnrolmentResponses(){
        this.isActive=false;
        this.isOnFocus=false;
        this.showCurrency =false;
        this.isFutureOne=false;
        this.isPast=false;
        this.showMultiList=false;
        this.flagMultiListControl =false;
        this.Responses_New=new List<Response__c>();
        this.isSecondaryControlsPresent=false;
        this.MulilistValueOrder=new Map<string,List<string>>();
        this.argsDecimal = new String[]{'0','number',Label.WV_Homepage_NumberFormat};
    }
    
    global Integer compareTo(Object compareTo) {
        WV_EnrolmentResponses compareToEmp = (WV_EnrolmentResponses)compareTo;
        if (EnrolmentEndDate == compareToEmp.EnrolmentEndDate) return 0;
        if (EnrolmentEndDate > compareToEmp.EnrolmentEndDate) return 1;
        return -1;        
    }

}