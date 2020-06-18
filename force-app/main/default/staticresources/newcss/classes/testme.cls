public class testme{

public static void testme(){
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    string str=userinfo.getsessionId();
    string firstImageURL = 'https://www.appextremes.com/apps/Conga/PM.aspx?BML=Generating+Documents+Please+wait...&DS7=1&id=a0Af000000NlI0p&LG3=2&MTOFN=Severance+And+Release+Summary&serverUrl=https://morganstanleyhr--dev.cs16.my.salesforce.com%2Fservices%2FSoap%2Fu%2F8.0%2F00Df0000002K0p7&sessionId='+str+'&templateId=a0Rf0000000BLhR';
    //Replace any spaces with %20
    firstImageURL = firstImageURL.replace(' ', '%20');
    req.setEndpoint(firstImageURL);
    req.setMethod('GET');
    //If you want to get a PDF file the Content Type would be 'application/pdf'
    req.setHeader('Content-Type', 'application/pdf');
    req.setCompressed(true);
    req.setTimeout(60000);
                     
    HttpResponse res = null;
    res = h.send(req);
    //These next three lines can show you the actual response for dealing with error situations
    string responseValue = '';
    responseValue = res.getBody();
    system.debug('Response Body for File: ' + responseValue);
    //This is the line that does the magic.  We can get the blob of our file.  This getBodyAsBlob method was added in the Spring 2012 release and version 24 of the API.
    blob image = res.getBodyAsBlob();
}
}