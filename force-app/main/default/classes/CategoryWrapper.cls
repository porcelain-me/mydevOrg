public class CategoryWrapper {

    public Boolean checked{ get; set; }
    public Position__c cat { get; set;}

    public CategoryWrapper(){
        cat = new Position__c();
        checked = false;
    }

    public CategoryWrapper(Position__c c){
        cat = c;
        checked = false;
    } 
 
    }