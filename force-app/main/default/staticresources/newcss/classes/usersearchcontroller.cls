public class usersearchcontroller {
    public List<User> userList{get;set;}
    public String searchString{get;set;}
    
    public usersearchcontroller(){
        userList = new List<User>();   
    }

    public void search(){
        string searchQuery = 'SELECT Name, Id FROM User WHERE Name like \'%'+searchString+'%\' LIMIT 20';
        userList = Database.query(searchQuery);
    }
    
    public void clear(){
        userList.clear();
    }
}