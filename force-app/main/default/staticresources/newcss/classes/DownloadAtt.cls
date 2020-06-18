public class DownloadAtt {
    public String att1 {get
    {
      return '00Pf0000002YYcL'; 
    }set{
        att1='00Pf0000002YYcL';
    }}
    public PageReference down()
    {
        String att ='00Pf0000002YYcL';
     
        List<String> lisSTe = new List<String>{'00Pf0000002YYcL','00Pf0000002YYcL'};
                //List<Attachment> att = [Select ID from Attachment where ID ='00Pf0000002YYcL'].ID;
        String strURL= 'https://' + ApexPages.currentPage().getHeaders().get('Host')+'/servlet/servlet.FileDownload?file='+att;
        PageReference ref = new PageReference(strURL);
        return ref;
    }
}