trigger CustomerTrigger on porcelain__Customer__c (before insert, before update,before delete, after insert,
                                                   after update,after undelete,after delete) {
                                                       if (Trigger.isBefore){
                                                        if (Trigger.isInsert)
                                                            System.debug('before insert value of trigger.new'+trigger.new);
                                                            system.debug('Before insert old list values in before case'+trigger.old);
                                                        if (Trigger.isUpdate)
                                                            System.debug('before update value of trigger.new'+trigger.new);
                                                            system.debug('before update old list values in before case'+trigger.old);
                                                           
                                                        if (Trigger.isdelete)
                                                            System.debug('before delete value of trigger.new'+trigger.new);
                                                            system.debug('before delete old list values in before case'+trigger.old);
                                                       }
                                                       
                                                       if (trigger.isAfter){
                                                           List <Product2> clist = new List <Product2>();
                                                          List <Product2> prd = new List<Product2>([Select id, name, description from Product2 limit 1]);
                                                           system.debug('prd list is'+prd);
                                                           if (Trigger.isInsert)
                                                               for (Customer__c cust:trigger.new){
                                                               if( cust.Product__c =='')
                                                                   
                                                                   prd[0].Description = 'not dummy';
                                                                  update prd;
                                                                   System.debug('updated list is'+prd);
                                                               
                                                                   
                                                                   
                                                            System.debug('after insert value of trigger.new'+trigger.new);
                                                            system.debug('after insert old list values in before case'+trigger.old);
                                                               }
                                                               insert clist;
                                                           if(trigger.isDelete)
                                                               system.debug('after delete trigger new value is'+trigger.new);
                                                               system.debug('after delete trigger old value is'+trigger.old);
                                                           if(trigger.isUpdate)
                                                               system.debug(' after update trigger new value is'+trigger.new);
                                                               system.debug('after update trigger old value is'+trigger.old);
                                                           if(trigger.isUndelete)
                                                               system.debug('after undelete trigger new value is'+trigger.new);
                                                               system.debug('after undelete trigger old value is'+trigger.old);
                                                               
                                                           
                                                           
                                                                                                                 }

}