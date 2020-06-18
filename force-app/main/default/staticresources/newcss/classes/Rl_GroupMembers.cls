public class Rl_GroupMembers {
	
	public String requestId {get;set;}
	 
	 public list<String> getuserEmailAddress(){
	 Reference_Letter_Request__c quote=new Reference_Letter_Request__c();	
	 Map<String,ID> gMap = new Map<String,ID>();
    Map<ID,String> gIdMap = new Map<ID,String>();
    Map<ID,List<GroupMember>> groupMemberMap = new Map<ID,List<GroupMember>>();
    List<Group> gList = new List<Group>();
    
    gList =[Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers) From Group g];
    for (Group g:gList){
        gMap.put(g.developername,g.id);
        gIdMap.put(g.id,g.developername);
        groupMemberMap.put(g.id,g.GroupMembers);
    }
    
     if (requestId != null) {
          quote = [Select Id,email_q_name__c from Reference_Letter_Request__c where Id = :requestId];
    
    
    
	 
	 }
	  List<String> emailToAddresses = new List<String>();
	 
	  ID gId = gMap.get(quote.email_q_name__c);
            List<GroupMember> gmList = groupMemberMap.get(gId);
            Set<ID> userIdSet = new Set<ID>();
            for (GroupMember g:gmList){
                if (string.valueOf(g.UserOrGroupId).startswith('005')){
                    userIdSet.add(g.UserOrGroupId);
                }   
            }
            
            
           
            if (userIdSet.size() > 0){
                List<User> uList = [select email from User where id in :userIdSet];
                for (User u:uList)
                    emailToAddresses.add(u.email);
	 
            }
            
            return emailToAddresses;
	 }
	
	 
}