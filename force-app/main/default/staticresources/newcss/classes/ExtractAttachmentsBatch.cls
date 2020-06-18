global class ExtractAttachmentsBatch implements Database.Batchable<sObject>{
	global String objectAPIStr,queryStr;
    global String headerFieldsStr = 'CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId';
    global List<sObject> sObjectList = new List<sObject>();
    
    global ExtractAttachmentsBatch(String objectAPI){
        /* if(!String.isEmpty(objectAPI)){
            this.objectAPIStr = objectAPI;
            queryStr = 'SELECT ' + headerFieldsStr + ' FROM ' + objectAPI;
        }
		*/
        queryStr = 'SELECT Id, (SELECT CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId FROM Histories) FROM Cross_Sell__c';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        /* if(!String.isEmpty(queryStr)){
            return Database.getQueryLocator(queryStr);
        }
        return null;
		*/
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<Cross_Sell__c> scope){
        system.debug(' EXEC -> ' + scope);
        if(!scope.isEmpty()){
            String csvContentStr = '';
            csvContentStr =+ headerFieldsStr + '\n';
            //Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
			//Schema.SobjectType oType = gd.get(objectAPIStr);
            for(Cross_Sell__c cros : scope){
                system.debug(' scope -> ' + scope);
                /*String s = (oType) obj;
                 String cont = 	obj.CreatedById + ',' + obj.CreatedDate + ',' + obj.Field + ',' 
                    			+ obj.Id + ',' + obj.NewValue + ',' + obj.OldValue + ',' 
                    			+ obj.ParentId + '\n';
                csvContentStr =+ cont;*/
                  /*String cont =  anm.CreatedById + ',' + anm.CreatedDate + ',' + anm.Field + ',' 
                    			+ anm.Id + ',' + anm.NewValue + ',' + anm.OldValue + ',' 
                    			+ anm.ParentId + '\n';
*/
                  //csvContentStr
            }
            
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}