public class ContactController2 {
    @auraenabled
    public static list<contact> findall (){
        return [select id,name, phone from Contact limit 50];
        
    }
    @auraenabled
    public static list<contact> findbyId(string ContactId){
        return[ select id, name, title, phone, mobilephone, Account.Name from Contact where id = :ContactId];
    }
    
    @auraenabled
    public static list<contact> findByName(String searchKey) {
        String name = '%' + searchKey + '%';
        return [SELECT id, name, phone FROM Contact WHERE name LIKE :name LIMIT 50];
    }
}