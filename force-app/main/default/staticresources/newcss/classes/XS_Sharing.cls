/***************************************************************************************************************
* XS SHARING CLASS -    this class inserts a sharing record to share a cross sell record  
*
* MRM 1/16/15 - Created Class
****************************************************************************************************************/

// Adding @isTest annotation as this class is not used

@isTest
public without sharing class XS_Sharing {

    public static List<Cross_Sell__Share> shareRead (Map<ID,Cross_Sell__c> cMap){
        
        try{
            Cross_Sell__c c = [select nominee__c, ownerid from Cross_Sell__c where id in :cMap.keySet()];
            /* Figure out who to share with */
            List<ID> uToShareWithList = new List<ID>();
            
            Set<ID> uToShareWithIDSet = new Set<ID>();
            Set<ID> uSharedWithIDSet = new Set<ID>();
            
            /* get the nominee */
            if (c.nominee__c != null){
                Employee__c e = [select user__r.id, user__r.isactive,
                     Manager__r.user__c, Manager__r.user__r.isactive from Employee__c where id = :c.nominee__c];
                if (e.user__c != null && e.user__r.isactive){
                    uToShareWithIDSet.add(e.user__r.id);
                    uToShareWithList.add(e.user__r.id);
                    
                    System.debug('e.Manager__r.user__c: ' + e.Manager__r.user__c);
                    if(e.Manager__r.user__c != null && e.Manager__r.user__r.isactive) {
                        uToShareWithIDSet.add(e.Manager__r.user__c);
                        uToShareWithList.add(e.Manager__r.user__c);
                    }
                }
            }
            
            /* get a list of other employees to share with */   
            List <Cross_Sell_Parties_Involved__c> pList = new List<Cross_Sell_Parties_Involved__c>();
            pList = [select employee__r.user__r.id, employee__r.user__r.isactive, employee__r.Manager__r.user__c,
             employee__r.Manager__r.user__r.isactive from Cross_Sell_Parties_Involved__c where cross_sell__c = :c.id];
           
            for(Cross_Sell_Parties_Involved__c cs:pList){
                if (cs.employee__r.user__c != null && cs.employee__r.user__r.isactive){
                    uToShareWithIDSet.add(cs.employee__r.user__r.id);
                    uToShareWithList.add(cs.employee__r.user__r.id);
                    
                    if(cs.employee__r.Manager__r.user__c != null && cs.employee__r.Manager__r.user__r.isactive) {
                        uToShareWithIDSet.add(cs.employee__r.Manager__r.user__c);
                        uToShareWithList.add(cs.employee__r.Manager__r.user__c);
                    }
                }
            }
            
           system.debug('to share with list: ' + utoShareWithList);
           
            /* figure out who it is shared with already */
            
            /* get the shared with list */
            List<Cross_Sell__Share> sharedWithList = [
                        Select Id, UserOrGroupId
                        From Cross_Sell__Share
                        where parentid = :c.id and userorgroupid != :UserInfo.getUserId()]; 
            
            for (Cross_Sell__Share s:sharedWithList)
                uSharedWithIDSet.add(s.UserOrGroupId);
            
            system.debug('shared with list: ' + uSharedWithIDSet);
            
            Cross_Sell__Share crossSellShr;
            List<Cross_Sell__Share> Cross_SellShrs  = new List<Cross_Sell__Share>();
            List<Cross_Sell__Share> Cross_SellShrsDelete  = new List<Cross_Sell__Share>();
            
           
            /* go thru toSharedWithList */  
            for (ID u:uToShareWithList){
                system.debug('searching for: ' + u);
                if(!uSharedWithIDSet.contains(u)){ // if not already shared with then add a new share        
                    // insert a new share
                    // Instantiate the sharing objects
                    crossSellShr = new Cross_Sell__Share();
                
                    // Set the ID of record being shared
                    crossSellShr.ParentId = c.Id;
            
                    system.debug('---------------Parent Id is---------'+c.id) ;   
                    // Set the ID of user or group being granted access
                    crossSellShr.UserOrGroupId = u;
                    system.debug('---------------User Id is---------'+userInfo.getUserId()) ; 
                
                    // Set the access level
                    crossSellShr.AccessLevel = 'Edit';
               
                
                    // Add objects to list for insert
                    Cross_SellShrs.add(crossSellShr);
                    
                }
            }
            
            /* go thru shared with list and see if in to share list for deletes */
            
            
            for (Cross_Sell__Share s:sharedWithList){
                system.debug('User is:' + s.userOrgroupId);
                system.debug('Owner is:' + c.ownerid);
                if (uToShareWithIDSet.contains(s.UserOrGroupId) ||  s.UserOrGroupId == c.ownerid){
                    //do nothing
                }
                else{
                    
                    Cross_SellShrsDelete.add(s);
                }
            }
                
               
            // Insert sharing records and capture save result 
            // The false parameter allows for partial processing if multiple records are passed 
            // into the operation; so we use true instead
            if (Cross_SellShrs.size() > 0){
                Database.SaveResult[] lsr = Database.insert(Cross_SellShrs,true);
            }
            
            if (Cross_SellShrsDelete.size() > 0){
                Database.DeleteResult[] lsrd = Database.delete(Cross_SellShrsDelete,true);
            }
        } catch(Exception e) {
            
        }
            
        return null;
    }
}