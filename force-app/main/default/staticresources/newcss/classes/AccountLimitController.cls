public class AccountLimitController {
    

    public AccountLimitController(ApexPages.StandardController controller) {
        accountId=ApexPages.currentPage().getParameters().get('Id');

    System.debug('I am in AccountLimitController  constructor');
    }
    public void attachUploadedFileInTicket(String id)
    {
       Savepoint sp = Database.setSavepoint();
       
       try{
       document1.AuthorId = UserInfo.getUserId();
       document1.FolderId='00l60000001rTEc';
       document1.Keywords=String.valueOf(id);
       Database.SaveResult sr= Database.insert(document1);
      
       Document d = [Select Name,Keywords,d.CreatedById,d.CreatedDate, d.LastModifiedById, d.LastModifiedDate,d.Id
       From Document d where id =:sr.getId()] ;
       Account_Limit__c accn = new Account_Limit__c();
       accn.MSET_Account__c=d.Keywords;
       accn.Created_By__c=d.CreatedById;
       accn.Created_Date__c=d.CreatedDate;
       accn.Last_Modified_By__c=d.LastModifiedById;
       accn.Last_Modified_Date__c=d.LastModifiedDate;
       accn.DocumentId__c= d.Id;
       accn.File_Name__c=d.Name;
       Database.insert(accn);
       
       }
       catch(Exception e)
       {
       System.debug('Error in inserting'+e);
       Database.rollback(sp);
       }
       
       
    }
    
     public String accountId{get;set;}
    
        public Document document1 {
      get {
        System.debug('s111:::'+document1);
        if (document1 == null)
          document1 = new Document();
        return document1;
      }
      set;
    }
    
    
    public PageReference saveFile()
    {
        if(document1.name == null || document1.name == '' || document1.body == null )
        {
          ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please select the file to upload');
          ApexPages.addMessage(msg);
            return null;
        }
        
        System.debug('in save::'+accountId);
        attachUploadedFileInTicket(accountId);
        document1 = null;
        return null;
    }
    
    public String recId {get;set;}
    
     public List<Document> lstDoc;
    
    public List<Document> getLstDoc()
    {
       String id=ApexPages.currentPage().getParameters().get('Id');
        System.debug('AcciuntID::'+id);
        lstDoc= [Select d.Name,d.CreatedById,d.CreatedDate, d.LastModifiedById, d.LastModifiedDate,d.Id
        From Document d where d.Keywords=:id and d.FolderId=: '00l60000001rTEc' ]   ;
        System.debug('AcciuntIDsize::'+lstDoc.size());

        return lstDoc;
    }
    
    public String fileName {get;set;}

    public PageReference deleteRec()
    {
        SavePoint sp=Database.setSavePoint();
        String docId;
        try{
        Document d=[Select Id From Document d where d.Id=:recId];
        docId=d.Id;
        Database.DeleteResult sr=Database.delete(d);
        
        Account_Limit__c accntRec=[Select Id from Account_Limit__c where 
        DocumentId__c=: sr.getId()]        ;
        Database.delete(accntRec);
        }
        catch(Exception e)
        {
            System.debug('Error in deleteing::'+e);
            Database.rollback  (sp);
        }
        
        PageReference pg=new PageReference('/apex/AccountLimit?id='+accountId);
        //PageReference pg=new PageReference('/'+accountId);
        pg.setRedirect(true);        
        return pg;
    }
    
    public PageReference editRec()
    {
        fileName = [Select d.Name From Document d where d.Id=:recId].name; 
        fileName = removeExtension(fileName);
        System.debug('recordedit Id::'+recId);    
        PageReference pg=new PageReference('/apex/AccountLimitFileRename');
        
        return pg;
    
     }
    
    public PageReference saveRename()
    {
        if(fileName == null || fileName == '')
        {
          ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter name');
          ApexPages.addMessage(msg);
            return null;
        }

       SavePoint sp= Database.setSavePoint();
    try{
      Document d=[Select d.Name,d.Type,d.LastModifiedById,d.LastModifiedDate From Document d where d.Id=:recId];
      d.name=fileName+'.'+d.Type;
      Database.SaveResult sr = Database.update(d);
    
        d=[Select d.Name,d.LastModifiedById,d.LastModifiedDate From Document d where d.Id=:recId];

       Account_Limit__c accn = [Select Name,Last_Modified_By__c, Last_Modified_Date__c from Account_Limit__c 
       where DocumentId__c=: sr.getId()];
       accn.File_Name__c=d.Name;
       accn.Last_Modified_By__c=d.LastModifiedById;
       accn.Last_Modified_Date__c=d.LastModifiedDate;
       System.debug(accn.Last_Modified_Date__c+'1111::'+ d.LastModifiedDate );
       Database.update(accn);
       System.debug(accn.Last_Modified_Date__c+'1112::'+ d.LastModifiedDate );
       }
       catch(Exception e)        
       {
       System.debug('Error in rename::'+e);
       Database.rollback(sp);
       }

     
        PageReference pg=new PageReference('/apex/AccountLimit?id='+accountId);
//      PageReference pg=new PageReference('/'+accountId);
        pg.setRedirect(true);        
        return pg;

    }
    
    public PageReference View()
    {//https://mset--test--c.cs17.content.force.com/servlet/servlet.FileDownload?file=00Pg0000001EJJj
        PageReference pg=new PageReference('/servlet/servlet.FileDownload?file='+recId);
        pg.setRedirect(true);        
        return pg;
    
    }


    public PageReference cancel()
    {
        PageReference pg=new PageReference('/apex/AccountLimit?id='+accountId);
        pg.setRedirect(true);        
        return pg;
    }

    public String removeExtension(String name)
    {
        Integer i1=name.lastIndexOf('.');
        return name.substring(0,i1);
    }
    
}