public with sharing class LoginAsCustomController {

    public String Role{get;set;}
    public PageReference usersInRole() {
        return null;
    }
    public String txtSearchEmployee{get;set;}    

 
    public LoginAsCustomController(){       
    }
    

    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            
            List<UserRole> this_roles = new List<UserRole>([Select Id, Name from UserRole]);
            
            if(this_roles.size()>0){
                for(UserRole ur : this_roles){
                     options.add(new SelectOption(ur.Id, ur.Name));
                }
            }
            return options;
        }
        
    public List<User> getUserforRoleandSubs(){
        //RoleandGroupHelper roleHelper = new RoleandGroupHelper(); //TODO: this method call is probably hugely inefficient - used just for a quick PoC. Do not bring to production. review and fully rewrite. Use this to understand the intent only
        //Map<Id, Set<Id>> roleSubUsers = roleHelper.roleSubordinateUsers;
        
        User [] users = new List<User>([Select Id, Username, UserRole.Name from User where  IsActive=true and id in ('005f0000001O2Wd', '005f0000001PHnV', '005f0000001PHMC')]);
                    
        return users;
    }

}