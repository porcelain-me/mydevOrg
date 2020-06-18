/***************************************************************************************************************
*  PP Send Email -  this class sends emails related to the approval process for property pass
*
* MRM 2/19/15 - Created Class
****************************************************************************************************************/
public without sharing class PP_SendEmail {

    /*****************************************************************************************
    * SendEmail
    *****************************************************************************************/
    public static Messaging.Singleemailmessage CreateEmail (List<String> toEmail, String orgEmail, String urlString, List<String> watcherListDetails, Contact c, String orgEmailid, PR_Request__c p, String label, Map<String,String> empMap){
        
        Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
       
        List<String> emailToAddresses = new List<String>();
        emailToAddresses = toEmail;
            
        
        //if (emailToaddresses.size() > 0){
            if (urlString.toLowercase().contains('prod') || urlString.toLowercase().contains('uat')){  
                //if production or UAT then send to actual users
                //system.debug('email address'+emailToAddresses+watcherListDetails+c);
                email.setToAddresses(emailToAddresses);
                email.setCcAddresses(watcherListDetails);

                if( urlString.toLowercase().contains('uat') && (label == system.label.pp_email2 ||  label == system.label.pp_email7) )
                    //email.setReplyTo('pp_action_via_email@2-11xc6yyiv12wy9o4l9bknwr33fop11jgj7omx4szljmc2h9rv7.e-nlbceaa.cs15.apex.sandbox.salesforce.com');                   
                    email.setReplyTo(system.label.PP_Reply_via_email);
                else if(urlString.toLowercase().contains('prod') && (label == system.label.pp_email2 ||  label == system.label.pp_email7) ) {
                    // Need to change the URL for Prod Email Services
                    //email.setReplyTo('pp_action_via_email@2-11xc6yyiv12wy9o4l9bknwr33fop11jgj7omx4szljmc2h9rv7.e-nlbceaa.cs15.apex.sandbox.salesforce.com');
                    email.setReplyTo(system.label.PP_Reply_via_email);
                }
                
            }
            
            //adding QA for email approval on 22June
             else  if (urlString.toLowercase().contains('qa')){
                //if not (production or UAT) then send to group email for testing purposes
                emailToAddresses = new List<String>();
                //emailToaddresses.add(orgEmail);
                email.setToAddresses(emailToAddresses);
                email.setCcAddresses(watcherListDetails); 
                //email.setReplyTo('pp_action_via_email@33uoxs41qqavgi8ecc98ej4vqkg5opjm806dpbygn33sny0x8s.e-nleteay.cs15.apex.sandbox.salesforce.com');                             
                email.setReplyTo(system.label.PP_Reply_via_email);
            } 
            //End
            
            
            else {
                //if not (production or UAT) then send to group email for testing purposes
                //pp added by dw
                if(label == system.label.pp_email1){
                emailToAddresses = new List<String>();
                //emailToaddresses.add(orgEmail);
                email.setToAddresses(emailToAddresses);
                email.setCcAddresses(watcherListDetails); 
                //email.setReplyTo('pp_action_vua_email@32b3inx68haaen0ixejuev2c5d8tsbefpel6ggignok53d63f8.f-2k0p7eac.cs16.apex.sandbox.salesforce.com'); 
                //system.debug('----------Inside REply--------------');
                email.setReplyTo(system.label.PP_Reply_via_email);  
                }                          
            }                              
                
            email.setOrgWideEmailAddressId(orgEmailId);
            email.setTargetObjectId(c.id);
            email.setWhatId(p.id);
            email.setTemplateId(empMap.get(label));
            //email.setReplyTo('pp_action_vua_email@32b3inx68haaen0ixejuev2c5d8tsbefpel6ggignok53d63f8.f-2k0p7eac.cs16.apex.sandbox.salesforce.com');
     
            return email;
        
        //}
        
        return null;
    }
}