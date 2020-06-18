public class testme1{
    @future(callout=true)
    public static void getcongaDocument(String id,string serverUrl,string templIdsStr,string queryId,set<string> congaTemp,string sessionId){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //string str=userinfo.getsessionId();
        string firstImageURL = 'https://www.appextremes.com/apps/Conga/composer.aspx?BML=Generating+Documents+Please+wait...&DS7=1&id='+Id+'&LG3=2&MTOFN=Consolidated+Document+For+Printing&serverUrl='+serverUrl+'&sessionId='+sessionId+'&templateId='+templIdsStr+'&DefaultPDF=1&&QueryId='+queryId+'?pv0='+Id;
        //string firstImageURL = 'https://www.appextremes.com/apps/Conga/PM.aspx?BML=Generating+Documents+Please+wait...&DS7=1&id='+Id+'&LG3=2&MTOFN=Severance+And+Release+Summary&serverUrl='+serverUrl+'&sessionId='+sessionId+'&templateId='+templateId;
        firstImageURL = firstImageURL.replace(' ', '%20');
        system.debug('******************'+firstImageURL );
        req.setEndpoint(firstImageURL);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/pdf');
        req.setCompressed(true);
        req.setTimeout(60000);
        HttpResponse res = null;
        res = h.send(req);  
        
        List<APXTConga4__Conga_Template__c> congaTemplates=new List<APXTConga4__Conga_Template__c>();
        if(congaTemp != null && congaTemp.size() >0){
            for(String s:congaTemp){
                APXTConga4__Conga_Template__c a=new APXTConga4__Conga_Template__c (Id=s);
                congaTemplates.add(a);
            }
            delete congaTemplates;
        }
    }
}