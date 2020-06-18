public class exampleCon {
    String uname;
     Integer count = 0;
    public String getUsername() {
        return uname;
    }
           
    // action Poller
                        
    public PageReference incrementCounter() {
        count++;
        return null;
    }
                        
    public Integer getCount() {
        return count;
    }      
           
     ///end     
           
           
           
           
           
            
    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
            
    public PageReference methodOne() {
        return null;
    }
            
    private String state = 'no';
}