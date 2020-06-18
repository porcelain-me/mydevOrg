trigger demoTrigger2 on Leave__c (before update, before insert, before delete, after insert, after update, after delete) {

    if(Trigger.isBefore){
        for(Leave__c bk : Trigger.new){
            
            if(bk.Name != 'Goodbook')
               bk.Name.addError('You can\'t create this record!'+bk.Name);
 
               
            //try doing dml on unrelated object
            //list<Account> accList = [Select id, Name from Account where name ='' limit 1];
             system.debug('this is before side'+bk);
        }
           
          
    }
    else if(Trigger.isAfter){
        aftermethod();
        /*for (Leave__c bka : Trigger.old){
         
        system.debug('this is after side'+bka);            
        }*/
        
    }
    //lets try writing specific methods for each task
    private void beforemethod(){
        
    }
    private void aftermethod(){
        
        
        
    }
    
    
    
    
}