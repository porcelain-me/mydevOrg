public class testme2{
    @future(Callout=true)
    public static void getcongaDocument(String id,string serverUrl,string sessionId,string templateId){
        Http h = new Http();
                    HttpRequest req = new HttpRequest();
                    string str=userinfo.getsessionId();
                    string firstImageURL = 'https://www.appextremes.com/apps/Conga/PM.aspx?BML=Generating+Documents+Please+wait...&DS7=1&id='+Id+'&LG3=2&MTOFN=Severance+And+Release+Summary&serverUrl='+serverUrl+'&sessionId='+sessionId+'&templateId='+templateId;
                    firstImageURL = firstImageURL.replace(' ', '%20');
                    req.setEndpoint(firstImageURL);
                    req.setMethod('GET');
                    req.setHeader('Content-Type', 'application/pdf');
                    req.setCompressed(true);
                    req.setTimeout(60000);
                    HttpResponse res = null;
                    res = h.send(req);  
    }
}