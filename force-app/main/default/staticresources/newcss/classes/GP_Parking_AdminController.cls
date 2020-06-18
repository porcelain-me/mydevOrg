public class GP_Parking_AdminController{

    public string location{get;set;}
    public String getadmindetails(){
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
                  
                String LondonEmailAddress = string.join(LondonEmailAddresses,',  ');  
                String TokyoEmailAddress =  string.join(TokyoEmailAddresses,',  ');  
                
                
                
                system.debug('********************London Users Email Addresse String************************'+LondonEmailAddress);
                system.debug('********************Tokyo Users Email Addresse String************************'+TokyoEmailAddress);
                if(location == 'London'){
                return LondonEmailAddress ;
                }
                else 
                return TokyoEmailAddress ;
    }
}