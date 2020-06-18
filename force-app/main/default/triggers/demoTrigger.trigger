trigger demoTrigger on Book__c (before update, before insert, before delete, after insert, after update, after delete) {

    if(Trigger.isBefore){
        for(Book__c bk : Trigger.new){
            
            if(bk.Name != 'Goodbook')
               bk.addError('You can\'t create this record!');
 
               
            //try doing dml on unrelated object
            //list<Account> accList = [Select id, Name from Account where name ='' limit 1];
             system.debug('this is before side'+bk);
        }
           
          
    }
    else if(Trigger.isAfter){
        for (Book__c bka : Trigger.old){
         
        system.debug('this is after side'+bka);            
        }
        
    }
    
}