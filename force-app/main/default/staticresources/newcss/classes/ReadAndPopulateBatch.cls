global class ReadAndPopulateBatch  implements Database.batchable<String>, Database.Stateful
{
   public String m_csvFile;
   public String fileId;
   public Map<Integer,string>  OrderMap;
   
   global Iterable<String> start(Database.batchableContext batchableContext)
   { 
       return new WV_CSVIterator(m_csvFile,'\n');
   }
   global void execute(Database.BatchableContext batchableContext, List<String> scope)  
   {
       list<Wav_Custom_data__c> insertlist=new list<Wav_Custom_data__c>();
       
       if(scope != null && scope.size() > 0){
           for(String line : scope) {
                Wav_Custom_data__c t=new Wav_Custom_data__c();
                if (line.replaceAll(',','').trim().length() == 0) continue;
                
                String regexStr = ',(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))';
                List<String> fields = line.split(regexStr);
                List<String> cleanFields = new List<String>();    
                      
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    field = field.trim();
                    if (field.startsWith('"') && field.endsWith('"')) {                 
                       // cleanFields.add(field.replaceAll('""','"'));
                       cleanFields.add(field.replaceAll('"',''));
                    } else if (field.startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.endsWith('"')) {
                        compositeField += ',' + field;                  
                        cleanFields.add(compositeField.replaceAll('""','"'));
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                    } else {                  
                        //cleanFields.add(field.replaceAll('""','"'));
                        cleanFields.add(field.replaceAll('"',''));
                    }
                }
                t.File_Upload__c=fileId;
                
                if(cleanFields != null && cleanFields.size() >0){
                    for(Integer j=0;j<cleanFields.size();j++){
                        if(OrderMap.containsKey(j)){
                            t.put(OrderMap.get(j),cleanFields[j]); 
                        }
                    } 
                }   
                
                insertlist.add(t);
           }    
       }
       if(insertlist != null && insertlist.size() >0){   
           Database.Insert(insertlist);
           insertlist.clear();
       }
   }
   global void finish(Database.BatchableContext batchableContext){
   
   }
}