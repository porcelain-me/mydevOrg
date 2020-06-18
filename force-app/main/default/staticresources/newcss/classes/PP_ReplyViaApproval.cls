global class PP_ReplyViaApproval implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope)
    {  
        Messaging.InboundEmailResult emailresult = new Messaging.InboundEmailResult();
        PR_Request__c  pr = new PR_Request__c();
        List<PR_Request__c> submitReqList;
        Boolean rightApproval = false;
        String strHTMLEmailBody;
        if(email.subject.containsIgnoreCase('Property Pass')) {
            
            String str = email.subject.normalizeSpace();
            try {
                if(str != null && str.length() > 0) {
                    String ReqNumber = str.substring(str.indexOf('PR-'));
                    system.debug('*****************ReqNumber'+ReqNumber);
                    if(ReqNumber!=null && ReqNumber.length() > 0) {         
                    
                        submitReqList = [Select Id,name,request_type__c,Property_Service_Approver__c,createdbyid,Approvers_List__c,Manager__c,Manager__r.emp_id__c,Manager_Email__c From PR_Request__c WHERE name=:ReqNumber.trim() and Status__C ='Submitted' limit 1];
                        //system.debug('Property Request Details:'+pr );
                        if(submitReqList != null && submitReqList.size()>0) {
                            pr = submitReqList[0]; 
                            system.debug('Property Request Details:1'+pr.request_type__c +email.fromAddress+pr.Manager_Email__c); 
                            if((pr.request_type__c == PP_Util.STANDARD_REQUEST_TYPE) ){                            
                                system.debug('*************email.fromAddress'+email.fromAddress );
                                if(email.fromAddress == pr.Manager_Email__c) {
                                    system.debug('*************email.fromAddress Matches with Manager Email Address'+pr.Manager_Email__c );
                                    rightApproval = true;
                                    user u = [select Id,Emp_ID__c from user where Emp_ID__c=:pr.Manager__r.emp_id__c and isactive= true limit 1];
                                    pr.ActualApprover__c = u.id; 
                                }
                            }
                            else{
                                if(pr.request_type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE || pr.request_type__c == PP_Util.EDC_REQUEST_TYPE){                            
                                    system.debug('Property Request Details:4'+pr.request_type__c +email.fromAddress+pr.Approvers_List__c); 
                                    String s = pr.Approvers_List__c;
                                    system.debug('Property Request Details:5'+s.contains(email.fromAddress)); 
                                    user u = [select Id,Emp_ID__c from user where email =:email.fromAddress and isactive =true limit 1];
                                    if(s.contains(email.fromAddress) && pr.createdbyid!=u.Id){ 
                                        system.debug('Property Request Details:2'+pr.request_type__c +email.fromAddress+pr.Approvers_List__c); 
                                        rightApproval = true;
                                    
                                    pr.ActualApprover__c = u.id;
                                    system.debug('Property Request Details31'+u.id);  

                                    }
                                }
                            }
                        }
                    }
                }    
                if(rightApproval ){
                    //Actor.Email=:email.fromAddress
                    List<ProcessInstance> pi = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:pr.id AND Status='Pending']; 
                    if(pi.size()==0)
                        return emailresult;
                    List<ProcessInstanceWorkitem> piw = [SELECT Id,ActorId,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE 
                        ProcessInstanceId=:pi[0].Id];           
                    if(piw.size()==0)
                        return emailresult;
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest(); 
                    list<String> lineitem=new String[2];

                   Integer app_rejStr =0;
                   Integer spanStr =0;
                   String strComments;

                   system.debug('*************email.plainTextBody:'+email.plainTextBody);
                   if(email.plainTextBody == null){
                          
                       Integer bodyTagLoc = email.htmlBody.indexOf('<BODY>');
                       system.debug('*****************bodyTagLoc :'+ bodyTagLoc );
                       Integer SubjectTagLoc = email.htmlBody.indexOf('APPROVAL REQUIRED: Property Pass Request');
                       system.debug('*****************SubjectTagLoc :'+ SubjectTagLoc );
                       strHTMLEmailBody = email.htmlBody.substring(bodyTagLoc ,SubjectTagLoc );
                       
                       system.debug('*****************strHTMLEmailBody Text:'+ strHTMLEmailBody);
                       system.debug('*****************strHTMLEmailBody Has Approved:'+strHTMLEmailBody.containsIgnoreCase('>Approved<'));
                       system.debug('*****************strHTMLEmailBody Has Rejected:'+ strHTMLEmailBody.containsIgnoreCase('>Rejected<'));
               
                              
                       if(strHTMLEmailBody!= NULL && strHTMLEmailBody.containsIgnoreCase('>Approved<')){
                           system.debug('*****************Approved case:');
                           
                           lineitem[0] = 'Approved';
                           app_rejStr = email.htmlBody.indexOf('>Approved');
                           system.debug('*****************Approved case:app_rejStr'+app_rejStr);
                           spanStr = email.htmlBody.indexOf('</span></div>');
                           system.debug('*****************Approved case:spanStr'+spanStr );
                           if(spanStr > 0 && app_rejStr > 0 && spanStr != app_rejStr+9)
                              strComments = email.htmlBody.substring(app_rejStr+15  ,spanStr );
                           system.debug('*****************Approved case:strComments '+strComments );
                           if( strComments == null)
                                strComments = 'Approved by approver, over an email using Iphone.';
                           lineitem[1] = strComments;
                       } else if(strHTMLEmailBody!= NULL && strHTMLEmailBody.containsIgnoreCase('>Rejected<')){ 
                           system.debug('*****************Rejected case:');
                           lineitem[0] = 'Rejected';
                           app_rejStr = email.htmlBody.indexOf('>Rejected');
                           system.debug('*****************Rejected case:app_rejStr'+app_rejStr);
                           spanStr = email.htmlBody.indexOf('</span></div>');
                           system.debug('*****************Rejected case:spanStr'+spanStr );
                           if(spanStr > 0 && app_rejStr > 0 && spanStr != app_rejStr+9)
                               strComments = email.htmlBody.substring(app_rejStr+15  ,spanStr );
                           system.debug('*****************Rejected case:strComments '+strComments );
                           if( strComments == null)
                               strComments = 'Rejected by approver, over an email using Iphone.';
                           lineitem[1] = strComments;
                      }    
               }
               else{
                   lineitem = email.plainTextBody.split('\n');
               } 

               system.debug('*************PP_ReplyViaApproval::lineitem:'+lineitem);
               if( lineitem != null && lineitem.size() > 1  ){                       
                    if(lineitem[0].containsIgnoreCase('Approved'))
                    {                        
                        system.debug('i am here in Approved');
                        if(lineitem[1] == Null)
                            req.setComments('Approved by approver, over an email using Phone.');
                        else
                            req.setComments(lineitem[1]);
                        req.setAction('Approve');
                        system.debug('*************lineitem[1]:'+lineitem[1]);

                    }                                    
                    else if(lineitem[0].containsIgnoreCase('Rejected'))
                    {   
                        system.debug('i am here in Rejected');
                         if(lineitem[1] == Null)
                            req.setComments('Rejected by approver, over an email using Phone.');
                        else
                            req.setComments(lineitem[1]);
    
                        req.setAction('Reject');
                        system.debug('*************lineitem[1]:'+lineitem[1]);
                    }
                }    
               /** else
                {
                    if(email.plainTextBody !=null && email.plainTextBody.containsIgnoreCase('Approved'))
                    {
                        if(lineitem[1] == Null)
                            req.setComments('Approved by approver, over an email using Phone.');
                        else
                            req.setComments(lineitem[1]);

                        req.setAction('Approve');
                    }                                    
                    else if(email.plainTextBody !=null && email.plainTextBody.containsIgnoreCase('Rejected'))
                    {  
                        if(lineitem[1] == Null)
                            req.setComments('Rejected by approver, over an email using Phone.');
                        else
                            req.setComments(lineitem[1]);

                        req.setAction('Reject');
                    }
                    
                }**/
                req.setWorkitemId(piw[0].Id);                                  
                Approval.ProcessResult result = Approval.process(req);
                
                update pr;
            }
                
        }
        catch(Exception e){
            system.debug(e);
            }            
        }
           
        return emailresult;        
    } 
}