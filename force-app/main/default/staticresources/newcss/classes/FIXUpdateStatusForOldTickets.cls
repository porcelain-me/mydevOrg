global class FIXUpdateStatusForOldTickets implements Database.Batchable<sObject>,Database.Stateful{
        List<String> lst=new List<String>();
    String str1='Name\n';        
     // singhrak, REQ3243291, 20Jan, 2015, Add Integrator in header  
    String oldRecords='Name,Status,Last Modified By, Last Modified Date, Integrator \n';    
   global Database.QueryLocator start(Database.BatchableContext BC){
    List<String> lst=new List<String>();   
    date d = system.today().addDays(-180);
    // singhrak, REQ3243291, 20Jan, 2015, Add Integrator__c in select query list
    String query='select Name,Status__c, LastModifiedById, LastModifiedDate, Integrator__c  from EU_ProductRequest__c where LastModifiedDate  < :d and  (Status__c=\'Submitted\' OR status__c like \'Work In-Progress%\') ';
    return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<EU_ProductRequest__c> scope){
      Map<String,String> usernameList = getUsernameList(scope);
    // singhrak, REQ3243291, 20Jan, 2015, Add Integrator__c in following line
     for(EU_ProductRequest__c s : scope){system.debug('ss11:'+s.LastModifiedById);
        oldRecords+=s.get('Name')+','+s.get('status__c')+','+usernameList.get(s.LastModifiedById)+','+s.get('LastModifiedDate')+','+s.get('Integrator__c')+'\n';
    }   

     for(EU_ProductRequest__c s : scope){
     s.put('status__c','On Hold');
     s.put('DisableTriggrerFlag__c','True389');
     }
    Database.SaveResult[] srList = Database.update(scope, false);
    system.debug('listsize::'+srList.size());
    
  
    Map<String,String> ticketNameMap = getTicketNameNPR(srList);
    
    
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        str1+=ticketNameMap.get(sr.getId())+'\n';   
    }
    else {
              for(Database.Error err : sr.getErrors()) {
                str1+='Error occured ==>> '+err.getStatusCode() + ': ' + err.getMessage();
              }
            str1+='\n';     
//        str1+=(sr.getId()+'::'+sr.getErrors()+'\n');
        } 
     }   
    }
    
    public Map<String,String> getUsernameList(EU_ProductRequest__c[] scope)
    {
        Set<String> idList = new Set<String>();
        for(EU_ProductRequest__c e: scope)
        {
            idList.add(e.LastModifiedById);
        }       
        User[] usrList=[select name,id from User where id in: idList];
        Map<String,String> mapListUser = new Map<String,String>();
        for(User u: usrList)
        {
            mapListUser.put(u.id,u.name);
        }
        return mapListUser;
    }
    
    public Map<String,String> getTicketNameNPR(Database.SaveResult[] srList)
    {
        List<String> idList = new List<String>();
        for (Database.SaveResult sr : srList) {
            idList.add(sr.getId());
        }
        
        Map<String,String> mapList = new Map<String,String>();
        EU_ProductRequest__c[] euprod = [select name,id from EU_ProductRequest__c where id in: idList];
        for(EU_ProductRequest__c e: euprod)
        {
            mapList.put(e.id,e.name);       
        }
    return  mapList;
    }
    

   global void finish(Database.BatchableContext BC){
   
     Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[2];

     Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
     Blob txtBlob = Blob.valueOf(str1); 
     fileAttachment.setBody(txtBlob);
     fileAttachment.setFileName('FIXUpdated.csv');
     fileattachment.setContentType('application/csv');
     fileAttachments[0] = fileAttachment;
     
     Messaging.EmailFileAttachment fileAttachment1 = new Messaging.EmailFileAttachment();
     Blob txtBlob1 = Blob.valueOf(oldRecords); 
     fileAttachment1.setBody(txtBlob1);
     fileAttachment1.setFileName('FIXOld.csv');
     fileattachment1.setContentType('application/csv');
     fileAttachments[1] = fileAttachment1;

     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //globaletsclients@morganstanley.com.test
    MSET_Contact__c contacts=[Select Id from MSET_Contact__c where Name='globaletsclients']; 
     mail.setTargetObjectId(contacts.id);
     
     List<String> ccAdr=new List<String>();
     ccAdr.add('Rakesh.Singh1@morganstanley.com.test');
     mail.setCcAddresses(ccAdr);
             
     mail.setSaveAsActivity(false);
     mail.setFileAttachments(fileAttachments);
    
    
     mail.setSubject( '*** Auto Update: Salesforce requests moved to On Hold status ***' );
     mail.setHtmlBody('Please see attached for a list of Salesforce requests recently moved to On Hold status due to inactivity for more than six months.  The attachment titled "FIXOld" contains the prior status for these requests.<br/><br/>  ** This is an auto-generated email **    ');
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

   }
}