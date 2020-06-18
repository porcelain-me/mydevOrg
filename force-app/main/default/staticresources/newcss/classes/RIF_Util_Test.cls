@isTest
public class RIF_Util_Test{

     public static boolean TriggerRecursiveBarrierVar=false;
     
     public static void sendRIFReminderEmails(List<Severance_And_Release__c> srList,Id templateId){ 
        Contact c;
        Messaging.SingleEmailmessage email;
        String orgname=Label.ORG_ENVIRONMENT;
        List<OrgWideEmailAddress> org=[select id,DisplayName, Address from OrgWideEmailAddress where DisplayName='My Elections Dev Team'];
        List<Contact> conList=new List<Contact>();
        List<Messaging.SingleEmailmessage> emailList = new List<Messaging.SingleEmailmessage>();
        Map<string,string> conEmailMap=new Map<string,string>();
        
        if(org !=null && org.size() >0 && templateId != null && srList != null && templateId != null){
           for(Severance_And_Release__c sr:srList){
                  if(!conEmailMap.containsKey(sr.createdby.email)){
                     c = new Contact(firstname='**test**', lastname='**test**',email=sr.createdby.email);
                     conList.add(c);
                  }                  
            }
            /*Contact c1 = new Contact(firstname='**test**', lastname='**test**',email=userinfo.getuseremail());
            conList.add(c1);*/
            
            if(conList.size() >0){
                insert conList;
                for(contact con:conList){
                    conEmailMap.put(con.email,con.Id);
                }
            }   
            
            for(Severance_And_Release__c sr:srList){
                  email = new Messaging.SingleEmailmessage();
                  
                  
                   // String userId = UserInfo.getUserId();
                                    
                  //email.setTargetObjectId(sr.CreatedBy.email);
                  //String[] toAddresses = new String[] {sr.CreatedBy.email};
                  //email.setToAddresses(toAddresses);   
                  //email.setTargetObjectID(sr.CreatedById);
                  //email.setSaveAsActivity(false);
                  /*if(orgname.tolowercase()!='prod' && conEmailMap.containsKey(userinfo.getuseremail())){  //if its non-production environment then send email to logged in user.
                     email.setTargetObjectId(conEmailMap.get(userinfo.getuseremail()));
                  }
                  else if(conEmailMap.containsKey(sr.Decisional_Unit__r.Employee__r.email__c)){//if its production then send email to actual employees with no users in CC addresses.                 
                     email.setTargetObjectId(conEmailMap.get(sr.Decisional_Unit__r.Employee__r.email__c));
                  }*/
                  if(conEmailMap.containsKey(sr.createdby.email)){//if its production then send email to actual employees with no users in CC addresses.                 
                     email.setTargetObjectId(conEmailMap.get(sr.createdby.email));
                  }
                  email.setOrgWideEmailAddressId(org[0].Id);
                  email.setSaveAsActivity(false);
                  email.setWhatId(sr.id);
                  email.setTemplateId(templateId);  
                  emailList.add(email); 
                  
                  
        
            }
            /*if (emailList.size() > 0) { 
                SYSTEM.DEBUG('**************emailList'+emailList);
                List<Messaging.SendEmailResult> result=Messaging.sendEmail(emailList);
            }*/
            
           if (emailList.size() > 0) { 
                SYSTEM.DEBUG('**************emailList'+emailList);
                List<Messaging.SendEmailResult> result=Messaging.sendEmail(emailList);
                delete conList;
                conEmailMap=null;
            }
        }
    }
}