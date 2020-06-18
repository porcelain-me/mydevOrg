@istest

public with sharing class AccountLimitControllerTest {
	
	static testMethod void TM1()
	{
		ApexPages.currentPage().getParameters().put('id','0013000000AgEMl');

		
		ApexPages.StandardController stdController = new ApexPages.StandardController(new MSET_Account__c()); 
		AccountLimitController cont = new AccountLimitController(stdController);
		String id = '0013000000AgEMl';
		cont.accountId = id;
		
		Document d = new Document(); 
		d.Name = 'A';
		 String myContent = 'aabbcc'; 
		 d.Body = Blob.valueOf(myContent); 
		 d.ContentType = 'text/plain';
		d.Type = 'txt';
		d.FolderId = '00l60000001rTEc';
       Database.SaveResult sr= Database.insert(d);
		
		cont.recId = sr.getId();
		cont.fileName = 'Test';
		
		
		cont.attachUploadedFileInTicket(id);
		cont.cancel();
		cont.deleteRec();
		//cont.editRec();
		cont.getLstDoc();
		cont.saveFile();
		cont.saveRename();
		cont.View();
	}

}