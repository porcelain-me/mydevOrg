@isTest(seeAllData=true)
public class RIF_AddAttachmentstoSNRTest {
    static testMethod void myTest(){
        
        Severance_And_Release__c snr  = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;

        Attachment attach= new Attachment();    
        attach.parentid =snr.id;
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.Body=Blob.valueOf('Unit Test Attachment Body');
        attach.Description=null;
        insert attach;
        
        
        note note =new note();
        note.parentid=snr.id;
        note.Body='Unit Test note Body';
        note.Title='title note';
        insert note;
        string selectedTemplate='Release Agreement';
        
        ApexPages.StandardController sc = new ApexPages.standardController(snr);
        
        Test.startTest();
        RIF_AddAttachmentstoSNR obj= new RIF_AddAttachmentstoSNR(sc);
        
        obj.getlistWrapper();
        obj.attach();
       
       
        obj.getExstNotes();
        obj.getExstAttachments();
        obj.selectedTemplate='Release Agreement';
        //obj.refresh='test';
        obj.delId=attach.id;
         obj.deleteRecord();
        obj.delNoteId=note.id; 
       obj.deleteNote();
   
    

        Test.stopTest();      
       
    }
  
    static testMethod void myTest1(){
         Severance_And_Release__c snr  = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;
        
           ApexPages.StandardController sc = new ApexPages.standardController(snr);
        
              RIF_AddAttachmentstoSNR obj1= new RIF_AddAttachmentstoSNR(sc);
        
           obj1.selectedTemplate='Release Agreement';    
        obj1.newAttachment.Name='Unit Test Attachment';        
         obj1.newAttachment.Body=Blob.valueOf('Unit Test Attachment Body');
        
        obj1.attach();
       
    }
        static testMethod void myTest2(){
         Severance_And_Release__c snr  = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert snr;
        
           ApexPages.StandardController sc = new ApexPages.standardController(snr);
        
              RIF_AddAttachmentstoSNR obj1= new RIF_AddAttachmentstoSNR(sc);
        
           obj1.selectedTemplate='Release Agreement';    
        obj1.newAttachment.Name=null;        
         obj1.newAttachment.Body=null;
        
        obj1.attach();
       
    }
    
}