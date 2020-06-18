public class WV_UtilityCoptKum{
    
    public static string getEmailTemplate(){
        String temp='';
        
        temp+='<body style="width: 100% !important;background-color: #f2f2f2; margin: 0px; margin-top:20px;padding: 0px; width: 100%; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; height: 100%; border: 0; font-size: 100%; line-height: 1;" leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" yahoofix="">'+
               '<div style="display:@recipient">'+
                    'Recipients: <br/>TO:&nbsp;@EmployeeEmail'+
                    '<p style="line-height:115%">'+
                       '<span style="font-size:12px;line-height:115%;font-family:Arial,Helvetica,sans-serif;"></span>'+
                    '</p>'+
               '</div>'+
                '<table align="center" bgcolor="#f2f2f2" height="100%" width="100%" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                    '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                        '<td align="center" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
            
                            '<table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
            
                                '<tr style="margin: 0; border: 0; font-size: 100%;">'+
            
                                    '<td class="container" align="center" valign="top" width="800" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%; width: 800px;">'+
            
                                        '<table border="0" cellpadding="0" cellspacing="0" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                        
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" align="left" bgcolor="#002B51" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
                                                    '<table cellspacing="0" cellpadding="0" border="0" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                                                        '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                            '<td style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"><img src="@mslogourl" alt="" border="0" style="display: block; -ms-interpolation-mode: bicubic; line-height: 100%; outline: 0; text-decoration: none; margin: 0; border: 0; font-size: 100%;" align="top" />'+
                                                             '<td width="5" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                                              '<td style="font-family: Arial; color: #009AD9; padding-bottom: 2px; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">My Elections</td>'+
                                                        '</tr>'+
                                                    '</table>'+
                                                '</td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" height="32" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td width="33" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                                '<td style="background-color: #ffffff; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
                                                    '<table style="border-collapse: collapse; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%;font-family: Arial;font-size: 14px;color: #555555;" cellspacing="0" cellpadding="0" border="0">'+
                                                        '@MyEmailBody'+
                                                    '</table>'+
                                                '</td>'+
                                                '<td width="33" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" height="32" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                        '</table>'+
                                    '</td>'+
                                '</tr>'+
                            '</table>'+
                        '</td>'+
                    '</tr>'+
                    '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                        '<td height="50" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                    '</tr>'+
                '</table>'+
            '</body>';
            
            return temp;
    }
    
    public static string getActualEmailBody(election__C election,String content){
        
        if(content != null && election != null && election.Id != null){
            if(content.contains('@FirstName') && election.Employee__r.First_Name__c!= null){
                content=content.replaceALL('@FirstName',election.Employee__r.First_Name__c);
            }
            if(content.contains('@LastName') && election.Employee__r.Last_Name__c!= null){
                content=content.replaceALL('@LastName',election.Employee__r.Last_Name__c);
            }
            if(content.contains('@ElectionName') && election.Scheme_name_dummy__c != null){
                content=content.replaceALL('@ElectionName',election.Scheme_name_dummy__c);
            }
            if(content.contains('@DateTime') && election.LastModifiedDate != null){
                content=content.replaceALL('@DateTime',election.LastModifiedDate.format(Label.WV_EmailTemplate_DatetimeFormat));
            }
            if(content.contains('@Url')){
                content=content.replaceALL('@Url','<a href="'+Label.DG_BaseUrl+'/apex/WV_Homepage" target="_blank">here</a>');
            }
        }
        
        return content ;
    
    }
    
    public static string getMergedEmailContent(election__C election,String temp,string contentBody){
        String logoURL='';
        List<Document> mslogo=[select id,developername from document where developername='MS_Logos'];
        if(mslogo != null && mslogo.size() ==1){
            logoURL=Label.DG_BaseUrl+'/servlet/servlet.ImageServer?id='+mslogo[0].Id+'&oid='+UserInfo.getOrganizationId();
        }
        
        if(temp != null && contentBody != null){
            
            if(temp.contains('@MyEmailBody')){
                temp=temp.replaceAll('@MyEmailBody',contentBody);
            }
            
            if(temp.contains('@EmployeeEmail') && election.Employee__r.Email__c!= null){
                temp=temp.replaceAll('@EmployeeEmail',election.Employee__r.Email__c);
            }
            
            if(temp.contains('@mslogourl') && logoURL != null){
                temp=temp.replaceAll('@mslogourl',logoURL);
            }
            
            if(Label.ORG_ENVIRONMENT.tolowercase() != 'prod' && temp.contains('@recipient')){
                temp=temp.replaceAll('@recipient','block');
            }
            else if(temp.contains('@recipient')){
                temp=temp.replaceAll('@recipient','none');
            }
        }  
        
        return temp;  
    }
    
    public static set<string> getSchemeContentTypeList(){
        set<string> contentTypeSet=new set<string>{'Description','Introduction','Terms & Conditions','Email Template - Election Submit/Update','Email Template - Election Cancellation'};
        return contentTypeSet;
    }
    
     public static List<Wav_Content__c> getPageContentManagementData(string schemeId){
        List<Wav_Content__c> Content;
        
        if(schemeId != null && schemeId != ''){
            set<string> contentTypes=WV_UtilityCoptKum.getSchemeContentTypeList();
            Content=[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Scheme__c=:schemeId AND Content_Type__c IN:contentTypes];
        }
        return Content;
    }
    
    public static void sendElectionEmails(election__c e,string emailid,string body,string type){ 
        List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
        
        String orgname=Label.ORG_ENVIRONMENT;
        List<OrgWideEmailAddress> org=WV_Utility.getOrgWideAddressExceptions();
        List<OrgWideEmailAddress> DEVTeamEmail=WV_Utility.getOrgWideAddressDEVElectionEmails();
        List<String> toAddresses=new List<String>();
        
        if (e != null && e.Id != null && emailid != null && emailid.trim() != '' && org !=null && org.size() >0 && body != null){
              if(orgname.tolowercase()!='prod'){  //if its non-production environment then send email to logged in user.
                 toAddresses.add(userinfo.getuseremail());
                 if(DEVTeamEmail != null && DEVTeamEmail.size() >0){
                     email.setCCAddresses(new list<string>{DEVTeamEmail[0].address});
                 }
              }
              else{//if its production then send email to actual employees with no users in CC addresses.                 
                 toAddresses.add(emailid);
              }
              
              email.setOrgWideEmailAddressId(org[0].Id);
              email.setHtmlBody(Body);
              if(type != null && type =='Cancellation'){
                  email.setSubject('My Elections: Election Cancellation');
              }
              else if(type != null && type =='Submission'){
                  email.setSubject('My Elections: Election Confirmation');
              }
              
              if(toAddresses.size() >0){
                  email.setToAddresses(toAddresses);
              }                                             
              emailList.add(email);
        }
        
        if (emailList.size() > 0) { 
            List<Messaging.SendEmailResult> result=Messaging.sendEmail(emailList);
        }
    }
}