@RestResource(urlmapping='/Sourceservice/*')  
global class SourceAdapter{    
    @HttpPost
    global static void doPost(){   
        RestResponse res = RestContext.response;     
        
        List<wav_source__C> sourceList=[select id,name,Source_Order__c from wav_source__C];
        List<SourceAdapter.wrap> warps=new List<SourceAdapter.wrap>();
        if(   sourceList != null && sourceList.size() >0){
              for(wav_source__C s:sourceList ){
                  warps.add(new SourceAdapter.wrap(s.name,string.valueOf(s.Source_Order__c)));
              } 
              String JSONString = JSON.serialize(warps);
              System.debug('Serialized list of invoices into JSON format: ' + JSONString);
              RestContext.response.addHeader('Content-Type', 'application/json');
              RestContext.response.responseBody = Blob.valueOf(JSONString);
        }
    }   
    
    global class wrap{
        global string name {get; set;}
        global string orders {get; set;}
        
        global wrap(string name,string order){
            this.name=name;
            this.orders=order;
        }
    } 
}