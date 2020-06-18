//MSN: RIF#121 Created the new class for sending Emails to Project Owner- Emp SYnc

global class RIF_EmailProjectOwnerBatch implements  Database.Batchable<sObject>, Database.Stateful,Schedulable  {
    
    global Map<String,List<Severance_Release_ETL_Temp__c>> mapPjtIDSNRETL  = new Map<String,List<Severance_Release_ETL_Temp__c>>();
    global  Map<String,List<Severance_Release_ETL_Temp__c>> mapSNRIDSNRETL  = new Map<String,List<Severance_Release_ETL_Temp__c>>();
    private final String query = 'SELECT Id,Project__r.ownerId,Severance_And_Release__r.name,Project__r.owner.email,Employee__r.emp_id__c,Employee__r.name, Project__r.name,Changed_Fields__c, Employee__c, Project__c, Severance_And_Release__c, Active__c, MS_ID__c from Severance_Release_ETL_Temp__c where Active__c =true and createddate >= LAST_N_DAYS:5    and Severance_And_Release__r.Communicated__c =false and project__r.status__c=\'Active\'  order by Severance_And_Release__r.name, createddate desc';
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Severance_Release_ETL_Temp__c> snrETLList)
    {
        if(snrETLList!=null && !snrETLList.isEmpty())
        {
            for(Severance_Release_ETL_Temp__c snrETL : snrETLList)
            {
                if(!mapSNRIDSNRETL.containsKey(snrETL.Severance_And_Release__c))
                {
                    mapSNRIDSNRETL.put(snrETL.Severance_And_Release__c,new List<Severance_Release_ETL_Temp__c>{snrETL});
                }
                else
                {
                    List<Severance_Release_ETL_Temp__c> snrList = mapSNRIDSNRETL.get(snrETL.Severance_And_Release__c);
                    snrList.add(snrETL);
                    mapSNRIDSNRETL.put(snrETL.Severance_And_Release__c,snrList);
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        List<Messaging.SingleEmailMessage> listEmail = new   List<Messaging.SingleEmailMessage>();
        List<contact> contactList = new List<Contact>();
        List<Severance_Release_ETL_Temp__c>  listETLtoUpdate = new List<Severance_Release_ETL_Temp__c>() ;
        Map<String,String> mapETLIDContID = new Map<String,String>();
        List<EmailTemplate> emailTempList;
        String orgEmail = '';
        String orgEmailId = '';
        for(OrgWideEmailAddress owe : RIF_DataUtil.getOrgWideEmaillAddresses(System.Label.RIF_Orgwide_Email)) {
            orgEmail = owe.Address;
            orgEmailId = owe.id;
        }
        emailTempList = [Select Id, DeveloperName From EmailTemplate  where DeveloperName ='RIF_EmpSyncEmailv1_3'];
        
        if(!mapSNRIDSNRETL.isEmpty())
        {
            for(String snrID : mapSNRIDSNRETL.keySet())
            {
                List<Severance_Release_ETL_Temp__c> snrIdETLList = mapSNRIDSNRETL.get(snrID);
                system.debug('snrIdETLList size--'+snrIdETLList.size());
                if(snrIdETLList!=null && snrIdETLList.size()<=Integer.valueOf(label.RIF_EmailPrjtOwner))
                {
                    for(Severance_Release_ETL_Temp__c snrETL :snrIdETLList)
                    {
                        if(!mapPjtIDSNRETL.containsKey(snrETL.Project__c))
                        {
                            mapPjtIDSNRETL.put(snrETL.Project__c,new List<Severance_Release_ETL_Temp__c>{snrETL});
                        }
                        else
                        {
                            List<Severance_Release_ETL_Temp__c> snrList = mapPjtIDSNRETL.get(snrETL.Project__c);
                            snrList.add(snrETL);
                            mapPjtIDSNRETL.put(snrETL.Project__c,snrList);
                        }
                        break;
                    }
                }
            }
        }
        
        if(!mapPjtIDSNRETL.isEmpty())
        {
            for(String pjtId:mapPjtIDSNRETL.keySet())
            {
                List<Severance_Release_ETL_Temp__c>  listETL1 = mapPjtIDSNRETL.get(pjtId);
                List<String> etldataList = new List<String>();
                String projectEmailID;
                String etldata ='';
                Contact cont;
                for(Severance_Release_ETL_Temp__c etltemp : listETL1)
                {
                    etldata =  etldata +'Project Name -'+ etltemp.Project__r.name +
                        +' Severance Name -' +etltemp.Severance_And_Release__r.name+
                        + ' Changed Fields -' +etltemp.Changed_Fields__c+'\n'+'\n'; 
                    projectEmailID = etltemp.Project__r.owner.Email;
                }
                
                if(listETL1!=null && !listETL1.isEmpty())
                {
                    cont = new Contact(firstname = '**test**', lastname = '**test**',SNR_ETL_ID__c =listETL1[0].Id, email = projectEmailID);
                    contactList.add(cont);
                    listETL1[0].Email_Subject_Data__c = etldata;
                    listETLtoUpdate.add(listETL1[0]);
                } 
            }
        }
        
        if(contactList!=null && !contactList.isEmpty())
        {
            insert contactList;
            for(Contact con : contactList)
            {
                mapETLIDContID.put(con.SNR_ETL_ID__c,con.Id);
            }
        }
        if(listETLtoUpdate!=null && !listETLtoUpdate.isEmpty())
        {
            update listETLtoUpdate;
        }
        
        for(Severance_Release_ETL_Temp__c etl : listETLtoUpdate)
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(emailTempList[0].id);
            message.setOrgWideEmailAddressId(orgEmailId);
            message.setTargetObjectId(mapETLIDContID.get(etl.Id));
            message.setSaveAsActivity(false);
            message.setWhatId(etl.Id);
            listEmail.add(message);
        }
        
        if(listEmail!=null && !listEmail.isEmpty())
        {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(listEmail);
        }
        if(!contactList.isEmpty())
            delete contactList;
        
    }
    
    global void execute(SchedulableContext SC)
    {
        Database.executeBatch(new RIF_EmailProjectOwnerBatch(),2000);
    }
    
}