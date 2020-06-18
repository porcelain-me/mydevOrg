/**************************************************************************************
* RIF_Attachment Copy 
* This batch process copies documents for the generate all option
*
* Change Log:
*
*   MRM 4/11/16 - Created class
*
****************************************************************************************/
global class RIF_AttachmentCopy implements Database.Batchable<SObject>, System.Schedulable{  
    
    Map<ID,Map<ID,List<Attachment>>> fromToDU;
    Map<ID,Map<ID,List<Attachment>>> fromToSRDoc;
    Set<ID> srBatchSet;
    Boolean updateSR;  
    Set<String> congaTemp;
    Project__c p; 
    class forceException extends Exception {}    
    
    global RIF_AttachmentCopy(Boolean updateSR, Set<ID>srBatchSet, Map<ID,Map<ID,List<Attachment>>> fromToDU,Map<ID,Map<ID,List<Attachment>>> fromToSRDoc, set<String> congaTemp) { 
       
        this.fromToDU = fromToDU;
        this.fromToSRDoc = fromToSRDoc;
        this.srBatchSet = srBatchSet;
        this.updateSR = updateSR;
        this.congaTemp = congaTemp;
       
        /*Package Status
        Submitted Running Complete Failed 
        
        */
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext c) { 
        
        
        
        String queryStr = 'Select id from Severance_And_Release__c where id in (';
        
        Boolean firstTime = true;
        for (String srId : srBatchSet){
            if (firstTime)
                firstTime= false;
            else
                queryStr += ',';
            
            queryStr += '\'' + srId + '\'';
        }
        queryStr += ')';
        
          
        List<Severance_And_Release__c>  srFirst = [select project__c from Severance_And_Release__c where id in :srBatchSet limit 1];
       
        if (!srFirst.isEmpty()){
            p = [select id from Project__c where id = :srFirst[0].project__c];
        
            p.package_status__c = 'Running';
            p.package_status_message__c = 'There are ' + srBatchSet.size()  + ' SR records to process';
        
        
            update p;
        }
         
        return Database.getQueryLocator(queryStr); 
        
    }
    
    
    /**************************************************************************************************
    *
    *
    * EXECUTE
    *
    *
    ****************************************************************************************************/
    
    global void execute(Database.BatchableContext c, List<Severance_And_Release__c> srList){
        
            try{
            system.debug('try');
            system.debug('fromToDu: ' + fromToDU);
            system.debug('fromToSRDoc: ' + fromToSRDoc);
            system.debug('srBatchSet: ' + srBatchSet);
            
         
            List<Attachment> iList = new List<Attachment>();
        
        
            for (Severance_And_Release__c sr:srList){
                
                if (Limits.getHeapSize() > Limits.getLimitHeapSize()){
                    throw new forceException('Heapsize limit exceeded, reduce batch size!');
                    break;
                }  
                    
                system.debug('Heap size is: ' + Limits.getHeapSize());
                system.debug('Max heap size is: ' + Limits.getLimitHeapSize());
                
                Map<ID,List<Attachment>> fromToDUMap = fromToDU.get(sr.id); 
                Map<ID,List<Attachment>> fromToSRDocMap = fromToSRDoc.get(sr.id);   
                
                
                if (fromToDUMap != null){   
                    List<Attachment> fromListDU = [select id, body from Attachment where id in:fromToDUMap.keyset()];
            
                    for (attachment f:fromListDU){
                        List <Attachment> toList = fromToDUMap.get(f.id);
                        if (fromToDUMap.get(f.id) != null){
                            for (Attachment t:toList){
                                t.body = f.body;
                                iList.add(t); 
                                 
                            }
                            toList = new List<Attachment>();
                            fromTODUMap.remove(f.id);
                        }       
                    }
                    
                    fromListDU = new List<Attachment>();
                    
                }
                
                
            
                if (fromToSRDocMap != null){    
                    List<Attachment> fromListSRDoc = [select id, body from Attachment where id in:fromToSRDocMap.keyset()];
            
                    for (attachment f:fromListSRDoc){
                        if (fromToSRDocMap.get(f.id) != null){
                            List <Attachment> toList = fromToSRDocMap.get(f.id);
                            for (Attachment t:toList){
                                t.body = f.body;
                                iList.add(t); 
                                 
                            }
                            toList = new List<Attachment>();
                            fromToSRDocMap.remove(f.id);
                        }
                    }
                    
                    fromListSRDoc = new List<Attachment>();
                    
                }
                
                fromToDU.remove(sr.id); 
                fromTOSRDoc.remove(sr.id);
                
            }
             
            Set<ID> srSetD = new set<ID>();
            for (Severance_and_release__c s:srList)
                srSetD.add(s.id);
            
            system.debug('**INSIDE RIF_AttachmentCopy::srSetD:'+srSetD);
            system.debug('**INSIDE RIF_AttachmentCopy::updateSR:'+updateSR);
            if (updateSR){  
                List<Severance_And_Release__c> uSRList = new List<Severance_And_Release__c>();
         
                uSRList = RIF_Util_Kumaresan.updateSnROnContentManagementforSet(srSetD,congaTemp); 
                system.debug('**INSIDE RIF_AttachmentCopy::uSRList :'+uSRList );
                if (!uSRList.isEmpty())
                    update uSRList;
                
            }
    
            if (!iList.isEmpty()) 
                insert iList;
            
            List<Attachment> attListTobeDeleted = [Select id,name,parentId from Attachment where parentId in:srSetD and (name like 'LHH%' or name like 'Exec Comp Overview%')];
            if(!attListTobeDeleted.isEmpty())
                delete attListTobeDeleted ;
                
                
            }
            
            catch (Exception e){
                system.debug('******************* in exception **********************');
                List<Severance_And_Release__c>  srFirst = [select project__c from Severance_And_Release__c where id in :srBatchSet limit 1];
                
                if (!srFirst.isEmpty()){    
                    p = [select id,package_status__c, package_status_message__c from Project__c where id = :srFirst[0].project__c];
                    if (p.package_status__c == 'Failed'){
                        p.package_status_message__c += '/n' + e.getMessage();
                    }
                    else{
                        p.package_status__c = 'Failed';
                        p.package_status_message__c = e.getMessage();
                    }
                    update p;
                }
            }
    } 
    
    global void finish(Database.BatchableContext c){
        
        List<Severance_And_Release__c>  srFirst = [select project__c from Severance_And_Release__c where id in :srBatchSet limit 1];
       
        if (!srFirst.isEmpty()){
            p = [select package_status__c, package_status_message__c from Project__c where id = :srFirst[0].project__c];
            if (p.package_status__c != 'Failed'){
                p.package_status__c = 'Complete';
                p.package_status_message__c = null; 
                update p;
            }
        }
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new RIF_AttachmentCopy(null,null,null,null,null), 1);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}