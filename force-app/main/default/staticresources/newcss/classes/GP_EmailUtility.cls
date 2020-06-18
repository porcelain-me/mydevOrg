/******************Global Parking Utility Class for Evaluating conditions of sending mail**********************/

/* change log */


/*************Class Begins*******************/

    public class GP_EmailUtility {
        
        /**************************Method for Insert operations on Parking Lot Request object********************/
        
        public static void SendMailforInsert(List <Parking_Lot_Request__c> parkingrequestList , Map<ID, Parking_Lot_Request__c> triggermap ){
            
            EmailTemplate templateId1 = [SELECT id FROM EmailTemplate WHERE developerName = 'GP_Email_1_Request_Submitted'];
            EmailTemplate templateId3 = [Select id from EmailTemplate where developerName = 'GP_Email_3_Termination_Requested'];
            EmailTemplate templateId9 = [Select id from EmailTemplate where developerName = 'GP_Email_9_Replacement_Request_Submitted'];
            EmailTemplate templateId11 = [Select id from EmailTemplate where developerName ='GP_Email_11_Overnight_Request_Submitted'];
            
            
             Map<Id,String> emailToAddressMap1 = new Map<Id,String>();
             
             Map<Id,ID> parkingLotMap1 = new Map<Id,ID>();
            
             Map<Id,String> emailToAddressMap2 = new Map<Id,String>();
             Map<Id,String> emailCCMap2 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap2 = new Map<Id,ID>();
            
             Map<Id,String> emailToAddressMap3 = new Map<Id,String>();
             Map<Id,String> emailCCMap3 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap3 = new Map<Id,ID>();
             
             Map<Id,String> emailToAddressMap4 = new Map<Id,String>();
             Map<Id,String> emailCCMap4 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap4 = new Map<Id,ID>();

             Map<Id,String> emailToAddressMap5 = new Map<Id,String>();
             Map<Id,String> emailCCMap5 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap5 = new Map<Id,ID>();
             
             Map<Id,String> emailToAddressMap6 = new Map<Id,String>();
             Map<Id,String> emailCCMap6 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap6 = new Map<Id,ID>();
             
             
             
             
             
            List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: triggermap.keyset()];
            
            SET<ID> requestee = new SET<ID>();
            for(Parking_Lot_Request__c obj : parkingcompletelist){
                requestee.add(obj.Requestee__c);
            }
            System.debug('***********************requestee******************'+requestee);
            List<Employee_Delegate__c> empDelegates = [Select 
                                  Delegate__c
                                 ,employee__c
                                 ,delegate__r.email__c
                                 From Employee_Delegate__c 
                                 where application__c = 'Global Parking'
                                 and status__c = 'Approved'
                                 and employee__c in :requestee
                                 ];
            Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
            for(Employee_Delegate__c d:empDelegates){
                
                if(employeedelegatemap.isEmpty()){
                    employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                    
                }
                else{
                    if(employeedelegatemap.containskey(d.employee__c)){
                        employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                    }
                    else{
                        employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                    }
                }
            }
            System.debug('***********************employeedelegatemap******************'+employeedelegatemap);
            
            for(Parking_Lot_Request__c parkingObject:parkingcompletelist){
            
                if(parkingObject.type__c == 'Parking Space') {
                    if(parkingObject.status__c == 'New'){
                       if(employeedelegatemap.get(parkingObject.Requestee__c) != null){
                           
                            emailToAddressMap1.put(parkingObject.Id, parkingObject.Requestee__r.Email__c +', '+string.join(employeedelegatemap.get(parkingObject.Requestee__c),',  ')); 
                       }
                       else emailToAddressMap1.put(parkingObject.Id, parkingObject.Requestee__r.Email__c); 
                       
                       parkingLotMap1.put(parkingObject.Id, parkingObject.Id);
                    }   
                }
                
                if(parkingObject.type__c == 'Parking Space') {
                    if(parkingObject.status__c == 'Cancelled'){
                       emailToAddressMap2.put(parkingObject.Id, parkingObject.Requestee__r.Email__c); 
                       if(employeedelegatemap.get(parkingObject.Requestee__c)!=null){
                        emailCCMap2.put(parkingObject.Id, string.join(employeedelegatemap.get(parkingObject.Requestee__c),',  '));
                       }
                       else emailCCMap2.put(parkingObject.Id,null); 
                       parkingLotMap2.put(parkingObject.Id, parkingObject.Id); 
                    }   
                }
                
                if(parkingObject.type__c == 'Cancellation') {
                    if(parkingObject.status__c == 'New' && parkingObject.expectant_mother__c == false){
                       emailToAddressMap3.put(parkingObject.Id, parkingObject.Requestee__r.Email__c); 
                       if(employeedelegatemap.get(parkingObject.Requestee__c)!=null){
                        emailCCMap3.put(parkingObject.Id, string.join(employeedelegatemap.get(parkingObject.Requestee__c),',  '));
                       }
                       else emailCCMap3.put(parkingObject.Id,null); 
                       parkingLotMap3.put(parkingObject.Id, parkingObject.Id); 
                    }
                }
                
                
                
                if(parkingObject.type__c == 'Replacement Pass') {
                    if(parkingObject.status__c == 'New'){
                        emailToAddressMap5.put(parkingObject.Id, parkingObject.Requestee__r.Email__c); 
                       if(employeedelegatemap.get(parkingObject.Requestee__c)!=null){
                        emailCCMap5.put(parkingObject.Id, string.join(employeedelegatemap.get(parkingObject.Requestee__c),',  '));
                       }
                       else emailCCMap5.put(parkingObject.Id,null); 
                       parkingLotMap5.put(parkingObject.Id, parkingObject.Id); 
                    }
                }
                
                if(parkingObject.type__c == 'Overnight Parking' || parkingObject.type__c == 'Weekend Parking') {
                    if(parkingObject.status__c == 'New'){
                       emailToAddressMap6.put(parkingObject.Id, parkingObject.Requestee__r.Email__c); 
                       if(employeedelegatemap.get(parkingObject.Requestee__c)!=null){
                        emailCCMap6.put(parkingObject.Id, string.join(employeedelegatemap.get(parkingObject.Requestee__c),',  '));
                       }
                       else emailCCMap6.put(parkingObject.Id,null); 
                       parkingLotMap6.put(parkingObject.Id, parkingObject.Id); 
                    }
                }
                
                
            
            }
            
            System.debug('**************Email Addresses Map*********'+emailToAddressMap1);
            
            System.debug('**************Parking Request Map*********'+parkingLotMap1);
            System.debug('**************Parking Request Map Size *********'+parkingLotMap1.size());
            
            If(parkingLotMap1.size()>0){
                GP_SendEmail.sendEmail(templateId1.id,emailToAddressMap1,parkingLotMap1 );
            }
            If(parkingLotMap2.size()>0){
                GP_SendEmail.sendEmail(templateId3.id,emailToAddressMap2,emailCCMap2,parkingLotMap2 );  
            }
            If(parkingLotMap3.size() > 0){
                GP_SendEmail.sendEmail(templateId3.id,emailToAddressMap3,emailCCMap3,parkingLotMap3 );  
            }
           
            If(parkingLotMap5.size() > 0){
                GP_SendEmail.sendEmail(templateId9.id,emailToAddressMap5,emailCCMap5,parkingLotMap5 );  
            }
            If(parkingLotMap6.size() > 0){
                GP_SendEmail.sendEmail(templateId11.id,emailToAddressMap6,emailCCMap6,parkingLotMap6 ); 
            }
            
            
        }   
            
       /**************************Method for Update operations on Parking Lot Request object********************/  
        
        public static void SendMailforUpdate(List <Parking_Lot_Request__c> parkingrequestList ,Map<ID, Parking_Lot_Request__c> triggermap, Map<ID, Parking_Lot_Request__c> triggeroldmap ){
         
         
            EmailTemplate templateId2 = [Select id from EmailTemplate where developerName = 'GP_Email_2_Space_Assigned'];
            EmailTemplate templateId4 = [Select id from EmailTemplate where developerName = 'GP_Email_4_Termination_Complete'];
            EmailTemplate templateId4b = [Select id from EmailTemplate where developerName = 'GP_Email_4B_Cancellation_Rejected'];
            EmailTemplate templateId10 = [Select id from EmailTemplate where developerName = 'GP_Email_10_Replacement_Req_Processed'];
            EmailTemplate templateId12 = [Select id from EmailTemplate where developerName = 'GP_Email_12_Overnight_Request_Processed'];
            EmailTemplate templateId17 = [Select id from EmailTemplate where developerName ='GP_Email_17_Request_Deleted'];
            EmailTemplate templateId18 = [Select id from EmailTemplate where developerName ='GP_Email_18_Expecting_Mother'];
            
            //Added For Jira GLBPARKING-343 on 15/02/17 by Mayur
            EmailTemplate templateId19 = [Select id from EmailTemplate where developerName = 'GP_Email_19_Overnight_Request_Rejected'];
            
             Map<Id,String> emailToAddressMap1 = new Map<Id,String>();
             Map<Id,String> emailCCMap1 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap1 = new Map<Id,Id>();
            
             Map<Id,String> emailToAddressMap2 = new Map<Id,String>();
             Map<Id,String> emailCCMap2 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap2 = new Map<Id,Id>();
            
             Map<Id,String> emailToAddressMap3 = new Map<Id,String>();
             Map<Id,String> emailCCMap3 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap3 = new Map<Id,Id>();
             
             Map<Id,String> emailToAddressMap4 = new Map<Id,String>();
             Map<Id,String> emailCCMap4 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap4 = new Map<Id,Id>();
             
             Map<Id,String> emailToAddressMap5 = new Map<Id,String>();
             Map<Id,String> emailCCMap5 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap5 = new Map<Id,Id>();
             
             Map<Id,String> emailToAddressMap6 = new Map<Id,String>();
             Map<Id,String> emailCCMap6 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap6 = new Map<Id,ID>();
             
             Map<Id,String> emailToAddressMap7 = new Map<Id,String>();
             Map<Id,String> emailCCMap7 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap7 = new Map<Id,ID>();
             
              Map<Id,String> emailToAddressMap8 = new Map<Id,String>();
             Map<Id,String> emailCCMap8 = new Map<Id,String>();
             Map<Id,ID> parkingLotMap8 = new Map<Id,ID>();
            
             //Added For Jira GLBPARKING-343 on 15/02/17 by Mayur - Starts
             Map<Id,String> emailToAddressMap9 = new Map<Id,String>();
             Map<Id,String> emailCCMap9 = new Map<Id,String>();
             Map<Id,Id> parkingLotMap9 = new Map<Id,Id>();
             //Added For Jira GLBPARKING-343 on 15/02/17 by Mayur - Ends
             
            List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Expectant_Mother_Email__c,Requestee__r.Email__c,type__c,status__c,Expectant_Mother__c,Actual_Cancellation_Date__c  from Parking_Lot_Request__c 
            where id in: triggermap.keyset()];
            SET<ID> requestee = new SET<ID>();
            for(Parking_Lot_Request__c obj : parkingcompletelist){
                requestee.add(obj.Requestee__c);
            }
            System.debug('***********************requestee******************'+requestee);
            List<Employee_Delegate__c> empDelegates = [Select 
                                  Delegate__c
                                 ,employee__c
                                 ,delegate__r.email__c
                                 From Employee_Delegate__c 
                                 where application__c = 'Global Parking'
                                 and status__c = 'Approved'
                                 and employee__c in :requestee
                                 ];
             Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
            for(Employee_Delegate__c d:empDelegates){
                
                if(employeedelegatemap.isEmpty()){
                    employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                    
                }
                else{
                    if(employeedelegatemap.containskey(d.employee__c)){
                        employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                    }
                    else{
                        employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                    }
                }
            }
            System.debug('***********************employeedelegatemap******************'+employeedelegatemap);    
                for(Parking_Lot_Request__c parkingObj :parkingcompletelist){
                    
                    if(parkingObj.type__c == 'Parking Space') {
                        if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Assigned' ) {
                                emailToAddressMap1.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap1.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap1.put(parkingObj.Id,null);
                                parkingLotMap1.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    
                    if(parkingObj.type__c == 'Parking Space') {
                        if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Pending Assignment' ) {
                                emailToAddressMap8.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap8.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap8.put(parkingObj.Id,null);
                                parkingLotMap8.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    
                   
                   
                    if(parkingObj.type__c == 'Parking Space') {
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Cancelled' && triggeroldmap.get(parkingObj.id).status__c != 'Pending Cancellation') {
                                emailToAddressMap6.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap6.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap6.put(parkingObj.Id,null);
                                parkingLotMap6.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    
                    if(parkingObj.type__c == 'Cancellation'){
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Complete') {
                                emailToAddressMap2.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap2.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap2.put(parkingObj.Id,null); 
                                parkingLotMap2.put(parkingObj.Id, parkingObj.Id);      
                            }
                         }   
                    }
                    
                    if(parkingObj.type__c == 'Cancellation'){
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Rejected') {
                                emailToAddressMap5.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap5.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap5.put(parkingObj.Id,null); 
                                parkingLotMap5.put(parkingObj.Id, parkingObj.Id);      
                            }
                         }   
                    }
                    
                    if(parkingObj.type__c == 'Replacement Pass'){
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Assigned') {
                                emailToAddressMap3.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap3.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap3.put(parkingObj.Id,null); 
                                parkingLotMap3.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    
                    if(parkingObj.type__c == 'Overnight Parking' || parkingObj.type__c == 'Weekend Parking'){
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Confirmed') {
                                emailToAddressMap4.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap4.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap4.put(parkingObj.Id,null); 
                                parkingLotMap4.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    //Added For Jira GLBPARKING-343 on 15/02/17 by Mayur - Starts
                     if(parkingObj.type__c == 'Overnight Parking' || parkingObj.type__c == 'Weekend Parking'){
                         if (triggermap.get(parkingObj.id).status__c != triggeroldmap.get(parkingObj.id).status__c ){
                            if(parkingObj.status__c == 'Rejected') {
                                emailToAddressMap9.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                                if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap9.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                                }
                                else emailCCMap9.put(parkingObj.Id,null); 
                                parkingLotMap9.put(parkingObj.Id, parkingObj.Id);    
                            }
                        }    
                    }
                    //Added For Jira GLBPARKING-343 on 15/02/17 by Mayur - Ends
                    
                    System.debug('**************Expectant Mother****'+parkingObj.Expectant_Mother__c);
                    if(parkingObj.Expectant_Mother__c == True){
                    
                    System.debug('**************Actual_Cancellation_Date__c Before Update****'+triggeroldmap.get(parkingObj.id).Actual_Cancellation_Date__c);
                    System.debug('**************Actual_Cancellation_Date__c After Update****'+triggermap.get(parkingObj.id).Actual_Cancellation_Date__c);
                    //Commented below line and added next line for Jira GLBPARKING-353 by Mayur 3rd April
                        //if (triggermap.get(parkingObj.id).Actual_Cancellation_Date__c != triggeroldmap.get(parkingObj.id).Actual_Cancellation_Date__c){
                         if(triggermap.get(parkingObj.id).Expectant_Mother_Email__c != triggeroldmap.get(parkingObj.id).Expectant_Mother_Email__c){
                            emailToAddressMap7.put(parkingObj.Id, parkingObj.Requestee__r.Email__c); 
                            if(employeedelegatemap.get(parkingObj.Requestee__c)!=null){
                                emailCCMap7.put(parkingObj.Id, string.join(employeedelegatemap.get(parkingObj.Requestee__c),',  '));
                            }
                            else emailCCMap7.put(parkingObj.Id,null); 
                            parkingLotMap7.put(parkingObj.Id, parkingObj.Id);    
                        }
                    }
                        
            
        }
                
                If(parkingLotMap1.size() > 0){
                    GP_SendEmail.sendEmail(templateId2.id,emailToAddressMap1,emailCCMap1,parkingLotMap1);
                }
                If(parkingLotMap2.size() > 0){
                    GP_SendEmail.sendEmail(templateId4.id,emailToAddressMap2,emailCCMap2,parkingLotMap2);
                }
                If(parkingLotMap3.size() > 0){
                    GP_SendEmail.sendEmail(templateId10.id,emailToAddressMap3,emailCCMap3,parkingLotMap3);
                }
                If(parkingLotMap4.size() > 0){
                    GP_SendEmail.sendEmail(templateId12.id,emailToAddressMap4,emailCCMap4,parkingLotMap4);
                }
            	//Added For Jira GLBPARKING-343 on 15/02/17 by Mayur
             	If(parkingLotMap9.size() > 0){
                    GP_SendEmail.sendEmail(templateId19.id,emailToAddressMap9,emailCCMap9,parkingLotMap9);
                }
            
                If(parkingLotMap5.size() > 0){
                    GP_SendEmail.sendEmail(templateId4b.id,emailToAddressMap5,emailCCMap5,parkingLotMap5);
                }
                If(parkingLotMap6.size() > 0 && parkingLotMap2.size() == 0){
                    GP_SendEmail.sendEmail(templateId17.id,emailToAddressMap6,emailCCMap6,parkingLotMap6);
                }
                If(parkingLotMap7.size() > 0){
                    GP_SendEmail.sendEmail(templateId18.id,emailToAddressMap7,emailCCMap7,parkingLotMap7);
                }
                If(parkingLotMap8.size() > 0){  //pending assignment
                    GP_SendEmail.sendEmail(templateId2.id,emailToAddressMap8,emailCCMap8,parkingLotMap8);
                }
        }
        
         /**************************Method for Update operations on Employee Vehicle object********************/  
   
   
        public static void mailforvehicle(List <Employee_Vehicle__c> updatedvehicle , Map<ID, Employee_Vehicle__c> triggernewmap , Map<ID, Employee_Vehicle__c> triggeroldmap ){
            SET<ID> changednumber = new SET<ID>();
            system.debug('********************Inside Mail For Vehicle Method************************');
            for (Employee_Vehicle__c v:triggernewmap.values()){
                if (triggernewmap.get(v.id).registration_number__c != triggeroldmap.get(v.id).registration_number__c){
                    changednumber.add(v.id);
                    
                }
                  
            }
            System.debug('*******************Registration Change***** '+changednumber);
            
            if(!changednumber.isEmpty()) {
                system.debug('********************Inside Result************************');
                EmailTemplate templateId16 = [Select id from EmailTemplate where developerName = 'GP_Email_16_Vehicle_Registn_Tracking'];
                
                List<String> LondonEmailAddresses = new List<String>();
                List<String> londonList = new List<String>();
                Group london = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE developername = 'Global_Parking_London'];
                  for (GroupMember gm : london.groupMembers) 
                  {
                   londonList.add(gm.userOrGroupId);
                  }
                  User[] londonusr = [SELECT email FROM user WHERE id IN :londonList];
                  for(User u : londonusr ) 
                  {
                  LondonEmailAddresses.add(u.email);
                  } 
                  if (test.isRunningTest()){
                    LondonEmailAddresses.add('test@test.com');
                  }
                system.debug('********************London Users Email Addresses************************'+LondonEmailAddresses);
                
                
                List<String> TokyoEmailAddresses = new List<String>();
                List<String> tokyoList = new List<String>();
                Group tokyo = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE developername = 'Global_Parking_Tokyo'];
                  for (GroupMember gm : tokyo.groupMembers) 
                  {
                   tokyoList.add(gm.userOrGroupId);
                  }
                  
                  User[] tokyousr = [SELECT email FROM user WHERE id IN :tokyoList];
                  for(User u : tokyousr) 
                  {
                  TokyoEmailAddresses.add(u.email);
                  } 
                  if (test.isRunningTest()){
                    TokyoEmailAddresses.add('test@test.com');
                  }
                  
                String LondonEmailAddress = string.join(LondonEmailAddresses,',');  
                String TokyoEmailAddress =  string.join(TokyoEmailAddresses,',');  
                
                
                
                system.debug('********************London Users Email Addresse String************************'+LondonEmailAddress);
                system.debug('********************Tokyo Users Email Addresse String************************'+TokyoEmailAddress);
                
                
                
                system.debug('********************Tokyo Users Email Addresses************************'+TokyoEmailAddresses);
                
                                
                List<Parking_Lot_Request_Vehicles__c> assignmentList = new List<Parking_Lot_Request_Vehicles__c>([Select 
                                  Employee_Vehicle__c,Employee_Vehicle_Color__c,Employee_Vehicle_Make_Model__c,Employee_Vehicle_Registration__c,
                                  Parking_Lot_Request__c,Parking_Lot_Request__r.status__c,Parking_Lot_Request__r.type__c,
                                  Parking_Lot_Request__r.Parking_Lot_Region__r.Name From 
                                  Parking_Lot_Request_Vehicles__c 
                                  where employee_vehicle__c in :changednumber
                                and  Parking_Lot_Request__r.status__c = 'Assigned'
                                and  Parking_Lot_Request__r.type__c = 'Parking Space'
                                and  Parking_Lot_Request__c <> null]);
                                
                Map<ID,ID> Parkingrequestmaplondon = new Map<ID,ID>();
                Map<ID,ID> Parkingrequesttokyo = new Map<ID,ID>();
                Map<ID,String> EmailToAddressesmaplondon = new Map<ID,String>();
                Map<ID,String> EmailToAddressesmaptokyo = new Map<ID,String>();
                
                
                for(Parking_Lot_Request_Vehicles__c assignmentvehicle: assignmentList){
                    if(assignmentvehicle.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'London'){
                        Parkingrequestmaplondon.put(assignmentvehicle.Employee_Vehicle__c,assignmentvehicle.Parking_Lot_Request__c);
                        EmailToAddressesmaplondon.put(assignmentvehicle.Employee_Vehicle__c,LondonEmailAddress); 
                        system.debug('********************Parkingrequestmaplondon************************'+Parkingrequestmaplondon);
                        system.debug('********************EmailToAddressesmaplondon************************'+EmailToAddressesmaplondon);    
                    }   
                    if(assignmentvehicle.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'Tokyo'){
                        Parkingrequesttokyo.put(assignmentvehicle.Employee_Vehicle__c,assignmentvehicle.Parking_Lot_Request__c);
                        EmailToAddressesmaptokyo.put(assignmentvehicle.Employee_Vehicle__c,TokyoEmailAddress); 
                    }   
                    
                }                      
                
                
                
                
                    if(!(Parkingrequestmaplondon == null || Parkingrequestmaplondon.isEmpty())){
                        system.debug('********************Inside X, Location is london*****************************');
                        GP_SendEmail.sendEmail(templateId16.id,EmailToAddressesmaplondon,Parkingrequestmaplondon);
                    }
                    if(!(Parkingrequesttokyo == null || Parkingrequesttokyo.isEmpty())){
                        system.debug('********************Inside Y, Location is Tokyo******************************');
                        GP_SendEmail.sendEmail(templateId16.id,EmailToAddressesmaptokyo,Parkingrequesttokyo);
                    }
                   
            }
                    system.debug('******************************Inside mailforvehicle for General Updates******************');
                    EmailTemplate templateId5 = [Select id from EmailTemplate where developerName = 'GP_Email_5_Vehicle_Details_Updated'];
                    
                    SET<ID> updatedvehicleids = new SET<ID>();
                    
                    for(Employee_Vehicle__c vehicle: updatedvehicle){
                        updatedvehicleids.add(vehicle.id);
                    }
                    
                    System.debug('***********Updated Vehicle ID**********'+updatedvehicleids);
                
                    
                    Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
                    Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
                    Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
                    
                  
                    
                    List<Parking_Lot_Request_Vehicles__c> assignmentList = new List<Parking_Lot_Request_Vehicles__c>([Select 
                                  Employee_Vehicle__c,Employee_Vehicle_Color__c,Employee_Vehicle_Make_Model__c,Employee_Vehicle_Registration__c,
                                  Parking_Lot_Request__c,Parking_Lot_Request__r.status__c,Parking_Lot_Request__r.type__c,
                                  Parking_Lot_Request__r.Parking_Lot_Region__r.Name,Employee_Vehicle__r.Employee__r.Email__c,
                                  Parking_Lot_Request__r.Requestee__c
                                  From Parking_Lot_Request_Vehicles__c 
                                  where employee_vehicle__c in :updatedvehicleids
                                and  Parking_Lot_Request__r.status__c = 'Assigned'
                                and  Parking_Lot_Request__r.type__c = 'Parking Space'
                                and  Parking_Lot_Request__c <> null]); 
                    SET<ID> parkingrecords = new SET<ID>();
                    for(Parking_Lot_Request_Vehicles__c obj :assignmentList){
                        parkingrecords.add(obj.Parking_Lot_Request__c);
                    }

                    List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: parkingrecords];
                    SET<ID> requestee = new SET<ID>();
                    for(Parking_Lot_Request__c obj : parkingcompletelist){
                        requestee.add(obj.Requestee__c);
                    }
                    System.debug('***********************requestee******************'+requestee);
                    List<Employee_Delegate__c> empDelegates = [Select 
                                          Delegate__c
                                         ,employee__c
                                         ,delegate__r.email__c
                                         From Employee_Delegate__c 
                                         where application__c = 'Global Parking'
                                         and status__c = 'Approved'
                                         and employee__c in :requestee
                                         ];
                     Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
                    for(Employee_Delegate__c d:empDelegates){
                        
                        if(employeedelegatemap.isEmpty()){
                            employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                            
                        }
                        else{
                            if(employeedelegatemap.containskey(d.employee__c)){
                                employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                            }
                            else{
                                employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                            }
                        }
                    }
                    System.debug('***********************employeedelegatemap******************'+employeedelegatemap);                   
                    
                    for(Parking_Lot_Request_Vehicles__c assignmentvehicle: assignmentList){
                        Parkingrequestmap.put(assignmentvehicle.Employee_Vehicle__c,assignmentvehicle.Parking_Lot_Request__c);
                        EmailToAddressesmap.put(assignmentvehicle.Employee_Vehicle__c,assignmentvehicle.Employee_Vehicle__r.Employee__r.Email__c );
                        if(employeedelegatemap.get(assignmentvehicle.Parking_Lot_Request__r.Requestee__c)!=null){
                            EmailCCAddressesmap.put(assignmentvehicle.Employee_Vehicle__c,string.join(employeedelegatemap.get(assignmentvehicle.Parking_Lot_Request__r.Requestee__c),',  '));
                            }
                        else EmailCCAddressesmap.put(assignmentvehicle.Employee_Vehicle__c,null); 
                        
                        
                    }
                    
                    for(ID key :Parkingrequestmap.values()){
                    System.debug('***********Parking Request ID**********'+key);
                    }
                    for(String key :EmailToAddressesmap.values()){
                        System.debug('***********Email To Addresses**********'+key);
                    }
                    for(String key :EmailCCAddressesmap.values()){
                        System.debug('***********Email CC Addresses**********'+key);
                    }
                    
                    GP_SendEmail.sendEmail(templateId5.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
            
    }
    
    
/****** Mail for adding vehicles to a Parking Pass***********/    
    
    public static void mailforvehicleaddition(SET<ID> newvehicles){
            
            Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
            Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
            Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
            system.debug('********************Inside Mail For Added Vehicle Method************************');
            EmailTemplate templateId5 = [Select id from EmailTemplate where developerName = 'GP_Email_5_Vehicle_Details_Updated'];
            System.debug('*************************newvehicles***********'+newvehicles);
            List<Parking_Lot_Request_Vehicles__c> addedvehicleslist  = new List<Parking_Lot_Request_Vehicles__c>([Select 
                                  Employee_Vehicle__c,Employee_Vehicle_Color__c,Employee_Vehicle_Make_Model__c,Employee_Vehicle_Registration__c,
                                  Parking_Lot_Request__c,Parking_Lot_Request__r.status__c,Parking_Lot_Request__r.type__c,
                                  Parking_Lot_Request__r.Parking_Lot_Region__r.Name,Employee_Vehicle__r.Employee__r.Email__c,
                                  Parking_Lot_Request__r.Requestee__c
                                  From Parking_Lot_Request_Vehicles__c 
                                  where Employee_Vehicle__c in :newvehicles
                                //and  Parking_Lot_Request__c in :parkingrequests  
                                and  Parking_Lot_Request__r.status__c = 'Assigned'
                                and  Parking_Lot_Request__r.type__c = 'Parking Space'
                                and  Parking_Lot_Request__c <> null]); 
            
            SET<ID> parkingrecords = new SET<ID>();
                    for(Parking_Lot_Request_Vehicles__c obj :addedvehicleslist){
                        parkingrecords.add(obj.Parking_Lot_Request__c);
                    }

                    List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: parkingrecords];
                    SET<ID> requestee = new SET<ID>();
                    for(Parking_Lot_Request__c obj : parkingcompletelist){
                        requestee.add(obj.Requestee__c);
                    }
                    System.debug('***********************requestee******************'+requestee);
                    List<Employee_Delegate__c> empDelegates = [Select 
                                          Delegate__c
                                         ,employee__c
                                         ,delegate__r.email__c
                                         From Employee_Delegate__c 
                                         where application__c = 'Global Parking'
                                         and status__c = 'Approved'
                                         and employee__c in :requestee
                                         ];
                     Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
                    for(Employee_Delegate__c d:empDelegates){
                        
                        if(employeedelegatemap.isEmpty()){
                            employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                            
                        }
                        else{
                            if(employeedelegatemap.containskey(d.employee__c)){
                                employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                            }
                            else{
                                employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                            }
                        }
                    }
                    System.debug('***********************employeedelegatemap******************'+employeedelegatemap); 
            
            
            
            for(Parking_Lot_Request_Vehicles__c assignmentvehicle: addedvehicleslist){
                Parkingrequestmap.put(assignmentvehicle.id,assignmentvehicle.Parking_Lot_Request__c);
                EmailToAddressesmap.put(assignmentvehicle.id,assignmentvehicle.Employee_Vehicle__r.Employee__r.Email__c );
                if(employeedelegatemap.get(assignmentvehicle.Parking_Lot_Request__r.Requestee__c)!=null){
                    EmailCCAddressesmap.put(assignmentvehicle.id,string.join(employeedelegatemap.get(assignmentvehicle.Parking_Lot_Request__r.Requestee__c),',  '));
                }
                else EmailCCAddressesmap.put(assignmentvehicle.id,null); 

                
                    
            }                      
                
                
            System.debug('**************Email Addresses Map*********'+EmailToAddressesmap);
            System.debug('**************Email CCAddresses Map*********'+EmailCCAddressesmap);
            System.debug('**************Parking Request Map*********'+Parkingrequestmap);
            System.debug('**************Size of Parkingrequestmap *********'+Parkingrequestmap.size());
            
            if(Parkingrequestmap.size()>0){        
                GP_SendEmail.sendEmail(templateId5.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
            }
    }
    
    
    
    
               
                 
            
     /**************************Method for Update operations on Parking Invoice object********************/     
        
        public static void mailforparkingcharges(List<Parking_Lot_Assignment_Fees_Due__c>  assignmentfeeslist , Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermap , Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermapold){
    
            EmailTemplate templateId6 = [Select id from EmailTemplate where developerName = 'GP_Email_6_Charges_Available_for_Review'];
        
            SET<ID> Assignmentfeesrecords = new SET<ID>();
            
            for(Parking_Lot_Assignment_Fees_Due__c assignmentfees :assignmentfeeslist){
                system.debug('assignment fees status:'  + assignmentfees.status__c);
                system.debug('Conductor Sent :'  + assignmentfees.Conductor_Sent__c);
                system.debug('triggermap.get(assignmentfees.id).Conductor_Sent__c'  + triggermap.get(assignmentfees.id).Conductor_Sent__c);
                system.debug('triggermapold.get(assignmentfees.id).Conductor_Sent__c'  + triggermapold.get(assignmentfees.id).Conductor_Sent__c);
                
                if(triggermap.get(assignmentfees.id).Conductor_Sent__c != triggermapold.get(assignmentfees.id).Conductor_Sent__c){
                    if(assignmentfees.Conductor_Sent__c == true && (assignmentfees.status__c == null || assignmentfees.status__c == 'Invoiced')){
                        if (assignmentfees.method_of_payment__c != 'No Charge')
                            Assignmentfeesrecords.add(assignmentfees.id);           
                    }
                }   
            }
            System.debug('******************* Assignment Fees Records**************'+Assignmentfeesrecords);
            System.debug('******************* Assignment Fees Record Size**************'+Assignmentfeesrecords.size());
            
            if(Assignmentfeesrecords.size()>0){
                List<Parking_Lot_Assignment_Fees_Due__c> parkingbillingsummarylist = [SELECT id,Employee__c,Employee__r.Global_Parking_Level__c ,
                    Parking_Invoice_Run__c,Parking_Invoice_Run__r.Send_Email_TO__c,  Employee__r.Email__c ,
                    Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c, Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name,Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Method_of_Payment__c,
                    Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c FROM Parking_Lot_Assignment_Fees_Due__c WHERE Id IN:  Assignmentfeesrecords] ;   
                
                Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
                Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
                Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
                
                SET<ID> parkingrecords = new SET<ID>();
                    for(Parking_Lot_Assignment_Fees_Due__c obj :parkingbillingsummarylist){
                    System.debug('***********************Parking Location******************'+obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name);
                        if(!(obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'Budapest')){
                            
                            parkingrecords.add(obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                        }
                        else{
                            if((obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'Budapest')&& (obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Method_of_Payment__c == 'Consumption')){
                                System.debug('****************Inside Budapest & Monthly consumption****************************'); 
                                 parkingrecords.add(obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                            }
                        }
                       
                    }

                    List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Parking_Lot_Region__r.Name,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: parkingrecords];
                    SET<ID> requestee = new SET<ID>();
                    for(Parking_Lot_Request__c obj : parkingcompletelist){
                        requestee.add(obj.Requestee__c);
                    }
                    System.debug('***********************requestee******************'+requestee);
                    List<Employee_Delegate__c> empDelegates = [Select 
                                          Delegate__c
                                         ,employee__c
                                         ,delegate__r.email__c
                                         From Employee_Delegate__c 
                                         where application__c = 'Global Parking'
                                         and status__c = 'Approved'
                                         and employee__c in :requestee
                                         ];
                     Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
                    for(Employee_Delegate__c d:empDelegates){
                        
                        if(employeedelegatemap.isEmpty()){
                            employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                            
                        }
                        else{
                            if(employeedelegatemap.containskey(d.employee__c)){
                                employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                            }
                            else{
                                employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                            }
                        }
                    }
                    System.debug('***********************employeedelegatemap******************'+employeedelegatemap); 
                
                for(Parking_Lot_Assignment_Fees_Due__c parkingbillingbatchobj : parkingbillingsummarylist) {
                    if (parkingbillingbatchobj.Parking_Invoice_Run__r.Send_Email_TO__c == null)
                        break;
                        
                    String[] joblevel = parkingbillingbatchobj.Parking_Invoice_Run__r.Send_Email_TO__c.split(';');
                    
                    System.debug('***************************************************Job Level************'+joblevel);
                    set<string> gprole=new Set<string>{parkingbillingbatchobj.Employee__r.Global_Parking_Level__c};
                    
                    System.debug('********mrm************************** Global Parking Level*****************'+gprole);
                        
                        for(String s: joblevel){
                        	system.debug('job levels: ' + joblevel);
                            if(gprole.contains(s)){
                            	system.debug('found role');
                                if(!(parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'Budapest') || ((parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Parking_Lot_Region__r.Name == 'Budapest')&& (parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Method_of_Payment__c == 'Consumption'))){
                                    Parkingrequestmap.put(parkingbillingbatchobj.id,parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                                    EmailToAddressesmap.put(parkingbillingbatchobj.id,parkingbillingbatchobj.Employee__r.Email__c);
                                
                                    if(employeedelegatemap.get(parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c)!=null){
                                        EmailCCAddressesmap.put(parkingbillingbatchobj.id,string.join(employeedelegatemap.get(parkingbillingbatchobj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c),',  '));
                                    }
                                    else EmailCCAddressesmap.put(parkingbillingbatchobj.id,null); 
                                }

                            }
                            else{ system.debug('role not found');}
                        }
                            
                            
                }
                /*Map<ID,Attachment> Attachmentmap = new Map<ID,Attachment>([SELECT id,(SELECT Id,body,Name FROM Attachment) from Parking_Lot_Assignment_Fees_Due__c where id in :Parkingrequestmap.keyset()]);*/
               /* Map<ID,Attachment> Attachmentmap = new Map<ID,Attachment>();
                for(Attachment objCS : [Select Name,parentid, Id,body From Attachment where parentid in :Parkingrequestmap.keyset()]){

                    Attachmentmap.put(objCS.parentid, objCS);
                }*/

                for(ID key :Parkingrequestmap.values()){
                    System.debug('***********Parking Request ID**********'+key);
                }
                if(!(Parkingrequestmap == null || Parkingrequestmap.isEmpty())){
                    GP_SendEmail.sendEmailForInvoiceAndDispute(templateId6.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
                }
                
            }   
        }       
          
        
/**************************Method for  Sending Mails for Parking Dispute Submitted********************/    
        
        public static void mailforparkingDispute (List<Parking_Lot_Space_Assignment_Time_Used__c>  disputechargeslist , Map<ID, Parking_Lot_Space_Assignment_Time_Used__c> disputenewmap ,Map<ID, Parking_Lot_Space_Assignment_Time_Used__c> disputeoldmap){
            
            System.debug('********Inside mailforparkingDisputesubmitted*********');
            EmailTemplate templateId7 = [Select id from EmailTemplate where developerName = 'GP_Email_7_Monthly_Dispute_Submitted'];
            
            
            SET<ID> disputedrecord = new SET<ID>();
            SET<ID> resolvedrecords = new SET<ID>();
            System.debug('********lIST OF rECORDS DISPUTED*********'+disputechargeslist);
            system.debug('map:' + disputenewmap.values());
            for (Parking_Lot_Space_Assignment_Time_Used__c disputecharges: disputenewmap.values()){
            	system.debug('new:' + disputenewmap.get(disputecharges.id).Disputed__c);
            	system.debug('old:' + disputeoldmap.get(disputecharges.id).Disputed__c);
            	
                if (disputenewmap.get(disputecharges.id).Disputed__c != disputeoldmap.get(disputecharges.id).Disputed__c){
                    if(disputecharges.Disputed__c == true){
                        disputedrecord.add(disputecharges.id);  
                    }   
                }
                    
            }
            System.debug('******** Disputed Records where disputed= true *********'+disputedrecord); 
            
            if(disputedrecord.size()>0){
                
                System.debug('********Inside Disputed Records*********');
                Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
                Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
                Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
                
                List<Parking_Lot_Space_Assignment_Time_Used__c>  disputelist = new List<Parking_Lot_Space_Assignment_Time_Used__c>([SELECT plr.id, 
                    plr.Disputed__c , plr.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c, plr.Invoice__r.Employee__c,plr.Invoice__r.Employee__r.Email__c,plr.Invoice__r.Conductor_Sent__c,
                    plr.Resolved__c, plr.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c , plr.Parking_Lot_Space_Assignment__r.Employee__c , plr.Parking_Lot_Space_Assignment__r.Employee__r.Email__c 
                    from Parking_Lot_Space_Assignment_Time_Used__c plr 
                    WHERE ID IN :disputedrecord]);  
                    
                SET<ID> parkingrecords = new SET<ID>();
                    for(Parking_Lot_Space_Assignment_Time_Used__c obj :disputelist){
                        if(obj.Invoice__r.Conductor_Sent__c == true){
                            parkingrecords.add(obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                        }
                    }

                    List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: parkingrecords];
                    SET<ID> requestee = new SET<ID>();
                    for(Parking_Lot_Request__c obj : parkingcompletelist){
                        requestee.add(obj.Requestee__c);
                    }
                    System.debug('***********************requestee******************'+requestee);
                    List<Employee_Delegate__c> empDelegates = [Select 
                                          Delegate__c
                                         ,employee__c
                                         ,delegate__r.email__c
                                         From Employee_Delegate__c 
                                         where application__c = 'Global Parking'
                                         and status__c = 'Approved'
                                         and employee__c in :requestee
                                         ];
                     Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
                    for(Employee_Delegate__c d:empDelegates){
                        
                        if(employeedelegatemap.isEmpty()){
                            employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                            
                        }
                        else{
                            if(employeedelegatemap.containskey(d.employee__c)){
                                employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                            }
                            else{
                                employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                            }
                        }
                    }
                    System.debug('***********************employeedelegatemap******************'+employeedelegatemap);   
                
                
                
                for(Parking_Lot_Space_Assignment_Time_Used__c disputecharges: disputelist ){
                	system.debug('**************************************** in this loop' +  disputecharges.Invoice__r.Conductor_Sent__c);
                    if(disputecharges.Invoice__r.Conductor_Sent__c == true){
                        Parkingrequestmap.put(disputecharges.id,disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                        EmailToAddressesmap.put(disputecharges.id,disputecharges.Invoice__r.Employee__r.Email__c);
                        if(employeedelegatemap.get(disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c)!=null){
                            EmailCCAddressesmap.put(disputecharges.id,string.join(employeedelegatemap.get(disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c),',  '));
                        }
                        else EmailCCAddressesmap.put(disputecharges.id,null); 
                    }   
                    

                }
                for(ID key :Parkingrequestmap.values()){
                    System.debug('***********Parking Request ID**********'+key);
                }
                if(!(Parkingrequestmap == null || Parkingrequestmap.isEmpty())){
                    GP_SendEmail.sendEmailForInvoiceAndDispute(templateId7.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
                }
                
            }   
              
            
            
                 
        }
        /*********************Mail for Parking Dispute Processed******************/
        public static void mailforparkingDisputeprocessed (List<Parking_Lot_Assignment_Fees_Due__c>  disputechargeslist , Map<ID, Parking_Lot_Assignment_Fees_Due__c> disputenewmap ,Map<ID, Parking_Lot_Assignment_Fees_Due__c> disputeoldmap){
            
            System.debug('********Inside mailforparkingDisputeProcessed*********');
            
            EmailTemplate templateId8 = [Select id from EmailTemplate where developerName = 'GP_Email_8_Monthly_Dispute_Processed'];
            
           
            SET<ID> resolvedrecords = new SET<ID>();
            System.debug('********lIST OF rECORDS to be processed*********'+disputechargeslist);
            
                
            for (Parking_Lot_Assignment_Fees_Due__c disputecharges: disputenewmap.values()){
                System.debug('*****************Value of Status  before Update ********'+disputeoldmap.get(disputecharges.id).Status__c);
                System.debug('*****************Value of Status afterUpdate ********'+disputenewmap.get(disputecharges.id).Status__c);
                System.debug('*****************Value of Conductor Sent before Update ********'+disputeoldmap.get(disputecharges.id).Conductor_Sent__c);
                System.debug('*****************Value of Conductor Sent after Update ********'+disputenewmap.get(disputecharges.id).Conductor_Sent__c);
                system.debug('**** right here ******');
                if(disputenewmap.get(disputecharges.id).Conductor_Sent__c != disputeoldmap.get(disputecharges.id).Conductor_Sent__c){
                    if (disputecharges.Conductor_Sent__c == true && disputecharges.Status__c == 'Revised Invoice'){
                        
                        resolvedrecords.add(disputecharges.id);  
                         
                    }
                }    
            }
            System.debug('******** Disputed Records where Conductor Sent = true && Status = Revised Invoice*********'+resolvedrecords);
            
            
            if(resolvedrecords.size()>0){
            
                System.debug('********Inside Resolved Records*********');       
                
                List<Parking_Lot_Assignment_Fees_Due__c>  disputelist = new List<Parking_Lot_Assignment_Fees_Due__c>([SELECT plr.id, 
                    plr.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c, plr.Employee__c, plr.Employee__r.Email__c,plr.Conductor_Sent__c,
                    plr.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c  

                    from Parking_Lot_Assignment_Fees_Due__c plr 
                    WHERE ID IN :resolvedrecords]); 
                    
                    
                Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
                Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
                Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
                
                SET<ID> parkingrecords = new SET<ID>();
                    for(Parking_Lot_Assignment_Fees_Due__c obj :disputelist){
                        
                            parkingrecords.add(obj.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                        
                    }
                    System.debug('***************Parking Records************'+parkingrecords);

                    List<Parking_Lot_Request__c> parkingcompletelist = [SELECT Id,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where id in: parkingrecords];
                    SET<ID> requestee = new SET<ID>();
                    for(Parking_Lot_Request__c obj : parkingcompletelist){
                        requestee.add(obj.Requestee__c);
                    }
                    System.debug('***********************requestee******************'+requestee);
                    List<Employee_Delegate__c> empDelegates = [Select 
                                          Delegate__c
                                         ,employee__c
                                         ,delegate__r.email__c
                                         From Employee_Delegate__c 
                                         where application__c = 'Global Parking'
                                         and status__c = 'Approved'
                                         and employee__c in :requestee
                                         ];
                     Map<ID,List<String>>  employeedelegatemap = new Map<ID,List<String>>();
                    for(Employee_Delegate__c d:empDelegates){
                        
                        if(employeedelegatemap.isEmpty()){
                            employeedelegatemap.put(d.employee__c, new List <String>{d.delegate__r.email__c});
                            
                        }
                        else{
                            if(employeedelegatemap.containskey(d.employee__c)){
                                employeedelegatemap.get(d.employee__c).add(d.delegate__r.email__c);
                            }
                            else{
                                employeedelegatemap.put(d.employee__c,new List <String>{d.delegate__r.email__c});
                            }
                        }
                    }
                    System.debug('***********************employeedelegatemap******************'+employeedelegatemap);  
                
                for(Parking_Lot_Assignment_Fees_Due__c disputecharges: disputelist ){
                   
                        Parkingrequestmap.put(disputecharges.id,disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__c);
                        EmailToAddressesmap.put(disputecharges.id,disputecharges.Employee__r.Email__c);
                        if(employeedelegatemap.get(disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c)!=null){
                            EmailCCAddressesmap.put(disputecharges.id,string.join(employeedelegatemap.get(disputecharges.Parking_Lot_Space_Assignment__r.Parking_Lot_Request__r.Requestee__c),',  '));
                        }
                        else EmailCCAddressesmap.put(disputecharges.id,null); 
                  
                    

                }
                for(ID key :Parkingrequestmap.values()){
                    System.debug('***********Parking Request ID**********'+key);
                }
                if(!(Parkingrequestmap == null || Parkingrequestmap.isEmpty())){
                    GP_SendEmail.sendEmailForInvoiceAndDispute(templateId8.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
                }   
            }   
            
            
                 
        }
        
        
        
    /**************************Method for  insert operations on Employee Delegate object********************/    
    
        public static void SendMailforDelegateRequest(List<Employee_Delegate__c>delegatelist , Map<ID,Employee_Delegate__c> triggermap){
            Map<ID,String> delegatemap = new Map<ID,String>();
            Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
            Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
            Map<ID,String> delegatemap1 = new Map<ID,String>();
            Map<ID,String> EmailToAddressesmap1 = new Map<ID,String>();
            Map<ID,String> EmailCCAddressesmap1 = new Map<ID,String>();
            Set<ID> requestee = new Set<ID>();
            
            System.debug('*******************Inside SendMailforDelegateRequest method*************');
            
            EmailTemplate templateId13 = [Select id from EmailTemplate where developerName = 'GP_Email_13_Add_Delegate_Request'];
            EmailTemplate templateId14 = [Select id from EmailTemplate where developerName = 'GP_Email_14_Delegate_Access_Granted'];
            for(Employee_Delegate__c ed :delegatelist){
                if(ed.Application__c == 'Global Parking'){
                    if(ed.Status__c == 'Submitted'){
                        requestee.add(ed.Employee__c);
                    }
                }   
            }
            System.debug('*******************Value of Requesteee*************'+requestee);
            Map<ID,Employee_Delegate__c> delegatesEmpMap = new Map<ID,Employee_Delegate__c>( 
                [Select id, Delegate__r.User__c, Delegate__r.Name, Delegate__r.Middle_Name__c, 
                    Delegate__r.Login_Id_Directory__c, 
                    Delegate__r.Last_Name__c, 
                    Delegate__r.First_Name__c, Delegate__r.Emp_ID__c, Delegate__r.Email__c From Employee_Delegate__c  
                    where Employee__r.id IN :requestee
                        and Application__c = 'Global Parking' and  Status__c = 'Approved']);
                        
            List<String> emailCCAddresses =  new List<String>();
                
            for(Id key : delegatesEmpMap.keySet()){
                
                emailCCAddresses.add(delegatesEmpMap.get(key).Delegate__r.Email__c);
            }
            
            System.debug('*******************Value of emailCCAddresses*************'+emailCCAddresses);
            
            string allstring = string.join(emailCCAddresses,',  '); 
             
            List<Employee_Delegate__c> employeedelegatelist = new List<Employee_Delegate__c>([SELECT id,Application__c,Status__c,Delegate__r.name,Delegate__r.Email__c,Employee__r.Email__c 
                from Employee_Delegate__c WHERE id in :triggermap.keyset()]);
             
            for(Employee_Delegate__c ed :employeedelegatelist){
                if(ed.Application__c == 'Global Parking'){
                    if(ed.Status__c == 'Submitted'){
                        delegatemap.put(ed.id,ed.Delegate__r.name);
                        EmailToAddressesmap.put(ed.id,ed.Employee__r.Email__c);
                        EmailCCAddressesmap.put(ed.id,allstring);
                        
                    }
                    else if (ed.Status__c == 'Approved'){
                        delegatemap1.put(ed.id,ed.Delegate__r.name);
                        EmailToAddressesmap1.put(ed.id,ed.Delegate__r.Email__c);
                        EmailCCAddressesmap1.put(ed.id,ed.Employee__r.Email__c);
                    
                    }
                }   
            }
            
            System.debug('*******************Value of EmailToAddressesmap*************'+EmailToAddressesmap);
            
            if(delegatemap.size()>0){
                GP_SendEmail.sendEmail(templateId13.id,EmailToAddressesmap,EmailCCAddressesmap,delegatemap);
            }
            if(delegatemap1.size()>0){
                GP_SendEmail.sendEmail(templateId14.id,EmailToAddressesmap1,EmailCCAddressesmap1,delegatemap1);
            }
        }
    
       /**************************Method for  Update operations on Employee Delegate object********************/    
    
        public static void SendMailforDelegateApproval(List<Employee_Delegate__c>delegatelist , Map<ID,Employee_Delegate__c> triggermap){
            Map<ID,String> delegatemap = new Map<ID,String>();
            Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
            Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
            Set<ID> requestee = new Set<ID>();
            Set<ID> rejectedrequestee = new Set<ID>();
            system.debug('delegate list: ' + delegateList);
            
            System.debug('*******************Inside SendMailforDelegateApproval method*************');
           
            EmailTemplate templateId14 = [Select id from EmailTemplate where developerName = 'GP_Email_14_Delegate_Access_Granted'];
            EmailTemplate templateId15 = [Select id from EmailTemplate where developerName = 'GP_Email_15_Delegate_Request_Rejected'];
            for(Employee_Delegate__c ed :delegatelist){
                if(ed.Application__c == 'Global Parking'){
                    if(ed.Status__c == 'Approved'){
                        requestee.add(ed.Delegate__c);
                    }
                }   
            }
            
            System.debug('*******************Value of Requesteee*************'+requestee);
            
            for(Employee_Delegate__c ed :delegatelist){
                if(ed.Application__c == 'Global Parking'){
                    if(ed.Status__c == 'Rejected'){
                        //changed this code; use delegate not employee mrm 4/4
                        rejectedrequestee.add(ed.Delegate__c); 
                    }
                }   
            }
            
            System.debug('*******************Value of rejectedrequestee*************'+rejectedrequestee);
            
           if(requestee.size()>0){ 
               
                boolean firsttime = true;          
                for(Employee_Delegate__c ed :delegatelist){
                    if(ed.Application__c == 'Global Parking'){
                        if(ed.Status__c == 'Approved'){
                            delegatemap.put(ed.id,ed.Delegate__r.name);
                            system.debug('adding to map' +  ed.Delegate__r.Email__c);
                            EmailToAddressesmap.put(ed.id,ed.Delegate__r.Email__c);
                            if (firstTime){
                                EmailCCAddressesmap.put(ed.id,ed.Employee__r.Email__c);
                                firstTime=false;
                            }
                            
                        }
                    }   
                }
                
                System.debug('*****to**************Value of EmailToAddressesmap*************'+EmailToAddressesmap);
                System.debug('*****to**************Value of EmailCCAddressesmap*************'+EmailCCAddressesmap);
                
                if(delegatemap.size()>0){
                    system.debug('emailtoaddressmap' + emailToaddressesMap);
                    system.debug('emailccadrressss' + emailccaddressesmap);
                    system.debug('dlegetmap' + delegatemap);
                    
                    GP_SendEmail.sendEmail(templateId14.id,EmailToAddressesmap,EmailCCAddressesmap,delegatemap);
                }            
                        
                        
            }            
                        
            if(rejectedrequestee.size()>0){ 
                //mrm 4/4 initialize maps
                delegatemap = new Map<ID,String>();
                EmailToAddressesmap = new Map<ID,String>();
                EmailCCAddressesmap = new Map<ID,String>();
                
               
                                            
                for(Employee_Delegate__c ed :delegatelist){
                    if(ed.Application__c == 'Global Parking'){
                        //fixed code chaned approved to rejected mrm 4/4//16
                        if(ed.Status__c == 'Rejected'){
                            delegatemap.put(ed.id,ed.Delegate__r.name);
                            EmailToAddressesmap.put(ed.id,ed.Delegate__r.Email__c);
                            EmailCCAddressesmap.put(ed.id,ed.Employee__r.Email__c);
                        }
                    }   
               }
                System.debug('*******************Value of EmailToAddressesmap*************'+EmailToAddressesmap);
                System.debug('*******************Value of EmailCCAddressesmap*************'+EmailCCAddressesmap);
                
                if(delegatemap.size()>0){
                    GP_SendEmail.sendEmail(templateId15.id,EmailToAddressesmap,EmailCCAddressesmap,delegatemap);
                }            
                        
                                       
            }                      
            
        }
   
  
    }